/*
 * Copyright © 2020 Mark Raynsford <code@io7m.com> http://io7m.com
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
 * IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

package com.io7m.xstructural.vanilla.internal;

import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.api.XSProcessorType;
import com.io7m.xstructural.api.XSTransformException;
import com.io7m.xstructural.xml.SXMLResources;
import net.sf.saxon.Configuration;
import net.sf.saxon.lib.Feature;
import net.sf.saxon.lib.StandardLogger;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltPackage;
import net.sf.saxon.trace.XSLTTraceListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;

import javax.xml.transform.sax.SAXSource;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.util.Objects;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

public final class XSTransformer implements XSProcessorType
{
  private static final Logger LOG = LoggerFactory.getLogger(XSTransformer.class);

  private final SXMLResources resources;
  private final XSProcessorRequest request;

  public XSTransformer(
    final SXMLResources inResources,
    final XSProcessorRequest inRequest)
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");
    this.request =
      Objects.requireNonNull(inRequest, "request");
  }

  @Override
  public void execute()
    throws XSTransformException
  {
    try {
      this.executeTransform();
    } catch (final IOException | SaxonApiException e) {
      throw new XSTransformException(e);
    }
  }

  private void executeTransform()
    throws IOException, SaxonApiException
  {
    final var configuration = new Configuration();
    configuration.setConfigurationProperty(
      Feature.OPTIMIZATION_LEVEL, "ltmv"
    );
    configuration.setConfigurationProperty(
      Feature.XINCLUDE, Boolean.TRUE
    );
    configuration.setConfigurationProperty(
      Feature.XSLT_ENABLE_ASSERTIONS, Boolean.TRUE
    );

    final var outputPath =
      this.request.outputDirectory()
        .toAbsolutePath();

    Files.createDirectories(outputPath);

    final var processor = new Processor(configuration);
    final var compiler = processor.newXsltCompiler();
    compiler.setErrorListener(new XSErrorListener(LOG));

    this.compileCorePackage(compiler);
    final XsltExecutable executable = this.compileStylesheet(compiler);

    LOG.debug("loading stylesheet");
    final var transformer = executable.load();
    try (var stream = Files.newInputStream(this.request.sourceFile())) {
      final var source = new InputSource();
      source.setByteStream(stream);
      source.setSystemId(this.request.sourceFile().toString());
      transformer.setSource(new SAXSource(source));

      final Serializer out =
        processor.newSerializer(
          this.request.outputDirectory()
            .resolve("extra.xml")
            .toFile()
        );
      out.setOutputProperty(Serializer.Property.METHOD, "xml");
      out.setOutputProperty(Serializer.Property.INDENT, "yes");
      transformer.setDestination(out);
      transformer.setTraceListener(this.createTraceListener());

      final var messagePath = this.request.messageFile().toAbsolutePath();
      try (var messageListener = new XSMessageListener(messagePath)) {
        transformer.setMessageListener(messageListener);

        transformer.setParameter(
          QName.fromEQName("outputDirectory"),
          XdmValue.makeValue(outputPath.toString())
        );

        LOG.debug("output directory: {}", outputPath);
        LOG.debug("executing stylesheet");
        transformer.transform();
        LOG.debug("execution completed");
      }
    }

    if (this.request.writeResources()) {
      this.copyXStructuralResource("reset.css");
      this.copyXStructuralResource("structural.css");
    }
  }

  private void copyXStructuralResource(final String name)
    throws IOException
  {
    LOG.info("copy resource {}", name);
    try (var stream = this.resources.xstructuralResourceOf(name).openStream()) {
      Files.copy(
        stream,
        this.request.outputDirectory().resolve(name),
        REPLACE_EXISTING
      );
    }
  }


  private void compileCorePackage(
    final XsltCompiler compiler)
    throws IOException, SaxonApiException
  {
    LOG.debug("compiling core package");
    final XsltPackage core;
    try (var stream = this.resources.core().openStream()) {
      final var source = new InputSource();
      source.setByteStream(stream);
      source.setSystemId(this.resources.core().toString());
      core = compiler.compilePackage(new SAXSource(source));
      compiler.importPackage(core);
    }
  }

  private XsltExecutable compileStylesheet(
    final XsltCompiler compiler)
    throws IOException, SaxonApiException
  {
    LOG.debug("compiling stylesheet");
    final URL url;
    switch (this.request.stylesheet()) {
      case SINGLE_FILE:
        url = this.resources.single();
        break;
      case MULTIPLE_FILE:
        url = this.resources.multi();
        break;
      default: {
        throw new IllegalStateException();
      }
    }

    final XsltExecutable executable;
    try (var stream = url.openStream()) {
      final var source = new InputSource();
      source.setByteStream(stream);
      source.setSystemId(url.toString());
      executable = compiler.compile(new SAXSource(source));
    }
    return executable;
  }

  private XSLTTraceListener createTraceListener()
    throws FileNotFoundException
  {
    final var traceListener = new XSLTTraceListener();
    final var traceFile = this.request.traceFile().toFile();
    LOG.debug("trace file: {}", traceFile);

    final var traceLogger = new StandardLogger(traceFile);
    traceListener.setOutputDestination(traceLogger);
    return traceListener;
  }

}
