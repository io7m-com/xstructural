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
import java.io.UncheckedIOException;
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
  public void testValidateOK_71()
    throws Exception
  {
    final var main = new Main(new String[]{
      "validate",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_71.xml")
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
  public void testTransformXHTMLOK_71()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_71.xml")
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
  public void testTransformXHTMLSingleOK_71()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_71.xml")
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
  public void testTransformXHTMLSingleBrandingOK_71()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_71.xml")
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
  public void testTransformXHTMLMultiOK_71()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_71.xml")
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

  @Test
  public void testTransformXHTMLMultiBrandingOK_71()
    throws Exception
  {
    final var main = new Main(new String[]{
      "xhtml",
      "--sourceFile",
      XSTestDirectories.resourceOf(
        XSCommandLineTest.class,
        this.sourceDirectory,
        "example0_71.xml")
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

  @Test
  public void testSchema()
    throws Exception
  {
    final var main = new Main(new String[]{
      "schema",
      "--outputDirectory",
      this.outputDirectory.toString()
    });
    main.run();
    Assertions.assertEquals(0, main.exitCode());

    final var files =
      Files.list(this.outputDirectory)
        .map(Path::getFileName)
        .map(Path::toString)
        .collect(Collectors.toList());

    Assertions.assertEquals(4L, (long) files.size());
    Assertions.assertTrue(files.contains("xml.xsd"));
    Assertions.assertTrue(files.contains("dc.xsd"));
    Assertions.assertTrue(files.contains("xstructural-7.xsd"));
    Assertions.assertTrue(files.contains("xstructural-7_1.xsd"));
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
    main.run();
    Assertions.assertEquals(0, main.exitCode());
    Assertions.assertEquals(4L, Files.list(this.outputDirectory).count());

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
    Assertions.assertEquals(4L, Files.list(this.outputDirectory).count());

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
    main.run();
    Assertions.assertEquals(0, main.exitCode());
    Assertions.assertEquals(4L, Files.list(this.outputDirectory).count());

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
    Assertions.assertEquals(4L, Files.list(this.outputDirectory).count());

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
  public void testTransformXHTMLEPUBOKExample0()
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
        "example0.xml")
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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample1()
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
        "example1.xml")
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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample2()
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
        "example2.xml")
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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }

  @Test
  public void testTransformXHTMLEPUBOKExample0_71()
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
        "example0_71.xml")
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
      Files.isRegularFile(this.outputDirectory.resolve("output.epub")),
      "EPUB file exists"
    );
  }
}
