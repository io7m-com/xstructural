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

package com.io7m.xstructural.tests;

import com.io7m.xstructural.cmdline.Main;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class XSCommandLineTest
{
  private Path directory;
  private Path sourceDirectory;
  private Path outputDirectory;
  private Path branding;

  @BeforeEach
  public void testSetup()
    throws IOException
  {
    this.directory = XSTestDirectories.createTempDirectory();
    this.sourceDirectory = this.directory.resolve("src");
    this.outputDirectory = this.directory.resolve("out");
    Files.createDirectories(this.sourceDirectory);
    Files.createDirectories(this.outputDirectory);

    this.branding =
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "brand.xml"
      );
  }

  @Test
  public void testNoArguments()
    throws Exception
  {
    final var main = new Main(new String[]{

    });
    main.run();
    Assertions.assertEquals(1, main.exitCode());
  }

  @Test
  public void testValidateMissingSource()
    throws Exception
  {
    final var main = new Main(new String[]{
      "validate",
      "--outputDirectory",
      this.outputDirectory.toString()
    });
    main.run();
    Assertions.assertEquals(1, main.exitCode());
  }

  @Test
  public void testValidateOK()
    throws Exception
  {
    final var main = new Main(new String[]{
      "validate",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString(),
      "--verbose",
      "trace"
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());
  }


  @Test
  public void testTransformXHTMLMissingOutput()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString()
    });
    main.run();
    Assertions.assertEquals(1, main.exitCode());
  }

  @Test
  public void testTransformXHTMLMissingSource()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--outputDirectory",
      this.outputDirectory.toString()
    });
    main.run();
    Assertions.assertEquals(1, main.exitCode());
  }

  @Test
  public void testTransformXHTMLOK()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--verbose",
      "trace"
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());
  }

  @Test
  public void testTransformXHTMLSingleOK()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace",
      "--stylesheet",
      "SINGLE_FILE"
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());

    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("trace.xml")),
      "Trace file exists"
    );
    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("messages.log")),
      "Messages file exists"
    );
    Assertions.assertTrue(
      Files.isRegularFile(this.outputDirectory.resolve("index.xhtml")),
      "Index file exists"
    );
  }

  @Test
  public void testTransformXHTMLSingleBrandingOK()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace",
      "--brandingFile",
      this.branding.toString(),
      "--stylesheet",
      "SINGLE_FILE"
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());

    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("trace.xml")),
      "Trace file exists"
    );
    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("messages.log")),
      "Messages file exists"
    );
    Assertions.assertTrue(
      Files.isRegularFile(this.outputDirectory.resolve("index.xhtml")),
      "Index file exists"
    );
  }

  @Test
  public void testTransformXHTMLMultiOK()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace",
      "--stylesheet",
      "MULTIPLE_FILE"
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());

    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("trace.xml")),
      "Trace file exists"
    );
    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("messages.log")),
      "Messages file exists"
    );
  }

  @Test
  public void testTransformXHTMLMultiBrandingOK()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace",
      "--brandingFile",
      this.branding.toString(),
      "--stylesheet",
      "MULTIPLE_FILE"
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());

    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("trace.xml")),
      "Trace file exists"
    );
    Assertions.assertTrue(
      Files.isRegularFile(this.directory.resolve("messages.log")),
      "Messages file exists"
    );
  }
}
