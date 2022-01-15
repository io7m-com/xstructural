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
                xmlns:s="urn:com.io7m.structural:7:0"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="xstructural7-links.xsl"/>
  <xsl:import href="xstructural7-outputs.xsl"/>
  <xsl:import href="xstructural7-text.xsl"/>

  <xdoc:doc>
    Generate a navigation table at the top of the document.
  </xdoc:doc>

  <xsl:template name="xstructural.navigation.header"
                as="element()">

    <xsl:param name="sectionNext"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionNextFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionNextTitle"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionPrev"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionPrevFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionPrevTitle"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionUp"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionUpFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionUpTitle"
               as="xsd:string"
               required="yes"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrev">$sectionPrev must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevFile">$sectionPrevFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevTitle">$sectionPrevTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUp">$sectionUp must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

    <div class="stNavigationHeader">
      <div class="stNavigationHeaderPrevTitle">
        <xsl:value-of select="$sectionPrevTitle"/>
      </div>

      <div class="stNavigationHeaderPrevLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionPrevFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionPrev"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">prev</xsl:attribute>
          <xsl:text>Previous</xsl:text>
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
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionUp"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">up</xsl:attribute>
          <xsl:text>Up</xsl:text>
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
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          <xsl:text>Next</xsl:text>
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xdoc:doc>
    Generate a navigation table at the bottom of the document.
  </xdoc:doc>

  <xsl:template name="xstructural.navigation.footer"
                as="element()">

    <xsl:param name="sectionNext"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionNextFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionNextTitle"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionPrev"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionPrevFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionPrevTitle"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionUp"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionUpFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionUpTitle"
               as="xsd:string"
               required="yes"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrev">$sectionPrev must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevFile">$sectionPrevFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionPrevTitle">$sectionPrevTitle must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUp">$sectionUp must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

    <div class="stNavigationFooter">
      <div class="stNavigationFooterPrevTitle">
        <xsl:value-of select="$sectionPrevTitle"/>
      </div>

      <div class="stNavigationFooterPrevLink">
        <xsl:element name="a">
          <xsl:attribute name="href"
                         select="$sectionPrevFile"/>
          <xsl:attribute name="title">
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionPrev"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">prev</xsl:attribute>
          <xsl:text>Previous</xsl:text>
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
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionUp"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">up</xsl:attribute>
          <xsl:text>Up</xsl:text>
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
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          <xsl:text>Next</xsl:text>
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xdoc:doc>
    Generate a navigation table at the top of the document for the front page.
  </xdoc:doc>

  <xsl:template name="xstructural.navigation.header.frontPage"
                as="element()">

    <xsl:param name="sectionNext"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionNextFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionNextTitle"
               as="xsd:string"
               required="yes"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>

    <div class="stNavigationHeader">
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
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          <xsl:text>Next</xsl:text>
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xstructural.navigation.footer.frontPage"
                as="element()">

    <xsl:param name="sectionNext"
               as="element()"
               required="yes"/>
    <xsl:param name="sectionNextFile"
               as="xsd:string"
               required="yes"/>
    <xsl:param name="sectionNextTitle"
               as="xsd:string"
               required="yes"/>

    <xsl:assert test="$sectionNext">$sectionNext must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextFile">$sectionNextFile must be non-empty</xsl:assert>
    <xsl:assert test="$sectionNextTitle">$sectionNextTitle must be non-empty</xsl:assert>

    <div class="stNavigationFooter">
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
            <xsl:call-template name="xstructural.links.anchorOf">
              <xsl:with-param name="target"
                              select="$sectionNext"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">next</xsl:attribute>
          <xsl:text>Next</xsl:text>
        </xsl:element>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="s:Document"
                mode="xstructural.navigation.header"
                as="element()?">

    <xsl:if test="count(s:Section) > 0">
      <xsl:call-template name="xstructural.navigation.header.frontPage">
        <xsl:with-param name="sectionNext"
                        select="s:Section[1]"/>
        <xsl:with-param name="sectionNextTitle">
          <xsl:apply-templates mode="xstructural.titleText"
                               select="s:Section[1]"/>
        </xsl:with-param>
        <xsl:with-param name="sectionNextFile">
          <xsl:value-of select="concat(generate-id(s:Section[1]),'.xhtml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="s:Document"
                mode="xstructural.navigation.footer"
                as="element()?">

    <xsl:if test="count(s:Section) > 0">
      <xsl:call-template name="xstructural.navigation.footer.frontPage">
        <xsl:with-param name="sectionNext"
                        select="s:Section[1]"/>
        <xsl:with-param name="sectionNextTitle">
          <xsl:apply-templates mode="xstructural.titleText"
                               select="s:Section[1]"/>
        </xsl:with-param>
        <xsl:with-param name="sectionNextFile">
          <xsl:value-of select="concat(generate-id(s:Section[1]),'.xhtml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="s:Section"
                mode="xstructural.navigation.header"
                as="element()">

    <xsl:variable name="documentOwning"
                  as="element()"
                  select="ancestor::s:Document"/>

    <xsl:variable name="sectionsPreceding"
                  as="element()*"
                  select="$documentOwning//s:Section[. &lt;&lt; current()]"/>
    <xsl:variable name="sectionsFollowing"
                  as="element()*"
                  select="$documentOwning//s:Section[. &gt;&gt; current()]"/>
    <xsl:variable name="sectionUpNode"
                  as="element()?"
                  select="parent::s:Section"/>
    <xsl:variable name="sectionsPrecedingUp"
                  as="element()*"
                  select="$documentOwning//s:Section[. &lt;&lt; $sectionUpNode]"/>

    <xsl:variable name="sectionPrev"
                  as="element()">
      <xsl:choose>
        <xsl:when test="count($sectionsPreceding) > 0">
          <xsl:sequence select="$sectionsPreceding[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$documentOwning"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionNext"
                  as="element()">
      <xsl:choose>
        <xsl:when test="count($sectionsFollowing) > 0">
          <xsl:sequence select="$sectionsFollowing[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$documentOwning"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionUp"
                  as="element()">
      <xsl:choose>
        <xsl:when test="$sectionUpNode">
          <xsl:sequence select="$sectionUpNode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$documentOwning"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--                           -->
    <!-- Elements for the up file. -->
    <!--                           -->

    <xsl:variable name="sectionUpFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionUp) = 'Document'">
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(generate-id($sectionUp),'.xhtml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>

    <xsl:variable name="sectionUpTitle"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionUp) = 'Document'">
          <xsl:value-of select="'Front Matter'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="xstructural.titleText"
                               select="$sectionUp"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

    <!--                                 -->
    <!-- Elements for the previous file. -->
    <!--                                 -->

    <xsl:variable name="sectionPrevFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionPrev) = 'Document'">
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(generate-id($sectionPrev),'.xhtml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionPrevTitle"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionPrev) = 'Document'">
          <xsl:value-of select="'Front Matter'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="xstructural.titleText"
                               select="$sectionPrev"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--                             -->
    <!-- Elements for the next file. -->
    <!--                             -->

    <xsl:variable name="sectionNextFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionNext) = 'Document'">
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(generate-id($sectionNext),'.xhtml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionNextTitle"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionNext) = 'Document'">
          <xsl:value-of select="'Front Matter'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="xstructural.titleText"
                               select="$sectionNext"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="xstructural.navigation.header">
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
  </xsl:template>

  <xsl:template match="s:Section"
                mode="xstructural.navigation.footer"
                as="element()">

    <xsl:variable name="documentOwning"
                  as="element()"
                  select="ancestor::s:Document"/>

    <xsl:variable name="sectionsPreceding"
                  as="element()*"
                  select="$documentOwning//s:Section[. &lt;&lt; current()]"/>
    <xsl:variable name="sectionsFollowing"
                  as="element()*"
                  select="$documentOwning//s:Section[. &gt;&gt; current()]"/>
    <xsl:variable name="sectionUpNode"
                  as="element()?"
                  select="parent::s:Section"/>
    <xsl:variable name="sectionsPrecedingUp"
                  as="element()*"
                  select="$documentOwning//s:Section[. &lt;&lt; $sectionUpNode]"/>

    <xsl:variable name="sectionPrev"
                  as="element()">
      <xsl:choose>
        <xsl:when test="count($sectionsPreceding) > 0">
          <xsl:sequence select="$sectionsPreceding[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$documentOwning"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionNext"
                  as="element()">
      <xsl:choose>
        <xsl:when test="count($sectionsFollowing) > 0">
          <xsl:sequence select="$sectionsFollowing[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$documentOwning"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionUp"
                  as="element()">
      <xsl:choose>
        <xsl:when test="$sectionUpNode">
          <xsl:sequence select="$sectionUpNode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$documentOwning"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--                           -->
    <!-- Elements for the up file. -->
    <!--                           -->

    <xsl:variable name="sectionUpFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionUp) = 'Document'">
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(generate-id($sectionUp),'.xhtml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:assert test="$sectionUpFile">$sectionUpFile must be non-empty</xsl:assert>

    <xsl:variable name="sectionUpTitle"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionUp) = 'Document'">
          <xsl:value-of select="'Front Matter'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="xstructural.titleText"
                               select="$sectionUp"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:assert test="$sectionUpTitle">$sectionUpTitle must be non-empty</xsl:assert>

    <!--                                 -->
    <!-- Elements for the previous file. -->
    <!--                                 -->

    <xsl:variable name="sectionPrevFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionPrev) = 'Document'">
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(generate-id($sectionPrev),'.xhtml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionPrevTitle"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionPrev) = 'Document'">
          <xsl:value-of select="'Front Matter'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="xstructural.titleText"
                               select="$sectionPrev"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--                             -->
    <!-- Elements for the next file. -->
    <!--                             -->

    <xsl:variable name="sectionNextFile"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionNext) = 'Document'">
          <xsl:value-of select="$xstructural.web.indexMulti"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(generate-id($sectionNext),'.xhtml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sectionNextTitle"
                  as="xsd:string">
      <xsl:choose>
        <xsl:when test="local-name($sectionNext) = 'Document'">
          <xsl:value-of select="'Front Matter'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="xstructural.titleText"
                               select="$sectionNext"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="xstructural.navigation.footer">
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
  </xsl:template>

</xsl:stylesheet>