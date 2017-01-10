<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 490, 510, 530-535 - Other linking entries -->

  <xsl:template match="marc:datafield[@tag='490']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:seriesStatement>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:seriesStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='v']">
          <bf:seriesEnumeration>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:seriesEnumeration>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='x']">
          <bf:hasSeries>
            <bf:Work>
              <bf:identifiedBy>
                <bf:Issn>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Issn>
              </bf:identifiedBy>
            </bf:Work>
          </bf:hasSeries>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
