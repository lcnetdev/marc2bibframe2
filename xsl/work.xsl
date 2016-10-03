<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Templates for building a BIBFRAME 2.0 Work Resource from MARCXML
      All templates should have the mode "work"
  -->
  
  <xsl:template match="marc:record" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>work</xsl:attribute>
          <xsl:apply-templates mode="work">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          <bf:hasInstance>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>instance</xsl:attribute>
          </bf:hasInstance>
        </bf:Work>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="@ind1 = 1">
      <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title245</xsl:attribute>
            </bf:title>
            <xsl:for-each select="marc:subfield[@code='f' or @code='g']">
              <bf:originDate><xsl:value-of select="."/></bf:originDate>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='h']">
              <bf:genreForm>
                <bf:GenreForm>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='s']">
              <bf:version><xsl:value-of select="."/></bf:version>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="work"/>

</xsl:stylesheet>
