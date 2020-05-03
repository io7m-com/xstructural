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
import com.io7m.xstructural.api.XSValidationException;
import com.io7m.xstructural.xml.SXMLResources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;

import javax.xml.XMLConstants;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.sax.SAXSource;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.nio.file.Files;
import java.util.Objects;

public final class XSValidator implements XSProcessorType
{
  private static final Logger LOG = LoggerFactory.getLogger(XSValidator.class);

  private final SXMLResources resources;
  private final XSProcessorRequest request;
  private final SAXParserFactory parsers;

  public XSValidator(
    final SXMLResources inResources,
    final XSProcessorRequest inRequest)
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");
    this.request =
      Objects.requireNonNull(inRequest, "request");

    this.parsers = SAXParserFactory.newInstance();
  }

  @Override
  public void execute()
    throws XSValidationException
  {
    LOG.debug("validating source file");

    try {
      final var schemaUrl = this.resources.schema();
      try (var schemaStream = schemaUrl.openStream()) {
        final var schemaSource = new InputSource();
        schemaSource.setByteStream(schemaStream);
        schemaSource.setSystemId(schemaUrl.toString());

        LOG.debug("creating schema");
        final var schemaFactory =
          SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);

        final var schemaErrorHandler =
          new XSErrorHandler(
            LoggerFactory.getLogger(XSValidator.class.getCanonicalName() + ".schemaCompilation")
          );
        schemaFactory.setErrorHandler(schemaErrorHandler);
        schemaFactory.setResourceResolver(
          new XSResourceResolver(this.resources));

        final var schema =
          schemaFactory.newSchema(new SAXSource(schemaSource));

        if (schemaErrorHandler.isFailed()) {
          throw new XSValidationException("Error compiling schema");
        }

        final var sourcePath = this.request.sourceFile();
        LOG.info("validate (xstructural) {}", sourcePath);

        final var parser = this.parsers.newSAXParser();
        final var reader = parser.getXMLReader();

        reader.setFeature(
          XMLConstants.FEATURE_SECURE_PROCESSING,
          true);
        reader.setProperty(
          XMLConstants.ACCESS_EXTERNAL_SCHEMA,
          "");
        reader.setProperty(
          XMLConstants.ACCESS_EXTERNAL_DTD,
          "");
        reader.setFeature(
          "http://apache.org/xml/features/nonvalidating/load-external-dtd",
          false);
        reader.setFeature(
          "http://apache.org/xml/features/xinclude",
          true);
        reader.setFeature(
          "http://xml.org/sax/features/namespaces",
          true);
        reader.setFeature(
          "http://xml.org/sax/features/validation",
          false);
        reader.setFeature(
          "http://apache.org/xml/features/validation/schema",
          false);

        try (var sourceStream = Files.newInputStream(sourcePath)) {
          final var fileSource = new InputSource();
          fileSource.setByteStream(sourceStream);
          fileSource.setSystemId(sourcePath.toString());
          final var saxSource = new SAXSource(reader, fileSource);

          final Validator validator = schema.newValidator();
          final XSErrorHandler errorHandler =
            new XSErrorHandler(LoggerFactory.getLogger(
              XSValidator.class.getCanonicalName() + ".validation"));

          validator.setErrorHandler(errorHandler);
          validator.validate(saxSource);
          if (errorHandler.isFailed()) {
            LOG.error("one or more validation errors occurred");
            throw new XSValidationException(
              String.format(
                "Document %s is not a valid structural document",
                sourcePath
              )
            );
          }
        }
      }
    } catch (final Exception e) {
      throw new XSValidationException(e);
    }
  }
}
