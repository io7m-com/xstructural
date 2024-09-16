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

import com.github.marschall.memoryfilesystem.MemoryFileSystemBuilder;
import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.api.XSProcessorRequestType;
import com.io7m.xstructural.api.XSTransformException;
import com.io7m.xstructural.api.XSValidationException;
import com.io7m.xstructural.vanilla.XSProcessors;
import com.io7m.xstructural.vanilla.internal.XSValidator;
import com.io7m.xstructural.xml.SXMLResources;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public final class XSProcessorTest
{
  private static final Duration TIMEOUT = Duration.ofSeconds(15L);

  private Path directory;
  private XSProcessors processors;
  private Path outputDirectory;
  private Path sourceDirectory;
  private FileSystem windowsFilesystem;

  @BeforeEach
  public void testSetup()
    throws IOException
  {
    this.directory = XSTestDirectories.createTempDirectory();
    this.sourceDirectory = this.directory.resolve("src");
    this.outputDirectory = this.directory.resolve("out");
    this.processors = new XSProcessors();

    Files.createDirectories(this.sourceDirectory);
    Files.createDirectories(this.outputDirectory);

    this.windowsFilesystem =
      MemoryFileSystemBuilder.newWindows()
        .build();
  }

  @AfterEach
  public void tearDown()
    throws IOException
  {
    this.windowsFilesystem.close();
  }

  @Test
  public void testCompileInvalid()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "file0.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertThrows(XSValidationException.class, processor::execute);
  }

  @Test
  public void testCompileSingleExample0_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example0_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileSingleExample1_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example1_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileSingleExample2_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example2_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileSingleExample0_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example0_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileSingleExample1_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example1_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileSingleExample2_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example2_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleExample0_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example0_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleExample1_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example1_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleExample2_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example2_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleExample0_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example0_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleExample1_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example1_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleExample2_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example2_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileSingleExampleWindows0_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example0_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.SINGLE_FILE)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);
  }

  @Test
  public void testCompileMultipleIndex0_70()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example1_70.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE_INDEX_ONLY)
        .build();

    final var processor =
      this.processors.create(request);
    final var x =
      Assertions.assertThrows(XSTransformException.class, processor::execute);
    assertTrue(x.getMessage().contains("Unsupported configuration"));
  }

  @Test
  public void testCompileMultipleIndex0_80()
    throws Exception
  {
    final var request =
      XSProcessorRequest.builder()
        .setOutputDirectory(this.outputDirectory)
        .setSourceFile(XSTestDirectories.resourceOf(
          XSProcessorTest.class,
          this.sourceDirectory,
          "example1_index_80.xml"))
        .setTraceFile(this.directory.resolve("trace.xml"))
        .setMessageFile(this.directory.resolve("messages.txt"))
        .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE_INDEX_ONLY)
        .build();

    final var processor = this.processors.create(request);
    Assertions.assertTimeout(TIMEOUT, processor::execute);

    final var indexFile =
      this.outputDirectory.resolve("xstructural-index.xml");

    assertTrue(Files.isRegularFile(indexFile));

    final var validator =
      new XSValidator(
        new SXMLResources(),
        XSProcessorRequest.builder()
          .setTask(XSProcessorRequestType.Task.VALIDATE)
          .setOutputDirectory(this.outputDirectory)
          .setSourceFile(indexFile)
          .setStylesheet(XSProcessorRequestType.Stylesheet.MULTIPLE_FILE_INDEX_ONLY)
          .build()
      );

    validator.execute();

    {
      final var d =
        DocumentBuilderFactory.newNSInstance()
          .newDocumentBuilder()
          .parse(indexFile.toFile());

      final var items = d.getElementsByTagNameNS("urn:com.io7m.structural.index:1:0", "Item");
      assertEquals(8, items.getLength());

      {
        final var i = (Element) items.item(0);
        assertEquals("d0e32.xhtml", i.getAttribute("File"));
        assertEquals("59259ed7-a88d-4411-b397-b9aa20aec3a0", i.getAttribute("ID"));
        assertEquals("Section", i.getAttribute("Type"));
        assertEquals("Section-A", i.getAttribute("Title"));
      }

      {
        final var i = (Element) items.item(1);
        assertEquals("d0e32.xhtml", i.getAttribute("File"));
        assertEquals("27174ab0-0c36-43c9-9f7e-1e140ade8510", i.getAttribute("ID"));
        assertEquals("Subsection", i.getAttribute("Type"));
        assertEquals("Subsection-A", i.getAttribute("Title"));
      }

      {
        final var i = (Element) items.item(2);
        assertEquals("d0e32.xhtml", i.getAttribute("File"));
        assertEquals("24cafbdf-cfb6-4fee-a8d6-496d98b4def7", i.getAttribute("ID"));
        assertEquals("Paragraph", i.getAttribute("Type"));
      }

      {
        final var i = (Element) items.item(3);
        assertEquals("d0e32.xhtml", i.getAttribute("File"));
        assertEquals("cdbeb82b-ba49-4504-9c7f-86fe5186184d", i.getAttribute("ID"));
        assertEquals("FormalItem", i.getAttribute("Type"));
        assertEquals("Formal-A", i.getAttribute("Title"));
      }

      {
        final var i = (Element) items.item(4);
        assertEquals("d0e46.xhtml", i.getAttribute("File"));
        assertEquals("1b3fed5d-31dd-42bd-98c1-30bfaa873de4", i.getAttribute("ID"));
        assertEquals("Section", i.getAttribute("Type"));
        assertEquals("Section-B", i.getAttribute("Title"));
      }

      {
        final var i = (Element) items.item(5);
        assertEquals("d0e46.xhtml", i.getAttribute("File"));
        assertEquals("5455c2c4-5468-4dc3-8f0f-27d8da7331cd", i.getAttribute("ID"));
        assertEquals("Subsection", i.getAttribute("Type"));
        assertEquals("Subsection-B", i.getAttribute("Title"));
      }

      {
        final var i = (Element) items.item(6);
        assertEquals("d0e46.xhtml", i.getAttribute("File"));
        assertEquals("ee1f2ec7-d958-4a31-8773-36235e63c9ab", i.getAttribute("ID"));
        assertEquals("Paragraph", i.getAttribute("Type"));
      }

      {
        final var i = (Element) items.item(7);
        assertEquals("d0e46.xhtml", i.getAttribute("File"));
        assertEquals("b8bc55d6-3f1e-491e-a3f1-8e6c40461a51", i.getAttribute("ID"));
        assertEquals("FormalItem", i.getAttribute("Type"));
        assertEquals("Formal-B", i.getAttribute("Title"));
      }
    }
  }
}
