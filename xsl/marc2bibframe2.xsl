<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf2="http://bibframe.org/vocab2/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

  <xsl:param name="baseuri" select="'http://example.org/'"/>

  <xsl:include href="work.xsl"/>
  <xsl:include href="instance.xsl"/>

  <xsl:template match="/">

    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
             xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
             xmlns:bf2="http://bibframe.org/vocab2/"
             xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
             xmlns:relators="http://id.loc.gov/vocabulary/relators/">

      <xsl:apply-templates/>
      
    </rdf:RDF>
    
  </xsl:template>

  <xsl:template match="marc:collection">

    <xsl:apply-templates/>

  </xsl:template>

  <xsl:template match="marc:record[@type='Bibliographic' or not(@type)]">

    <bf2:Work>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="$baseuri"/><xsl:value-of select="marc:controlfield[@tag='001']"/>
      </xsl:attribute>

      <xsl:apply-templates mode="work"/>
      
    </bf2:Work>

    <bf2:Instance>
      <xsl:apply-templates mode="instance"/>
    </bf2:Instance>

  </xsl:template>

  <!-- warn about other elements -->
  <xsl:template match="*">

    <xsl:message terminate="no">
      WARNING: Unmatched element: <xsl:value-of select="name()"/>
    </xsl:message>

    <xsl:apply-templates/>

  </xsl:template>

</xsl:stylesheet>
