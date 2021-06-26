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

  /**
   * Find a W3C XHTML schema resource.
   *
   * @param name The name
   *
   * @return The resource URL
   */

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

  /**
   * @return The available W3C XHTML schema resources
   */

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

  /**
   * Find an XSD resource with the given name.
   *
   * @param name The name
   *
   * @return The resource URL
   */

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

  /**
   * @return The available XSD resources
   */

  public Stream<String> xsdResources()
  {
    return Stream.of(
      "datatypes.dtd",
      "XMLSchema.dtd"
    );
  }

  /**
   * Find the xstructural resource with the given name.
   *
   * @param name The name
   *
   * @return The resource URL
   */

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

  /**
   * @return The available xstructural resources
   */

  public Stream<String> xstructuralResources()
  {
    return Stream.of(
      "dc.xsd",
      "xml.xsd",
      "xstructural-7.xsd",
      "xstructural-7_1.xsd"
    );
  }

  /**
   * @return The W3C XHTML schema
   */

  public URL w3cXHTMLSchema()
  {
    return this.w3cXHTMLResourceOf("xhtml11.xsd");
  }

  /**
   * @deprecated Use {@link #schema7p0()}
   * @return The xstructural XSD schema
   */

  @Deprecated(since = "1.3.0")
  public URL schema()
  {
    return SXMLResources.class.getResource("xstructural-7.xsd");
  }

  /**
   * @return The xstructural XSD 7.0 schema
   */

  public URL schema7p0()
  {
    return SXMLResources.class.getResource("xstructural-7.xsd");
  }

  /**
   * @return The xstructural XSD 7.1 schema
   */

  public URL schema7p1()
  {
    return SXMLResources.class.getResource("xstructural-7_1.xsd");
  }

  /**
   * @return The xstructural core XSL stylesheet
   */

  public URL core()
  {
    return SXMLResources.class.getResource("xstructural1-core.xsl");
  }

  /**
   * @return The xstructural multi-page XSL stylesheet
   */

  public URL multi()
  {
    return SXMLResources.class.getResource("xstructural1-multi.xsl");
  }

  /**
   * @return The xstructural single-page XSL stylesheet
   */

  public URL single()
  {
    return SXMLResources.class.getResource("xstructural1-single.xsl");
  }

  /**
   * @return The xstructural EPUB XSL stylesheet
   */

  public URL epub()
  {
    return SXMLResources.class.getResource("xstructural1-epub.xsl");
  }

  /**
   * @return The xstructural EPUB package XSL stylesheet
   */

  public URL epubPackage()
  {
    return SXMLResources.class.getResource("xstructural1-epub-package.xsl");
  }

  /**
   * @return The xstructural CSS stylesheet
   */

  public URL cssStructural()
  {
    return SXMLResources.class.getResource("structural.css");
  }

  /**
   * @return The xstructural EPUB CSS stylesheet
   */

  public URL cssStructuralEPUB()
  {
    return SXMLResources.class.getResource("structural-epub.css");
  }

  /**
   * @return The xstructural reset CSS stylesheet
   */

  public URL cssReset()
  {
    return SXMLResources.class.getResource("reset.css");
  }

  /**
   * @return The xstructural EPUB reset CSS stylesheet
   */

  public URL cssResetEPUB()
  {
    return SXMLResources.class.getResource("reset-epub.css");
  }
}
