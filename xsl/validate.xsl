<xsl:stylesheet version="1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      templates for trivial MARC record validation for the purposes
      of BIBFRAME conversion
  -->

  <xsl:template name="validate">
    <!-- output an error string for the first error condition found -->

    <xsl:variable name="current_record" select="position()"/>
    <xsl:choose>

      <!-- tests for 001 -->
      <xsl:when test="count(marc:controlfield[@tag='001']) &lt; 1">No 001 tag in record <xsl:value-of select="$current_record"/></xsl:when>
      <xsl:when test="count(marc:controlfield[@tag='001']) > 1">Multiple 001 tags in record <xsl:value-of select="$current_record"/></xsl:when>

    </xsl:choose>
    
  </xsl:template>
  
</xsl:stylesheet>
