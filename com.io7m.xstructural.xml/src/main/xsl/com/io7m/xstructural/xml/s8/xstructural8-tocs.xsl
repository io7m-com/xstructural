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
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural8-links.xsl"/>
  <xsl:import href="xstructural8-text.xsl"/>

  <xsl:template match="s:Subsection"
                mode="xstructural.tableOfContents">

    <xsl:param name="depthMaximum"
               as="xsd:integer"/>
    <xsl:param name="depthCurrent"
               as="xsd:integer"/>

    <xsl:choose>
      <xsl:when test="$depthCurrent &lt;= $depthMaximum">
        <xsl:element name="li">
          <xsl:variable name="numberTitle">
            <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
              <xsl:with-param name="section"
                              select="."/>
            </xsl:call-template>
          </xsl:variable>

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
            <xsl:value-of select="concat($numberTitle,'. ',attribute::title)"/>
          </xsl:element>

          <xsl:variable name="depthNext"
                        as="xsd:integer"
                        select="$depthCurrent + 1"/>
          <xsl:variable name="haveSections"
                        select="count(s:Section) > 0"
                        as="xsd:boolean"/>
          <xsl:variable name="haveSubsections"
                        select="count(s:Subsection) > 0"
                        as="xsd:boolean"/>
          <xsl:variable name="haveElements"
                        select="$haveSections or $haveSubsections"
                        as="xsd:boolean"/>
          <xsl:variable name="haveDepth"
                        select="$depthNext &lt; $depthMaximum"
                        as="xsd:boolean"/>
          <xsl:variable name="shouldCreateSubList"
                        select="$haveDepth and $haveElements"/>

          <xsl:if test="$shouldCreateSubList">
            <ul>
              <xsl:apply-templates select="s:Section|s:Subsection"
                                   mode="xstructural.tableOfContents">
                <xsl:with-param name="depthMaximum"
                                select="$depthMaximum"/>
                <xsl:with-param name="depthCurrent"
                                select="$depthCurrent + 1"/>
              </xsl:apply-templates>
            </ul>
          </xsl:if>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="xstructural.tableOfContents">
    <xsl:param name="depthMaximum"
               as="xsd:integer"/>
    <xsl:param name="depthCurrent"
               as="xsd:integer"/>

    <xsl:choose>
      <xsl:when test="$depthCurrent &lt;= $depthMaximum">
        <xsl:element name="li">
          <xsl:variable name="numberTitle">
            <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
              <xsl:with-param name="section"
                              select="."/>
            </xsl:call-template>
          </xsl:variable>

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
            <xsl:value-of select="concat($numberTitle,'. ',attribute::title)"/>
          </xsl:element>

          <xsl:variable name="depthNext"
                        as="xsd:integer"
                        select="$depthCurrent + 1"/>
          <xsl:variable name="haveSections"
                        select="count(s:Section) > 0"
                        as="xsd:boolean"/>
          <xsl:variable name="haveSubsections"
                        select="count(s:Subsection) > 0"
                        as="xsd:boolean"/>
          <xsl:variable name="haveElements"
                        select="$haveSections or $haveSubsections"
                        as="xsd:boolean"/>
          <xsl:variable name="haveDepth"
                        select="$depthNext &lt; $depthMaximum"
                        as="xsd:boolean"/>
          <xsl:variable name="shouldCreateSubList"
                        select="$haveDepth and $haveElements"/>

          <xsl:if test="$shouldCreateSubList">
            <ul>
              <xsl:apply-templates select="s:Section|s:Subsection"
                                   mode="xstructural.tableOfContents">
                <xsl:with-param name="depthMaximum"
                                select="$depthMaximum"/>
                <xsl:with-param name="depthCurrent"
                                select="$depthCurrent + 1"/>
              </xsl:apply-templates>
            </ul>
          </xsl:if>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()"
                mode="xstructural.tableOfContentsOptional">
    <xsl:param name="withTitle"
               as="xsd:boolean"
               required="yes"/>
    <xsl:message terminate="yes">
      <xsl:value-of select="concat('Unexpected node ', local-name(.) , ' passed to xstructural.tableOfContentsOptional')"/>
    </xsl:message>
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
        <xsl:text>&#x000a;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
