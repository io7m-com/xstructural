<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:epub="http://www.idpf.org/2007/ops"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sxc="urn:com.io7m.structural.xsl.core"
                version="3.0">

  <xsl:param name="outputDirectory"
             as="xs:string"
             required="true"/>

  <xsl:param name="indexFile"
             select="'index-m.xhtml'"
             as="xs:string"
             required="false"/>

  <xsl:use-package name="com.io7m.structural.xsl.core"
                   package-version="1.0.0">
    <xsl:override>

      <xsl:template match="s:Image"
                    as="element()"
                    mode="sxc:content">
        <xsl:element name="img">
          <xsl:call-template name="sxc:addOptionalClassAttribute">
            <xsl:with-param name="extraTypes"
                            select="'stImage'"/>
          </xsl:call-template>
          <xsl:attribute name="alt">
            <xsl:value-of select="."/>
          </xsl:attribute>
          <xsl:attribute name="src">
            <xsl:value-of select="@source"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:template>

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
        <xsl:assert test="local-name(.) = 'Section'">sxc:section must be called on a Section</xsl:assert>

        <xsl:variable name="documentTitle"
                      as="xs:string">
          <xsl:value-of select="ancestor::s:Document[1]/s:Metadata/dc:title[1]"/>
        </xsl:variable>

        <xsl:variable name="sectionsPreceding"
                      select="ancestor::s:Document//s:Section[. &lt;&lt; current()]"/>
        <xsl:variable name="sectionsFollowing"
                      select="ancestor::s:Document//s:Section[. &gt;&gt; current()]"/>

        <!-- -->
        <!-- Elements for the current file. -->
        <!-- -->

        <xsl:variable name="sectionCurrFile"
                      as="xs:string">
          <xsl:value-of select="concat(generate-id(.),'.xhtml')"/>
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

        <xsl:message>
          <xsl:value-of select="concat('create ', $sectionFilePath)"/>
        </xsl:message>

        <xsl:result-document href="{$sectionFilePath}"
                             exclude-result-prefixes="#all"
                             method="xhtml"
                             include-content-type="no"
                             indent="true">
          <xsl:text>&#x000a;</xsl:text>
          <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
          <xsl:text>&#x000a;</xsl:text>
          <html xml:lang="en">
            <head>
              <meta name="generator"
                    content="${project.groupId}/${project.version}"/>

              <link rel="stylesheet"
                    type="text/css"
                    href="reset.css"/>
              <link rel="stylesheet"
                    type="text/css"
                    href="structural-epub.css"/>
              <link rel="stylesheet"
                    type="text/css"
                    href="document.css"/>

              <title>
                <xsl:value-of select="$sectionCurrTitle"/>
              </title>
            </head>
            <body>
              <div id="stMain">
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
                </xsl:element>

                <xsl:variable name="sectionNumber">
                  <xsl:call-template name="sxc:sectionNumberTitleOf">
                    <xsl:with-param name="section"
                                    select="."/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="sectionTitle">
                  <h1 class="stSectionTitle">
                    <xsl:value-of select="concat($sectionNumber, '. ', @title)"/>
                  </h1>
                </xsl:variable>

                <xsl:call-template name="sxc:standardRegion">
                  <xsl:with-param name="class"
                                  select="'stSectionHeader'"/>
                  <xsl:with-param name="stMarginNode"
                                  select="''"/>
                  <xsl:with-param name="stContentNode"
                                  select="$sectionTitle"/>
                </xsl:call-template>

                <xsl:apply-templates select="."
                                     mode="sxc:tableOfContentsOptional"/>

                <xsl:apply-templates select="s:Section|s:Subsection|s:Paragraph|s:FormalItem"
                                     mode="sxc:blockMode"/>
              </div>

              <xsl:call-template name="sxc:footnotesOptional"/>
            </body>
          </html>
        </xsl:result-document>
      </xsl:template>


      <xsl:template match="s:Subsection"
                    mode="sxc:blockMode">

        <xsl:element name="a">
          <xsl:attribute name="class"
                         select="'stSubsectionNumber'"/>
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
        </xsl:element>

        <xsl:variable name="stSubsectionNumber">
          <xsl:call-template name="sxc:subsectionNumberTitleOf">
            <xsl:with-param name="subsection"
                            select="."/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="stSubsectionTitle"
                      as="element()">
          <h2 class="stSubsectionTitle">
            <xsl:value-of select="concat($stSubsectionNumber, '. ', @title)"/>
          </h2>
        </xsl:variable>

        <xsl:call-template name="sxc:standardRegion">
          <xsl:with-param name="class"
                          select="'stSubsectionHeader'"/>
          <xsl:with-param name="stMarginNode"
                          select="''"/>
          <xsl:with-param name="stContentNode"
                          select="$stSubsectionTitle"/>
        </xsl:call-template>

        <xsl:apply-templates select="s:Subsection|s:Paragraph|s:FormalItem"
                             mode="sxc:blockMode"/>
      </xsl:template>
    </xsl:override>
  </xsl:use-package>

  <xsl:output method="text"
              indent="no"
              name="textOutput"/>

  <xsl:template match="s:Document">
    <xsl:for-each select="s:Section">
      <xsl:call-template name="sxc:section"/>
    </xsl:for-each>

    <xsl:call-template name="document-cover"/>
    <xsl:call-template name="document-colophon"/>
    <xsl:call-template name="document-toc"/>
    <xsl:call-template name="document-resources"/>
  </xsl:template>

  <xd:doc>
    Generate a cover page for the document.
  </xd:doc>

  <xsl:template name="document-cover">
    <xsl:variable name="coverFilePath"
                  as="xs:string"
                  select="concat($outputDirectory,'/cover.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $coverFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$coverFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en">
        <head>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural-epub.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <title>
            <xsl:value-of select="s:Metadata/dc:title"/>
          </title>
        </head>
        <body>
          <div>
            <h1><xsl:value-of select="s:Metadata/dc:title"/></h1>
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xd:doc>
    Generate a colophon page for the document.
  </xd:doc>

  <xsl:template name="document-colophon">
    <xsl:variable name="colophonFilePath"
                  as="xs:string"
                  select="concat($outputDirectory,'/colophon.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $colophonFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$colophonFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en">
        <head>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural-epub.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <title>
            <xsl:value-of select="concat(s:Metadata/dc:title, ': Colophon')"/>
          </title>
        </head>
        <body>
          <div>
            <table class="stMetadataTable">
              <xsl:apply-templates select="s:Metadata/*"
                                   mode="sxc:metadataFrontMatter"/>
            </table>
          </div>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xd:doc>
    Generate a list of resources for the document.
  </xd:doc>

  <xsl:template name="document-resources">
    <xsl:variable name="resourcesFilePath"
                  as="xs:string"
                  select="concat($outputDirectory,'/epub-resources.txt')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $resourcesFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$resourcesFilePath}"
                         format="textOutput">
      <xsl:for-each select=".//s:Image">
        <xsl:value-of select="@source"/>
        <xsl:text>&#x000a;</xsl:text>
      </xsl:for-each>
    </xsl:result-document>
  </xsl:template>

  <xd:doc>
    Generate a table of contents for the document.
  </xd:doc>

  <xsl:template name="document-toc">
    <xsl:variable name="tocFilePath"
                  as="xs:string"
                  select="concat($outputDirectory,'/toc.xhtml')"/>

    <xsl:message>
      <xsl:value-of select="concat('create ', $tocFilePath)"/>
    </xsl:message>

    <xsl:result-document href="{$tocFilePath}"
                         exclude-result-prefixes="#all"
                         include-content-type="no"
                         method="xhtml"
                         indent="true">
      <xsl:text>&#x000a;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <xsl:text>&#x000a;</xsl:text>
      <html xml:lang="en"
            xmlns:epub="http://www.idpf.org/2007/ops">
        <head>
          <meta name="generator"
                content="${project.groupId}/${project.version}"/>

          <link rel="stylesheet"
                type="text/css"
                href="reset.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="structural-epub.css"/>
          <link rel="stylesheet"
                type="text/css"
                href="document.css"/>

          <title>
            <xsl:value-of select="concat(s:Metadata/dc:title, ': Table Of Contents')"/>
          </title>
        </head>
        <body>
          <nav epub:type="toc">
            <h2>Table Of Contents</h2>
            <ol epub:type="list">
              <li>
                <a href="cover.xhtml">Cover</a>
              </li>
              <li>
                <a href="colophon.xhtml">Colophon</a>
              </li>
              <li>
                <a href="toc.xhtml">Table Of Contents</a>
              </li>
              <xsl:apply-templates select="s:Section|s:Subsection"
                                   mode="toc"/>
            </ol>
          </nav>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template mode="toc"
                match="s:Section">
    <xsl:variable name="sectionCurrNumber"
                  as="xs:string">
      <xsl:call-template name="sxc:sectionNumberTitleOf">
        <xsl:with-param name="section"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:assert test="$sectionCurrNumber">$sectionCurrNumber must be non-empty</xsl:assert>

    <li>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="sxc:anchorOf(.)"/>
        </xsl:attribute>
        <xsl:value-of select="concat($sectionCurrNumber, '. ', @title)"/>
      </xsl:element>

      <xsl:if test="count(s:Section|s:Subsection) > 0">
        <ol>
          <xsl:apply-templates select="s:Section|s:Subsection"
                               mode="toc"/>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template mode="toc"
                match="s:Subsection">

    <xsl:variable name="subsectionCurrNumber"
                  as="xs:string">
      <xsl:call-template name="sxc:subsectionNumberTitleOf">
        <xsl:with-param name="subsection"
                        select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:assert test="$subsectionCurrNumber">$subsectionCurrNumber must be non-empty</xsl:assert>

    <li>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="sxc:anchorOf(.)"/>
        </xsl:attribute>
        <xsl:value-of select="concat($subsectionCurrNumber, '. ', @title)"/>
      </xsl:element>

      <xsl:if test="count(s:Section|s:Subsection) > 0">
        <ol>
          <xsl:apply-templates select="s:Section|s:Subsection"
                               mode="toc"/>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
