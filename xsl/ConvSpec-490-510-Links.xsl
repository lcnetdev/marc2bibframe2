<?xml version='1.0'  encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 510 - Other linking entries  see process 6 for 490 now -->
  
  
  <xsl:template match="marc:datafield[@tag='510' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='510')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="@ind1='0' or @ind1='1' or @ind1='2'">bflc:indexedIn</xsl:when>
        <xsl:otherwise>bf:references</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vProperty}">
          <bf:Work>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:title>
                <bf:Title>
                  <bf:mainTitle>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </bf:mainTitle>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b' or @code='c']">
              <bf:note>
                <bf:Note>
                  <xsl:choose>
                    <xsl:when test="@code='b'">
                      <rdf:type>
                        <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/coverage</xsl:attribute>
                      </rdf:type>
                    </xsl:when>
                    <xsl:when test="@code='c'">
                      <rdf:type>
                        <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/loc</xsl:attribute>
                      </rdf:type>
                    </xsl:when>
                  </xsl:choose>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='x']">
              <bf:identifiedBy>
                <bf:Issn>
                  <rdf:value>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdf:value>
                </bf:Issn>
              </bf:identifiedBy>
            </xsl:for-each>
          </bf:Work>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
