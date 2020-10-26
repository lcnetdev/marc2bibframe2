<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:fn="http://www.w3.org/2005/xpath-function"
                extension-element-prefixes="date fn"
                exclude-result-prefixes="xsl marc">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Current marc2bibframe2 version -->
  <xsl:variable name="vCurrentVersion">v1.6.0-SNAPSHOT</xsl:variable>

  <!-- stylesheet parameters -->

  <!-- base for minting URIs -->
  <xsl:param name="baseuri" select="'http://example.org/'"/>

  <!--
      MARC field in which to find the record ID
      Defaults to subfield $a, to use a different subfield,
      add to the end of the tag (e.g. "035a")
  -->
  <xsl:param name="idfield" select="'001'"/>

  <!--
      URI for record source, default none,
      e.g. http://id.loc.gov/vocabulary/organizations/dlc
      To run test of idsource, comment out next line, uncomment
      following line, and uncomment the test in
      test/ConvSpec-001-007.xspec
  -->
  <xsl:param name="idsource"/>
  <!-- <xsl:param name="idsource" select="'http://id.loc.gov/vocabulary/organizations/dlc'"/> -->

  <!--
      Use field conversion for locally defined fields.
      Some fields in the conversion (e.g. 859) are locally defined by
      LoC for conversion. By default these fields will not be
      converted unless this parameter evaluates to true()
  -->
  <xsl:param name="localfields"/>
  
  <!--
      datestamp for generationProcess property of Work adminMetadata
      Useful to override if date:date-time() extension is not
      available
  -->
  <xsl:param name="pGenerationDatestamp">
    <xsl:choose>
      <xsl:when test="function-available('date:date-time')">
        <xsl:value-of select="date:date-time()"/>
      </xsl:when>
      <xsl:when test="function-available('fn:current-dateTime')">
        <xsl:value-of select="fn:current-dateTime()"/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  
  <!-- Output serialization. Currently only "rdfxml" is supported -->
  <xsl:param name="serialization" select="'rdfxml'"/>

  <xsl:include href="utils.xsl"/>
  <xsl:include href="ConvSpec-ControlSubfields.xsl"/>
  <xsl:include href="ConvSpec-LDR.xsl"/>
  <xsl:include href="ConvSpec-001-007.xsl"/>
  <xsl:include href="ConvSpec-006,008.xsl"/>
  <xsl:include href="ConvSpec-010-048.xsl"/>
  <xsl:include href="ConvSpec-050-088.xsl"/>
  <xsl:include href="ConvSpec-1XX,6XX,7XX,8XX-names.xsl"/>
  <xsl:include href="ConvSpec-200-247not240-Titles.xsl"/>
  <xsl:include href="ConvSpec-240andX30-UnifTitle.xsl"/>
  <xsl:include href="ConvSpec-250-270.xsl"/>
  <xsl:include href="ConvSpec-3XX.xsl"/>
  <xsl:include href="ConvSpec-490-510-530to535-Links.xsl"/>
  <xsl:include href="ConvSpec-5XX.xsl"/>
  <xsl:include href="ConvSpec-648-662.xsl"/>
  <xsl:include href="ConvSpec-720+740to755.xsl"/>
  <xsl:include href="ConvSpec-760-788-Links.xsl"/>
  <xsl:include href="ConvSpec-841-887.xsl"/>
  <xsl:include href="ConvSpec-880.xsl"/>
  <xsl:include href="ConvSpec-Process6-Series.xsl"/>

  <!-- namespace URIs -->
  <xsl:variable name="bf">http://id.loc.gov/ontologies/bibframe/</xsl:variable>
  <xsl:variable name="bflc">http://id.loc.gov/ontologies/bflc/</xsl:variable>
  <xsl:variable name="edtf">http://id.loc.gov/datatypes/</xsl:variable>
  <xsl:variable name="madsrdf">http://www.loc.gov/mads/rdf/v1#</xsl:variable>
  <xsl:variable name="xs">http://www.w3.org/2001/XMLSchema#</xsl:variable>

  <!-- id.loc.gov vocabulary stems -->
  <xsl:variable name="carriers">http://id.loc.gov/vocabulary/carriers/</xsl:variable>
  <xsl:variable name="classSchemes">http://id.loc.gov/vocabulary/classSchemes/</xsl:variable>
  <xsl:variable name="contentType">http://id.loc.gov/vocabulary/contentTypes/</xsl:variable>
  <xsl:variable name="countries">http://id.loc.gov/vocabulary/countries/</xsl:variable>
  <xsl:variable name="demographicTerms">http://id.loc.gov/authorities/demographicTerms/</xsl:variable>
  <xsl:variable name="descriptionConventions">http://id.loc.gov/vocabulary/descriptionConventions/</xsl:variable>
  <xsl:variable name="genreForms">http://id.loc.gov/authorities/genreForms/</xsl:variable>
  <xsl:variable name="geographicAreas">http://id.loc.gov/vocabulary/geographicAreas/</xsl:variable>
  <xsl:variable name="graphicMaterials">http://id.loc.gov/vocabulary/graphicMaterials/</xsl:variable>
  <xsl:variable name="issuance">http://id.loc.gov/vocabulary/issuance/</xsl:variable>
  <xsl:variable name="languages">http://id.loc.gov/vocabulary/languages/</xsl:variable>
  <xsl:variable name="marcgt">http://id.loc.gov/vocabulary/marcgt/</xsl:variable>
  <xsl:variable name="mcolor">http://id.loc.gov/vocabulary/mcolor/</xsl:variable>
  <xsl:variable name="mediaType">http://id.loc.gov/vocabulary/mediaTypes/</xsl:variable>
  <xsl:variable name="mmaterial">http://id.loc.gov/vocabulary/mmaterial/</xsl:variable>
  <xsl:variable name="mplayback">http://id.loc.gov/vocabulary/mplayback/</xsl:variable>
  <xsl:variable name="mpolarity">http://id.loc.gov/vocabulary/mpolarity/</xsl:variable>
  <xsl:variable name="marcauthen">http://id.loc.gov/vocabulary/marcauthen/</xsl:variable>
  <xsl:variable name="marcmuscomp">http://id.loc.gov/vocabulary/marcmuscomp/</xsl:variable>
  <xsl:variable name="organizations">http://id.loc.gov/vocabulary/organizations/</xsl:variable>
  <xsl:variable name="relators">http://id.loc.gov/vocabulary/relators/</xsl:variable>
  <xsl:variable name="mproduction">http://id.loc.gov/vocabulary/mproduction/</xsl:variable>
  <xsl:variable name="msoundcontent">http://id.loc.gov/vocabulary/msoundcontent/</xsl:variable>
  <xsl:variable name="mrecmedium">http://id.loc.gov/vocabulary/mrecmedium/</xsl:variable>
  <xsl:variable name="mgeneration">http://id.loc.gov/vocabulary/mgeneration/</xsl:variable>
  <xsl:variable name="mpresformat">http://id.loc.gov/vocabulary/mpresformat/</xsl:variable>
  <xsl:variable name="mmaspect">http://id.loc.gov/vocabulary/maspect/</xsl:variable>
  <xsl:variable name="mrectype">http://id.loc.gov/vocabulary/mrectype/</xsl:variable>
  <xsl:variable name="mspecplayback">http://id.loc.gov/vocabulary/mspecplayback/</xsl:variable>
  <xsl:variable name="mgroove">http://id.loc.gov/vocabulary/mgroove/</xsl:variable>
  <xsl:variable name="mvidformat">http://id.loc.gov/vocabulary/mvidformat/</xsl:variable>
  <xsl:variable name="mbroadstd">http://id.loc.gov/vocabulary/mbroadstd/</xsl:variable>
  <xsl:variable name="mfiletype">http://id.loc.gov/vocabulary/mfiletype/</xsl:variable>
  <xsl:variable name="mregencoding">http://id.loc.gov/vocabulary/mregencoding/</xsl:variable>
  <xsl:variable name="mmusicformat">http://id.loc.gov/vocabulary/mmusicformat/</xsl:variable>
  <xsl:variable name="genreFormSchemes">http://id.loc.gov/vocabulary/genreFormSchemes/</xsl:variable>
  <xsl:variable name="subjectSchemes">http://id.loc.gov/vocabulary/subjectSchemes/</xsl:variable>
  <xsl:variable name="nationalbibschemes">http://id.loc.gov/vocabulary/nationalbibschemes/</xsl:variable>
  <xsl:variable name="fingerprintschemes">http://id.loc.gov/vocabulary/fingerprintschemes/</xsl:variable>
  <xsl:variable name="languageschemes">http://id.loc.gov/vocabulary/languageschemes/</xsl:variable>
  <xsl:variable name="musiccompschemes">http://id.loc.gov/vocabulary/musiccompschemes/</xsl:variable>
  <xsl:variable name="mgovtpubtype">http://id.loc.gov/vocabulary/mgovtpubtype/</xsl:variable>
  <xsl:variable name="mencformat">http://id.loc.gov/vocabulary/mencformat/</xsl:variable>

  <!-- for upper- and lower-case translation (ASCII only) -->
  <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  

  <!-- configuration files -->

  <!-- subject thesaurus map -->
  <xsl:variable name="subjectThesaurus" select="document('conf/subjectThesaurus.xml')"/>

  <!-- language map -->
  <xsl:variable name="languageMap" select="document('conf/languageCrosswalk.xml')"/>

  <!-- code maps -->
  <xsl:variable name="codeMaps" select="document('conf/codeMaps.xml')"/>

  <xsl:template match="/">

    <!-- RDF/XML document frame -->
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                 xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                 xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#">

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

    <xsl:variable name="vInstanceType">
      <xsl:apply-templates mode="instanceType" select="marc:leader"/>
    </xsl:variable>
    
    <!-- generate main Work entity -->
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          <bf:adminMetadata>
            <bf:AdminMetadata>
              <bf:generationProcess>
                <bf:GenerationProcess>
                  <rdfs:label>DLC marc2bibframe2 <xsl:value-of select="$vCurrentVersion"/></rdfs:label>
                  <xsl:if test="$pGenerationDatestamp != ''">
                    <bf:generationDate>
                      <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'dateTime')"/></xsl:attribute>
                      <xsl:value-of select="$pGenerationDatestamp"/>
                    </bf:generationDate>
                  </xsl:if>
                </bf:GenerationProcess>
              </bf:generationProcess>
              <!-- pass fields through conversion specs for AdminMetadata properties -->
              <xsl:apply-templates mode="adminmetadata">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:AdminMetadata>
          </bf:adminMetadata>
          <!-- pass fields through conversion specs for Work properties -->
          <xsl:apply-templates mode="work">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="$serialization"/>
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
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          </bf:instanceOf>
          <!-- generate hasItem properties -->
          <xsl:apply-templates mode="hasItem">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="adminmetadata"/>
  <xsl:template match="text()" mode="work"/>
  <xsl:template match="text()" mode="instance"/>
  <xsl:template match="text()" mode="hasItem"/>

  <!-- warn about other elements -->
  <xsl:template match="*">

    <xsl:message terminate="no">
      <xsl:text>WARNING: Unmatched element: </xsl:text><xsl:value-of select="name()"/>
    </xsl:message>

    <xsl:apply-templates/>

  </xsl:template>

</xsl:stylesheet>
