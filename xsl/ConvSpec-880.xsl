<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for handling 880 fields
  -->

  <xsl:template match="marc:datafield[@tag='880']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'243')">
        <xsl:apply-templates mode="work243" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'245')">
        <xsl:if test="@ind1 = 1 and not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
          <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
          <xsl:apply-templates mode="work245" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='880']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'210')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance210" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'222')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>      
        <xsl:apply-templates mode="instance222" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'242')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>      
        <xsl:apply-templates mode="instance242" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'245')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance245" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'246')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance246" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'247')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance247" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
