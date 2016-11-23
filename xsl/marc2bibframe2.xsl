<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="baseuri" select="'http://example.org/'"/>
  <xsl:param name="idfield" select="'001'"/>
  <xsl:param name="serialization" select="'rdfxml'"/>

  <xsl:include href="utils.xsl"/>
  <xsl:include href="ConvSpec-ControlSubfields.xsl"/>
  <xsl:include href="ConvSpec-LDR.xsl"/>
  <xsl:include href="ConvSpec-001-007.xsl"/>
  <xsl:include href="ConvSpec-1XX,6XX,7XX,8XX-names.xsl"/>
  <xsl:include href="ConvSpec-X30and240-UnifTitle.xsl"/>
  <xsl:include href="ConvSpec-200-247not240-Titles.xsl"/>
  <xsl:include href="ConvSpec-880.xsl"/>

  <xsl:variable name="bf">http://id.loc.gov/ontologies/bibframe/</xsl:variable>
  <xsl:variable name="bflc">http://id.loc.gov/ontologies/bibframe/lc-extensions/</xsl:variable>
  <xsl:variable name="xs">http://www.w3.org/2001/XMLSchema#</xsl:variable>
  <xsl:variable name="marcgt">http://id.loc.gov/vocabulary/marcgt/</xsl:variable>
  <xsl:variable name="mcolor">http://id.loc.gov/vocabulary/mcolor/</xsl:variable>
  <xsl:variable name="mmatrial">http://id.loc.gov/vocabulary/mmatrial/</xsl:variable>
  <xsl:variable name="mpolarity">http://id.loc.gov/vocabulary/mpolarity/</xsl:variable>
  <xsl:variable name="carriers">http://id.loc.gov/vocabulary/carriers/</xsl:variable>

  <xsl:template match="/">

    <!-- RDF/XML document frame -->
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                 xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/">

          <xsl:apply-templates>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          
        </rdf:RDF>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="marc:collection">
    <xsl:param name="serialization"/>

    <!-- pass marc:record nodes on down -->
    <xsl:apply-templates>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="marc:record[@type='Bibliographic' or not(@type)]">
    <xsl:param name="serialization"/>

    <xsl:variable name="recordno"><xsl:value-of select="position()"/></xsl:variable>

    <xsl:variable name="recordid">
      <xsl:apply-templates mode="recordid" select=".">
        <xsl:with-param name="baseuri" select="$baseuri"/>
        <xsl:with-param name="idfield" select="$idfield"/>
        <xsl:with-param name="recordno" select="$recordno"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <!-- generate main Work entity -->
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          <bf:adminMetadata>
            <bf:AdminMetadata>
              <!-- pass fields through conversion specs for AdminMetadata properties -->
              <xsl:apply-templates mode="adminmetadata">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:AdminMetadata>
          </bf:adminMetadata>
          <!-- pass fields through conversion specs for Work properties -->
          <xsl:apply-templates mode="work">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          <bf:hasInstance>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
          </bf:hasInstance>
        </bf:Work>
      </xsl:when>
    </xsl:choose>
    
    <!-- generate main Instance entity -->
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Instance>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
          <!-- pass fields through conversion specs for Instance properties -->
          <xsl:apply-templates mode="instance">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          </bf:instanceOf>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="adminmetadata"/>
  <xsl:template match="text()" mode="work"/>
  <xsl:template match="text()" mode="instance"/>

  <!-- warn about other elements -->
  <xsl:template match="*">

    <xsl:message terminate="no">
      <xsl:text>WARNING: Unmatched element: </xsl:text><xsl:value-of select="name()"/>
    </xsl:message>

    <xsl:apply-templates/>

  </xsl:template>

</xsl:stylesheet>
