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
import org.w3c.dom.bootstrap.DOMImplementationRegistry;
import org.w3c.dom.ls.DOMImplementationLS;
import org.w3c.dom.ls.LSInput;
import org.w3c.dom.ls.LSResourceResolver;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.NoSuchFileException;
import java.util.Objects;

/**
 * A resource resolver.
 */

public final class XSResourceResolver implements LSResourceResolver
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSResourceResolver.class);

  private final SXMLResources resources;
  private final DOMImplementationLS domImplementationLS;

  /**
   * A resource resolver.
   *
   * @param inResources The SXML resources
   *
   * @throws Exception On errors
   */

  public XSResourceResolver(
    final SXMLResources inResources)
    throws Exception
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");

    final DOMImplementationRegistry domImplementationRegistry =
      DOMImplementationRegistry.newInstance();
    this.domImplementationLS =
      (DOMImplementationLS) domImplementationRegistry.getDOMImplementation("LS");
  }

  @Override
  public LSInput resolveResource(
    final String type,
    final String namespaceURI,
    final String publicId,
    final String systemId,
    final String baseURI)
  {
    try {
      LOG.debug(
        "resolveResource: {} {} {} {} {}",
        type,
        namespaceURI,
        publicId,
        systemId,
        baseURI
      );

      if (namespaceURI != null) {
        switch (namespaceURI) {
          case "urn:com.io7m.structural:7:0": {
            final var input = this.domImplementationLS.createLSInput();
            input.setSystemId(systemId);
            input.setPublicId(publicId);
            input.setBaseURI(baseURI);
            input.setByteStream(this.resources.xstructuralResourceOf("xstructural-7.xsd").openStream());
            return input;
          }
          case "urn:com.io7m.structural:8:0": {
            final var input = this.domImplementationLS.createLSInput();
            input.setSystemId(systemId);
            input.setPublicId(publicId);
            input.setBaseURI(baseURI);
            input.setByteStream(this.resources.xstructuralResourceOf("xstructural-8.xsd").openStream());
            return input;
          }
          default: {
            break;
          }
        }
      }

      final var xsdFileOpt =
        this.resources.xsdResources()
          .filter(name -> name.equals(systemId))
          .findFirst();

      if (xsdFileOpt.isPresent()) {
        final var xsdFile = xsdFileOpt.get();
        final var input = this.domImplementationLS.createLSInput();
        input.setSystemId(systemId);
        input.setPublicId(publicId);
        input.setBaseURI(baseURI);
        input.setByteStream(this.resources.xsdResourceOf(xsdFile).openStream());
        return input;
      }

      final var xsFileOpt =
        this.resources.xstructuralResources()
          .filter(name -> name.equals(systemId))
          .findFirst();

      if (xsFileOpt.isPresent()) {
        final var xsFile = xsFileOpt.get();
        final var input = this.domImplementationLS.createLSInput();
        input.setSystemId(systemId);
        input.setPublicId(publicId);
        input.setBaseURI(baseURI);
        input.setByteStream(this.resources.xstructuralResourceOf(xsFile).openStream());
        return input;
      }

      final var w3cFileOpt =
        this.resources.w3cXHTMLResources()
          .filter(name -> name.equals(systemId))
          .findFirst();

      if (w3cFileOpt.isPresent()) {
        final var w3cFile = w3cFileOpt.get();
        final var input = this.domImplementationLS.createLSInput();
        input.setSystemId(systemId);
        input.setPublicId(publicId);
        input.setBaseURI(baseURI);
        input.setByteStream(this.resources.w3cXHTMLResourceOf(w3cFile).openStream());
        return input;
      }

      throw new NoSuchFileException(systemId);
    } catch (final IOException e) {
      throw new UncheckedIOException(e);
    }
  }
}
