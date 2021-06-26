<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.idpf.org/2007/opf"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sx="urn:com.io7m.xstructural.mime"
                exclude-result-prefixes="#all"
                xmlns:s="urn:com.io7m.structural:7:0"
                version="3.0">

  <xsl:param name="outputFile"
             as="xs:string"
             required="true"/>

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
          <xsl:apply-templates select="s:Metadata"/>
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

          <xsl:if test="count(s:Subsection) > 0">
            <xsl:call-template name="topLevelDocumentFile"/>
          </xsl:if>

          <item href="OEBPS/toc.xhtml"
                id="nav"
                media-type="application/xhtml+xml"
                properties="nav"/>
          <item href="OEBPS/cover.xhtml"
                id="cover"
                media-type="application/xhtml+xml"/>
          <item href="OEBPS/colophon.xhtml"
                id="colophon"
                media-type="application/xhtml+xml"/>
        </manifest>
        <spine>
          <itemref idref="cover"/>
          <itemref idref="colophon"/>
          <itemref idref="nav"/>

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

  <xsl:template match="s:Metadata">
    <xsl:for-each select="dc:*">
      <xsl:if test="not(local-name(.) = 'identifier')">
        <xsl:copy-of select="."
                     copy-namespaces="no"/>
      </xsl:if>
    </xsl:for-each>
    <dc:identifier id="pub-id">
      <xsl:value-of select="dc:identifier"/>
    </dc:identifier>

    <meta property="dcterms:modified">
      <xsl:choose>
        <xsl:when test="dc:date">
          <xsl:value-of select="xs:dateTime(dc:date)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>2000-01-01T00:00:00Z</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </meta>
  </xsl:template>

</xsl:stylesheet>
