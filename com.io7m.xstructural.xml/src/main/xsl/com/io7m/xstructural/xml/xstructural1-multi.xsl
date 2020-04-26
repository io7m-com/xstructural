<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sxc="urn:com.io7m.structural.xsl.core"
                version="3.0">

  <xsl:param name="outputDirectory"
             required="true"/>
  <xsl:param name="branding"
             required="false"/>

  <xsl:use-package name="com.io7m.structural.xsl.core"
                   package-version="1.0.0">
    <xsl:override>
      <xsl:function name="sxc:anchorOf"
                    as="xs:string">
        <xsl:param name="node"/>

        <xsl:variable name="owningSection"
                      select="$node/ancestor-or-self::s:Section[1]"/>
        <xsl:variable name="owningFile"
                      select="concat(generate-id($owningSection),'.xhtml')"/>

        <xsl:choose>
          <xsl:when test="$node/attribute::id">
            <xsl:value-of select="concat($owningFile,'#id_',$node/attribute::id[1])"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($owningFile,'#',generate-id($node))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:function>

      <xsl:template name="sxc:section">
        <xsl:variable name="documentTitle">
          <xsl:choose>
            <xsl:when test="ancestor::s:Document/s:Metadata/dc:title">
              <xsl:value-of select="concat(ancestor::s:Document/s:Metadata/dc:title[1],': ')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="sectionsPreceding"
                      select="ancestor::s:Document//s:Section[. &lt;&lt; current()]"/>
        <xsl:variable name="sectionsFollowing"
                      select="ancestor::s:Document//s:Section[. &gt;&gt; current()]"/>
        <xsl:variable name="sectionUp"
                      select="parent::s:Section"/>
        <xsl:variable name="sectionsPrecedingUp"
                      select="ancestor::s:Document//s:Section[. &lt;&lt; $sectionUp]"/>
        <xsl:variable name="sectionPrev"
                      select="$sectionsPreceding[last()]"/>
        <xsl:variable name="sectionNext"
                      select="$sectionsFollowing[1]"/>

        <!-- -->
        <!-- Elements for the up file. -->
        <!-- -->

        <xsl:variable name="sectionUpFile">
          <xsl:choose>
            <xsl:when test="$sectionUp">
              <xsl:value-of select="concat(generate-id($sectionUp),'.xhtml')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sectionUpNumber">
          <xsl:choose>
            <xsl:when test="count($sectionsPrecedingUp) > 0">
              <xsl:call-template name="sxc:sectionNumberTitleOf">
                <xsl:with-param name="section"
                                select="$sectionUp"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sectionUpTitle"
                      select="concat($sectionUpNumber,'. ',$sectionUp/attribute::title)"/>

        <!-- -->
        <!-- Elements for the previous file. -->
        <!-- -->

        <xsl:variable name="sectionPrevFile">
          <xsl:choose>
            <xsl:when test="count($sectionsPreceding) > 0">
              <xsl:value-of select="concat(generate-id($sectionPrev),'.xhtml')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sectionPrevNumber">
          <xsl:choose>
            <xsl:when test="count($sectionsPreceding) > 0">
              <xsl:call-template name="sxc:sectionNumberTitleOf">
                <xsl:with-param name="section"
                                select="$sectionPrev"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sectionPrevTitle"
                      select="concat($sectionPrevNumber,'. ',$sectionPrev/attribute::title)"/>

        <!-- -->
        <!-- Elements for the next file. -->
        <!-- -->

        <xsl:variable name="sectionNextFile">
          <xsl:choose>
            <xsl:when test="count($sectionsFollowing) > 0">
              <xsl:value-of select="concat(generate-id($sectionNext),'.xhtml')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sectionNextNumber">
          <xsl:choose>
            <xsl:when test="count($sectionsFollowing) > 0">
              <xsl:call-template name="sxc:sectionNumberTitleOf">
                <xsl:with-param name="section"
                                select="$sectionNext"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sectionNextTitle"
                      select="concat($sectionNextNumber,'. ',$sectionNext/attribute::title)"/>

        <!-- -->
        <!-- Elements for the current file. -->
        <!-- -->

        <xsl:variable name="sectionCurrFile"
                      select="concat(generate-id(),'.xhtml')"/>
        <xsl:variable name="sectionCurrNumber">
          <xsl:call-template name="sxc:sectionNumberTitleOf">
            <xsl:with-param name="section"
                            select="."/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sectionCurrTitle"
                      select="concat($documentTitle,$sectionCurrNumber,'. ',attribute::title)"/>

        <!-- -->
        <!-- Start a new file. -->
        <!-- -->

        <xsl:variable name="sectionFilePath"
                      select="concat($outputDirectory,'/',$sectionCurrFile)"/>

        <xsl:result-document href="{$sectionFilePath}"
                             doctype-public="-//W3C//DTD XHTML 1.1//EN"
                             exclude-result-prefixes="#all"
                             indent="true"
                             doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
          <xsl:text>&#x000a;</xsl:text>
          <html xml:lang="en">
            <head>
              <meta http-equiv="content-type"
                    content="application/xhtml+xml; charset=utf-8"/>

              <xsl:choose>
                <xsl:when test="string-length($sectionPrevFile)">
                  <link href="{$sectionPrevFile}"
                        rel="prev"/>
                </xsl:when>
              </xsl:choose>

              <xsl:choose>
                <xsl:when test="string-length($sectionNextFile)">
                  <link href="{$sectionNextFile}"
                        rel="next"/>
                </xsl:when>
              </xsl:choose>

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

              <xsl:apply-templates select="ancestor::s:Document[1]/s:Metadata/*"
                                   mode="sxc:metadataHeader"/>

              <title>
                <xsl:value-of select="$sectionCurrTitle"/>
              </title>
            </head>
            <body>
              <xsl:call-template name="sxc:brandingHeader">
                <xsl:with-param name="branding" select="$branding"/>
              </xsl:call-template>

              <xsl:call-template name="navigationHeader">
                <xsl:with-param name="sectionNext"
                                select="$sectionNext"/>
                <xsl:with-param name="sectionNextFile"
                                select="$sectionNextFile"/>
                <xsl:with-param name="sectionNextTitle"
                                select="$sectionNextTitle"/>
                <xsl:with-param name="sectionPrev"
                                select="$sectionPrev"/>
                <xsl:with-param name="sectionPrevFile"
                                select="$sectionPrevFile"/>
                <xsl:with-param name="sectionPrevTitle"
                                select="$sectionPrevTitle"/>
                <xsl:with-param name="sectionUp"
                                select="$sectionUp"/>
                <xsl:with-param name="sectionUpFile"
                                select="$sectionUpFile"/>
                <xsl:with-param name="sectionUpTitle"
                                select="$sectionUpTitle"/>
              </xsl:call-template>

              <div id="stMain">
                <h1 class="stSectionHeader">
                  <span class="stSectionNumber">
                    <xsl:element name="a">
                      <xsl:value-of select="$sectionCurrNumber"/>
                    </xsl:element>
                  </span>
                  <span class="stSectionTitle">
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
                </h1>

                <xsl:apply-templates select="."
                                     mode="sxc:tableOfContentsOptional"/>

                <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                                     mode="sxc:blockMode"/>
              </div>

              <xsl:if test="count(.//s:Footnote) > 0">
                <div id="stFootnotes">
                  <h2>Footnotes</h2>
                  <xsl:apply-templates select="./s:Footnote"
                                       mode="sxc:blockMode"/>
                </div>
              </xsl:if>

              <xsl:call-template name="navigationFooter">
                <xsl:with-param name="sectionNext"
                                select="$sectionNext"/>
                <xsl:with-param name="sectionNextFile"
                                select="$sectionNextFile"/>
                <xsl:with-param name="sectionNextTitle"
                                select="$sectionNextTitle"/>
                <xsl:with-param name="sectionPrev"
                                select="$sectionPrev"/>
                <xsl:with-param name="sectionPrevFile"
                                select="$sectionPrevFile"/>
                <xsl:with-param name="sectionPrevTitle"
                                select="$sectionPrevTitle"/>
                <xsl:with-param name="sectionUp"
                                select="$sectionUp"/>
                <xsl:with-param name="sectionUpFile"
                                select="$sectionUpFile"/>
                <xsl:with-param name="sectionUpTitle"
                                select="$sectionUpTitle"/>
              </xsl:call-template>

              <xsl:call-template name="sxc:brandingFooter">
                <xsl:with-param name="branding" select="$branding"/>
              </xsl:call-template>
            </body>
          </html>
        </xsl:result-document>
      </xsl:template>
    </xsl:override>
  </xsl:use-package>

  <xsl:template name="navigationHeader">
    <xsl:param name="sectionNext"
               required="true"/>
    <xsl:param name="sectionNextFile"
               required="true"/>
    <xsl:param name="sectionNextTitle"
               required="true"/>
    <xsl:param name="sectionPrev"
               required="true"/>
    <xsl:param name="sectionPrevFile"
               required="true"/>
    <xsl:param name="sectionPrevTitle"
               required="true"/>
    <xsl:param name="sectionUp"
               required="true"/>
    <xsl:param name="sectionUpFile"
               required="true"/>
    <xsl:param name="sectionUpTitle"
               required="true"/>

    <div id="stNavigationHeader">
      <xsl:choose>
        <xsl:when test="string-length($sectionPrevFile)">
          <div class="stNavigationHeaderPrevTitle">
            <xsl:value-of select="$sectionPrevTitle"/>
          </div>
          <div class="stNavigationHeaderPrevLink">
            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="$sectionPrevFile"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="$sectionPrev"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="rel">prev</xsl:attribute>
              Previous
            </xsl:element>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="stNavigationHeaderPrevTitle">
            <xsl:comment>No previous title</xsl:comment>
          </div>
          <div class="stNavigationHeaderPrevLink">
            <xsl:comment>No previous link</xsl:comment>
          </div>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="string-length($sectionUpFile)">
          <div class="stNavigationHeaderUpTitle">
            <xsl:value-of select="$sectionUpTitle"/>
          </div>
          <div class="stNavigationHeaderUpLink">
            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="$sectionUpFile"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="$sectionUp"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="rel">up</xsl:attribute>
              Up
            </xsl:element>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="stNavigationHeaderUpTitle">
            <xsl:comment>No up title</xsl:comment>
          </div>
          <div class="stNavigationHeaderUpLink">
            <xsl:comment>No up link</xsl:comment>
          </div>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="string-length($sectionNextFile)">
          <div class="stNavigationHeaderNextTitle">
            <xsl:value-of select="$sectionNextTitle"/>
          </div>
          <div class="stNavigationHeaderNextLink">
            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="$sectionNextFile"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="$sectionNext"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="rel">next</xsl:attribute>
              Next
            </xsl:element>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="stNavigationHeaderNextTitle">
            <xsl:comment>No next title</xsl:comment>
          </div>
          <div class="stNavigationHeaderNextLink">
            <xsl:comment>No next link</xsl:comment>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template name="navigationFooter">
    <xsl:param name="sectionNext"
               required="true"/>
    <xsl:param name="sectionNextFile"
               required="true"/>
    <xsl:param name="sectionNextTitle"
               required="true"/>
    <xsl:param name="sectionPrev"
               required="true"/>
    <xsl:param name="sectionPrevFile"
               required="true"/>
    <xsl:param name="sectionPrevTitle"
               required="true"/>
    <xsl:param name="sectionUp"
               required="true"/>
    <xsl:param name="sectionUpFile"
               required="true"/>
    <xsl:param name="sectionUpTitle"
               required="true"/>

    <div id="stNavigationFooter">
      <xsl:choose>
        <xsl:when test="string-length($sectionPrevFile)">
          <div class="stNavigationFooterPrevTitle">
            <xsl:value-of select="$sectionPrevTitle"/>
          </div>
          <div class="stNavigationFooterPrevLink">
            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="$sectionPrevFile"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="$sectionPrev"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="rel">prev</xsl:attribute>
              Previous
            </xsl:element>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="stNavigationFooterPrevTitle">
            <xsl:comment>No previous title</xsl:comment>
          </div>
          <div class="stNavigationFooterPrevLink">
            <xsl:comment>No previous link</xsl:comment>
          </div>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="string-length($sectionUpFile)">
          <div class="stNavigationFooterUpTitle">
            <xsl:value-of select="$sectionUpTitle"/>
          </div>
          <div class="stNavigationFooterUpLink">
            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="$sectionUpFile"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="$sectionUp"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="rel">up</xsl:attribute>
              Up
            </xsl:element>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="stNavigationFooterUpTitle">
            <xsl:comment>No up title</xsl:comment>
          </div>
          <div class="stNavigationFooterUpLink">
            <xsl:comment>No up link</xsl:comment>
          </div>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="string-length($sectionNextFile)">
          <div class="stNavigationFooterNextTitle">
            <xsl:value-of select="$sectionNextTitle"/>
          </div>
          <div class="stNavigationFooterNextLink">
            <xsl:element name="a">
              <xsl:attribute name="href"
                             select="$sectionNextFile"/>
              <xsl:attribute name="title">
                <xsl:call-template name="sxc:nodeNumberTitleOf">
                  <xsl:with-param name="node"
                                  select="$sectionNext"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="rel">prev</xsl:attribute>
              Next
            </xsl:element>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="stNavigationFooterNextTitle">
            <xsl:comment>No next title</xsl:comment>
          </div>
          <div class="stNavigationFooterNextLink">
            <xsl:comment>No next link</xsl:comment>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="s:Document">
    <xsl:for-each select="s:Section">
      <xsl:call-template name="sxc:section"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
