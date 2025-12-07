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

import com.io7m.xstructural.api.XSValidationException;
import com.io7m.xstructural.vanilla.internal.XSTypeAttributeDeclaration;
import com.io7m.xstructural.vanilla.internal.XSTypeLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Locale;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

public final class XSTypeLoaderTest
{
  private Path directory;

  @BeforeEach
  public void testSetup()
    throws IOException
  {
    this.directory = XSTestDirectories.createTempDirectory();
  }

  @Test
  public void testLoadOK_0()
    throws Exception
  {
    final var types =
      XSTypeLoader.read(
        XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.directory,
          "types-example-0.xml"
        )
      );

    {
      final var t = types.types().get("y");
      assertEquals("y", t.name());
      assertEquals(3, t.description().size());
      final var en = t.description().get(Locale.forLanguageTag("en"));
      final var fr = t.description().get(Locale.forLanguageTag("fr"));
      final var de = t.description().get(Locale.forLanguageTag("de"));
      assertEquals("Something.", en.text());
      assertEquals("Quelque chose.", fr.text());
      assertEquals("Etwas.", de.text());
    }

    {
      final var t = types.types().get("z");
      assertEquals("z", t.name());
      assertEquals(3, t.description().size());
      final var en = t.description().get(Locale.forLanguageTag("en"));
      final var fr = t.description().get(Locale.forLanguageTag("fr"));
      final var de = t.description().get(Locale.forLanguageTag("de"));
      assertEquals("Something else.", en.text());
      assertEquals("Autre chose.", fr.text());
      assertEquals("Etwas anderes.", de.text());
    }
  }

  @Test
  public void testLoadOK_1()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSProcessorTest.class,
      this.directory,
      "types-example-1a.xml"
    );
    XSTestDirectories.resourceOf(
      XSProcessorTest.class,
      this.directory,
      "types-example-1b.xml"
    );

    final var types =
      XSTypeLoader.read(
        XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.directory,
          "types-example-1.xml"
        )
      );

    {
      final var t = types.types().get("y");
      assertEquals("y", t.name());
      assertEquals(3, t.description().size());
      final var en = t.description().get(Locale.forLanguageTag("en"));
      final var fr = t.description().get(Locale.forLanguageTag("fr"));
      final var de = t.description().get(Locale.forLanguageTag("de"));
      assertEquals("Something.", en.text());
      assertEquals("Quelque chose.", fr.text());
      assertEquals("Etwas.", de.text());
    }

    {
      final var t = types.types().get("z");
      assertEquals("z", t.name());
      assertEquals(3, t.description().size());
      final var en = t.description().get(Locale.forLanguageTag("en"));
      final var fr = t.description().get(Locale.forLanguageTag("fr"));
      final var de = t.description().get(Locale.forLanguageTag("de"));
      assertEquals("Something else.", en.text());
      assertEquals("Autre chose.", fr.text());
      assertEquals("Etwas anderes.", de.text());
    }
  }

  @Test
  public void testLoadInvalid0()
  {
    assertThrows(XSValidationException.class, () -> {
      XSTypeLoader.read(
        XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.directory,
          "types-invalid-0.xml"
        )
      );
    });
  }
}
