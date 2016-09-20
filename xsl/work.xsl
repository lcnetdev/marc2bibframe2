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
    <xsl:param name="workid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="entities"/>

    <xsl:choose>
      
      <xsl:when test="$serialization = 'rdfxml'">
        
        <bf:Work>
          <xsl:attribute name="rdf:about">
            <xsl:value-of select="$workid"/>
          </xsl:attribute>

          <xsl:apply-templates mode="work">
            <xsl:with-param name="serialization" select="'rdfxml'"/>
            <xsl:with-param name="entities" select="$entities"/>
          </xsl:apply-templates>

        </bf:Work>

      </xsl:when>

    </xsl:choose>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="work"/>

</xsl:stylesheet>
