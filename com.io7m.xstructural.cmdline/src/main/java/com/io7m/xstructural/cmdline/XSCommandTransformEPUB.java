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
import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.cmdline.internal.XSServices;

import java.nio.file.Path;

import static com.io7m.xstructural.api.XSProcessorRequestType.Stylesheet;
import static com.io7m.xstructural.api.XSProcessorRequestType.Task;

@Parameters(commandDescription = "Transform a structural document to an EPUB")
final class XSCommandTransformEPUB extends XSCommandRoot
{
  @Parameter(
    required = true,
    description = "The source document",
    names = "--sourceFile"
  )
  private Path sourceFile;

  @Parameter(
    required = true,
    description = "The output directory",
    names = "--outputDirectory"
  )
  private Path outputDirectory;

  @Parameter(
    required = false,
    description = "The output file for trace messages",
    names = "--traceFile"
  )
  private Path traceFile;

  @Parameter(
    required = false,
    description = "The output file for XSLT messages",
    names = "--messagesFile"
  )
  private Path messagesFile;

  @Parameter(
    required = false,
    description = "The output file name",
    names = "--outputFileName"
  )
  private String outputFileName;

  XSCommandTransformEPUB()
  {

  }

  @Override
  public Status execute()
    throws Exception
  {
    if (super.execute() == Status.FAILURE) {
      return Status.FAILURE;
    }

    final var requestBuilder = XSProcessorRequest.builder();
    requestBuilder.setOutputDirectory(this.outputDirectory.toAbsolutePath());
    requestBuilder.setSourceFile(this.sourceFile.toAbsolutePath());
    requestBuilder.setStylesheet(Stylesheet.EPUB);
    requestBuilder.setTask(Task.TRANSFORM_EPUB);
    requestBuilder.setWriteResources(false);

    if (this.traceFile != null) {
      requestBuilder.setTraceFile(this.traceFile.toAbsolutePath());
    }
    if (this.messagesFile != null) {
      requestBuilder.setMessageFile(this.messagesFile.toAbsolutePath());
    }
    if (this.outputFileName != null) {
      requestBuilder.setOutputName(this.outputFileName);
    }

    final var request = requestBuilder.build();
    final var processors = XSServices.findProcessors();
    final var processor = processors.create(request);
    processor.execute();
    return Status.SUCCESS;
  }

}