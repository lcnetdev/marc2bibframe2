<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:local="local:"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc local">

  <!--
      Conversion specs for 010-048
  -->

  <xsl:template match="marc:datafield[@tag='010']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Lccn>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
            </bf:Lccn>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='015']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Nbn>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
              <xsl:if test="following-sibling::marc:subfield[position() = 1][@code = 'q']">
                <bf:qualifier><xsl:value-of select="following-sibling::marc:subfield[position() = 1][@code = 'q']"/></bf:qualifier>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='2']">
                <bf:source>
                  <bf:Source>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Source>
                </bf:source>
              </xsl:for-each>
            </bf:Nbn>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='016']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Nban>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="../@ind1 = ' '">
                  <bf:source>
                    <bf:Source>
                      <rdfs:label>Library and Archives Canada</rdfs:label>
                    </bf:Source>
                  </bf:source>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../marc:subfield[@code='2']">
                    <bf:source>
                      <bf:Source>
                        <rdfs:label><xsl:value-of select="."/></rdfs:label>
                      </bf:Source>
                    </bf:source>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </bf:Nban>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
