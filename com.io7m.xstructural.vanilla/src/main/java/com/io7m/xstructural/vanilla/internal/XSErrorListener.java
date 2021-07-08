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

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;
import java.util.Objects;

final class XSErrorListener implements ErrorListener
{
  private final Logger logger;

  XSErrorListener(
    final Logger inLogger)
  {
    this.logger = Objects.requireNonNull(inLogger, "logger");
  }

  @Override
  public void warning(final TransformerException exception)
  {
    this.logger.warn(
      "{}:{}:{}: {}",
      exception.getLocator().getSystemId(),
      Integer.valueOf(exception.getLocator().getLineNumber()),
      Integer.valueOf(exception.getLocator().getColumnNumber()),
      exception.getMessage()
    );
  }

  @Override
  public void error(final TransformerException exception)
  {
    this.logger.error(
      "{}:{}:{}: {}",
      exception.getLocator().getSystemId(),
      Integer.valueOf(exception.getLocator().getLineNumber()),
      Integer.valueOf(exception.getLocator().getColumnNumber()),
      exception.getMessage()
    );
  }

  @Override
  public void fatalError(final TransformerException exception)
    throws TransformerException
  {
    this.logger.error(
      "{}:{}:{}: {}",
      exception.getLocator().getSystemId(),
      Integer.valueOf(exception.getLocator().getLineNumber()),
      Integer.valueOf(exception.getLocator().getColumnNumber()),
      exception.getMessage()
    );
    throw exception;
  }
}
