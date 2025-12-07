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

import com.io7m.xstructural.api.XSSchemas;
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

import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * A loader for type declarations.
 */

public final class XSTypeLoader implements ContentHandler, ErrorHandler
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSTypeLoader.class);
  private static final Pattern WHITESPACE =
    Pattern.compile("\\s+");

  private final ArrayList<XSTypeAttributeDeclaration.LanguageString> descriptions;
  private final StringBuilder descriptionText;
  private final HashMap<String, XSTypeAttributeDeclaration> types;
  private Locator locator;
  private Locale descriptionLocale;
  private XSTypeAttributeDeclaration typeStart;
  private boolean failed;

  private XSTypeLoader()
  {
    this.descriptions = new ArrayList<>();
    this.descriptionText = new StringBuilder();
    this.types = new HashMap<>();
  }

  /**
   * Load type declarations.
   *
   * @param file The file
   *
   * @return The type declarations
   *
   * @throws Exception On errors
   */

  public static XSTypeAttributeDeclarationCollection read(
    final Path file)
    throws Exception
  {
    final var parsers = new XSSAXParsers();
    try (var stream = Files.newInputStream(file)) {
      final var source = new InputSource(stream);
      source.setSystemId(file.toUri().toString());

      final var reader =
        parsers.createXMLReader(file.getParent(), new SXMLResources());
      final var loader =
        new XSTypeLoader();

      reader.setErrorHandler(loader);
      reader.setContentHandler(loader);
      reader.parse(source);

      if (loader.failed) {
        throw new XSValidationException("One or more errors occurred.");
      }

      return new XSTypeAttributeDeclarationCollection(Map.copyOf(loader.types));
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
    if (this.failed) {
      return;
    }

    if (!Objects.equals(uri, XSSchemas.namespaceTypes().toString())) {
      return;
    }

    switch (localName) {
      case "Type" -> {
        final var typeName = atts.getValue("Name");
        this.typeStart = new XSTypeAttributeDeclaration(
          URI.create(this.locator.getSystemId()),
          this.locator.getLineNumber(),
          this.locator.getColumnNumber(),
          typeName,
          Map.of()
        );
      }
      case "Description" -> {
        final var tag = atts.getValue("xml:lang");
        this.descriptionLocale = Locale.forLanguageTag(tag);
        this.descriptionText.setLength(0);
      }
      default -> {

      }
    }
  }

  @Override
  public void endElement(
    final String uri,
    final String localName,
    final String qName)
  {
    if (this.failed) {
      return;
    }

    if (!Objects.equals(uri, XSSchemas.namespaceTypes().toString())) {
      return;
    }

    switch (localName) {
      case "Type" -> {
        this.types.put(
          this.typeStart.name(),
          new XSTypeAttributeDeclaration(
            this.typeStart.source(),
            this.typeStart.line(),
            this.typeStart.column(),
            this.typeStart.name(),
            this.descriptions.stream()
              .collect(Collectors.toMap(
                XSTypeAttributeDeclaration.LanguageString::locale,
                x -> x))
          )
        );

        this.typeStart = null;
        this.descriptions.clear();
      }
      case "Description" -> {
        this.descriptions.add(
          new XSTypeAttributeDeclaration.LanguageString(
            this.descriptionLocale,
            WHITESPACE.matcher(this.descriptionText.toString()).replaceAll(" ")
              .strip()
          )
        );
        this.descriptionLocale = null;
      }
      default -> {

      }
    }
  }

  @Override
  public void characters(
    final char[] ch,
    final int start,
    final int length)
  {
    if (this.failed) {
      return;
    }

    if (this.descriptionLocale != null) {
      this.descriptionText.append(new String(ch, start, length));
    }
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
    throws SAXException
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
