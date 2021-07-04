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

/**
 * Command-line interface.
 */

module com.io7m.xstructural.cmdline
{
  requires static org.osgi.annotation.bundle;
  requires static org.osgi.annotation.versioning;

  requires ch.qos.logback.classic;
  requires ch.qos.logback.core;
  requires com.io7m.junreachable.core;
  requires com.io7m.xstructural.api;
  requires com.io7m.xstructural.xml;
  requires jcommander;
  requires org.slf4j;

  uses com.io7m.xstructural.api.XSProcessorFactoryType;

  opens com.io7m.xstructural.cmdline to jcommander;

  exports com.io7m.xstructural.cmdline;
}