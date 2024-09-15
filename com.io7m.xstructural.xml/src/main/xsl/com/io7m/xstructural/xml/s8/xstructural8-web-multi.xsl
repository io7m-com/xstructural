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

  <xsl:import href="xstructural8-links.xsl"/>
  <xsl:import href="xstructural8-branding.xsl"/>
  <xsl:import href="xstructural8-navigation.xsl"/>

  <xsl:import href="xstructural8-outputs.xsl"/>
  <xsl:import href="xstructural8-blocks-web-multi.xsl"/>

  <xsl:template match="@*|node()">
    <xsl:message terminate="yes"
                 select="concat('Unexpectedly reached catch-all template: ', namespace-uri(.), ':',  node-name(.))"/>
  </xsl:template>

  <xsl:template match="comment()"/>

  <!--                                -->
  <!-- Top-level web multi templates. -->
  <!--                                -->

  <xsl:template name="xstructural.fileOf"
                as="xsd:string">
    <xsl:param name="target"
               as="element()"/>

    <xsl:variable name="targetOwner"
                  as="element()">
      <xsl:choose>
        <xsl:when test="count($target/ancestor-or-self::s:Section) > 0">
          <xsl:sequence select="$target/ancestor-or-self::s:Section[1]"/>
        </xsl:when>
        <xsl:when test="count($target/ancestor-or-self::s:Document) > 0">
          <xsl:sequence select="$target/ancestor-or-self::s:Document[1]"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat(generate-id($targetOwner), '.xhtml')"/>
  </xsl:template>

  <xdoc:doc>
    An override of the anchorOf function that works for multi-page XHTML files.
  </xdoc:doc>

  <xsl:template name="xstructural.links.anchorOf"
                as="xsd:string">
    <xsl:param name="target"
               as="element()"/>

    <xsl:message select="concat('anchorOf: ', local-name($target))"/>

    <xsl:variable name="owningFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="$target/ancestor-or-self::s:Section[1]">
          <xsl:variable name="owningSection"
                        as="element()">
            <xsl:sequence select="$target/ancestor-or-self::s:Section[1]"/>
          </xsl:variable>
          <xsl:value-of select="concat(generate-id($owningSection),'.xhtml')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

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

    <xsl:variable name="file"
                  as="xsd:string"
                  select="concat($xstructural.outputDirectory,'/index-m.xhtml')"/>

    <xsl:message select="concat('create ', $file)"/>

    <xsl:result-document href="{$file}"
                         doctype-public="-//W3C//DTD XHTML 1.1//EN"
                         doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
                         exclude-result-prefixes="#all"
                         method="xhtml"
                         include-content-type="no"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en">
        <head>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>
          <meta name="viewport"
                content="width=device-width, initial-scale=1.0"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <xsl:apply-templates select="s:Metadata"
                               mode="xstructural.metadata.header"/>
          <title>
            <xsl:value-of select="s:Metadata/dc:title"/>
          </title>
        </head>
        <body>
          <xsl:apply-templates select="s:Metadata/*"
                               mode="xstructural.web.branding.header"/>

          <xsl:apply-templates select="."
                               mode="xstructural.navigation.header"/>

          <div class="stMain">
            <xsl:apply-templates select="."
                                 mode="xstructural.titleElement"/>

            <xsl:apply-templates select="s:Metadata"
                                 mode="xstructural.metadata.table"/>

            <xsl:apply-templates select="."
                                 mode="xstructural.tableOfContentsOptional">
              <xsl:with-param name="withTitle"
                              select="true()"/>
            </xsl:apply-templates>

            <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                                 mode="xstructural.blocks"/>

            <xsl:call-template name="xstructural.blocks.footnotesOptional"/>
          </div>

          <xsl:apply-templates select="."
                               mode="xstructural.navigation.footer"/>

          <xsl:apply-templates select="s:Metadata/*"
                               mode="xstructural.web.branding.footer"/>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>