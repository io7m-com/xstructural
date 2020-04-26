<?xml version="1.0" encoding="UTF-8" ?>

<!--
  Copyright © 2020 Mark Raynsford <code@io7m.com> http://io7m.com

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

<xsl:package xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
             xmlns:xs="http://www.w3.org/2001/XMLSchema"
             xmlns:s="urn:com.io7m.structural:7:0"
             xmlns="http://www.w3.org/1999/xhtml"
             xmlns:dc="http://purl.org/dc/elements/1.1/"
             name="com.io7m.structural.xsl.core"
             exclude-result-prefixes="#all"
             declared-modes="yes"
             xmlns:sxc="urn:com.io7m.structural.xsl.core"
             package-version="1.0.0"
             version="3.0">

  <xsl:key name="LinkKey"
           match="/s:Document//(s:Paragraph|s:FormalItem|s:Section|s:Subsection)"
           use="@id"/>

  <xsl:key name="FootnoteKey"
           match="/s:Document//s:Footnote"
           use="@id"/>

  <xsl:key name="FootnoteReferenceKey"
           match="/s:Document//s:LinkFootnote"
           use="@target"/>

  <xsl:function name="sxc:anchorOf"
                as="xs:string"
                visibility="abstract">
    <xsl:param name="node"/>
  </xsl:function>

  <xsl:mode name="sxc:tableOfContentsOptional"
            visibility="final"
            warning-on-no-match="true"/>

  <xsl:mode name="sxc:tableOfContents"
            visibility="final"
            warning-on-no-match="true"/>

  <xsl:mode name="sxc:blockMode"
            visibility="final"
            warning-on-no-match="true"/>

  <xsl:mode name="sxc:content"
            visibility="final"
            warning-on-no-match="true"/>

  <xsl:template match="text()"
                mode="sxc:content">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template name="sxc:sectionNumberTitleOf"
                visibility="final">
    <xsl:param name="section"
               required="true"/>
    <xsl:number level="multiple"
                select="$section"
                count="s:Section"/>
  </xsl:template>

  <xsl:template name="sxc:subsectionNumberTitleOf"
                visibility="final">
    <xsl:param name="subsection"
               required="true"/>

    <xsl:variable name="sectionNumber">
      <xsl:call-template name="sxc:sectionNumberTitleOf">
        <xsl:with-param name="section"
                        select="ancestor::s:Section[1]"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="subsectionNumber">
      <xsl:number level="multiple"
                  select="$subsection"
                  count="s:Subsection"/>
    </xsl:variable>

    <xsl:value-of select="concat($sectionNumber,'.',$subsectionNumber)"/>
  </xsl:template>

  <xsl:template name="sxc:nodeNumberTitleOf"
                visibility="final">
    <xsl:param name="node"
               required="true"/>

    <xsl:variable name="number">
      <xsl:number level="multiple"
                  select="$node"
                  count="s:Section|s:Subsection|s:Paragraph|s:FormalItem"/>
    </xsl:variable>

    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="local-name($node) = 'Section'">Section</xsl:when>
        <xsl:when test="local-name($node) = 'Subsection'">Subsection</xsl:when>
        <xsl:when test="local-name($node) = 'Paragraph'">Paragraph</xsl:when>
        <xsl:when test="local-name($node) = 'FormalItem'">Formal Item</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$node/attribute::title">
        <xsl:value-of select="concat($type,' ',$number,': ',$node/attribute::title)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($type,' ',$number)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Subsection"
                mode="sxc:tableOfContents">
    <xsl:param name="depthMaximum"
               required="true"/>
    <xsl:param name="depthCurrent"
               required="true"/>

    <xsl:choose>
      <xsl:when test="$depthCurrent &lt;= $depthMaximum">
        <ul>
          <li>
            <xsl:variable name="numberTitle">
              <xsl:call-template name="sxc:subsectionNumberTitleOf">
                <xsl:with-param name="subsection"
                                select="."/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="sxc:anchorOf(.)"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="."/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:value-of select="concat($numberTitle,'. ',attribute::title)"/>
            </xsl:element>

            <xsl:apply-templates select="s:Section|s:Subsection"
                                 mode="sxc:tableOfContents">
              <xsl:with-param name="depthMaximum"
                              select="$depthMaximum"/>
              <xsl:with-param name="depthCurrent"
                              select="$depthCurrent + 1"/>
            </xsl:apply-templates>
          </li>
        </ul>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="sxc:tableOfContents">
    <xsl:param name="depthMaximum"
               required="true"/>
    <xsl:param name="depthCurrent"
               required="true"/>

    <xsl:choose>
      <xsl:when test="$depthCurrent &lt;= $depthMaximum">
        <xsl:element name="ul">
          <li>
            <xsl:variable name="numberTitle">
              <xsl:call-template name="sxc:sectionNumberTitleOf">
                <xsl:with-param name="section"
                                select="."/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="sxc:anchorOf(.)"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="."/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:value-of select="concat($numberTitle,'. ',attribute::title)"/>
            </xsl:element>

            <xsl:apply-templates select="s:Section|s:Subsection"
                                 mode="sxc:tableOfContents">
              <xsl:with-param name="depthMaximum"
                              select="$depthMaximum"/>
              <xsl:with-param name="depthCurrent"
                              select="$depthCurrent + 1"/>
            </xsl:apply-templates>
          </li>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Section"
                name="sxc:tableOfContents"
                mode="sxc:tableOfContentsOptional"
                visibility="public">
    <xsl:choose>
      <xsl:when test="@tableOfContents = 'false'">
        <div class="stTableOfContents">
          <xsl:comment>No table of contents requested.</xsl:comment>
        </div>
      </xsl:when>
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

        <div class="stTableOfContents">
          <div class="stTableOfContentsMargin">
            <xsl:comment>Margin</xsl:comment>
          </div>
          <div class="stTableOfContentsContent">
            <xsl:apply-templates select="."
                                 mode="sxc:tableOfContents">
              <xsl:with-param name="depthCurrent"
                              select="0"/>
              <xsl:with-param name="depthMaximum"
                              select="$maximumDepth"/>
            </xsl:apply-templates>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="stMaybeType">
    <xsl:choose>
      <xsl:when test="@type">
        <xsl:attribute name="class">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Link"
                mode="sxc:content">
    <xsl:element name="a">
      <xsl:call-template name="stMaybeType"/>
      <xsl:attribute name="href"
                     select="sxc:anchorOf(key('LinkKey',@target))"/>
      <xsl:attribute name="title">
        <xsl:call-template name="sxc:nodeNumberTitleOf">
          <xsl:with-param name="node"
                          select="key('LinkKey',@target)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:LinkExternal"
                mode="sxc:content">
    <xsl:element name="a">
      <xsl:call-template name="stMaybeType"/>
      <xsl:attribute name="href"
                     select="@target"/>
      <xsl:attribute name="title"
                     select="@target"/>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:LinkFootnote"
                mode="sxc:content">
    <xsl:variable name="node"
                  select="key('FootnoteKey',@target)"/>
    <xsl:element name="a">
      <xsl:call-template name="stMaybeType"/>
      <xsl:attribute name="id"
                     select="generate-id()"/>
      <xsl:attribute name="href"
                     select="sxc:anchorOf($node)"/>
      <xsl:variable name="footnoteIndex">
        <xsl:number select="$node"
                    level="single"
                    count="s:Footnote"/>
      </xsl:variable>
      <xsl:attribute name="title">
        <xsl:value-of select="concat('Footnote ',$footnoteIndex)"/>
      </xsl:attribute>
      <xsl:value-of select="concat('[',$footnoteIndex,']')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Verbatim"
                mode="sxc:content">
    <xsl:variable name="trimmedLeading"
                  select="replace(.,'^\s+','')"/>
    <xsl:variable name="trimmedTrailing"
                  select="replace($trimmedLeading,'\s+$','')"/>
    <pre class="stVerbatim">
      <xsl:value-of select="$trimmedLeading"/>
    </pre>
  </xsl:template>

  <xsl:template match="s:Cell"
                mode="sxc:content">
    <xsl:element name="td">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="child::node()"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Row"
                mode="sxc:content">
    <xsl:element name="tr">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="s:Cell"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Column"
                mode="sxc:content">
    <xsl:element name="th">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="child::node()"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Columns"
                mode="sxc:content">
    <xsl:element name="thead">
      <xsl:call-template name="stMaybeType"/>
      <tr>
        <xsl:apply-templates select="s:Column"
                             mode="sxc:content"/>
      </tr>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Table"
                mode="sxc:content">
    <xsl:element name="table">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="s:Columns"
                           mode="sxc:content"/>
      <tbody>
        <xsl:apply-templates select="s:Row"
                             mode="sxc:content"/>
      </tbody>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Item"
                mode="sxc:content">
    <xsl:element name="li">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="child::node()"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:ListUnordered"
                mode="sxc:content">
    <xsl:element name="ul">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="child::node()"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:ListOrdered"
                mode="sxc:content">
    <xsl:element name="ol">
      <xsl:call-template name="stMaybeType"/>
      <xsl:apply-templates select="child::node()"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Term"
                mode="sxc:content">
    <xsl:element name="span">
      <xsl:attribute name="class">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates select="child::node()"
                           mode="sxc:content"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Image"
                mode="sxc:content">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="@source"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:element name="img">
        <xsl:attribute name="class">
          <xsl:value-of select="'stImage'"/>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:value-of select="."/>
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="@source"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Paragraph"
                mode="sxc:blockMode">
    <div class="stParagraph">
      <div class="stParagraphNumber">
        <xsl:choose>
          <xsl:when test="@id">
            <xsl:element name="a">
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
              <xsl:value-of select="count(preceding-sibling::s:Paragraph|preceding-sibling::s:FormalItem) + 1"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:variable name="stId">
                <xsl:value-of select="generate-id(.)"/>
              </xsl:variable>
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
              <xsl:value-of select="count(preceding-sibling::s:Paragraph|preceding-sibling::s:FormalItem) + 1"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </div>

      <div class="stParagraphContent">
        <xsl:apply-templates select="child::node()"
                             mode="sxc:content"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="s:FormalItem"
                mode="sxc:blockMode">
    <div class="stFormalItemHeader">
      <span class="stFormalItemNumber">
        <xsl:choose>
          <xsl:when test="@id">
            <xsl:element name="a">
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
              <xsl:value-of select="count(preceding-sibling::s:Paragraph|preceding-sibling::s:FormalItem) + 1"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:variable name="stId">
                <xsl:value-of select="generate-id(.)"/>
              </xsl:variable>
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
              <xsl:value-of select="count(preceding-sibling::s:Paragraph|preceding-sibling::s:FormalItem) + 1"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <span class="stFormalItemTitle">
        <xsl:variable name="stNumber">
          <xsl:number select="."
                      level="multiple"
                      count="s:Section|s:Subsection|s:Paragraph|s:FormalItem"/>
        </xsl:variable>
        <xsl:value-of select="concat($stNumber,' ',@title)"/>
      </span>
    </div>

    <div class="stFormalItemContent">
      <div class="stFormalItemContentMargin">
        <xsl:comment>Margin</xsl:comment>
      </div>
      <div class="stFormalItemContentMain">
        <xsl:apply-templates select="child::node()"
                             mode="sxc:content"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="s:Footnote"
                mode="sxc:blockMode">

    <xsl:variable name="stNumber">
      <xsl:number level="single"
                  select="."
                  count="s:Footnote"/>
    </xsl:variable>

    <div class="stFootnoteContainer">
      <div class="stFootnoteNumber">
        <xsl:choose>
          <xsl:when test="@id">
            <xsl:element name="a">
              <xsl:attribute name="id">
                <xsl:value-of select="concat('id_', @id)"/>
              </xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="concat('#id_', @id)"/>
              </xsl:attribute>
              <xsl:value-of select="$stNumber"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:variable name="stId">
                <xsl:value-of select="generate-id(.)"/>
              </xsl:variable>
              <xsl:attribute name="id">
                <xsl:value-of select="$stId"/>
              </xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="concat('#', $stId)"/>
              </xsl:attribute>
              <xsl:value-of select="$stNumber"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </div>
      <div class="stFootnoteContent">
        <div>
          <xsl:apply-templates select="child::node()"
                               mode="sxc:content"/>
        </div>
        <xsl:choose>
          <xsl:when test="count(key('FootnoteReferenceKey',@id)) > 0">
            <div>
              <h4>Footnote References</h4>
              <ul>
                <xsl:for-each select="key('FootnoteReferenceKey',@id)">
                  <li>
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="sxc:anchorOf(.)"/>
                      </xsl:attribute>
                      <xsl:call-template name="sxc:nodeNumberTitleOf">
                        <xsl:with-param name="node"
                                        select="."/>
                      </xsl:call-template>
                    </xsl:element>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </xsl:when>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="s:Footnotes"
                mode="sxc:blockMode">
    <xsl:choose>
      <xsl:when test="count(s:Footnote) > 0">
        <div id="stFootnotes">
          <h3>Footnotes</h3>
          <xsl:apply-templates select="s:Footnote"
                               mode="sxc:blockMode"/>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Subsection"
                mode="sxc:blockMode">
    <h2 class="stSubsectionHeader">
      <span class="stSubsectionNumber">
        <xsl:call-template name="sxc:subsectionNumberTitleOf">
          <xsl:with-param name="subsection"
                          select="."/>
        </xsl:call-template>
      </span>
      <span class="stSubsectionTitle">
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
    </h2>

    <xsl:apply-templates select="s:Subsection|s:Paragraph|s:FormalItem"
                         mode="sxc:blockMode"/>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="sxc:blockMode">
    <xsl:call-template name="sxc:section"/>
  </xsl:template>

  <xsl:template name="sxc:section"
                visibility="abstract"/>

  <xsl:template name="sxc:brandingHeader"
                visibility="final">
    <xsl:param name="branding"
               required="true"/>
    <div id="stBrandingHeader">
      <xsl:comment>Branding Header</xsl:comment>
      <xsl:choose>
        <xsl:when test="$branding">
          <xsl:copy-of select="document($branding)/*"/>
        </xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template name="sxc:brandingFooter"
                visibility="final">
    <xsl:param name="branding"
               required="true"/>
    <div id="stBrandingFooter">
      <xsl:comment>Branding Footer</xsl:comment>
      <xsl:choose>
        <xsl:when test="$branding">
          <xsl:copy-of select="document($branding)/*"/>
        </xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:mode name="sxc:metadataHeader"
            visibility="final"/>
  <xsl:template match="dc:creator"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Creator'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:subject"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Subject'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:description"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Description'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:publisher"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Publisher'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:contributor"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Contributor'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:date"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Date'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:type"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Type'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:format"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Format'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:identifier"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Identifier'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:source"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Source'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:language"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Language'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:relation"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Relation'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:coverage"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Coverage'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:rights"
                mode="sxc:metadataHeader">
    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="'DC.Rights'"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dc:title"
                mode="sxc:metadataHeader"/>


  <xsl:mode name="sxc:metadataFrontMatter"
            visibility="final"/>
  <xsl:template match="dc:title"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:creator"
                mode="sxc:metadataFrontMatter">
    <tr>
      <td>Creator</td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="dc:subject"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:description"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:publisher"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:contributor"
                mode="sxc:metadataFrontMatter">
    <tr>
      <td>Contributor</td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="dc:date"
                mode="sxc:metadataFrontMatter">
    <tr>
      <td>Date</td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="dc:type"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:format"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:identifier"
                mode="sxc:metadataFrontMatter">
    <tr>
      <td>ID</td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="dc:source"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:language"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:relation"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:coverage"
                mode="sxc:metadataFrontMatter"/>
  <xsl:template match="dc:rights"
                mode="sxc:metadataFrontMatter"/>

</xsl:package>