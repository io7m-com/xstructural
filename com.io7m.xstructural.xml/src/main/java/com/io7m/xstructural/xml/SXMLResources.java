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

package com.io7m.xstructural.xml;

import java.io.UncheckedIOException;
import java.net.URL;
import java.nio.file.NoSuchFileException;
import java.util.Objects;
import java.util.stream.Stream;

/**
 * Resources exposed by the module.
 */

public final class SXMLResources
{
  /**
   * Construct a resource provider.
   */

  public SXMLResources()
  {

  }

  public URL w3cXHTMLResourceOf(
    final String name)
  {
    Objects.requireNonNull(name, "name");

    final var path =
      String.format("/com/io7m/xstructural/xml/org/w3c/xhtml/%s", name);
    final var resource =
      SXMLResources.class.getResource(path);
    if (resource == null) {
      throw new UncheckedIOException(new NoSuchFileException(path));
    }
    return resource;
  }

  public Stream<String> w3cXHTMLResources()
  {
    return Stream.of(
      "xhtml-attribs-1.xsd",
      "xhtml-base-1.xsd",
      "xhtml-bdo-1.xsd",
      "xhtml-blkphras-1.xsd",
      "xhtml-blkpres-1.xsd",
      "xhtml-blkstruct-1.xsd",
      "xhtml-charent-1.xsd",
      "xhtml-csismap-1.xsd",
      "xhtml-datatypes-1.xsd",
      "xhtml-edit-1.xsd",
      "xhtml-events-1.xsd",
      "xhtml-form-1.xsd",
      "xhtml-framework-1.xsd",
      "xhtml-hypertext-1.xsd",
      "xhtml-image-1.xsd",
      "xhtml-inlphras-1.xsd",
      "xhtml-inlpres-1.xsd",
      "xhtml-inlstruct-1.xsd",
      "xhtml-inlstyle-1.xsd",
      "xhtml-link-1.xsd",
      "xhtml-list-1.xsd",
      "xhtml-meta-1.xsd",
      "xhtml-notations-1.xsd",
      "xhtml-object-1.xsd",
      "xhtml-param-1.xsd",
      "xhtml-pres-1.xsd",
      "xhtml-ruby-1.xsd",
      "xhtml-script-1.xsd",
      "xhtml-ssismap-1.xsd",
      "xhtml-struct-1.xsd",
      "xhtml-style-1.xsd",
      "xhtml-table-1.xsd",
      "xhtml-target-1.xsd",
      "xhtml-text-1.xsd",
      "xhtml11-model-1.xsd",
      "xhtml11-modules-1.xsd",
      "xhtml11.xsd",
      "xml.xsd"
    );
  }

  public URL xsdResourceOf(
    final String name)
  {
    Objects.requireNonNull(name, "name");

    final var path =
      String.format("/com/io7m/xstructural/xml/org/w3c/%s", name);
    final var resource =
      SXMLResources.class.getResource(path);
    if (resource == null) {
      throw new UncheckedIOException(new NoSuchFileException(path));
    }
    return resource;
  }

  public Stream<String> xsdResources()
  {
    return Stream.of(
      "datatypes.dtd",
      "XMLSchema.dtd"
    );
  }

  public URL xstructuralResourceOf(
    final String name)
  {
    Objects.requireNonNull(name, "name");

    final var path =
      String.format("/com/io7m/xstructural/xml/%s", name);
    final var resource =
      SXMLResources.class.getResource(path);
    if (resource == null) {
      throw new UncheckedIOException(new NoSuchFileException(path));
    }
    return resource;
  }

  public Stream<String> xstructuralResources()
  {
    return Stream.of(
      "dc.xsd",
      "xml.xsd",
      "xstructural-1.xsd"
    );
  }

  public URL w3cXHTMLSchema()
  {
    return this.w3cXHTMLResourceOf("xhtml11.xsd");
  }

  public URL schema()
  {
    return SXMLResources.class.getResource("xstructural-1.xsd");
  }

  public URL core()
  {
    return SXMLResources.class.getResource("xstructural1-core.xsl");
  }

  public URL multi()
  {
    return SXMLResources.class.getResource("xstructural1-multi.xsl");
  }

  public URL single()
  {
    return SXMLResources.class.getResource("xstructural1-single.xsl");
  }
}
