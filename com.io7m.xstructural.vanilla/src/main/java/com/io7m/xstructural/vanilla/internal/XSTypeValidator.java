/*
 * Copyright © 2025 Mark Raynsford <code@io7m.com> https://www.io7m.com
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
import com.io7m.xstructural.api.XSValidationException;
import com.io7m.xstructural.xml.SXMLResources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Objects;
import java.util.regex.Pattern;

/**
 * A type attribute validator.
 */

public final class XSTypeValidator implements ContentHandler, ErrorHandler
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSTypeValidator.class);
  private static final Pattern WHITESPACE =
    Pattern.compile("\\s+");

  private final SXMLResources resources;
  private final XSProcessorRequest request;
  private final Path typeFile;
  private final XSSAXParsers parsers;
  private Locator locator;
  private XSTypeAttributeDeclarationCollection types;
  private boolean failed;
  private int checked;

  /**
   * A type attribute validator.
   *
   * @param inResources The SXML resources
   * @param inRequest   The transform request
   */

  public XSTypeValidator(
    final SXMLResources inResources,
    final XSProcessorRequest inRequest)
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");
    this.request =
      Objects.requireNonNull(inRequest, "request");
    this.parsers =
      new XSSAXParsers();
    this.typeFile =
      this.request.typeDescriptionFile()
        .orElseThrow();
  }

  /**
   * Execute the validator.
   *
   * @throws XSValidationException On errors
   */

  public void execute()
    throws XSValidationException
  {
    try {
      LOG.info("Validating type attributes.");

      this.types =
        XSTypeLoader.read(this.typeFile);
      final var parser =
        this.parsers.createXMLReaderNonValidating();

      try (var stream = Files.newInputStream(this.request.sourceFile())) {
        final var source = new InputSource(stream);
        source.setSystemId(this.request.sourceFile().toUri().toString());
        parser.setContentHandler(this);
        parser.setErrorHandler(this);
        parser.parse(source);

        if (this.failed) {
          throw new XSValidationException(
            "One or more validation errors occurred."
          );
        }

        LOG.info("Validated {} type attributes.", this.checked);
      }
    } catch (final Exception e) {
      throw new XSValidationException(e);
    }
  }

  @Override
  public void setDocumentLocator(
    final Locator newLocator)
  {
    this.locator = newLocator;
  }

  @Override
  public void startDocument()
  {

  }

  @Override
  public void endDocument()
  {

  }

  @Override
  public void startPrefixMapping(
    final String prefix,
    final String uri)
  {

  }

  @Override
  public void endPrefixMapping(
    final String prefix)
  {

  }

  @Override
  public void startElement(
    final String uri,
    final String localName,
    final String qName,
    final Attributes atts)
  {
    final var type = atts.getValue("type");
    if (type != null) {
      final var typeNames = List.of(WHITESPACE.split(type));
      for (final var typeName : typeNames) {
        this.checkType(typeName);
      }
    }
  }

  private void checkType(
    final String typeName)
  {
    final var type = this.types.types().get(typeName);
    if (type == null) {
      this.failed = true;
      LOG.error(
        "{}:{}:{}: Undeclared type '{}'",
        this.locator.getSystemId(),
        Integer.valueOf(this.locator.getLineNumber()),
        Integer.valueOf(this.locator.getColumnNumber()),
        typeName
      );
    } else {
      ++this.checked;
    }
  }

  @Override
  public void endElement(
    final String uri,
    final String localName,
    final String qName)
  {

  }

  @Override
  public void characters(
    final char[] ch,
    final int start,
    final int length)
  {

  }

  @Override
  public void ignorableWhitespace(
    final char[] ch,
    final int start,
    final int length)
  {

  }

  @Override
  public void processingInstruction(
    final String target,
    final String data)
  {

  }

  @Override
  public void skippedEntity(
    final String name)
  {

  }

  @Override
  public void warning(
    final SAXParseException exception)
  {
    LOG.warn(
      "{}:{}:{}: {}",
      exception.getSystemId(),
      Integer.valueOf(exception.getLineNumber()),
      Integer.valueOf(exception.getColumnNumber()),
      exception.getMessage()
    );
  }

  @Override
  public void error(
    final SAXParseException exception)
    throws SAXException
  {
    this.failed = true;
    LOG.error(
      "{}:{}:{}: {}",
      exception.getSystemId(),
      Integer.valueOf(exception.getLineNumber()),
      Integer.valueOf(exception.getColumnNumber()),
      exception.getMessage()
    );
  }

  @Override
  public void fatalError(
    final SAXParseException exception)
    throws SAXException
  {
    this.failed = true;
    LOG.error(
      "{}:{}:{}: {}",
      exception.getSystemId(),
      Integer.valueOf(exception.getLineNumber()),
      Integer.valueOf(exception.getColumnNumber()),
      exception.getMessage()
    );
    throw exception;
  }
}
