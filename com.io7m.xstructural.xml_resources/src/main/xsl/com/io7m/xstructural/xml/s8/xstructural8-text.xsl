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
                xmlns:xsc="urn:com.io7m.xstructural.case"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xdoc:doc>
    Generate text that is to be used as the 'title' attribute of an XHTML 'a' element. This typically yields text that
    describes the type, number, and the title of the target node, such as "Section 1. A Section".
  </xdoc:doc>

  <xsl:template name="xstructural.titles.anchorTitleFor"
                as="xsd:string">
    <xsl:param name="node"
               as="element()"/>

    <xsl:variable name="number"
                  as="xsd:string">
      <xsl:number level="multiple"
                  select="$node"
                  count="s:Section|s:Subsection|s:Paragraph|s:FormalItem"/>
    </xsl:variable>

    <xsl:variable name="type"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($node) = 'Document'">Document</xsl:when>
        <xsl:when test="local-name($node) = 'Section'">Section</xsl:when>
        <xsl:when test="local-name($node) = 'Subsection'">Subsection</xsl:when>
        <xsl:when test="local-name($node) = 'Paragraph'">Paragraph</xsl:when>
        <xsl:when test="local-name($node) = 'FormalItem'">Formal Item</xsl:when>
        <xsl:when test="local-name($node) = 'LinkFootnote'">Footnote Reference @</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="error(QName('urn:com.io7m.xstructural.core','wrongNode'), local-name($node))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$type = 'Document'">
        <xsl:value-of select="'Front Matter'"/>
      </xsl:when>
      <xsl:when test="$node/attribute::title">
        <xsl:value-of select="concat($type,' ',$number,': ',$node/attribute::title)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($type,' ',$number)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xdoc:doc>
    Generate title text in a rendered section.
  </xdoc:doc>

  <xsl:template match="@*|node()"
                mode="xstructural.titleText"
                as="xsd:string">
    <xsl:message terminate="yes">
      <xsl:value-of select="concat('Unexpected node ', local-name(.) , ' passed to xstructural.titleText')"/>
    </xsl:message>
  </xsl:template>

  <xdoc:doc>
    Generate title text in a rendered document.
  </xdoc:doc>

  <xsl:template match="s:Document"
                mode="xstructural.titleText"
                as="xsd:string">
    <xsl:value-of select="s:Metadata/dc:title"/>
  </xsl:template>

  <xdoc:doc>
    Generate title text in a rendered section.
  </xdoc:doc>

  <xsl:template match="s:Section"
                mode="xstructural.titleText"
                as="xsd:string">
    <xsl:variable name="sectionNumber">
      <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
        <xsl:with-param name="section"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($sectionNumber, '. ', @title)"/>
  </xsl:template>

  <xdoc:doc>
    Generate title text in a rendered subsection.
  </xdoc:doc>

  <xsl:template match="s:Subsection"
                mode="xstructural.titleText"
                as="xsd:string">
    <xsl:variable name="numberTitle">
      <xsl:call-template name="xstructural.numbers.subsectionNumberTitleOf">
        <xsl:with-param name="subsection"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($numberTitle, '. ', @title)"/>
  </xsl:template>

  <xdoc:doc>
    Generate title text in a rendered formal item.
  </xdoc:doc>

  <xsl:template match="s:FormalItem"
                mode="xstructural.titleText"
                as="xsd:string">
    <xsl:variable name="numberTitle">
      <xsl:call-template name="xstructural.numbers.formalItemNumberTitleOf">
        <xsl:with-param name="formalItem"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($numberTitle, '. ', @title)"/>
  </xsl:template>

  <xdoc:doc>
    Generate an ID attribute for the current element.
  </xdoc:doc>

  <xsl:template name="xstructural.ids.idAttributeFor"
                as="attribute()">
    <xsl:param name="node"
               as="element()"
               required="yes"/>

    <xsl:choose>
      <xsl:when test="$node/@id">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('id_', $node/@id)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="stId">
          <xsl:value-of select="generate-id($node)"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="$stId"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xdoc:doc>
    Generate a self referencing href attribute for the current element.
  </xdoc:doc>

  <xsl:template name="xstructural.ids.hrefAttributeFor"
                as="attribute()">
    <xsl:param name="node"
               as="element()"
               required="yes"/>

    <xsl:choose>
      <xsl:when test="$node/@id">
        <xsl:attribute name="href">
          <xsl:value-of select="concat('#id_', $node/@id)"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="stId">
          <xsl:value-of select="generate-id($node)"/>
        </xsl:variable>
        <xsl:attribute name="href">
          <xsl:value-of select="concat('#', $stId)"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xdoc:doc>
    Generate a class attribute based on the given named class and the type attribute of the current node.
  </xdoc:doc>

  <xsl:template name="xstructural.classes.attributeFor">
    <xsl:param name="baseClass"
               as="xsd:string"
               required="yes"/>

    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@type">
          <xsl:value-of select="concat($baseClass, ' ', @type)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$baseClass"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xdoc:doc>
    Generate text to be used as the displayed number of a given section. This will yield text values such as "1.2.3" if
    the current section is the third child section, of the second child section, of the first section in the document.
  </xdoc:doc>

  <xsl:template name="xstructural.numbers.sectionNumberTitleOf"
                as="xsd:string">
    <xsl:param name="section"
               as="element()"
               required="yes"/>
    <xsl:number level="multiple"
                select="$section"
                count="s:Section"/>
  </xsl:template>

  <xdoc:doc>
    Generate text to be used as the displayed number of a given subsection. This will yield text values such as "1.2.3"
    if the current subsection is the third child subsection, of the second child subsection, of the first subsection in
    the document.
  </xdoc:doc>

  <xsl:template name="xstructural.numbers.subsectionNumberTitleOf"
                as="xsd:string">
    <xsl:param name="subsection"
               as="element()"
               required="yes"/>

    <xsl:variable name="sectionNumber"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="count(ancestor::s:Section) > 0">
          <xsl:variable name="numericPart">
            <xsl:call-template name="xstructural.numbers.sectionNumberTitleOf">
              <xsl:with-param name="section"
                              select="ancestor::s:Section[1]"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="concat($numericPart,'.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="subsectionNumber"
                  as="xsd:string">
      <xsl:number level="multiple"
                  select="$subsection"
                  count="s:Subsection"/>
    </xsl:variable>

    <xsl:value-of select="concat($sectionNumber,$subsectionNumber)"/>
  </xsl:template>

  <xdoc:doc>
    Generate text to be used as the displayed number of a given formal item. This will yield text values such as "1.2.3"
    if the current formal item is the third child formal item, of the second child subsection, of the first subsection
    in the document.
  </xdoc:doc>

  <xsl:template name="xstructural.numbers.formalItemNumberTitleOf"
                as="xsd:string">
    <xsl:param name="formalItem"
               as="element()"
               required="yes"/>
    <xsl:number select="$formalItem"
                level="multiple"
                count="s:Section|s:Subsection|s:Paragraph|s:FormalItem"/>
  </xsl:template>

  <xdoc:doc>
    Generate headers for HTML documents based on metadata.
  </xdoc:doc>

  <xsl:template match="s:Metadata"
                mode="xstructural.metadata.header">
    <xsl:apply-templates select="*"
                         mode="xstructural.metadata.header"/>
  </xsl:template>

  <xsl:template match="s:MetaProperty"
                mode="xstructural.metadata.header">
    <xsl:if test="@visible">
      <xsl:element name="meta">
        <xsl:attribute name="name"
                       select="@name"/>
        <xsl:attribute name="content"
                       select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dc:*"
                mode="xstructural.metadata.header">

    <xsl:element name="meta">
      <xsl:attribute name="name"
                     select="concat('DC.', xsc:titleCaseOf(local-name()))"/>
      <xsl:attribute name="content"
                     select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
