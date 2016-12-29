<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 3XX -->
  <xsl:template match="marc:datafield[@tag='300']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance300">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='300' or @tag='880']" mode="instance300">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vExtentRaw">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='f' or @code='g']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vExtent">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="$vExtentRaw"/>
        <xsl:with-param name="punctuation"><xsl:text>+:,;/ </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:if test="$vExtent != ''">
          <bf:extent>
            <bf:Extent>
              <rdfs:label><xsl:value-of select="normalize-space($vExtent)"/></rdfs:label>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Extent>
          </bf:extent>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='b' or @code='e']">
          <bf:note>
            <bf:Note>
              <bf:noteType>
                <xsl:choose>
                  <xsl:when test="@code='b'">Physical details</xsl:when>
                  <xsl:when test="@code='e'">Accompanying materials</xsl:when>
                </xsl:choose>
              </bf:noteType>
              <rdfs:label>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                  <xsl:with-param name="punctuation"><xsl:text>+:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:dimensions>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>+:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:dimensions>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='306']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance306">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='306' or @tag='880']" mode="instance306">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:duration><xsl:value-of select="."/></bf:duration>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='310' or @tag='321']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance310">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='310' or @tag='321' or @tag='880']" mode="instance310">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:frequency>
            <bf:Frequency>
              <rdfs:label>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                  <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="../marc:subfield[@code='b']">
                <bf:date><xsl:value-of select="."/></bf:date>
              </xsl:for-each>
            </bf:Frequency>
          </bf:frequency>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
