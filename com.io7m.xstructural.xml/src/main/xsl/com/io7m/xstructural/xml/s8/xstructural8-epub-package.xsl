<?xml version="1.0" encoding="UTF-8" ?>

<!--
  Copyright © 2021 Mark Raynsford <code@io7m.com> http://io7m.com

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
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sx="urn:com.io7m.xstructural.mime"
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns="http://www.idpf.org/2007/opf"
                exclude-result-prefixes="#all"
                version="3.0">

  <xsl:param name="outputFile"
             as="xsd:string"
             required="true"/>

  <xsl:param name="sourceDirectory"
             as="xsd:string"
             required="yes"/>

  <xsl:template match="s:Document">
    <xsl:message select="concat('OUTPUT: ',$outputFile)"/>

    <xsl:result-document href="{$outputFile}"
                         method="xml"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <package version="3.0"
               unique-identifier="pub-id"
               xml:lang="en">
        <xsl:namespace name="dc"
                       select="'http://purl.org/dc/elements/1.1/'"/>
        <metadata>
          <xsl:apply-templates select="s:Metadata|s:Metadata"
                               mode="s:metadataItem"/>
        </metadata>

        <manifest>
          <item id="reset-css"
                href="OEBPS/reset-epub.css"
                media-type="text/css"/>
          <item id="structural-epub-css"
                href="OEBPS/structural-epub.css"
                media-type="text/css"/>
          <item id="document-css"
                href="OEBPS/document.css"
                media-type="text/css"/>

          <xsl:apply-templates select=".//s:Image"
                               mode="s:manifestItem"/>
          <xsl:apply-templates select=".//s:Section"
                               mode="s:manifestItem"/>
          <xsl:apply-templates select="s:Metadata|s:Metadata"
                               mode="s:manifestItem"/>

          <xsl:if test="count(s:Subsection) > 0">
            <xsl:call-template name="topLevelDocumentFile"/>
          </xsl:if>

          <item href="OEBPS/toc.ncx"
                id="ncx"
                media-type="application/x-dtbncx+xml"/>
          <item href="OEBPS/tocInternal.xhtml"
                id="tocInternal"
                media-type="application/xhtml+xml"
                properties="nav"/>
          <item href="OEBPS/toc.xhtml"
                id="toc"
                media-type="application/xhtml+xml"/>
          <item href="OEBPS/cover.xhtml"
                id="cover"
                media-type="application/xhtml+xml"/>
          <item href="OEBPS/colophon.xhtml"
                id="colophon"
                media-type="application/xhtml+xml"/>
        </manifest>

        <spine toc="ncx">
          <itemref idref="cover"/>
          <itemref idref="colophon"/>
          <itemref idref="toc"/>

          <xsl:if test="count(s:Subsection) > 0">
            <xsl:call-template name="topLevelDocumentFileReference"/>
          </xsl:if>

          <xsl:apply-templates select=".//s:Section"
                               mode="s:spineItem"/>
        </spine>
      </package>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="topLevelDocumentFile">
    <xsl:variable name="sectionId"
                  select="generate-id(.)"/>
    <xsl:element name="item">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('OEBPS/', $sectionId, '.xhtml')"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($sectionId, '_xhtml')"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
        <xsl:value-of select="'application/xhtml+xml'"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template name="topLevelDocumentFileReference">
    <xsl:variable name="sectionId"
                  select="generate-id(.)"/>
    <xsl:element name="itemref">
      <xsl:attribute name="idref">
        <xsl:value-of select="concat($sectionId, '_xhtml')"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="s:manifestItem">
    <xsl:variable name="sectionId"
                  select="generate-id(.)"/>
    <xsl:element name="item">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('OEBPS/', $sectionId, '.xhtml')"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat($sectionId, '_xhtml')"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
        <xsl:value-of select="'application/xhtml+xml'"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Image"
                mode="s:manifestItem">
    <xsl:element name="item">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('OEBPS/', @source)"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat('image_', replace(@source,'\.','_'))"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
        <xsl:value-of select="sx:mimeOf(@source)"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="s:spineItem">
    <xsl:variable name="sectionId"
                  select="generate-id(.)"/>
    <xsl:element name="itemref">
      <xsl:attribute name="idref">
        <xsl:value-of select="concat($sectionId, '_xhtml')"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Metadata|s:Metadata"
                mode="s:metadataItem">
    <xsl:for-each select="dc:*">
      <xsl:if test="not(local-name(.) = 'identifier')">
        <xsl:copy-of select="."
                     copy-namespaces="no"/>
      </xsl:if>
    </xsl:for-each>

    <dc:identifier id="pub-id">
      <xsl:value-of select="dc:identifier"/>
    </dc:identifier>

    <xsl:choose>
      <xsl:when test="s:MetaProperty[@name='com.io7m.xstructural.epub.cover']">
        <xsl:element name="meta">
          <xsl:attribute name="content">cover_image</xsl:attribute>
          <xsl:attribute name="name">cover</xsl:attribute>
        </xsl:element>
      </xsl:when>
    </xsl:choose>

    <meta property="dcterms:modified">
      <xsl:choose>
        <xsl:when test="dc:date">
          <xsl:value-of select="xsd:dateTime(dc:date)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>2000-01-01T00:00:00Z</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </meta>
  </xsl:template>

  <xsl:template match="s:Metadata|s:Metadata"
                mode="s:manifestItem">
    <xsl:apply-templates select="s:MetaProperty"
                         mode="s:manifestItem"/>
  </xsl:template>

  <xsl:template match="s:MetaProperty[@name='com.io7m.xstructural.epub.cover']"
                mode="s:manifestItem">
    <xsl:variable name="cover"
                  select="."/>
    <xsl:element name="item">
      <xsl:attribute name="id">cover_image</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('OEBPS/', $cover)"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
        <xsl:value-of select="sx:mimeOf($cover)"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:MetaProperty[@name='com.io7m.xstructural.epub.resource']"
                mode="s:manifestItem">
    <xsl:variable name="resource_id"
                  select="replace(.,'\.','_')"/>
    <xsl:element name="item">
      <xsl:attribute name="id"
                     select="$resource_id"/>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('OEBPS/', .)"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
        <xsl:value-of select="sx:mimeOf(.)"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:MetaProperty[@name='com.io7m.xstructural.epub.resource-list']"
                mode="s:manifestItem">
    <xsl:variable name="resourceFile"
                  select="concat($sourceDirectory, .)"/>
    <xsl:variable name="resourceFileText"
                  select="replace(unparsed-text($resourceFile),'\r','')"/>
    <xsl:for-each select="tokenize($resourceFileText,'\n')">
      <xsl:if test="string-length(.) > 0">
        <xsl:variable name="resource_id"
                      select="replace(.,'\.','_')"/>
        <xsl:element name="item">
          <xsl:attribute name="id"
                         select="$resource_id"/>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('OEBPS/', .)"/>
          </xsl:attribute>
          <xsl:attribute name="media-type">
            <xsl:value-of select="sx:mimeOf(.)"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="text()"
                mode="s:manifestItem"/>

</xsl:stylesheet>
