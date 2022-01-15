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

import com.io7m.xstructural.api.XSProcessorRequest;
import com.io7m.xstructural.api.XSProcessorType;
import com.io7m.xstructural.api.XSValidationException;
import com.io7m.xstructural.xml.SXMLResources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;

import java.nio.file.Files;
import java.util.Objects;

/**
 * A validator.
 */

public final class XSValidator implements XSProcessorType
{
  private static final Logger LOG =
    LoggerFactory.getLogger(XSValidator.class);

  private final SXMLResources resources;
  private final XSProcessorRequest request;

  /**
   * A validator.
   *
   * @param inResources The SXML resources
   * @param inRequest   The processor request
   */

  public XSValidator(
    final SXMLResources inResources,
    final XSProcessorRequest inRequest)
  {
    this.resources =
      Objects.requireNonNull(inResources, "resources");
    this.request =
      Objects.requireNonNull(inRequest, "request");
  }

  @Override
  public void execute()
    throws XSValidationException
  {
    LOG.debug("validating source file");
    this.validate();
  }

  private void validate()
    throws XSValidationException
  {
    try {
      final var parsers =
        new XSSAXParsers();
      final var reader =
        parsers.createXMLReader(
          this.request.sourceFile().getParent(),
          this.resources
        );

      final var sourcePath = this.request.sourceFile();
      LOG.info("validate (xstructural) {}", sourcePath);

      try (var sourceStream = Files.newInputStream(sourcePath)) {
        final var fileSource = new InputSource();
        fileSource.setByteStream(sourceStream);
        fileSource.setSystemId(sourcePath.toString());

        final XSErrorHandler errorHandler =
          new XSErrorHandler(LoggerFactory.getLogger(
            XSValidator.class.getCanonicalName() + ".validation"));

        reader.setErrorHandler(errorHandler);
        reader.parse(fileSource);

        if (errorHandler.isFailed()) {
          LOG.error("one or more validation errors occurred");
          throw new XSValidationException(
            String.format(
              "Document %s is not a valid structural document",
              sourcePath
            )
          );
        }
      }

    } catch (final Exception exception) {
      throw new XSValidationException(exception);
    }
  }
}
