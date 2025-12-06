<?xml version="1.0" encoding="UTF-8" ?>

<!--
  Copyright © 2021 Mark Raynsford <code@io7m.com> https://www.io7m.com

  Permission to use, copy, modify, and/or distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural7-blocks-web.xsl"/>

  <!--                                     -->
  <!-- Web-single block content overrides. -->
  <!--                                     -->

  <xsl:template match="s:Section"
                mode="xstructural.blocks">

    <xsl:apply-templates select="."
                         mode="xstructural.titleElement"/>

    <xsl:apply-templates select="."
                         mode="xstructural.tableOfContentsOptional">
      <xsl:with-param name="withTitle"
                      select="false()"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                         mode="xstructural.blocks"/>

    <xsl:call-template name="xstructural.blocks.footnotesOptional"/>
  </xsl:template>

</xsl:stylesheet>
