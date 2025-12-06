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
                xmlns:xdoc="http://www.pnp-software.com/XSLTdoc"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:template match="s:Paragraph"
                mode="xstructural.blocks">
    <xsl:message terminate="yes">
      s80:Paragraph xstructural.blocks template must be overridden.
    </xsl:message>
  </xsl:template>

  <xsl:template match="s:FormalItem"
                mode="xstructural.blocks">
    <xsl:message terminate="yes">
      s80:FormalItem xstructural.blocks template must be overridden.
    </xsl:message>
  </xsl:template>

  <xsl:template match="s:Subsection"
                mode="xstructural.blocks">
    <xsl:message terminate="yes">
      s80:Subsection xstructural.blocks template must be overridden.
    </xsl:message>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="xstructural.blocks">
    <xsl:message terminate="yes">
      s80:Section xstructural.blocks template must be overridden.
    </xsl:message>
  </xsl:template>

  <xsl:template match="s:Footnote"
                mode="xstructural.blocks">
    <xsl:message terminate="yes">
      s80:Footnote xstructural.blocks template must be overridden.
    </xsl:message>
  </xsl:template>

  <xdoc:doc>
    Generate a region containing the current set of footnotes, iff the set of footnotes is non-empty.
  </xdoc:doc>

  <xsl:template name="xstructural.blocks.footnotesOptional">
    <xsl:if test="count(s:Footnote) > 0">
      <xsl:call-template name="xstructural.blocks.footnotes"/>
    </xsl:if>
  </xsl:template>

  <xdoc:doc>
    Generate a region containing the current set of footnotes, iff the set of footnotes is non-empty.
  </xdoc:doc>

  <xsl:template name="xstructural.blocks.footnotes">
    <xsl:message terminate="yes">
      xstructural.blocks.footnotes template must be overridden.
    </xsl:message>
  </xsl:template>

  <xdoc:doc>
    Generate a table for metadata.
  </xdoc:doc>

  <xsl:template match="s:Metadata"
                mode="xstructural.metadata.table">
    <div class="stMetadataTable">
      <table>
        <xsl:apply-templates select="s:MetaProperty|dc:*"
                             mode="xstructural.metadata.table"/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="s:MetaProperty"
                mode="xstructural.metadata.table">
    <xsl:if test="@visible">
      <tr>
        <td>
          <xsl:value-of select="@name"/>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dc:*"
                mode="xstructural.metadata.table">
    <tr>
      <td>
        <xsl:value-of select="upper-case(local-name(.))"/>
      </td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xdoc:doc>
    The abstract template to be overridden for titles.
  </xdoc:doc>

  <xsl:template match="@*|node()"
                mode="xstructural.titleElement">
    <xsl:message terminate="yes">
      <xsl:value-of select="concat('Unexpected node ', local-name(.), ' processed with xstructural.titleElement')"/>
    </xsl:message>
  </xsl:template>

  <xdoc:doc>
    Generate a title element in a rendered document.
  </xdoc:doc>

  <xsl:template match="s:Document"
                mode="xstructural.titleElement">
    <h1 class="stDocumentTitle">
      <xsl:value-of select="s:Metadata/dc:title"/>
    </h1>
  </xsl:template>

  <xdoc:doc>
    Generate a title element in a rendered section.
  </xdoc:doc>

  <xsl:template match="s:Section"
                mode="xstructural.titleElement">
    <h1 class="stSectionTitle">
      <xsl:element name="a">
        <xsl:attribute name="class"
                       select="'stSectionNumber'"/>
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
  </xsl:template>

  <xdoc:doc>
    Generate a title element in a rendered subsection.
  </xdoc:doc>

  <xsl:template match="s:Subsection"
                mode="xstructural.titleElement">
    <h2 class="stSubsectionTitle">
      <xsl:element name="a">
        <xsl:attribute name="class"
                       select="'stSubsectionTitle'"/>

        <xsl:attribute name="title">
          <xsl:call-template name="xstructural.titles.anchorTitleFor">
            <xsl:with-param name="node"
                            select="."/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:call-template name="xstructural.ids.idAttributeFor">
          <xsl:with-param name="node"
                          select="."/>
        </xsl:call-template>

        <xsl:call-template name="xstructural.ids.hrefAttributeFor">
          <xsl:with-param name="node"
                          select="."/>
        </xsl:call-template>

        <xsl:variable name="numberTitle">
          <xsl:call-template name="xstructural.numbers.subsectionNumberTitleOf">
            <xsl:with-param name="subsection"
                            select="."/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="concat($numberTitle, '. ', @title)"/>
      </xsl:element>
    </h2>
  </xsl:template>

  <xdoc:doc>
    Generate a title element in a rendered formal item.
  </xdoc:doc>

  <xsl:template match="s:FormalItem"
                mode="xstructural.titleElement">
    <h3 class="stFormalItemTitle">
      <xsl:element name="a">
        <xsl:attribute name="class"
                       select="'stFormalItemTitle'"/>

        <xsl:attribute name="title">
          <xsl:call-template name="xstructural.titles.anchorTitleFor">
            <xsl:with-param name="node"
                            select="."/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:call-template name="xstructural.ids.idAttributeFor">
          <xsl:with-param name="node"
                          select="."/>
        </xsl:call-template>

        <xsl:call-template name="xstructural.ids.hrefAttributeFor">
          <xsl:with-param name="node"
                          select="."/>
        </xsl:call-template>

        <xsl:variable name="numberTitle">
          <xsl:call-template name="xstructural.numbers.formalItemNumberTitleOf">
            <xsl:with-param name="formalItem"
                            select="."/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="concat($numberTitle, '. ', @title)"/>
      </xsl:element>
    </h3>
  </xsl:template>

</xsl:stylesheet>
