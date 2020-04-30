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
             as="xs:string"
             required="true"/>

  <xsl:param name="branding"
             as="xs:anyURI?"
             required="false"/>

  <xsl:param name="indexFile"
             select="'index-m.xhtml'"
             as="xs:string"
             required="false"/>

  <xsl:use-package name="com.io7m.structural.xsl.core"
                   package-version="1.0.0">
    <xsl:override>
      <xsl:function name="sxc:anchorOf"
                    as="xs:string">
        <xsl:param name="node"
                   as="element()"/>

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
        <xsl:variable name="documentTitle"
                      as="xs:string">
          <xsl:value-of select="ancestor::s:Document[1]/s:Metadata/dc:title[1]"/>
        </xsl:variable>

        <xsl:variable name="sectionsPreceding"
                      select="ancestor::s:Document//s:Section[. &lt;&lt; current()]"/>
        <xsl:variable name="sectionsFollowing"
                      select="ancestor::s:Document//s:Section[. &gt;&gt; current()]"/>

        <xsl:variable name="sectionUpNode"
                      select="parent::s:Section"/>
        <xsl:variable name="sectionsPrecedingUp"
                      select="ancestor::s:Document//s:Section[. &lt;&lt; $sectionUpNode]"/>

        <xsl:variable name="sectionPrev"
                      as="element()">
          <xsl:choose>
            <xsl:when test="count($sectionsPreceding) > 0">
              <xsl:sequence select="$sectionsPreceding[last()]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="ancestor::s:Document[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionPrev">$sectionPrev must be present</xsl:assert>

        <xsl:variable name="sectionNext"
                      as="element()">
          <xsl:choose>
            <xsl:when test="count($sectionsFollowing) > 0">
              <xsl:sequence select="$sectionsFollowing[1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="ancestor::s:Document[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionNext">$sectionNext must be present</xsl:assert>

        <xsl:variable name="sectionUp"
                      as="element()">
          <xsl:choose>
            <xsl:when test="$sectionUpNode">
              <xsl:sequence select="$sectionUpNode"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="ancestor::s:Document[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionUp">$sectionUp must be present</xsl:assert>

        <!-- -->
        <!-- Elements for the up file. -->
        <!-- -->

        <xsl:variable name="sectionUpFile"
                      as="xs:string">
          <xsl:choose>
            <xsl:when test="local-name($sectionUp) = 'Document'">
              <xsl:value-of select="$indexFile"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(generate-id($sectionUp),'.xhtml')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>

        <xsl:variable name="sectionUpTitle"
                      as="xs:string">
          <xsl:choose>
            <xsl:when test="local-name($sectionUp) = 'Document'">
              <xsl:value-of select="$sectionUp/s:Metadata/dc:title"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="sectionUpNumber">
                <xsl:call-template name="sxc:sectionNumberTitleOf">
                  <xsl:with-param name="section"
                                  select="$sectionUp"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="concat($sectionUpNumber,'. ',$sectionUp/attribute::title)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

        <!-- -->
        <!-- Elements for the previous file. -->
        <!-- -->

        <xsl:variable name="sectionPrevFile"
                      as="xs:string">
          <xsl:choose>
            <xsl:when test="local-name($sectionPrev) = 'Document'">
              <xsl:value-of select="$indexFile"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(generate-id($sectionPrev),'.xhtml')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionPrevFile">$sectionPrevFile must be non-empty</xsl:assert>

        <xsl:variable name="sectionPrevTitle"
                      as="xs:string">
          <xsl:choose>
            <xsl:when test="local-name($sectionPrev) = 'Document'">
              <xsl:value-of select="$documentTitle"/>
            </xsl:when>
            <xsl:when test="count($sectionsPreceding) > 0">
              <xsl:variable name="sectionPrevNumber"
                            as="xs:string">
                <xsl:call-template name="sxc:sectionNumberTitleOf">
                  <xsl:with-param name="section"
                                  select="$sectionPrev"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="concat($sectionPrevNumber,'. ',$sectionPrev/attribute::title)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$sectionPrev/attribute::title"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionPrevTitle">$sectionPrevTitle must be non-empty</xsl:assert>

        <!-- -->
        <!-- Elements for the next file. -->
        <!-- -->

        <xsl:variable name="sectionNextFile"
                      as="xs:string">
          <xsl:choose>
            <xsl:when test="local-name($sectionNext) = 'Document'">
              <xsl:value-of select="$indexFile"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(generate-id($sectionNext),'.xhtml')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>

        <xsl:variable name="sectionNextTitle"
                      as="xs:string">
          <xsl:choose>
            <xsl:when test="local-name($sectionNext) = 'Document'">
              <xsl:value-of select="$documentTitle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="sectionNextNumber"
                            as="xs:string">
                <xsl:call-template name="sxc:sectionNumberTitleOf">
                  <xsl:with-param name="section"
                                  select="$sectionNext"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="concat($sectionNextNumber,'. ',$sectionNext/attribute::title)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>

        <!-- -->
        <!-- Elements for the current file. -->
        <!-- -->

        <xsl:variable name="sectionCurrFile"
                      as="xs:string">
          <xsl:value-of select="concat(generate-id(),'.xhtml')"/>
        </xsl:variable>
        <xsl:assert test="$sectionCurrFile">$sectionCurrFile must be non-empty</xsl:assert>

        <xsl:variable name="sectionCurrNumber"
                      as="xs:string">
          <xsl:call-template name="sxc:sectionNumberTitleOf">
            <xsl:with-param name="section"
                            select="."/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:assert test="$sectionCurrNumber">$sectionCurrNumber must be non-empty</xsl:assert>

        <xsl:variable name="sectionCurrTitle"
                      as="xs:string">
          <xsl:value-of select="concat($documentTitle,': ',$sectionCurrNumber,'. ',attribute::title)"/>
        </xsl:variable>
        <xsl:assert test="$sectionCurrTitle">$sectionCurrTitle must be non-empty</xsl:assert>

        <!-- -->
        <!-- Start a new file. -->
        <!-- -->

        <xsl:variable name="sectionFilePath"
                      as="xs:string"
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
              <meta name="generator"
                    content="${project.groupId}/${project.version}"/>

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
                <xsl:with-param name="branding"
                                select="$branding"/>
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
                <xsl:variable name="stSectionNumber"
                              as="element()">
                  <xsl:element name="a">
                    <xsl:attribute name="class"
                                   select="'stSectionNumber'"/>
                    <xsl:choose>
                      <xsl:when test="@id">
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat('id_', @id)"/>
                        </xsl:attribute>
                        <xsl:attribute name="href">
                          <xsl:value-of select="concat('#id_', @id)"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:call-template name="sxc:anchorTitleFor">
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
                          <xsl:call-template name="sxc:anchorTitleFor">
                            <xsl:with-param name="node"
                                            select="."/>
                          </xsl:call-template>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="sxc:sectionNumberTitleOf">
                      <xsl:with-param name="section"
                                      select="."/>
                    </xsl:call-template>
                  </xsl:element>
                </xsl:variable>

                <xsl:variable name="stSectionTitle"
                              as="element()">
                  <h1 class="stSectionTitle">
                    <xsl:value-of select="@title"/>
                  </h1>
                </xsl:variable>

                <xsl:call-template name="sxc:standardRegion">
                  <xsl:with-param name="class"
                                  select="'stSectionHeader'"/>
                  <xsl:with-param name="stMarginNode"
                                  select="$stSectionNumber"/>
                  <xsl:with-param name="stContentNode"
                                  select="$stSectionTitle"/>
                </xsl:call-template>

                <xsl:apply-templates select="."
                                     mode="sxc:tableOfContentsOptional"/>

                <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                                     mode="sxc:blockMode"/>
              </div>

              <xsl:call-template name="sxc:footnotesOptional"/>

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
                <xsl:with-param name="branding"
                                select="$branding"/>
              </xsl:call-template>
            </body>
          </html>
        </xsl:result-document>
      </xsl:template>
    </xsl:override>
  </xsl:use-package>

  <xsl:template name="navigationHeader">
    <xsl:param name="sectionNext"
               as="element()"
               required="true"/>
    <xsl:param name="sectionNextFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionNextTitle"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionPrev"
               as="element()"
               required="true"/>
    <xsl:param name="sectionPrevFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionPrevTitle"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionUp"
               as="element()"
               required="true"/>
    <xsl:param name="sectionUpFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionUpTitle"
               as="xs:string"
               required="true"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrev">$sectionPrev must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevFile">$sectionPrevFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevTitle">$sectionPrevTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUp">$sectionUp must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

    <div id="stNavigationHeader">
      <div class="stNavigationHeaderPrevTitle">
        <xsl:value-of select="$sectionPrevTitle"/>
      </div>
      <div class="stNavigationHeaderPrevLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionPrevFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionPrev"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">prev</xsl:attribute>
          Previous
        </xsl:element>
      </div>

      <div class="stNavigationHeaderUpTitle">
        <xsl:value-of select="$sectionUpTitle"/>
      </div>
      <div class="stNavigationHeaderUpLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionUpFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionUp"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">up</xsl:attribute>
          Up
        </xsl:element>
      </div>

      <div class="stNavigationHeaderNextTitle">
        <xsl:value-of select="$sectionNextTitle"/>
      </div>
      <div class="stNavigationHeaderNextLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionNextFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          Next
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="navigationFooter">
    <xsl:param name="sectionNext"
               as="element()"
               required="true"/>
    <xsl:param name="sectionNextFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionNextTitle"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionPrev"
               as="element()"
               required="true"/>
    <xsl:param name="sectionPrevFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionPrevTitle"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionUp"
               as="element()"
               required="true"/>
    <xsl:param name="sectionUpFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionUpTitle"
               as="xs:string"
               required="true"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrev">$sectionPrev must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevFile">$sectionPrevFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevTitle">$sectionPrevTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUp">$sectionUp must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

    <div id="stNavigationFooter">
      <div class="stNavigationFooterPrevTitle">
        <xsl:value-of select="$sectionPrevTitle"/>
      </div>
      <div class="stNavigationFooterPrevLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionPrevFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionPrev"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">prev</xsl:attribute>
          Previous
        </xsl:element>
      </div>

      <div class="stNavigationFooterUpTitle">
        <xsl:value-of select="$sectionUpTitle"/>
      </div>
      <div class="stNavigationFooterUpLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionUpFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionUp"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">up</xsl:attribute>
          Up
        </xsl:element>
      </div>

      <div class="stNavigationFooterNextTitle">
        <xsl:value-of select="$sectionNextTitle"/>
      </div>
      <div class="stNavigationFooterNextLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionNextFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          Next
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="navigationHeaderFrontPage">
    <xsl:param name="sectionNext"
               as="element()"
               required="true"/>
    <xsl:param name="sectionNextFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionNextTitle"
               as="xs:string"
               required="true"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>

    <div id="stNavigationHeader">
      <div class="stNavigationHeaderPrevTitle">
        <xsl:comment>No previous title.</xsl:comment>
      </div>
      <div class="stNavigationHeaderPrevLink">
        <xsl:comment>No previous link.</xsl:comment>
      </div>

      <div class="stNavigationHeaderUpTitle">
        <xsl:comment>No upwards title.</xsl:comment>
      </div>
      <div class="stNavigationHeaderUpLink">
        <xsl:comment>No upwards link.</xsl:comment>
      </div>

      <div class="stNavigationHeaderNextTitle">
        <xsl:value-of select="$sectionNextTitle"/>
      </div>
      <div class="stNavigationHeaderNextLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionNextFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          Next
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="navigationFooterFrontPage">
    <xsl:param name="sectionNext"
               as="element()"
               required="true"/>
    <xsl:param name="sectionNextFile"
               as="xs:string"
               required="true"/>
    <xsl:param name="sectionNextTitle"
               as="xs:string"
               required="true"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>

    <div id="stNavigationFooter">
      <div class="stNavigationFooterPrevTitle">
        <xsl:comment>No previous title.</xsl:comment>
      </div>
      <div class="stNavigationFooterPrevLink">
        <xsl:comment>No previous link.</xsl:comment>
      </div>

      <div class="stNavigationFooterUpTitle">
        <xsl:comment>No upwards title.</xsl:comment>
      </div>
      <div class="stNavigationFooterUpLink">
        <xsl:comment>No upwards link.</xsl:comment>
      </div>

      <div class="stNavigationFooterNextTitle">
        <xsl:value-of select="$sectionNextTitle"/>
      </div>
      <div class="stNavigationFooterNextLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionNextFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="sxc:anchorTitleFor">
              <xsl:with-param name="node"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          Next
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="s:Document">
    <xsl:variable name="documentFilePath"
                  as="xs:string"
                  select="concat($outputDirectory,'/',$indexFile)"/>

    <xsl:result-document href="{$documentFilePath}"
                         doctype-public="-//W3C//DTD XHTML 1.1//EN"
                         exclude-result-prefixes="#all"
                         indent="true"
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

          <xsl:apply-templates select="s:Metadata/*"
                               mode="sxc:metadataHeader"/>

          <title>
            <xsl:value-of select="s:Metadata/dc:title"/>
          </title>
        </head>
        <body>
          <xsl:call-template name="sxc:brandingHeader">
            <xsl:with-param name="branding"
                            select="$branding"/>
          </xsl:call-template>

          <xsl:if test="count(s:Section) > 0">
            <xsl:call-template name="navigationHeaderFrontPage">
              <xsl:with-param name="sectionNext"
                              select="s:Section[1]"/>
              <xsl:with-param name="sectionNextTitle">
                <xsl:call-template name="sxc:displayTitleFor">
                  <xsl:with-param name="node"
                                  select="s:Section[1]"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="sectionNextFile">
                <xsl:value-of select="concat(generate-id(s:Section[1]),'.xhtml')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <div id="stMain">
            <xsl:comment>Main Content</xsl:comment>

            <xsl:call-template name="sxc:standardRegion">
              <xsl:with-param name="class"
                              select="'stDocumentHeader'"/>
              <xsl:with-param name="stMarginNode">
                <xsl:comment>Margin</xsl:comment>
              </xsl:with-param>
              <xsl:with-param name="stContentNode">
                <h1 class="stDocumentHeaderTitle">
                  <xsl:value-of select="s:Metadata/dc:title"/>
                </h1>
                <table class="stMetadataTable">
                  <xsl:apply-templates select="s:Metadata/*"
                                       mode="sxc:metadataFrontMatter"/>
                </table>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="sxc:standardRegion">
              <xsl:with-param name="class"
                              select="'stTableOfContents'"/>
              <xsl:with-param name="stMarginNode">
                <xsl:comment>Margin</xsl:comment>
              </xsl:with-param>
              <xsl:with-param name="stContentNode">
                <xsl:choose>
                  <xsl:when test="count(s:Section) > 0">
                    <xsl:apply-templates select="s:Section"
                                         mode="sxc:tableOfContents">
                      <xsl:with-param name="depthMaximum"
                                      select="9999"/>
                      <xsl:with-param name="depthCurrent"
                                      select="0"/>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="count(s:Subsection) > 0">
                    <xsl:apply-templates select="s:Subsection"
                                         mode="sxc:tableOfContents">
                      <xsl:with-param name="depthMaximum"
                                      select="9999"/>
                      <xsl:with-param name="depthCurrent"
                                      select="0"/>
                    </xsl:apply-templates>
                  </xsl:when>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:if test="count(s:Section) = 0">
              <xsl:apply-templates select="s:Subsection"
                                   mode="sxc:blockMode"/>
            </xsl:if>
          </div>

          <xsl:if test="count(s:Section) = 0">
            <xsl:call-template name="sxc:footnotesOptional"/>
          </xsl:if>

          <xsl:if test="count(s:Section) > 0">
            <xsl:call-template name="navigationFooterFrontPage">
              <xsl:with-param name="sectionNext"
                              select="s:Section[1]"/>
              <xsl:with-param name="sectionNextTitle">
                <xsl:call-template name="sxc:displayTitleFor">
                  <xsl:with-param name="node"
                                  select="s:Section[1]"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="sectionNextFile">
                <xsl:value-of select="concat(generate-id(s:Section[1]),'.xhtml')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <xsl:call-template name="sxc:brandingFooter">
            <xsl:with-param name="branding"
                            select="$branding"/>
          </xsl:call-template>
        </body>
      </html>
    </xsl:result-document>

    <xsl:for-each select="s:Section">
      <xsl:call-template name="sxc:section"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
