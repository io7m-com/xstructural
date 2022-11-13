/*
 * Copyright © 2022 Mark Raynsford <code@io7m.com> https://www.io7m.com
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

package com.io7m.xstructural.maven_plugin;

import com.io7m.xstructural.api.XSProcessorException;
import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.api.XSProcessorRequestType;
import com.io7m.xstructural.vanilla.XSProcessors;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.nio.file.Paths;

import static com.io7m.xstructural.api.XSProcessorRequestType.Stylesheet.SINGLE_FILE;

/**
 * The "xhtml-single" mojo.
 */

@Mojo(name = "xhtml-single")
public final class XSXHTMLSingleMojo extends AbstractMojo
{
  @Parameter(
    name = "outputDirectory",
    required = true)
  private String outputDirectory;

  @Parameter(
    name = "sourceFile",
    required = true)
  private String sourceFile;

  @Parameter(
    name = "brandingFile",
    required = false)
  private String brandingFile;

  @Parameter(
    name = "copyResources",
    defaultValue = "true",
    required = false
  )
  private boolean copyResources;

  @Parameter(
    required = false,
    name = "skip",
    property = "xstructural.skip",
    defaultValue = "false"
  )
  private boolean skip;

  /**
   * The "xhtml-single" mojo.
   */

  public XSXHTMLSingleMojo()
  {

  }

  @Override
  public void execute()
    throws MojoExecutionException
  {
    if (this.skip) {
      return;
    }

    try {
      final var requestBuilder = XSProcessorRequest.builder();
      requestBuilder.setOutputDirectory(
        Paths.get(this.outputDirectory).toAbsolutePath());
      requestBuilder.setSourceFile(
        Paths.get(this.sourceFile).toAbsolutePath());

      requestBuilder.setStylesheet(SINGLE_FILE);
      requestBuilder.setTask(XSProcessorRequestType.Task.TRANSFORM_XHTML);
      requestBuilder.setWriteResources(this.copyResources);

      if (this.brandingFile != null) {
        requestBuilder.setBrandingFile(
          Paths.get(this.brandingFile).toAbsolutePath());
      }

      final var request = requestBuilder.build();
      final var processors = new XSProcessors();
      final var processor = processors.create(request);
      processor.execute();
    } catch (final XSProcessorException e) {
      throw new MojoExecutionException(e.getMessage(), e);
    }
  }
}
