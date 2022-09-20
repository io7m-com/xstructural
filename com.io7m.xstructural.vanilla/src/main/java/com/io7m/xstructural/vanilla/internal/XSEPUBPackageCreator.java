/*
 * Copyright © 2021 Mark Raynsford <code@io7m.com> https://www.io7m.com
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
import com.io7m.xstructural.vanilla.internal.xslt_extensions.XSMIMEExtensionFunction;
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

/**
 * An XSL EPUB package creator.
 */

public final class XSEPUBPackageCreator implements XSProcessorType
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSEPUBPackageCreator.class);

  private final SXMLResources resources;
  private final XSProcessorRequest request;

  /**
   * An XSL transformer.
   *
   * @param inResources The SXML resources
   * @param inRequest   The transform request
   */

  public XSEPUBPackageCreator(
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

    final var outputFile =
      this.request.outputDirectory()
        .resolve("epub")
        .resolve("content.opf")
        .toAbsolutePath();

    Files.createDirectories(outputFile.getParent());

    final var processor = new Processor(configuration);
    processor.registerExtensionFunction(new XSMIMEExtensionFunction());

    final var compiler = processor.newXsltCompiler();
    compiler.setErrorListener(new XSErrorListener(LOG));

    final var executable =
      this.compileStylesheet(compiler);

    LOG.debug("loading stylesheet");
    final var transformer = executable.load();

    XSDocumentNumbering.fixDocumentNumber(transformer);

    try (var stream = Files.newInputStream(this.request.sourceFile())) {
      final var source = new InputSource();
      source.setByteStream(stream);
      source.setSystemId(this.request.sourceFile().toString());
      transformer.setSource(new SAXSource(source));

      final var out =
        processor.newSerializer(
          this.request.outputDirectory()
            .resolve("extra.xml")
            .toFile()
        );
      out.setOutputProperty(Serializer.Property.METHOD, "xml");
      out.setOutputProperty(Serializer.Property.INDENT, "yes");
      transformer.setDestination(out);
      transformer.setTraceListener(this.createTraceListener());

      final var messagePath = this.request.messageFile();
      try (var messageListener = new XSMessageListener(messagePath)) {
        transformer.setMessageListener(messageListener);

        transformer.setParameter(
          QName.fromEQName("outputFile"),
          XdmValue.makeValue(outputFile.toUri().toString())
        );
        transformer.setParameter(
          QName.fromEQName("sourceDirectory"),
          XdmValue.makeValue(
            this.request.sourceFile().getParent().toUri().toString())
        );

        LOG.debug("output file: {}", outputFile);
        LOG.debug("executing stylesheet");
        transformer.transform();
        LOG.debug("execution completed");
      }
    }
  }

  private XsltExecutable compileStylesheet(
    final XsltCompiler compiler)
    throws IOException, SaxonApiException
  {
    LOG.debug("compiling stylesheet");
    final URL url = this.resources.s8EpubPackage();

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
