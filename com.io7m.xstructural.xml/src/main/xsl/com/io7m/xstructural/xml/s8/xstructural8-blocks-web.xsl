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

  <!--                              -->
  <!-- Web block content overrides. -->
  <!--                              -->

  <xdoc:doc>
    A template used to generate a "standard region". A standard region is a set of nested 'div' elements with an
    'stRegion' CSS class, and a margin and content node.
  </xdoc:doc>

  <xsl:template name="xstructural.regions.standardRegion"
                as="element()">
    <xsl:param name="class"
               as="xsd:string"/>
    <xsl:param name="stMarginNode"
               as="item()*"/>
    <xsl:param name="stContentNode"
               as="item()*"/>

    <xsl:element name="div">
      <xsl:attribute name="class"
                     select="concat('stRegion ',$class)"/>
      <xsl:element name="div">
        <xsl:attribute name="class"
                       select="'stRegionMargin'"/>
        <xsl:sequence select="$stMarginNode"/>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class"
                       select="'stRegionContent'"/>
        <xsl:sequence select="$stContentNode"/>
      </xsl:element>
      <xsl:text>&#x000a;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xdoc:doc>
    Generate a title element in a rendered document.
  </xdoc:doc>

  <xsl:template match="s:Document"
                mode="xstructural.titleElement">

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stSection'"/>
      <xsl:with-param name="stMarginNode">
        <xsl:comment>Empty</xsl:comment>
      </xsl:with-param>
      <xsl:with-param name="stContentNode">
        <h1 class="stDocumentTitle">
          <xsl:value-of select="s:Metadata/dc:title"/>
        </h1>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xdoc:doc>
    Generate a title element in a rendered section.
  </xdoc:doc>

  <xsl:template match="s:Section"
                mode="xstructural.titleElement">

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stSection'"/>
      <xsl:with-param name="stMarginNode">
        <xsl:comment>Empty</xsl:comment>
      </xsl:with-param>
      <xsl:with-param name="stContentNode">
        <h1 class="stSectionTitle">
          <xsl:element name="a">
            <xsl:call-template name="xstructural.ids.idAttributeFor">
              <xsl:with-param name="node"
                              select="."/>
            </xsl:call-template>

            <xsl:call-template name="xstructural.ids.hrefAttributeFor">
              <xsl:with-param name="node"
                              select="."/>
            </xsl:call-template>

            <xsl:attribute name="title">
              <xsl:call-template name="xstructural.titles.anchorTitleFor">
                <xsl:with-param name="node"
                                select="."/>
              </xsl:call-template>
            </xsl:attribute>

            <xsl:variable name="sectionNumber">
              <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
                <xsl:with-param name="section"
                                select="."/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:value-of select="concat($sectionNumber, '. ', @title)"/>
          </xsl:element>
        </h1>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

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
                      <xsl:with-param name="target"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:call-template name="xstructural.titles.anchorTitleFor">
                      <xsl:with-param name="node"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:value-of select="position()"/>
                </xsl:element>
              </xsl:for-each>
            </div>
          </xsl:when>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="xstructural.blocks.footnotes">
    <xsl:variable name="footnotesContent">
      <h2>Footnotes</h2>
      <div class="stFootnotes">
        <table>
          <xsl:apply-templates select="s:Footnote"
                               mode="xstructural.blocks"/>
        </table>
      </div>
    </xsl:variable>

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stFootnotes'"/>
      <xsl:with-param name="stMarginNode">
        <xsl:comment>Empty</xsl:comment>
      </xsl:with-param>
      <xsl:with-param name="stContentNode"
                      select="$footnotesContent"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="s:Paragraph"
                mode="xstructural.blocks">
    <xsl:variable name="stParagraphNumber"
                  as="element()">
      <xsl:element name="a">
        <xsl:attribute name="class"
                       select="'stParagraphNumber'"/>
        <xsl:call-template name="xstructural.ids.idAttributeFor">
          <xsl:with-param name="node"
                          select="."/>
        </xsl:call-template>
        <xsl:call-template name="xstructural.ids.hrefAttributeFor">
          <xsl:with-param name="node"
                          select="."/>
        </xsl:call-template>
        <xsl:attribute name="title">
          <xsl:call-template name="xstructural.titles.anchorTitleFor">
            <xsl:with-param name="node"
                            select="."/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:value-of select="count(preceding-sibling::s:Paragraph|preceding-sibling::s:FormalItem) + 1"/>
      </xsl:element>
    </xsl:variable>

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stParagraph'"/>
      <xsl:with-param name="stMarginNode"
                      select="$stParagraphNumber"/>
      <xsl:with-param name="stContentNode">
        <xsl:apply-templates select="child::node()"
                             mode="xstructural.inlines"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="s:FormalItem"
                mode="xstructural.blocks">
    <xsl:variable name="formalItemContent">
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
    </xsl:variable>

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stFootnotes'"/>
      <xsl:with-param name="stMarginNode">
        <xsl:comment>Empty</xsl:comment>
      </xsl:with-param>
      <xsl:with-param name="stContentNode"
                      select="$formalItemContent"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="s:Subsection"
                mode="xstructural.blocks">

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stSubsection'"/>
      <xsl:with-param name="stMarginNode">
        <xsl:comment>Empty</xsl:comment>
      </xsl:with-param>
      <xsl:with-param name="stContentNode">
        <xsl:apply-templates select="."
                             mode="xstructural.titleElement"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates select="s:Paragraph|s:FormalItem|s:Subsection"
                         mode="xstructural.blocks"/>
  </xsl:template>

  <xsl:template match="s:Metadata"
                mode="xstructural.metadata.table">

    <xsl:call-template name="xstructural.regions.standardRegion">
      <xsl:with-param name="class"
                      select="'stMetadata'"/>
      <xsl:with-param name="stMarginNode">
        <xsl:comment>Empty</xsl:comment>
      </xsl:with-param>
      <xsl:with-param name="stContentNode">
        <div class="stMetadataTable">
          <table>
            <xsl:apply-templates select="s:MetaProperty|dc:*"
                                 mode="xstructural.metadata.table"/>
          </table>
        </div>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="s:Document|s:Section"
                mode="xstructural.tableOfContentsOptional">
    <xsl:param name="withTitle"
               as="xsd:boolean"
               required="yes"/>

    <xsl:choose>
      <xsl:when test="@tableOfContents = 'false'"/>
      <xsl:when test="count(s:Section) = 0 and count(s:Subsection) = 0"/>

      <xsl:otherwise>
        <xsl:variable name="maximumDepth">
          <xsl:choose>
            <xsl:when test="@tableOfContentsDepth">
              <xsl:value-of select="@tableOfContentsDepth"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="3"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="xstructural.regions.standardRegion">
          <xsl:with-param name="class"
                          select="'stTableOfContents'"/>
          <xsl:with-param name="stMarginNode">
            <xsl:comment>Empty</xsl:comment>
          </xsl:with-param>
          <xsl:with-param name="stContentNode">
            <div class="stTableOfContents">
              <xsl:if test="$withTitle">
                <h1>Table Of Contents</h1>
              </xsl:if>

              <ul>
                <xsl:apply-templates select="s:Section|s:Subsection"
                                     mode="xstructural.tableOfContents">
                  <xsl:with-param name="depthCurrent"
                                  select="0"/>
                  <xsl:with-param name="depthMaximum"
                                  select="$maximumDepth"/>
                </xsl:apply-templates>
              </ul>
            </div>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
