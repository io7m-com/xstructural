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

import com.io7m.xstructural.api.XSProcessorException;
import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.api.XSProcessorType;
import com.io7m.xstructural.xml.SXMLResources;

import java.util.Objects;

/**
 * An XSL processor.
 */

public final class XSProcessor implements XSProcessorType
{
  private final SXMLResources resources;
  private final XSProcessorRequest request;
  private final XSTransformer transformer;
  private final XSValidator validator;
  private final XSXHTMLValidator xhtmlValidator;
  private final XSEPUBCreator epubCreator;

  /**
   * An XSL processor.
   *
   * @param inRequest An XSL processor request
   */

  public XSProcessor(
    final XSProcessorRequest inRequest)
  {
    this.request =
      Objects.requireNonNull(inRequest, "request");
    this.resources =
      new SXMLResources();

    this.validator =
      new XSValidator(this.resources, this.request);
    this.transformer =
      new XSTransformer(this.resources, this.request);
    this.xhtmlValidator =
      new XSXHTMLValidator(this.resources, this.request);
    this.epubCreator =
      new XSEPUBCreator(this.resources, this.request);
  }

  @Override
  public void execute()
    throws XSProcessorException
  {
    this.validator.execute();

    switch (this.request.task()) {
      case VALIDATE: {
        break;
      }
      case TRANSFORM_XHTML: {
        this.transformer.execute();
        this.xhtmlValidator.execute();
        break;
      }
      case TRANSFORM_EPUB:
        this.transformer.execute();
        this.xhtmlValidator.execute();
        this.epubCreator.execute();
        break;
    }
  }
}
