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
                xmlns:xdoc="http://www.pnp-software.com/XSLTdoc"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural8-links.xsl"/>
  <xsl:import href="xstructural8-blocks-epub.xsl"/>
  <xsl:import href="xstructural8-outputs.xsl"/>

  <!--                           -->
  <!-- Top-level EPUB templates. -->
  <!--                           -->

  <xdoc:doc>
    An override of the anchorOf function that works for EPUB files.
  </xdoc:doc>

  <xsl:template name="xstructural.links.anchorOf"
                as="xsd:string">
    <xsl:param name="target"
               as="element()"/>

    <xsl:variable name="owningSection"
                  as="element()">
      <xsl:choose>
        <xsl:when test="$target/ancestor-or-self::s:Section[1]">
          <xsl:sequence select="$target/ancestor-or-self::s:Section[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$target/ancestor::s:Document"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="owningFile"
                  select="concat(generate-id($owningSection),'.xhtml')"/>

    <xsl:variable name="completeHref">
      <xsl:choose>
        <xsl:when test="$target/attribute::id">
          <xsl:value-of select="concat($owningFile,'#id_',$target/attribute::id[1])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($owningFile,'#',generate-id($target))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$completeHref"/>
  </xsl:template>

  <xsl:template match="s:Document">
    <xsl:message select="concat('Processing document ', generate-id(.))"/>

    <xsl:choose>
      <xsl:when test="count(s:Section) > 0">
        <xsl:apply-templates select="s:Section"
                             mode="xstructural.blocks"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="."
                             mode="xstructural.epub.documentSubsectionsOnly"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="xstructural.epub.colophon"/>
    <xsl:call-template name="xstructural.epub.cover"/>
    <xsl:call-template name="xstructural.epub.resources"/>
    <xsl:call-template name="xstructural.epub.tableOfContentsInvisibleXHTML"/>
    <xsl:call-template name="xstructural.epub.tableOfContentsNCX"/>
    <xsl:call-template name="xstructural.epub.tableOfContentsXHTML"/>
  </xsl:template>

  <xdoc:doc>
    Render a document that only contains subsection-level content.
  </xdoc:doc>

  <xsl:template match="s:Document"
                mode="xstructural.epub.documentSubsectionsOnly">

    <xsl:variable name="sectionFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/',generate-id(.),'.xhtml')"/>

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
            <xsl:apply-templates select="."
                                 mode="xstructural.titleText"/>
          </title>
        </head>
        <body>
          <div class="stMain">
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
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xdoc:doc>
    Generate a list of resources for the document.
  </xdoc:doc>

  <xsl:template name="xstructural.epub.resources">
    <xsl:variable name="resourcesFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/epub-resources.txt')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $resourcesFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$resourcesFilePath}"
                         format="xstructural.textOutput">
      <xsl:for-each select=".//s:Image">
        <xsl:value-of select="@source"/>
        <xsl:text>&#x000a;</xsl:text>
      </xsl:for-each>

      <xsl:value-of select=".//s:Metadata/s:MetaProperty[@name='com.io7m.xstructural.epub.cover']"/>
      <xsl:text>&#x000a;</xsl:text>
    </xsl:result-document>
  </xsl:template>

  <xdoc:doc>
    Generate a cover page for the document.
  </xdoc:doc>

  <xsl:template name="xstructural.epub.cover">
    <xsl:variable name="coverFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/cover.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $coverFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$coverFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
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
            <xsl:apply-templates select="s:Metadata"
                                 mode="xstructural.epub.documentCoverTitle"/>
          </title>
        </head>
        <body>
          <div class="stEPUBCover">
            <h1>
              <xsl:apply-templates select="s:Metadata"
                                   mode="xstructural.epub.documentCoverTitle"/>
            </h1>

            <xsl:if test="s:Metadata/s:MetaProperty[@name='com.io7m.xstructural.epub.cover']">
              <div class="stEPUBCoverImage">
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    <xsl:value-of select="s:Metadata/s:MetaProperty[@name='com.io7m.xstructural.epub.cover']"/>
                  </xsl:attribute>
                  <xsl:attribute name="alt">
                    <xsl:apply-templates select="s:Metadata"
                                         mode="xstructural.epub.documentCoverTitle"/>
                  </xsl:attribute>
                </xsl:element>
              </div>

              <xsl:if test="s:Metadata/dc:creator">
                <h2 class="stEPUBCoverCreator">
                  <xsl:value-of select="s:Metadata/dc:creator"/>
                </h2>
              </xsl:if>
            </xsl:if>
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="s:Metadata"
                mode="xstructural.epub.documentCoverTitle">
    <xsl:value-of select="dc:title"/>
  </xsl:template>

  <xdoc:doc>
    Generate a colophon page for the document.
  </xdoc:doc>

  <xsl:template name="xstructural.epub.colophon">
    <xsl:variable name="colophonFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/colophon.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $colophonFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$colophonFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
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
            <xsl:apply-templates select="s:Metadata"
                                 mode="xstructural.epub.colophonTitle"/>
          </title>
        </head>
        <body>
          <div class="stEPUBColophon">
            <h1>Book Metadata</h1>
            <table class="stMetadataTable">
              <xsl:apply-templates select="s:Metadata/*"
                                   mode="xstructural.epub.colophonMetadata">
                <xsl:sort select="local-name()"/>
              </xsl:apply-templates>
            </table>
            <xsl:apply-templates select="s:Metadata/s:MetaProperty[@name='com.io7m.xstructural.epub.colophon']"
                                 mode="xstructural.epub.colophonExtra"/>
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="s:MetaProperty[@name = 'com.io7m.xstructural.epub.colophon']"
                mode="xstructural.epub.colophonExtra">
    <xsl:copy-of select="document(.)"/>
  </xsl:template>

  <xsl:template match="s:Metadata|s:Metadata"
                mode="xstructural.epub.colophonTitle">
    <xsl:value-of select="concat(dc:title, ': Colophon')"/>
  </xsl:template>

  <xsl:template match="s:MetaProperty"
                mode="xstructural.epub.colophonMetadata"/>

  <xsl:template match="dc:*"
                mode="xstructural.epub.colophonMetadata">
    <tr>
      <td>
        <xsl:value-of select="upper-case(local-name())"/>
      </td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xdoc:doc>
    Generate an EPUB2-style NCX table of contents for the document.
  </xdoc:doc>

  <xsl:template name="xstructural.epub.tableOfContentsNCX">
    <xsl:variable name="tocFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/toc.ncx')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $tocFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$tocFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xml"
                         indent="false">
      <ncx:ncx version="2005-1">
        <ncx:head>
          <xsl:element name="ncx:meta">
            <xsl:attribute name="content">
              <xsl:apply-templates select="s:Metadata"
                                   mode="xstructural.epub.documentTOCId"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:text>dtb:uid</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </ncx:head>
        <ncx:docTitle>
          <ncx:text>
            <xsl:apply-templates select="s:Metadata"
                                 mode="xstructural.epub.documentTOCTitle"/>
          </ncx:text>
        </ncx:docTitle>
        <ncx:navMap id="navmap">
          <ncx:navPoint id="navpoint-1"
                        playOrder="1">
            <ncx:navLabel>
              <ncx:text>Cover</ncx:text>
            </ncx:navLabel>
            <ncx:content src="cover.xhtml"/>
          </ncx:navPoint>

          <ncx:navPoint id="navpoint-2"
                        playOrder="2">
            <ncx:navLabel>
              <ncx:text>Colophon</ncx:text>
            </ncx:navLabel>
            <ncx:content src="colophon.xhtml"/>
          </ncx:navPoint>

          <ncx:navPoint id="navpoint-3"
                        playOrder="3">
            <ncx:navLabel>
              <ncx:text>Table Of Contents</ncx:text>
            </ncx:navLabel>
            <ncx:content src="toc.xhtml"/>
          </ncx:navPoint>

          <xsl:apply-templates select="s:Section|s:Subsection"
                               mode="xstructural.epub.ncxItem">
            <xsl:with-param name="offset"
                            select="3"/>
          </xsl:apply-templates>
        </ncx:navMap>
      </ncx:ncx>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="s:Section|s:Subsection"
                mode="xstructural.epub.ncxItem"
                as="element()">
    <xsl:param name="offset"
               as="xsd:integer"
               required="yes"/>

    <xsl:variable name="preceding"
                  as="xsd:integer">
      <xsl:number count="s:Section|s:Subsection"
                  level="any"/>
    </xsl:variable>

    <xsl:variable name="number"
                  as="xsd:integer"
                  select="$offset + $preceding"/>

    <xsl:variable name="label">
      <xsl:apply-templates select="."
                           mode="xstructural.epub.documentTableOfContentsElementTitle"/>
    </xsl:variable>

    <xsl:variable name="file">
      <xsl:call-template name="xstructural.links.anchorOf">
        <xsl:with-param name="target"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:element name="ncx:navPoint">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('navpoint-', $number)"/>
      </xsl:attribute>
      <xsl:attribute name="playOrder">
        <xsl:value-of select="$number"/>
      </xsl:attribute>

      <xsl:element name="ncx:navLabel">
        <xsl:element name="ncx:text">
          <xsl:value-of select="$label"/>
        </xsl:element>
      </xsl:element>

      <xsl:element name="ncx:content">
        <xsl:attribute name="src">
          <xsl:value-of select="$file"/>
        </xsl:attribute>
      </xsl:element>

      <xsl:apply-templates select="s:Section|s:Subsection"
                           mode="xstructural.epub.ncxItem">
        <xsl:with-param name="offset"
                        select="$offset"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Metadata"
                mode="xstructural.epub.documentTOCId">
    <xsl:value-of select="dc:identifier"/>
  </xsl:template>

  <xsl:template match="s:Metadata"
                mode="xstructural.epub.documentTOCTitle">
    <xsl:value-of select="dc:title"/>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="xstructural.epub.documentTableOfContentsElementTitle">
    <xsl:variable name="number">
      <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
        <xsl:with-param name="section"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($number,'. ',@title)"/>
  </xsl:template>

  <xsl:template match="s:Subsection"
                mode="xstructural.epub.documentTableOfContentsElementTitle">
    <xsl:variable name="number">
      <xsl:call-template name="xstructural.numbers.subsectionNumberTitleOf">
        <xsl:with-param name="subsection"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($number,'. ',@title)"/>
  </xsl:template>

  <xdoc:doc>
    Generate an internal XHTML TOC (EPUB 3).
  </xdoc:doc>

  <xsl:template name="xstructural.epub.tableOfContentsInvisibleXHTML">
    <xsl:variable name="tocFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/tocInternal.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $tocFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$tocFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <xsl:text>&#x000a;</xsl:text>
      <html xmlns:epub="http://www.idpf.org/2007/ops"
            xml:lang="en">
        <head>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>

          <title>
            <xsl:apply-templates select="s:Metadata"
                                 mode="xstructural.epub.documentTOCTitle"/>
          </title>
        </head>
        <body>
          <nav epub:type="toc"
               class="stEPUBTableOfContents">
            <h1>Table Of Contents</h1>

            <ol epub:type="list">
              <li>
                <a href="cover.xhtml">Cover</a>
              </li>
              <li>
                <a href="colophon.xhtml">Colophon</a>
              </li>
              <li>
                <a href="toc.xhtml">Table Of Contents</a>
              </li>

              <xsl:apply-templates select="s:Section|s:Subsection"
                                   mode="xstructural.epub.tableOfContentsInvisibleXHTMLItem"/>
            </ol>
          </nav>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="s:Section|s:Subsection"
                mode="xstructural.epub.tableOfContentsInvisibleXHTMLItem">

    <xsl:variable name="label">
      <xsl:apply-templates select="."
                           mode="xstructural.titleText"/>
    </xsl:variable>

    <xsl:variable name="file">
      <xsl:call-template name="xstructural.links.anchorOf">
        <xsl:with-param name="target"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$file"/>
        </xsl:attribute>
        <xsl:value-of select="$label"/>
      </xsl:element>

      <xsl:if test="count(s:Section|s:Subsection) > 0">
        <ol>
          <xsl:apply-templates select="s:Section|s:Subsection"
                               mode="xstructural.epub.tableOfContentsInvisibleXHTMLItem"/>
        </ol>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xdoc:doc>
    Generate a readable XHTML TOC page.
  </xdoc:doc>

  <xsl:template name="xstructural.epub.tableOfContentsXHTML">
    <xsl:variable name="tocFilePath"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/toc.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $tocFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$tocFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <xsl:text>&#x000a;</xsl:text>
      <html xmlns:epub="http://www.idpf.org/2007/ops"
            xml:lang="en">
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
            <xsl:apply-templates select="s:Metadata"
                                 mode="xstructural.epub.documentTOCTitle"/>
          </title>
        </head>
        <body>
          <div class="stMain">
            <h1>Table Of Contents</h1>

            <ul class="stEPUBTableOfContents">
              <li>
                <a href="cover.xhtml">Cover</a>
              </li>
              <li>
                <a href="colophon.xhtml">Colophon</a>
              </li>
              <li>
                <a href="toc.xhtml">Table Of Contents</a>
              </li>

              <xsl:apply-templates select="s:Section|s:Subsection"
                                   mode="xstructural.epub.tableOfContentsXHTMLItem"/>
            </ul>
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="s:Section|s:Subsection"
                mode="xstructural.epub.tableOfContentsXHTMLItem">

    <xsl:variable name="label">
      <xsl:apply-templates select="."
                           mode="xstructural.titleText"/>
    </xsl:variable>

    <xsl:variable name="file">
      <xsl:call-template name="xstructural.links.anchorOf">
        <xsl:with-param name="target"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$file"/>
        </xsl:attribute>
        <xsl:value-of select="$label"/>
      </xsl:element>

      <xsl:if test="count(s:Section|s:Subsection) > 0">
        <ul>
          <xsl:apply-templates select="s:Section|s:Subsection"
                               mode="xstructural.epub.tableOfContentsXHTMLItem"/>
        </ul>
      </xsl:if>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>