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

import com.io7m.xstructural.xml.SXMLResources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.ext.EntityResolver2;

import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.util.Objects;

/**
 * A resource resolver.
 */

public final class XSEntityResolver
  implements EntityResolver2
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSEntityResolver.class);

  private final SXMLResources resources;
  private final Path baseDirectory;

  /**
   * A resource resolver.
   *
   * @param inResources     The SXML resources
   * @param inBaseDirectory The base directory
   */

  public XSEntityResolver(
    final Path inBaseDirectory,
    final SXMLResources inResources)
  {
    this.baseDirectory =
      Objects.requireNonNull(inBaseDirectory, "baseDirectory");
    this.resources =
      Objects.requireNonNull(inResources, "resources");
  }

  @Override
  public InputSource getExternalSubset(
    final String name,
    final String baseURI)
  {
    return null;
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

      switch (systemId) {
        case "datatypes.dtd":
        case "XMLSchema.dtd": {
          final var source = new InputSource(systemId);
          source.setPublicId(publicId);
          source.setByteStream(this.resources.xsdResourceOf(systemId).openStream());
          return source;
        }

        case "xstructural-8.xsd":
        case "xstructural-7.xsd":
        case "xml.xsd":
        case "dc.xsd": {
          final var source = new InputSource(systemId);
          source.setPublicId(publicId);
          source.setByteStream(this.resources.xstructuralResourceOf(systemId).openStream());
          return source;
        }

        default: {
          break;
        }
      }

      LOG.debug("resolving {} from filesystem", systemId);

      final Path resolved =
        this.baseDirectory.resolve(systemId)
          .toAbsolutePath()
          .normalize();

      if (!resolved.startsWith(this.baseDirectory)) {
        final var lineSeparator = System.lineSeparator();
        throw new SAXException(
          new StringBuilder(128)
            .append(
              "Refusing to allow access to files above the base directory.")
            .append(lineSeparator)
            .append("  Base: ")
            .append(this.baseDirectory)
            .append(lineSeparator)
            .append("  Path: ")
            .append(resolved)
            .append(lineSeparator)
            .toString());
      }

      if (!Files.isRegularFile(resolved, LinkOption.NOFOLLOW_LINKS)) {
        throw new NoSuchFileException(
          resolved.toString(),
          null,
          "File does not exist or is not a regular file");
      }

      return createSource(Files.newInputStream(resolved), resolved.toString());
    } catch (final IOException | SAXException e) {
      throw new UncheckedIOException(new IOException(e));
    }
  }

  /*
   * It's necessary to explicitly set a system ID for the input
   * source, or Xerces XIncludeHandler.searchForRecursiveIncludes()
   * method will raise a null pointer exception when it tries to
   * call equals() on a null system ID.
   */

  private static InputSource createSource(
    final InputStream stream,
    final String system_id)
  {
    final InputSource source = new InputSource(stream);
    source.setSystemId(system_id);
    return source;
  }

  @Override
  public InputSource resolveEntity(
    final String publicId,
    final String systemId)
  {
    throw new UnsupportedOperationException(
      "Simple entity resolution not supported");
  }
}
