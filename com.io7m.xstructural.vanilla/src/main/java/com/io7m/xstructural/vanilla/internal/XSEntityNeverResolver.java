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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.ext.EntityResolver2;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.NoSuchFileException;

/**
 * A resource resolver.
 */

public final class XSEntityNeverResolver
  implements EntityResolver2
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSEntityNeverResolver.class);

  /**
   * A resource resolver.
   *
   */

  public XSEntityNeverResolver()
  {

  }

  @Override
  public InputSource getExternalSubset(
    final String name,
    final String baseURI)
    throws SAXException
  {
    /*
     * This will be encountered upon inline entity definitions.
     */

    final String lineSeparator = System.lineSeparator();
    throw new SAXException(
      new StringBuilder(128)
        .append(
          "External subsets are explicitly forbidden by this parser configuration.")
        .append(lineSeparator)
        .append("  Name: ")
        .append(name)
        .append(lineSeparator)
        .toString());
  }

  @Override
  public InputSource resolveEntity(
    final String name,
    final String publicId,
    final String baseURI,
    final String systemId)
  {
    try {
      LOG.debug(
        "resolveEntity: {} {} {} {}",
        name,
        publicId,
        systemId,
        baseURI
      );

      throw new NoSuchFileException(systemId);
    } catch (final IOException e) {
      throw new UncheckedIOException(e);
    }
  }

  /*
   * It's necessary to explicitly set a system ID for the input
   * source, or Xerces XIncludeHandler.searchForRecursiveIncludes()
   * method will raise a null pointer exception when it tries to
   * call equals() on a null system ID.
   */

  @Override
  public InputSource resolveEntity(
    final String publicId,
    final String systemId)
  {
    throw new UnsupportedOperationException(
      "Simple entity resolution not supported");
  }
}
