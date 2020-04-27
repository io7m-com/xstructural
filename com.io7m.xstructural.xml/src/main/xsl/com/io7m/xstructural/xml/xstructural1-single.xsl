<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sxc="urn:com.io7m.structural.xsl.core"
                version="3.0">

  <xsl:param name="outputDirectory"
             required="true"/>
  <xsl:param name="branding"
             required="false"/>

  <xsl:use-package name="com.io7m.structural.xsl.core"
                   package-version="1.0.0">
    <xsl:override>
      <xsl:function name="sxc:anchorOf"
                    as="xs:string">
        <xsl:param name="node"/>
        <xsl:choose>
          <xsl:when test="$node/attribute::id">
            <xsl:value-of select="concat('#id_',$node/attribute::id[1])"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('#',generate-id($node))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:function>

      <xsl:template name="sxc:section">
        <h1 class="stSectionHeader">
          <span class="stSectionNumber">
            <xsl:call-template name="sxc:sectionNumberTitleOf">
              <xsl:with-param name="section"
                              select="."/>
            </xsl:call-template>
          </span>
          <span class="stSectionTitle">
            <xsl:element name="a">
              <xsl:choose>
                <xsl:when test="@id">
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('id_', @id)"/>
                  </xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('#id_', @id)"/>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:call-template name="sxc:nodeNumberTitleOf">
                      <xsl:with-param name="node"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="stId"
                                select="generate-id(.)"/>
                  <xsl:attribute name="id">
                    <xsl:value-of select="$stId"/>
                  </xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('#', $stId)"/>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:call-template name="sxc:nodeNumberTitleOf">
                      <xsl:with-param name="node"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="@title"/>
            </xsl:element>
          </span>
        </h1>

        <xsl:apply-templates select="."
                             mode="sxc:tableOfContentsOptional"/>

        <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                             mode="sxc:blockMode"/>
      </xsl:template>
    </xsl:override>
  </xsl:use-package>

  <xsl:template match="s:Document">
    <xsl:variable name="filePath"
                  select="concat($outputDirectory,'/index.xhtml')"/>

    <xsl:message select="concat('OUTPUT: ',$filePath)"/>

    <xsl:result-document href="{$filePath}"
                         doctype-public="-//W3C//DTD XHTML 1.1//EN"
                         exclude-result-prefixes="#all"
                         method="xml"
                         indent="true"
                         doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en">
        <head>
          <meta http-equiv="content-type"
                content="application/xhtml+xml; charset=utf-8"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <link rel="schema.DC"
                href="http://purl.org/dc/elements/1.1/"/>

          <xsl:apply-templates select="s:Metadata/*"
                               mode="sxc:metadataHeader"/>

          <title>
            <xsl:value-of select="s:Metadata/dc:title"/>
          </title>
        </head>
        <body>
          <xsl:call-template name="sxc:brandingHeader">
            <xsl:with-param name="branding"
                            select="$branding"/>
          </xsl:call-template>

          <div id="stHeader">
            <xsl:comment>Header</xsl:comment>
            <h1>
              <xsl:value-of select="s:Metadata/dc:title"/>
            </h1>
            <table class="stMetadataTable">
              <xsl:apply-templates select="s:Metadata/*"
                                   mode="sxc:metadataFrontMatter"/>
            </table>
          </div>

          <div id="stMainTableOfContents">
            <h2>Table Of Contents</h2>
            <div class="stTableOfContentsContent stMainTableOfContentsContent">
              <xsl:apply-templates select="s:Section|s:Subsection"
                                   mode="sxc:tableOfContents">
                <xsl:with-param name="depthCurrent"
                                select="0"/>
                <xsl:with-param name="depthMaximum"
                                select="9999"/>
              </xsl:apply-templates>
            </div>
          </div>

          <div id="stMain">
            <xsl:comment>Main Content</xsl:comment>
            <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                                 mode="sxc:blockMode"/>
          </div>

          <xsl:if test="count(.//s:Footnote) > 0">
            <div id="stFootnotes">
              <h2>Footnotes</h2>
              <xsl:apply-templates select=".//s:Footnote"
                                   mode="sxc:blockMode"/>
            </div>
          </xsl:if>

          <xsl:call-template name="sxc:brandingFooter">
            <xsl:with-param name="branding"
                            select="$branding"/>
          </xsl:call-template>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
