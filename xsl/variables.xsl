<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- constants for marc2bibframe2.xsl -->

  <!-- Current marc2bibframe2 version -->
  <xsl:variable name="vCurrentVersion">v1.8.0-SNAPSHOT</xsl:variable>

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
  <xsl:variable name="nametitleschemes">http://id.loc.gov/vocabulary/nameTitleSchemes/</xsl:variable>
  <xsl:variable name="musiccodeschemes">http://id.loc.gov/vocabulary/musiccodeschemes/</xsl:variable>
  <xsl:variable name="classG">http://id.loc.gov/authorities/classification/G</xsl:variable>
  <xsl:variable name="msupplcont">http://id.loc.gov/vocabulary/msupplcont/</xsl:variable>
  <xsl:variable name="mstatus">http://id.loc.gov/vocabulary/mstatus/</xsl:variable>

  <!-- for upper- and lower-case translation (ASCII only) -->
  <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  

  <!-- configuration files -->

  <!-- subject thesaurus map -->
  <xsl:variable name="subjectThesaurus" select="document('conf/subjectThesaurus.xml')"/>

  <!-- language/script maps -->
  <xsl:variable name="languageMap" select="document('conf/languageCrosswalk.xml')"/>
  <xsl:variable name="scriptMap" select="document('conf/scriptCrosswalk.xml')"/>

  <!-- code maps -->
  <xsl:variable name="codeMaps" select="document('conf/codeMaps.xml')"/>

  <!-- 880 processing -->
  <xsl:variable name="map880" select="document('conf/map880.xml')"/>

  <!-- abbreviations for punctuation processing -->
  <xsl:variable name="abbreviations" select="document('conf/abbreviations.xml')"/>
  
</xsl:stylesheet>
