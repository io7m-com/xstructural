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

import net.sf.saxon.s9api.XsltTransformer;
import net.sf.saxon.tree.util.DocumentNumberAllocator;

/**
 * Functions to reset document numbering in Saxon.
 */

public final class XSDocumentNumbering
{
  private XSDocumentNumbering()
  {

  }

  /**
   * When the XSLT processor transforms a document, it uses a document number
   * allocator that will be called when XSLT code calls generate-id(). The
   * document number allocator increments a counter for each document
   * encountered. This means that an XSLT transformer that has transformed
   * multiple documents will give different values for generate-id() than
   * one that has transformed only one document. Because the XSLT transformer
   * that is used before this EPUB package creator will transform multiple
   * documents due to having to compile multiple stylesheets, we need to
   * manually increment the document number allocator for _this_ transformer
   * in order to get the same filename values in the generated EPUB package.
   *
   * @param transformer The XSLT transformer
   */

  public static void fixDocumentNumber(
    final XsltTransformer transformer)
  {
    final var numberAllocator =
      new DocumentNumberAllocator();

    transformer.getUnderlyingController()
      .getConfiguration()
      .setDocumentNumberAllocator(numberAllocator);
  }
}
