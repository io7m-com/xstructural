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

import java.net.URI;
import java.util.Set;

/**
 * The known structural schemas.
 */

public final class XSSchemas
{
  private XSSchemas()
  {

  }

  /**
   * @return The set of known structural schemas
   */

  public static Set<URI> namespaces()
  {
    return Set.of(
      namespace7p0(),
      namespace8p0()
    );
  }

  /**
   * @return The structural 7.0 schema
   */

  public static URI namespace7p0()
  {
    return URI.create("urn:com.io7m.structural:7:0");
  }

  /**
   * @return The structural 7.0 schema
   */

  public static String namespace7p0s()
  {
    return namespace7p0().toString();
  }

  /**
   * @return The structural 8.0 schema
   */

  public static URI namespace8p0()
  {
    return URI.create("urn:com.io7m.structural:8:0");
  }

  /**
   * @return The structural 8.0 schema
   */

  public static String namespace8p0s()
  {
    return namespace8p0().toString();
  }
}
