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
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural8-blocks.xsl"/>
  <xsl:import href="xstructural8-inlines.xsl"/>
  <xsl:import href="xstructural8-links.xsl"/>
  <xsl:import href="xstructural8-outputs.xsl"/>
  <xsl:import href="xstructural8-text.xsl"/>
  <xsl:import href="xstructural8-tocs.xsl"/>

  <!--                                        -->
  <!-- EPUB-specific block content overrides. -->
  <!--                                        -->

  <xsl:template match="s:Footnote"
                as="element()*"
                mode="xstructural.blocks">

    <xsl:variable name="stNumber"
                  as="xsd:string">
      <xsl:number level="single"
                  select="."
                  count="s:Footnote"/>
    </xsl:variable>

    <tr>
      <td class="stFootnoteNumber">
        <xsl:element name="a">
          <xsl:attribute name="class"
                         select="'stFootnoteNumber'"/>
          <xsl:call-template name="xstructural.ids.idAttributeFor">
            <xsl:with-param name="node"
                            select="."/>
          </xsl:call-template>
          <xsl:call-template name="xstructural.ids.hrefAttributeFor">
            <xsl:with-param name="node"
                            select="."/>
          </xsl:call-template>
          <xsl:value-of select="$stNumber"/>
        </xsl:element>
      </td>
      <td class="stFootnoteContentCell">
        <div class="stFootnoteContent">
          <xsl:apply-templates select="child::node()"
                               mode="xstructural.inlines"/>
        </div>

        <xsl:choose>
          <xsl:when test="count(key('xstructural.footnotes.referenceKey',@id)) > 0">
            <div class="stFootnoteReferences">
              References to this footnote:
              <xsl:for-each select="key('xstructural.footnotes.referenceKey',@id)">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:call-template name="xstructural.links.anchorOf">
                      <xsl:with-param name="node"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:call-template name="xstructural.titles.anchorTitleFor">
                      <xsl:with-param name="node"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:attribute>
                </xsl:element>
              </xsl:for-each>
            </div>
          </xsl:when>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="xstructural.blocks.footnotes">
    <h2>Footnotes</h2>

    <div class="stFootnotes">
      <table>
        <xsl:apply-templates select="s:Footnote"
                             mode="xstructural.blocks"/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="s:Paragraph"
                mode="xstructural.blocks">
    <xsl:element name="p">
      <xsl:call-template name="xstructural.ids.idAttributeFor">
        <xsl:with-param name="node"
                        select="."/>
      </xsl:call-template>
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stParagraph'"/>
      </xsl:call-template>
      <xsl:apply-templates select="child::node()"
                           mode="xstructural.inlines"/>
    </xsl:element>
    <xsl:text>&#x000a;</xsl:text>
  </xsl:template>

  <xsl:template match="s:FormalItem"
                mode="xstructural.blocks">
    <xsl:apply-templates select="."
                         mode="xstructural.titleElement"/>
    <xsl:element name="div">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stFormalItem'"/>
      </xsl:call-template>
      <xsl:apply-templates select="*"
                           mode="xstructural.inlines"/>
    </xsl:element>
    <xsl:text>&#x000a;</xsl:text>
  </xsl:template>

  <xsl:template match="s:Subsection"
                mode="xstructural.blocks">
    <xsl:apply-templates select="."
                         mode="xstructural.titleElement"/>
    <xsl:apply-templates select="s:Paragraph|s:FormalItem|s:Subsection"
                         mode="xstructural.blocks"/>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="xstructural.blocks">
    <xsl:variable name="sectionCurrFile"
                  as="xsd:string">
      <xsl:value-of select="concat(generate-id(.),'.xhtml')"/>
    </xsl:variable>

    <xsl:variable name="documentTitle"
                  as="xsd:string">
      <xsl:value-of select="ancestor::s:Document[1]/s:Metadata/dc:title[1]"/>
    </xsl:variable>

    <xsl:variable name="sectionFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/',$sectionCurrFile)"/>
    <xsl:variable name="sectionNumber"
                  as="xsd:string">
      <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
        <xsl:with-param name="section"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="sectionCurrTitle"
                  as="xsd:string">
      <xsl:value-of select="concat($documentTitle,': ',$sectionNumber,'. ',attribute::title)"/>
    </xsl:variable>

    <xsl:message>
      <xsl:value-of select="concat('create ', $sectionFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$sectionFilePath}"
                         exclude-result-prefixes="#all"
                         method="xhtml"
                         include-content-type="no"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en">
        <head>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset-epub.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural-epub.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <title>
            <xsl:value-of select="$sectionCurrTitle"/>
          </title>
        </head>
        <body>
          <div class="stMain">
            <xsl:apply-templates select="."
                                 mode="xstructural.titleElement"/>

            <xsl:apply-templates select="."
                                 mode="xstructural.tableOfContentsOptional">
              <xsl:with-param name="withTitle" select="false()"/>
            </xsl:apply-templates>

            <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                                 mode="xstructural.blocks"/>

            <xsl:call-template name="xstructural.blocks.footnotesOptional"/>
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
