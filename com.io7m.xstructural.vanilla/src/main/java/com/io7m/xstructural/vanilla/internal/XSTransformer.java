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
import com.io7m.xstructural.api.XSSchemas;
import com.io7m.xstructural.api.XSTransformException;
import com.io7m.xstructural.vanilla.internal.xslt_extensions.XSTitleCaseExtensionFunction;
import com.io7m.xstructural.xml.SXMLResources;
import net.sf.saxon.Configuration;
import net.sf.saxon.lib.StandardLogger;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.trace.XSLTTraceListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.transform.sax.SAXSource;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.util.HashSet;
import java.util.Objects;

import static java.lang.Boolean.TRUE;
import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;
import static net.sf.saxon.lib.Feature.OPTIMIZATION_LEVEL;
import static net.sf.saxon.lib.Feature.XINCLUDE;
import static net.sf.saxon.lib.Feature.XSLT_ENABLE_ASSERTIONS;

/**
 * An XSL transformer.
 */

public final class XSTransformer implements XSProcessorType
{
  private static final Logger LOG = LoggerFactory.getLogger(XSTransformer.class);

  private final SXMLResources resources;
  private final XSProcessorRequest request;

  /**
   * An XSL transformer.
   *
   * @param inResources The SXML resources
   * @param inRequest   The transform request
   */

