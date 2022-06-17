<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 460-468 - Series treatment -->
  
  <xsl:template match="marc:datafield[@tag='462' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='462')] |
                       marc:datafield[@tag='463' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='463')] |
                       marc:datafield[@tag='464' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='464')] |
                       marc:datafield[@tag='465' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='465')] |
                       marc:datafield[@tag='466' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='466')] |
                       marc:datafield[@tag='467' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='467')] |
                       marc:datafield[@tag='468' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='468')]"
                mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vClass">
      <xsl:choose>
        <xsl:when test="$vTag='462'">bflc:SeriesSequentialDesignation</xsl:when>
        <xsl:when test="$vTag='463'">bflc:SeriesNumberingPeculiarities</xsl:when>
        <xsl:when test="$vTag='464'">bflc:SeriesNumbering</xsl:when>
        <xsl:when test="$vTag='465'">bflc:SeriesProvider</xsl:when>
        <xsl:when test="$vTag='466'">bflc:SeriesAnalysis</xsl:when>
        <xsl:when test="$vTag='467'">bflc:SeriesTracing</xsl:when>
        <xsl:when test="$vTag='468'">bflc:SeriesClassification</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vCode">
      <xsl:if test="$vTag='466' or $vTag='467' or $vTag='468'">
        <xsl:value-of select="marc:subfield[@code='a']"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:choose>
        <!-- no label for 465 -->
        <xsl:when test="$vTag='465'"/>
        <xsl:when test="$vTag='466'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='a']='f'">analyzed in full</xsl:when>
            <xsl:when test="marc:subfield[@code='a']='p'">analyzed in part</xsl:when>
            <xsl:when test="marc:subfield[@code='a']='n'">not analyzed</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='467'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='a']='t'">traced</xsl:when>
            <xsl:when test="marc:subfield[@code='a']='n'">not traced</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='468'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='a']='c'">classed together</xsl:when>
            <xsl:when test="marc:subfield[@code='a']='m'">classed with main or other series</xsl:when>
            <xsl:when test="marc:subfield[@code='a']='s'">classed separately</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="marc:subfield[@code='a']"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vPart"><xsl:value-of select="marc:subfield[@code='d']"/></xsl:variable>
    <xsl:variable name="vSource"><xsl:value-of select="marc:subfield[@code='z']"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bflc:seriesTreatment>
          <xsl:element name="{$vClass}">
            <xsl:if test="$vCode != ''">
              <bf:code><xsl:value-of select="$vCode"/></bf:code>
            </xsl:if>
            <xsl:if test="$vLabel != ''">
              <rdfs:label><xsl:value-of select="$vLabel"/></rdfs:label>
            </xsl:if>
            <xsl:if test="$vTag='465'">
              <xsl:for-each select="marc:subfield[@code='a']">
                <bf:place>
                  <bf:Place>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Place>
                </bf:place>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:agent>
                  <bf:Agent>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Agent>
                </bf:agent>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$vTag='466'">
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:note>
                  <bf:Note>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$vPart != ''">
              <bf:part><xsl:value-of select="$vPart"/></bf:part>
            </xsl:if>
            <xsl:if test="$vTag='462' or $vTag='463'">
              <xsl:for-each select="marc:subfield[@code='z']">
                <bf:source>
                  <bf:Source>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Source>
                </bf:source>
              </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='5']">
              <bflc:applicableInstitution>
                <bf:Agent>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Agent>
              </bflc:applicableInstitution>
            </xsl:for-each>
          </xsl:element>
        </bflc:seriesTreatment>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
