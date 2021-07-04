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

package com.io7m.xstructural.tests;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.Objects;

import static java.nio.charset.StandardCharsets.UTF_8;

public final class XSOutputCaptured
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSOutputCaptured.class);

  private final String textOut;
  private final String textErr;

  private XSOutputCaptured(
    final String inTextOut,
    final String inTextErr)
  {
    this.textOut =
      Objects.requireNonNull(inTextOut, "textOut");
    this.textErr =
      Objects.requireNonNull(inTextErr, "textErr");
  }

  public static XSOutputCaptured capture(
    final ProcedureType proc)
    throws Exception
  {
    Objects.requireNonNull(proc, "proc");

    final var out = System.out;
    final var err = System.err;
    final ByteArrayOutputStream bArrayOut;
    final ByteArrayOutputStream bArrayErr;

    try {
      bArrayOut = new ByteArrayOutputStream();
      final var bOut = new PrintStream(bArrayOut, true, UTF_8);
      bArrayErr = new ByteArrayOutputStream();
      final var bErr = new PrintStream(bArrayErr, true, UTF_8);

      System.setOut(bOut);
      System.setErr(bErr);
      proc.execute();
      bOut.flush();
      bErr.flush();
    } finally {
      try {
        System.setOut(out);
      } catch (final Exception e) {
        e.printStackTrace();
      }
      try {
        System.setErr(err);
      } catch (final Exception e) {
        e.printStackTrace();
      }
    }

    final var outText = bArrayOut.toString(UTF_8);
    final var errText = bArrayErr.toString(UTF_8);
    LOG.debug("stdout: {}", outText);
    LOG.debug("stderr: {}", errText);
    return new XSOutputCaptured(outText, errText);
  }

  public String textOutput()
  {
    return this.textOut;
  }

  public String textError()
  {
    return this.textErr;
  }

  public interface ProcedureType
  {
    void execute()
      throws Exception;
  }
}