  public XSTransformer(
    final SXMLResources inResources,
    final XSProcessorRequest inRequest)
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");
    this.request =
      Objects.requireNonNull(inRequest, "request");
  }

  private static XSTransformException epub7NotSupported()
  {
    final var lineSeparator = System.lineSeparator();
    final var builder = new StringBuilder(128);
    builder.append("Unsupported configuration.");
    builder.append(lineSeparator);
    builder.append(
      "  Problem: Producing EPUB files from 7.0 documents is unsupported. Use 8.0 or newer.");
    builder.append(lineSeparator);
    return new XSTransformException(builder.toString());
  }

  private static XSTransformException index7NotSupported()
  {
    final var lineSeparator = System.lineSeparator();
    final var builder = new StringBuilder(128);
    builder.append("Unsupported configuration.");
    builder.append(lineSeparator);
    builder.append(
      "  Problem: Producing index files from 7.0 documents is unsupported. Use 8.0 or newer.");
    builder.append(lineSeparator);
    return new XSTransformException(builder.toString());
  }

  @Override
  public void execute()
    throws XSTransformException
  {
    try {
      this.executeTransform();
    } catch (final XSTransformException e) {
      throw e;
    } catch (final Exception e) {
      throw new XSTransformException(e);
    }
  }

  private void executeTransform()
    throws Exception
  {
    final var namespace = this.findNamespace();

    final var configuration = new Configuration();
    configuration.setConfigurationProperty(OPTIMIZATION_LEVEL, "ltmv");
    configuration.setConfigurationProperty(XINCLUDE, TRUE);
    configuration.setConfigurationProperty(XSLT_ENABLE_ASSERTIONS, TRUE);

    final var outputPath =
      this.request.outputDirectory()
        .toAbsolutePath();

    Files.createDirectories(outputPath);

    final var processor = new Processor(configuration);
    processor.registerExtensionFunction(new XSTitleCaseExtensionFunction());

    final var compiler = processor.newXsltCompiler();
    compiler.setErrorListener(new XSErrorListener(LOG));

    final var executable =
      this.compileStylesheet(namespace, compiler);

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
      out.setOutputProperty(Serializer.Property.METHOD, "xhtml");
      out.setOutputProperty(Serializer.Property.INDENT, "yes");
      transformer.setDestination(out);
      transformer.setTraceListener(this.createTraceListener());

      final var messagePath = this.request.messageFile();
      try (var messageListener = new XSMessageListener(messagePath)) {
        transformer.setMessageListener(messageListener);

        transformer.setParameter(
          QName.fromEQName("xstructural.outputDirectory"),
          XdmValue.makeValue(outputPath.toUri().toString())
        );

        transformer.setParameter(
          QName.fromEQName("xstructural.sourceDirectory"),
          XdmValue.makeValue(
            this.request.sourceFile().getParent().toUri().toString())
        );

        this.request.brandingFile()
          .ifPresent(path -> {
            LOG.debug("branding file: {}", path);
            transformer.setParameter(
              QName.fromEQName("branding"),
              new XdmAtomicValue(path.toUri())
            );
          });

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

  private URI findNamespace()
    throws Exception
  {
    final var parsers =
      new XSSAXParsers();
    final var reader =
      parsers.createXMLReaderNonValidating();

    final var namespaces = new HashSet<URI>();
    reader.setContentHandler(new DefaultHandler()
    {
      @Override
      public void startPrefixMapping(
        final String prefix,
        final String uri)
      {
        namespaces.add(URI.create(uri));
      }
    });

    try (var stream = Files.newInputStream(this.request.sourceFile())) {
      final var source = new InputSource();
      source.setByteStream(stream);
      source.setSystemId(this.request.sourceFile().toString());
      reader.parse(source);
    }

    namespaces.retainAll(XSSchemas.namespaces());

    if (namespaces.size() != 1) {
      final var lineSeparator = System.lineSeparator();
      final var builder = new StringBuilder(128);
      builder.append("Ambiguous document.");
      builder.append(lineSeparator);
      builder.append(
        "  Problem: The input document uses multiple xstructural schemas");
      builder.append(lineSeparator);
      builder.append("           Cannot determine which XSLT stylesheet to use!");
      builder.append(lineSeparator);
      builder.append("  Namespaces: ");
      builder.append(namespaces);
      builder.append(lineSeparator);
      throw new XSTransformException(builder.toString());
    }

    final var target = namespaces.iterator().next();
    LOG.info("document uses namespace {}", target);
    return target;
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

  private XsltExecutable compileStylesheet(
    final URI target,
    final XsltCompiler compiler)
    throws IOException, SaxonApiException, XSTransformException
  {
    final var url = this.selectStylesheet(target);
    Objects.requireNonNull(url, "url");
    LOG.debug("compiling stylesheet {}", url);

    final XsltExecutable executable;
    try (var stream = url.openStream()) {
      final var source = new InputSource();
      source.setByteStream(stream);
      source.setSystemId(url.toString());
      executable = compiler.compile(new SAXSource(source));
    }
    return executable;
  }

  private URL selectStylesheet(
    final URI target)
    throws XSTransformException
  {
    return switch (this.request.stylesheet()) {
      case SINGLE_FILE -> {
        if (Objects.equals(target, XSSchemas.namespace7p0())) {
          yield this.resources.s7Single();
        }
        if (Objects.equals(target, XSSchemas.namespace8p0())) {
          yield this.resources.s8Single();
        }
        throw new IllegalStateException();
      }

      case MULTIPLE_FILE -> {
        if (Objects.equals(target, XSSchemas.namespace7p0())) {
          yield this.resources.s7Multi();
        }
        if (Objects.equals(target, XSSchemas.namespace8p0())) {
          yield this.resources.s8Multi();
        }
        throw new IllegalStateException();
      }

      case EPUB -> {
        if (Objects.equals(target, XSSchemas.namespace7p0())) {
          throw epub7NotSupported();
        }
        if (Objects.equals(target, XSSchemas.namespace8p0())) {
          yield this.resources.s8Epub();
        }
        throw new IllegalStateException();
      }

      case MULTIPLE_FILE_INDEX_ONLY -> {
        if (Objects.equals(target, XSSchemas.namespace7p0())) {
          throw index7NotSupported();
        }
        if (Objects.equals(target, XSSchemas.namespace8p0())) {
          yield this.resources.s8Index();
        }
        throw new IllegalStateException();
      }
    };
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
