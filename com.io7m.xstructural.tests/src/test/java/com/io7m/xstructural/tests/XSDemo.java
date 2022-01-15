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

import com.io7m.xstructural.cmdline.Main;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public final class XSDemo
{
  private XSDemo()
  {

  }

  public static void main(
    final String[] args)
    throws IOException
  {
    final var directory =
      Files.list(Paths.get("/tmp/xstructural"))
        .map(Path::toAbsolutePath)
        .filter(Files::isDirectory)
        .filter(XSDemo::isUUID)
        .findFirst()
        .orElseThrow();

    Main.main(new String[]{
      "validate-xhtml",
      "--sourceDirectory",
      directory + "/out/"
    });
  }

  private static boolean isUUID(
    final Path p)
  {
    try {
      UUID.fromString(p.getFileName().toString());
      return true;
    } catch (final Exception exception) {
      return false;
    }
  }
}
