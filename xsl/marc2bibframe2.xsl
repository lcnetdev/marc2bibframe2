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
  <xsl:param name="serialization" select="'rdfxml'"/>

  <xsl:include href="validate.xsl"/>
  <xsl:include href="entities.xsl"/>
  <xsl:include href="work.xsl"/>
  <xsl:include href="instance.xsl"/>

  <xsl:template match="/">

    <!-- RDF/XML document frame -->
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
             xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
             xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
             xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/">

      <xsl:apply-templates/>
      
    </rdf:RDF>
    
  </xsl:template>

  <xsl:template match="marc:collection">

    <!-- pass marc:record nodes on down -->
    <xsl:apply-templates/>

  </xsl:template>

  <xsl:template match="marc:record[@type='Bibliographic' or not(@type)]">

    <!-- Simplistic MARC validation, only for conversion purposes -->
    <xsl:variable name="validation_error">
      <xsl:call-template name="validate"/>
    </xsl:variable>

    <xsl:choose>

      <xsl:when test="$validation_error = ''">

        <xsl:variable name="workid">
          <xsl:value-of select="$baseuri"/><xsl:value-of select="marc:controlfield[@tag='001']"/>
        </xsl:variable>


        <!-- generate entities to be used by Work and Instance -->
        <xsl:variable name="entities">
          <xsl:apply-templates mode="entities">
            <xsl:with-param name="workid" select="$workid"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:copy-of select="$entities"/>
        
        <!-- generate main Work entity -->
        <xsl:apply-templates mode="work" select=".">
          <xsl:with-param name="workid" select="$workid"/>
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="entities" select="$entities"/>
        </xsl:apply-templates>
          
        <!-- generate main Instance entity -->
        <bf:Instance>
          <xsl:apply-templates mode="instance">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Instance>

      </xsl:when>

      <xsl:otherwise>

        <!-- put a somewhat useful comment in the RDF/XML output -->
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
