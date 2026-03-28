<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:s2="http://schemas.io7m.com/structural/2.1.0"
                xmlns="urn:com.io7m.structural:7:0"
                version="3.0">

  <xsl:output indent="true"/>

  <xsl:template match="s2:image">
    <xsl:element name="Image">
      <xsl:attribute name="source" select="@s2:source"/>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:verbatim">
    <xsl:element name="Verbatim">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:list-item">
    <xsl:element name="Item">
      <xsl:apply-templates select="child::node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:list-ordered">
    <xsl:element name="ListOrdered">
      <xsl:apply-templates select="s2:list-item"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:formal-item">
    <xsl:element name="FormalItem">
      <xsl:attribute name="title" select="s2:formal-item-title"/>
      <xsl:apply-templates select="s2:verbatim|s2:image|s2:list-ordered|s2:list-unordered|s2:table"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:link-external">
    <xsl:element name="LinkExternal">
      <xsl:attribute name="target" select="@s2:target"/>
      <xsl:apply-templates select="child::node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:term">
    <xsl:element name="Term">
      <xsl:attribute name="type" select="@s2:type"/>
      <xsl:apply-templates select="child::node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:paragraph">
    <xsl:element name="Paragraph">
      <xsl:apply-templates select="child::node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:subsection">
    <xsl:element name="Subsection">
      <xsl:attribute name="title" select="s2:subsection-title"/>
      <xsl:text>&#x000a;</xsl:text>
      <xsl:apply-templates select="s2:paragraph|s2:formal-item"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:section">
    <xsl:element name="Section">
      <xsl:attribute name="title" select="s2:section-title"/>
      <xsl:text>&#x000a;</xsl:text>
      <xsl:apply-templates select="s2:paragraph|s2:formal-item|s2:subsection"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s2:document">
    <Document>
      <Metadata>
        <dc:title><xsl:value-of select="s2:document-title"/></dc:title>
      </Metadata>
      <xsl:apply-templates select="s2:section"/>
    </Document>
  </xsl:template>

</xsl:stylesheet>