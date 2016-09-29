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

    <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:title>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title245</xsl:attribute>
          </bf:title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

    <xsl:apply-templates mode="work245">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='f' or @code='g']" mode="work245">
    <xsl:param name="serialization" select="'rdfxml'"/>

    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:originDate><xsl:value-of select="."/></bf:originDate>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='h']" mode="work245">
    <xsl:param name="serialization" select="'rdfxml'"/>

    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:genreForm>
          <bf:GenreForm>
            <rdfs:label><xsl:value-of select="."/></rdfs:label>
          </bf:GenreForm>
        </bf:genreForm>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='p']" mode="work245">
    <xsl:param name="serialization" select="'rdfxml'"/>

    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:version><xsl:value-of select="."/></bf:version>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
        
  <xsl:template match="text()" mode="work245"/>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="work"/>

</xsl:stylesheet>
