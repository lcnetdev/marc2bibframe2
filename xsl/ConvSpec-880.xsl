<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for handling 880 fields
  -->

  <xsl:template match="marc:datafield[@tag='880']" mode="work880">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:variable name="tag"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$tag='765' or $tag='767' or $tag='770' or $tag='772' or $tag='773' or $tag='774' or $tag='775' or $tag='780' or $tag='785' or $tag='786' or $tag='787'">
        <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates select="." mode="work7XXLinks">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='880']" mode="instance880">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="tag"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:variable>
    <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance880-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$tag='760' or $tag='762'">
        <xsl:apply-templates select="." mode="instance7XXLinks">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='776'">
        <xsl:apply-templates select="." mode="instance776">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='777'">
        <xsl:apply-templates select="." mode="work7XXLinks">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
