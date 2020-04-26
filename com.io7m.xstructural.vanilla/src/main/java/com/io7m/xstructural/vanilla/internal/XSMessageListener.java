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

import net.sf.saxon.s9api.MessageListener2;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.transform.SourceLocator;
import java.io.BufferedWriter;
import java.io.Closeable;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;

public final class XSMessageListener implements MessageListener2, Closeable
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSMessageListener.class);

  private final BufferedWriter stream;

  XSMessageListener(final Path path)
    throws IOException
  {
    this.stream = Files.newBufferedWriter(
      Objects.requireNonNull(path, "path")
    );
  }

  @Override
  public void message(
    final XdmNode content,
    final QName errorCode,
    final boolean terminate,
    final SourceLocator locator)
  {
    try {
      final var message =
        String.format(
          "%s:%d:%d: %s: %s",
          locator.getSystemId(),
          Integer.valueOf(locator.getLineNumber()),
          Integer.valueOf(locator.getColumnNumber()),
          errorCode.toString(),
          content.getStringValue()
        );
      LOG.debug("XSLT: {}", message);
      this.stream.write(message);
      this.stream.write(System.lineSeparator());
      this.stream.flush();
    } catch (final IOException e) {
      throw new UncheckedIOException(e);
    }
  }

  @Override
  public void close()
    throws IOException
  {
    this.stream.close();
  }
}
