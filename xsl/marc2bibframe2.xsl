<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="baseuri" select="'http://example.org/'"/>

  <xsl:include href="validate.xsl"/>
  <xsl:include href="work.xsl"/>
  <xsl:include href="instance.xsl"/>

  <xsl:template match="/">

    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
             xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
             xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
             xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/">

      <xsl:apply-templates/>
      
    </rdf:RDF>
    
  </xsl:template>

  <xsl:template match="marc:collection">

    <xsl:apply-templates/>

  </xsl:template>

  <xsl:template match="marc:record[@type='Bibliographic' or not(@type)]">

    <xsl:variable name="validation_error">
      <xsl:call-template name="validate"/>
    </xsl:variable>

    <xsl:choose>

      <xsl:when test="$validation_error = ''">

        <bf:Work>
          <xsl:attribute name="rdf:about">
            <xsl:value-of select="$baseuri"/><xsl:value-of select="marc:controlfield[@tag='001']"/>
          </xsl:attribute>

          <xsl:apply-templates mode="work">
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          
        </bf:Work>

        <bf:Instance>
          <xsl:apply-templates mode="instance">
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
        </bf:Instance>

      </xsl:when>

      <xsl:otherwise>

        <!-- put a useful comment in the RDF/XML output -->
        <xsl:comment><xsl:value-of select="$validation_error"/></xsl:comment>


      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>

  <!-- warn about other elements -->
  <xsl:template match="*">

    <xsl:message terminate="no">
      WARNING: Unmatched element: <xsl:value-of select="name()"/>
    </xsl:message>

    <xsl:apply-templates/>

  </xsl:template>

</xsl:stylesheet>
