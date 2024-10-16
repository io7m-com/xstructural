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
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural7-links.xsl"/>
  <xsl:import href="xstructural7-text.xsl"/>
  <xsl:import href="xstructural7-keys.xsl"/>

  <xsl:template match="text()"
                mode="xstructural.inlines">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="s:Link"
                mode="xstructural.inlines">
    <xsl:element name="a">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stLink'"/>
      </xsl:call-template>

      <xsl:attribute name="href">
        <xsl:call-template name="xstructural.links.anchorOf">
          <xsl:with-param name="target"
                          select="key('xstructural.links.key',@target)"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="title">
        <xsl:call-template name="xstructural.titles.anchorTitleFor">
          <xsl:with-param name="node"
                          select="key('xstructural.links.key',@target)"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:LinkExternal"
                mode="xstructural.inlines">
    <xsl:element name="a">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stLinkExternal'"/>
      </xsl:call-template>

      <xsl:attribute name="href"
                     select="@target"/>
      <xsl:attribute name="title"
                     select="@target"/>

      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Footnote"
                mode="xstructural.footnotes.index"
                as="xsd:integer">
    <xsl:number count="s:Footnote"/>
  </xsl:template>

  <xsl:template match="s:LinkFootnote"
                mode="xstructural.inlines">

    <xsl:variable name="targetFootnote"
                  as="element()"
                  select="key('xstructural.footnotes.key',@target)"/>

    <xsl:element name="a">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stLinkFootnote'"/>
      </xsl:call-template>

      <xsl:call-template name="xstructural.ids.idAttributeFor">
        <xsl:with-param name="node"
                        select="."/>
      </xsl:call-template>

      <xsl:attribute name="href">
        <xsl:call-template name="xstructural.links.anchorOf">
          <xsl:with-param name="target"
                          select="$targetFootnote"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:variable name="footnoteIndex"
                    as="xsd:integer">
        <xsl:apply-templates select="$targetFootnote"
                             mode="xstructural.footnotes.index"/>
      </xsl:variable>

      <xsl:attribute name="title">
        <xsl:value-of select="concat('Footnote ',$footnoteIndex)"/>
      </xsl:attribute>

      <xsl:value-of select="concat('[',$footnoteIndex,']')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Cell"
                mode="xstructural.inlines">
    <xsl:element name="td">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stTableCell'"/>
      </xsl:call-template>
      <xsl:apply-templates select="child::node()"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Row"
                mode="xstructural.inlines">
    <xsl:element name="tr">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stTableRow'"/>
      </xsl:call-template>
      <xsl:apply-templates select="s:Cell"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Column"
                mode="xstructural.inlines">
    <xsl:element name="th">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stTableColumn'"/>
      </xsl:call-template>
      <xsl:apply-templates select="child::node()"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Columns"
                mode="xstructural.inlines">
    <xsl:element name="thead">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stTableColumns'"/>
      </xsl:call-template>

      <tr>
        <xsl:apply-templates select="s:Column"
                             mode="xstructural.inlines"/>
      </tr>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Table"
                mode="xstructural.inlines">
    <xsl:element name="table">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stTable'"/>
      </xsl:call-template>

      <xsl:apply-templates select="s:Columns"
                           mode="xstructural.inlines"/>
      <tbody>
        <xsl:apply-templates select="s:Row"
                             mode="xstructural.inlines"/>
      </tbody>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Item"
                mode="xstructural.inlines">
    <xsl:element name="li">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stItem'"/>
      </xsl:call-template>
      <xsl:apply-templates select="child::node()"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:ListOrdered"
                mode="xstructural.inlines">
    <xsl:element name="ol">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stListOrdered'"/>
      </xsl:call-template>
      <xsl:apply-templates select="s:Item"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:ListUnordered"
                mode="xstructural.inlines">
    <xsl:element name="ul">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stListUnordered'"/>
      </xsl:call-template>
      <xsl:apply-templates select="s:Item"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Verbatim"
                mode="xstructural.inlines">
    <xsl:element name="pre">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stVerbatim'"/>
      </xsl:call-template>
      <xsl:variable name="trimmedLeading"
                    as="xsd:string"
                    select="replace(.,'^\s+','')"/>
      <xsl:variable name="trimmedTrailing"
                    as="xsd:string"
                    select="replace($trimmedLeading,'\s+$','')"/>
      <xsl:value-of select="$trimmedTrailing"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Term"
                mode="xstructural.inlines">
    <xsl:element name="span">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stTerm'"/>
      </xsl:call-template>
      <xsl:apply-templates select="child::node()"
                           mode="xstructural.inlines"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Image"
                mode="xstructural.inlines">
    <xsl:element name="img">
      <xsl:call-template name="xstructural.classes.attributeFor">
        <xsl:with-param name="baseClass"
                        select="'stImage'"/>
      </xsl:call-template>
      <xsl:attribute name="src">
        <xsl:value-of select="@source"/>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:if test="@width">
        <xsl:attribute name="width">
          <xsl:value-of select="@width"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@height">
        <xsl:attribute name="height">
          <xsl:value-of select="@height"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
