<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

  <xsl:template match="/">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:bf="http://bibframe.org/vocab/" xmlns:bf2="http://bibframe.org/vocab2/" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:relators="http://id.loc.gov/vocabulary/relators/">

      <xsl:apply-templates />

    </rdf:RDF>
  </xsl:template>

  <xsl:template match="marc:record" />

  <!-- consume other elements -->
  <xsl:template match="*"/>

</xsl:stylesheet>
