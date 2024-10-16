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

package com.io7m.xstructural.api;

import com.io7m.immutables.styles.ImmutablesStyleType;
import org.immutables.value.Value;

import java.nio.file.Path;
import java.util.Optional;

/**
 * A document processor request.
 */

@ImmutablesStyleType
@Value.Immutable
public interface XSProcessorRequestType
{
  /**
   * @return The directory to which output files will be written
   */

  Path outputDirectory();

  /**
   * @return The source document
   */

  Path sourceFile();

  /**
   * @return The task that will be executed
   */

  @Value.Default
  default Task task()
  {
    return Task.TRANSFORM_XHTML;
  }

  /**
   * @return The stylesheet that will be used
   */

  @Value.Default
  default Stylesheet stylesheet()
  {
    return Stylesheet.SINGLE_FILE;
  }

  /**
   * @return {@code true} if resources (such as CSS) should be copied into the output directory
   */

  @Value.Default
  default boolean writeResources()
  {
    return true;
  }

  /**
   * @return The file to which trace messages will be written
   */

  @Value.Default
  default Path traceFile()
  {
    return this.outputDirectory().resolve("trace.xml");
  }

  /**
   * @return The file to which XSLT messages will be written
   */

  @Value.Default
  default Path messageFile()
  {
    return this.outputDirectory().resolve("messages.log");
  }

  /**
   * @return The branding file that will be included into output documents
   */

  Optional<Path> brandingFile();

  /**
   * @return The name of the output file, if relevant to the operation
   */

  Optional<String> outputName();

  /**
   * The stylesheet that will be used during processing.
   */

  enum Stylesheet
  {
    /**
     * The single-file stylesheet. Produces a single output file containing
     * the entire document.
     */

    SINGLE_FILE,

    /**
     * The multi-file stylesheet. Produces a set of output files, one file
     * per section.
     */

    MULTIPLE_FILE,

    /**
     * The EPUB stylesheet. Produces a set of output files suitable for
     * use in an EPUB file.
     */

    EPUB,

    /**
     * <p>The multiple file index stylesheet. Produces a single index file
     * that contains references to elements as they would appear had they
     * been handled by the {@link #MULTIPLE_FILE} stylesheet.</p>
     *
     * <p>Essentially, the index answers the question "Given an element in my
     * source document, in which file does that element appear in the output
     * document?".</p>
     *
     * @since 1.9.0
     */

    MULTIPLE_FILE_INDEX_ONLY
  }

  /**
   * A document processor task.
   */

  enum Task
  {
    /**
     * The input document will be validated, and no other steps will be
     * performed.
     */

    VALIDATE,

    /**
     * The input document will be transformed to XHTML.
     */

    TRANSFORM_XHTML,

    /**
     * The input document will be transformed to an EPUB.
     */

    TRANSFORM_EPUB,

    /**
     * The input XHTML will be validated, and no other steps will be
     * performed.
     */

    VALIDATE_XHTML,
  }

  /**
   * Check preconditions for the type.
   */

  @Value.Check
  default void checkPreconditions()
  {
    checkAbsolute(this.outputDirectory());
    checkAbsolute(this.messageFile());
    checkAbsolute(this.traceFile());
    this.brandingFile().ifPresent(XSProcessorRequestType::checkAbsolute);
    checkAbsolute(this.sourceFile());
  }

  private static void checkAbsolute(
    final Path directory)
  {
    if (!directory.isAbsolute()) {
      throw new IllegalArgumentException(
        String.format("Path %s is not absolute", directory)
      );
    }
  }
}
