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

import com.adobe.epubcheck.tool.EpubChecker;
import com.io7m.xstructural.api.XSProcessorException;
import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.api.XSProcessorType;
import com.io7m.xstructural.api.XSTransformException;
import com.io7m.xstructural.xml.SXMLResources;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.io.input.CountingInputStream;
import org.apache.commons.io.output.NullOutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.time.Instant;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.zip.CRC32;
import java.util.zip.ZipEntry;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * An EPUB creator.
 */

public final class XSEPUBCreator implements XSProcessorType
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSEPUBCreator.class);

  private static final FileTime ZIP_FILE_TIME =
    FileTime.from(Instant.parse("2000-01-01T00:00:00Z"));
  private static final byte[] EMPTY_EXTRA =
    new byte[0];

  private final SXMLResources resources;
  private final XSProcessorRequest request;
  private final Path epubDirectory;
  private final Path metaDirectory;
  private final XSEPUBPackageCreator epubPackageCreator;
  private final Path oebpsDirectory;
  private final Path epubFile;

  /**
   * An EPUB creator.
   *
   * @param inResources The SXML resources
   * @param inRequest   The processor request
   */

  public XSEPUBCreator(
    final SXMLResources inResources,
    final XSProcessorRequest inRequest)
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");
    this.request =
      Objects.requireNonNull(inRequest, "request");
    this.epubFile =
      this.request.outputDirectory().resolve(outputName(inRequest));
    this.epubDirectory =
      this.request.outputDirectory().resolve("epub");
    this.metaDirectory =
      this.epubDirectory.resolve("META-INF");
    this.oebpsDirectory =
      this.epubDirectory.resolve("OEBPS");
    this.epubPackageCreator =
      new XSEPUBPackageCreator(this.resources, this.request);
  }

  private static String outputName(
    final XSProcessorRequest inRequest)
  {
    return inRequest.outputName()
      .orElse("output.epub");
  }

  private static InputStream resource(
    final String name)
    throws IOException
  {
    final var path =
      String.format("/com/io7m/xstructural/vanilla/internal/%s", name);
    final var url =
      XSEPUBCreator.class.getResource(path);

    if (url == null) {
      throw new IllegalStateException(
        String.format("Missing resource: %s", path)
      );
    }

    return url.openStream();
  }

  private static void createEPUBWriteEmpty(
    final ZipArchiveOutputStream zipOut,
    final String directory,
    final String file)
    throws IOException
  {
    final var entry =
      new ZipArchiveEntry(String.format("%s/%s", directory, file));

    LOG.info("zip entry {}", entry.getName());

    entry.setCreationTime(ZIP_FILE_TIME);
    entry.setLastAccessTime(ZIP_FILE_TIME);
    entry.setLastModifiedTime(ZIP_FILE_TIME);
    entry.setSize(0L);
    entry.setCrc(0);
    entry.setExtra(EMPTY_EXTRA);

    zipOut.putArchiveEntry(entry);
    zipOut.closeArchiveEntry();
  }

  private static void createEPUBCopyFileResource(
    final ZipArchiveOutputStream zipOut,
    final String directory,
    final String name,
    final URL url)
    throws IOException
  {
    final var entry =
      new ZipArchiveEntry(String.format("%s/%s", directory, name));

    if (url == null) {
      throw new IOException(String.format("URL for entry %s is null", entry));
    }

    LOG.info("zip entry {}", entry.getName());

    entry.setCreationTime(ZIP_FILE_TIME);
    entry.setLastAccessTime(ZIP_FILE_TIME);
    entry.setLastModifiedTime(ZIP_FILE_TIME);
    entry.setSize(countURLSize(url));
    entry.setCrc(crcOfURL(url));
    entry.setExtra(EMPTY_EXTRA);

    zipOut.putArchiveEntry(entry);

    try (var stream = url.openStream()) {
      stream.transferTo(zipOut);
    }

    zipOut.closeArchiveEntry();
  }

  private static long countURLSize(
    final URL url)
    throws IOException
  {
    try (var countingStream = new CountingInputStream(url.openStream())) {
      countingStream.transferTo(NullOutputStream.nullOutputStream());
      return countingStream.getByteCount();
    }
  }

  private static void createEPUBCopyFile(
    final ZipArchiveOutputStream zipOut,
    final String directory,
    final Path file)
    throws IOException
  {
    final var entry =
      new ZipArchiveEntry(
        String.format("%s/%s", directory, file.getFileName().toString()));

    LOG.info("zip entry {}", entry.getName());

    entry.setCreationTime(ZIP_FILE_TIME);
    entry.setLastAccessTime(ZIP_FILE_TIME);
    entry.setLastModifiedTime(ZIP_FILE_TIME);
    entry.setSize(Files.size(file));
    entry.setCrc(crcOf(file));
    entry.setExtra(EMPTY_EXTRA);

    zipOut.putArchiveEntry(entry);
    Files.copy(file, zipOut);
    zipOut.closeArchiveEntry();
  }

  private static long crcOf(
    final Path source)
    throws IOException
  {
    try (var stream = Files.newInputStream(source)) {
      return crcOfStream(stream);
    }
  }

  private static long crcOfStream(
    final InputStream stream)
    throws IOException
  {
    final var crc = new CRC32();
    final var buffer = new byte[8192];
    try (var input = stream) {
      while (true) {
        final var r = input.read(buffer);
        if (r <= 0) {
          break;
        }
        crc.update(buffer, 0, r);
      }
    }
    return crc.getValue();
  }

  private static long crcOfURL(
    final URL url)
    throws IOException
  {
    try (var stream = url.openStream()) {
      return crcOfStream(stream);
    }
  }

  @Override
  public void execute()
    throws XSProcessorException
  {
    try {
      this.createDirectories();

      this.writeMimetypeFile();
      this.writeContainerFile();
      this.writePackageFile();
      this.copyOEBPS();
      this.createEPUB();
      this.checkEPUB();

    } catch (final IOException e) {
      throw new XSProcessorException(e);
    }
  }

  private void checkEPUB()
    throws IOException
  {
    final var outStream = new ByteArrayOutputStream();
    final var errStream = new ByteArrayOutputStream();

    LOG.info("validating {}", this.epubFile);

    try (var out = new PrintStream(outStream, true, UTF_8)) {
      try (var err = new PrintStream(errStream, true, UTF_8)) {

        final var oldOut = System.out;
        final var oldErr = System.err;

        final int result;
        try {
          System.setOut(out);
          System.setErr(err);

          final var checker = new EpubChecker();
          result = checker.run(new String[]{
            this.epubFile.toString(),
          });
        } finally {
          System.setOut(oldOut);
          System.setErr(oldErr);
        }

        {
          final var lines =
            outStream.toString(UTF_8)
              .lines()
              .collect(Collectors.toList());

          for (final var line : lines) {
            LOG.info("epubcheck: stdout: {}", line);
          }
        }

        {
          final var lines =
            errStream.toString(UTF_8)
              .lines()
              .collect(Collectors.toList());

          for (final var line : lines) {
            LOG.info("epubcheck: stderr: {}", line);
          }
        }

        if (result != 0) {
          LOG.error(
            "EPUB checker returned a non-zero exit code: {}",
            Integer.valueOf(result)
          );
          throw new IOException(
            String.format(
              "EPUB checker returned a non-zero exit code: %d",
              Integer.valueOf(result)
            )
          );
        }
      }
    }
  }

  private void createEPUB()
    throws IOException
  {
    try (var zipOut = new ZipArchiveOutputStream(Files.newOutputStream(this.epubFile))) {
      this.createEPUBWriteMime(zipOut);
      this.createEPUBWritePackage(zipOut);

      try (var stream = Files.list(this.metaDirectory)) {
        final var files = stream.collect(Collectors.toList());
        for (final var file : files) {
          createEPUBCopyFile(zipOut, "META-INF", file);
        }
      }

      try (var stream = Files.list(this.oebpsDirectory)) {
        final var files = stream.collect(Collectors.toList());
        for (final var file : files) {
          createEPUBCopyFile(zipOut, "OEBPS", file);
        }
      }

      createEPUBCopyFileResource(
        zipOut,
        "OEBPS",
        "reset-epub.css",
        this.resources.cssResetEPUB()
      );
      createEPUBCopyFileResource(
        zipOut,
        "OEBPS",
        "structural-epub.css",
        this.resources.cssStructuralEPUB()
      );

      final var documentCSSfile =
        this.request.sourceFile()
          .resolveSibling("document.css");

      if (Files.isRegularFile(documentCSSfile)) {
        createEPUBCopyFile(zipOut, "OEBPS", documentCSSfile);
      } else {
        createEPUBWriteEmpty(zipOut, "OEBPS", "document.css");
      }

      final var resourcesList =
        this.request.outputDirectory()
          .resolve("epub-resources.txt");

      try (var resourcesStream = Files.lines(resourcesList)) {
        final var resourceNames =
          resourcesStream
            .filter(p -> !p.isBlank())
            .collect(Collectors.toList());

        for (final var resourceName : resourceNames) {
          final var resourceFile =
            this.request.sourceFile()
              .resolveSibling(resourceName);
          createEPUBCopyFile(zipOut, "OEBPS", resourceFile);
        }
      }

      zipOut.finish();
      zipOut.flush();
    }
  }

  private void createEPUBWriteMime(
    final ZipArchiveOutputStream zipOut)
    throws IOException
  {
    final var source =
      this.epubDirectory.resolve("mimetype");

    final var entry =
      new ZipArchiveEntry("mimetype");

    LOG.info("zip entry {}", entry.getName());

    entry.setMethod(ZipEntry.STORED);
    entry.setCreationTime(ZIP_FILE_TIME);
    entry.setLastAccessTime(ZIP_FILE_TIME);
    entry.setLastModifiedTime(ZIP_FILE_TIME);
    entry.setSize(Files.size(source));
    entry.setCrc(crcOf(source));
    entry.setExtra(EMPTY_EXTRA);

    zipOut.putArchiveEntry(entry);
    Files.copy(source, zipOut);
    zipOut.closeArchiveEntry();
  }

  private void createEPUBWritePackage(
    final ZipArchiveOutputStream zipOut)
    throws IOException
  {
    final var source =
      this.epubDirectory.resolve("content.opf");

    final var entry =
      new ZipArchiveEntry("content.opf");

    LOG.info("zip entry {}", entry.getName());

    entry.setCreationTime(ZIP_FILE_TIME);
    entry.setLastAccessTime(ZIP_FILE_TIME);
    entry.setLastModifiedTime(ZIP_FILE_TIME);
    entry.setSize(Files.size(source));
    entry.setCrc(crcOf(source));
    entry.setExtra(EMPTY_EXTRA);

    zipOut.putArchiveEntry(entry);
    Files.copy(source, zipOut);
    zipOut.closeArchiveEntry();
  }

  private void createDirectories()
    throws IOException
  {
    Files.createDirectories(this.epubDirectory);
    Files.createDirectories(this.metaDirectory);
    Files.createDirectories(this.oebpsDirectory);
  }

  private void copyOEBPS()
    throws IOException
  {
    try (var fileStream =
           Files.list(this.request.outputDirectory())) {
      final var xhtmlFiles =
        fileStream.filter(p -> p.toString().endsWith(".xhtml"))
          .collect(Collectors.toList());

      for (final var file : xhtmlFiles) {
        final var outputFile =
          this.oebpsDirectory.resolve(file.getFileName().toString());

        LOG.info("copy {} {}", file, outputFile);
        Files.copy(file, outputFile);
      }
    }
  }

  private void writePackageFile()
    throws XSTransformException
  {
    this.epubPackageCreator.execute();
  }

  private void writeContainerFile()
    throws IOException
  {
    try (var stream = resource("container.xml")) {
      Files.copy(stream, this.metaDirectory.resolve("container.xml"));
    }
  }

  private void writeMimetypeFile()
    throws IOException
  {
    Files.writeString(
      this.epubDirectory.resolve("mimetype"),
      "application/epub+zip",
      UTF_8
    );
  }

}
