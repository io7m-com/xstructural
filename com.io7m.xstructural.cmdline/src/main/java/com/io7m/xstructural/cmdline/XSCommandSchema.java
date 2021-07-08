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

package com.io7m.xstructural.cmdline;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.Parameters;
import com.io7m.xstructural.xml.SXMLResources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

@Parameters(commandDescription = "Export the structural schemas to files")
final class XSCommandSchema extends XSCommandRoot
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSCommandSchema.class);

  @Parameter(
    required = true,
    description = "The output directory",
    names = "--outputDirectory"
  )
  private Path outputDirectory;

  @Parameter(
    required = false,
    arity = 1,
    description = "Replace output files if they already exist",
    names = "--replace"
  )
  private boolean replace;

  XSCommandSchema()
  {

  }

  @Override
  public Status execute()
    throws Exception
  {
    if (super.execute() == Status.FAILURE) {
      return Status.FAILURE;
    }

    final CopyOption[] options;
    if (this.replace) {
      options = new CopyOption[] {
        StandardCopyOption.REPLACE_EXISTING,
      };
    } else {
      options = new CopyOption[0];
    }

    final var outputAbs = this.outputDirectory.toAbsolutePath();
    Files.createDirectories(outputAbs);

    final var resources = new SXMLResources();
    resources.xstructuralResources().forEach(name -> {
      final Path outputPath = outputAbs.resolve(name);
      if (Files.exists(outputPath) && !this.replace) {
        LOG.info("output file {} already exists, ignoring", outputPath);
        return;
      }

      try (var stream = resources.xstructuralResourceOf(name).openStream()) {
        Files.copy(stream, outputPath, options);
      } catch (final IOException e) {
        throw new UncheckedIOException(e);
      }
    });

    return Status.SUCCESS;
  }
}
