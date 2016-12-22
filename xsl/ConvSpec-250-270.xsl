<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 250-270 -->

  <xsl:template match="marc:datafield[@tag='250']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance250">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='250' or @tag='880']" mode="instance250">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vEditionStatementRaw">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vEditionStatement">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="$vEditionStatementRaw"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:editionStatement><xsl:value-of select="$vEditionStatement"/></bf:editionStatement>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    
  
</xsl:stylesheet>
