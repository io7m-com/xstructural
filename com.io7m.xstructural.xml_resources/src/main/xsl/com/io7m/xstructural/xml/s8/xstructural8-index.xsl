<?xml version="1.0" encoding="UTF-8" ?>

<!--
  Copyright © 2024 Mark Raynsford <code@io7m.com> https://www.io7m.com

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
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:si="urn:com.io7m.structural.index:1:0"
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:template name="xstructural.fileOf"
                as="xsd:string">
    <xsl:param name="target"
               as="element()"/>

    <xsl:variable name="targetOwner"
                  as="element()">
      <xsl:choose>
        <xsl:when test="count($target/ancestor-or-self::s:Section) > 0">
          <xsl:sequence select="$target/ancestor-or-self::s:Section[1]"/>
        </xsl:when>
        <xsl:when test="count($target/ancestor-or-self::s:Document) > 0">
          <xsl:sequence select="$target/ancestor-or-self::s:Document[1]"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat(generate-id($targetOwner), '.xhtml')"/>
  </xsl:template>

  <xsl:template match="s:Document">
    <xsl:result-document href="xstructural-index.xml"
                         method="xml"
                         include-content-type="no"
                         indent="true">
      <xsl:element name="si:Index">
        <xsl:apply-templates mode="xstructural.indexing.item"
                             select="."/>
        <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                             mode="xstructural.indexing"/>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template mode="xstructural.indexing"
                match="s:Section|s:Subsection|s:Paragraph|s:FormalItem">
    <xsl:apply-templates mode="xstructural.indexing.item"
                         select="."/>
    <xsl:apply-templates mode="xstructural.indexing"/>
  </xsl:template>

  <xsl:template mode="xstructural.indexing"
                match="text()">
    <!-- Nothing -->
  </xsl:template>

  <xsl:template mode="xstructural.indexing.item" match="element()">
    <xsl:if test="@id">
      <xsl:element name="si:Item">
        <xsl:attribute name="File">
          <xsl:call-template name="xstructural.fileOf">
            <xsl:with-param name="target"
                            select="."/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="ID">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:attribute name="Type">
          <xsl:value-of select="local-name(.)"/>
        </xsl:attribute>
        <xsl:if test="@title">
          <xsl:attribute name="Title">
            <xsl:value-of select="@title"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:element>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
