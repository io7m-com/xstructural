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
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Collectors;

import static java.nio.charset.StandardCharsets.UTF_8;

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

    final var capture =
      XSOutputCaptured.capture(main::run);

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

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(1, main.exitCode());
  }

  @Test
  public void testValidateOK_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "validate",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
        .toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
  }

  @Test
  public void testValidateOK_80()
    throws Exception
  {
    final var main = new Main(new String[]{
      "validate",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
        .toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
  }

  @Test
  public void testTransformXHTMLMissingOutput_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
        .toString()
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

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

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(1, main.exitCode());
  }

  @Test
  public void testTransformXHTMLOK_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
  }

  @Test
  public void testTransformXHTMLOK_80()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
  }

  @Test
  public void testTransformXHTMLSingleOK_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLSingleOK_80()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLSingleBrandingOK_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLSingleBrandingOK_80()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLMultiOK_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLMultiOK_80()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLMultiBrandingOK_70()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testTransformXHTMLMultiBrandingOK_80()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
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

    final var capture =
      XSOutputCaptured.capture(main::run);

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
  public void testSchema()
    throws Exception
  {
    final var main = new Main(new String[]{
      "schema",
      "--outputDirectory",
      this.outputDirectory.toString()
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());

    final var files =
      Files.list(this.outputDirectory)
        .map(Path::getFileName)
        .map(Path::toString)
        .collect(Collectors.toList());

    Assertions.assertEquals(5L, (long) files.size());
    Assertions.assertTrue(files.contains("xml.xsd"));
    Assertions.assertTrue(files.contains("dc.xsd"));
    Assertions.assertTrue(files.contains("xstructural-7.xsd"));
    Assertions.assertTrue(files.contains("xstructural-8.xsd"));
    Assertions.assertTrue(files.contains("xstructural-8-index.xsd"));
  }

  @Test
  public void testSchemaNoReplace()
    throws Exception
  {
    final var main = new Main(new String[]{
      "schema",
      "--outputDirectory",
      this.outputDirectory.toString()
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
    Assertions.assertEquals(5L, Files.list(this.outputDirectory).count());

    Files.list(this.outputDirectory)
      .forEach(path -> {
        try {
          Files.write(path, "Hello".getBytes(UTF_8));
        } catch (final IOException e) {
          throw new UncheckedIOException(e);
        }
      });

    final var mainAgain = new Main(new String[]{
      "schema",
      "--outputDirectory",
      this.outputDirectory.toString()
    });
    mainAgain.run();
    Assertions.assertEquals(0, mainAgain.exitCode());
    Assertions.assertEquals(5L, Files.list(this.outputDirectory).count());

    Files.list(this.outputDirectory)
      .forEach(path -> {
                 try {
                   Assertions.assertEquals(5L, Files.size(path));
                 } catch (final IOException e) {
                   throw new UncheckedIOException(e);
                 }
               }
      );
  }

  @Test
  public void testSchemaReplace()
    throws Exception
  {
    final var main = new Main(new String[]{
      "schema",
      "--outputDirectory",
      this.outputDirectory.toString()
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
    Assertions.assertEquals(5L, Files.list(this.outputDirectory).count());

    Files.list(this.outputDirectory)
      .forEach(path -> {
        try {
          Files.write(path, "Hello".getBytes(UTF_8));
        } catch (final IOException e) {
          throw new UncheckedIOException(e);
        }
      });

    final var mainAgain = new Main(new String[]{
      "schema",
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--replace",
      "true"
    });
    mainAgain.run();
    Assertions.assertEquals(0, mainAgain.exitCode());
    Assertions.assertEquals(5L, Files.list(this.outputDirectory).count());

    Files.list(this.outputDirectory)
      .forEach(path -> {
                 try {
                   Assertions.assertNotEquals(5L, Files.size(path));
                 } catch (final IOException e) {
                   throw new UncheckedIOException(e);
                 }
               }
      );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample0_70()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_70.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(1, main.exitCode());
    Assertions.assertTrue(capture.textError().contains(
      "Producing EPUB files from 7.0 documents is unsupported. Use 8.0 or newer."));

    Assertions.assertFalse(
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample1_70()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example1_70.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(1, main.exitCode());
    Assertions.assertTrue(capture.textError().contains(
      "Producing EPUB files from 7.0 documents is unsupported. Use 8.0 or newer."));

    Assertions.assertFalse(
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample1_80()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example1_80.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample2_70()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example2_70.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(1, main.exitCode());
    Assertions.assertTrue(capture.textError().contains(
      "Producing EPUB files from 7.0 documents is unsupported. Use 8.0 or newer."));

    Assertions.assertFalse(
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample2_80()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example2_80.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample0_80()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_80.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExampleTwice_80()
    throws Exception
  {
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "poppy.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "missing.jpg"
    );
    XSTestDirectories.resourceOf(
      XSCommandLineTest.class,
      this.sourceDirectory,
      "woods.jpg"
    );

    {
      final var main = new Main(new String[]{
        "epub",
        "--sourceFile",
        XSTestDirectories.resourceOf(
          XSCommandLineTest.class,
          this.sourceDirectory,
          "example0_80.xml")
          .toString(),
        "--outputDirectory",
        this.outputDirectory.toString(),
        "--traceFile",
        this.directory.resolve("trace.xml").toString(),
        "--messagesFile",
        this.directory.resolve("messages.log").toString(),
        "--verbose",
        "trace"
      });

      final var capture =
        XSOutputCaptured.capture(main::run);

      Assertions.assertEquals(0, main.exitCode());
    }

    {
      final var main = new Main(new String[]{
        "epub",
        "--sourceFile",
        XSTestDirectories.resourceOf(
          XSCommandLineTest.class,
          this.sourceDirectory,
          "example0_80.xml")
          .toString(),
        "--outputDirectory",
        this.outputDirectory.toString(),
        "--traceFile",
        this.directory.resolve("trace.xml").toString(),
        "--messagesFile",
        this.directory.resolve("messages.log").toString(),
        "--verbose",
        "trace"
      });

      final var capture =
        XSOutputCaptured.capture(main::run);

      Assertions.assertEquals(0, main.exitCode());
    }
  }

  @Test
  public void testTransformEPUB4_80()
    throws Exception
  {
    final var file0 =
      Files.writeString(
        this.sourceDirectory.resolve("file0.txt"),
        "Text 0."
      );
    final var file1 =
      Files.writeString(
        this.sourceDirectory.resolve("file1.txt"),
        "Text 1."
      );
    final var file2 =
      Files.writeString(
        this.sourceDirectory.resolve("file2.txt"),
        "Text 2."
      );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example4_80.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
  }

  @Test
  public void testTransformEPUB5_80()
    throws Exception
  {
    final var file =
      this.sourceDirectory.resolve("extra-resources.txt");

    try (var writer = Files.newBufferedWriter(file, UTF_8)) {
      writer.append("file0.txt");
      writer.newLine();
      writer.append("file1.txt");
      writer.newLine();
      writer.append("file2.txt");
      writer.newLine();
    }

    final var file0 =
      Files.writeString(
        this.sourceDirectory.resolve("file0.txt"),
        "Text 0."
      );
    final var file1 =
      Files.writeString(
        this.sourceDirectory.resolve("file1.txt"),
        "Text 1."
      );
    final var file2 =
      Files.writeString(
        this.sourceDirectory.resolve("file2.txt"),
        "Text 2."
      );

    final var main = new Main(new String[]{
      "epub",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example5_80.xml")
        .toString(),
      "--outputDirectory",
      this.outputDirectory.toString(),
      "--traceFile",
      this.directory.resolve("trace.xml").toString(),
      "--messagesFile",
      this.directory.resolve("messages.log").toString(),
      "--verbose",
      "trace"
    });

    final var capture =
      XSOutputCaptured.capture(main::run);

    Assertions.assertEquals(0, main.exitCode());
  }
}
