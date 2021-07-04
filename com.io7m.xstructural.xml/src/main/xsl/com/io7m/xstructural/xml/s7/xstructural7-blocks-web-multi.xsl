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
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural7-branding.xsl"/>
  <xsl:import href="xstructural7-navigation.xsl"/>
  <xsl:import href="xstructural7-text.xsl"/>

  <xsl:import href="xstructural7-blocks-web.xsl"/>

  <!--                                    -->
  <!-- Web-multi block content overrides. -->
  <!--                                    -->

  <xsl:template match="s:Section"
                mode="xstructural.blocks">

    <xsl:variable name="documentTitle"
                  as="xsd:string"
                  select="ancestor::s:Document/s:Metadata/dc:title"/>

    <xsl:variable name="sectionCurrBaseTitle"
                  as="xsd:string">
      <xsl:apply-templates mode="xstructural.titleText"
                           select="."/>
    </xsl:variable>

    <xsl:variable name="sectionCurrTitle"
                  select="concat($documentTitle, ': ', $sectionCurrBaseTitle)"
                  as="xsd:string"/>

    <xsl:variable name="sectionCurrFile"
                  select="concat(generate-id(.), '.xhtml')"
                  as="xsd:string"/>

    <xsl:variable name="sectionFilePath"
                  select="concat($xstructural.outputDirectory,'/',$sectionCurrFile)"
                  as="xsd:string"/>

    <xsl:result-document href="{$sectionFilePath}"
                         doctype-public="-//W3C//DTD XHTML 1.1//EN"
                         exclude-result-prefixes="#all"
                         indent="true"
                         method="xml"
                         doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en">
        <head>
          <meta http-equiv="content-type"
                content="application/xhtml+xml; charset=utf-8"/>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <link rel="schema.DC"
                href="http://purl.org/dc/elements/1.1/"/>

          <xsl:apply-templates select="ancestor::s:Document/s:Metadata/*"
                               mode="xstructural.metadata.header"/>
          <title>
            <xsl:value-of select="$sectionCurrTitle"/>
          </title>
        </head>
        <body>
          <xsl:apply-templates select="ancestor::s:Document/s:Metadata/*"
                               mode="xstructural.web.branding.header"/>

          <xsl:apply-templates select="."
                               mode="xstructural.navigation.header"/>

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

          <xsl:apply-templates select="."
                               mode="xstructural.navigation.footer"/>

          <xsl:apply-templates select="ancestor::s:Document/s:Metadata/*"
                               mode="xstructural.web.branding.footer"/>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
