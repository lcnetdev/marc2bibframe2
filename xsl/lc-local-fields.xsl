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
                xmlns:lclocal="http://id.loc.gov/ontologies/lclocal/"
                xmlns:exslt="http://exslt.org/common" 
                exclude-result-prefixes="xsl marc date exslt">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- stylesheet parameters -->

 <!-- enter here any special transforms for tags not dealt with in other conversion spec stylesheets -->
  
  
  <xsl:template match="marc:datafield[@tag='985']" mode="adminmetadata">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="normalizedText">
      <xsl:value-of select="normalize-space(translate(translate(normalize-space(marc:subfield[@code='a' or @code='e'][1]),$upper,$lower),' ',''))"/>
    </xsl:variable>
    <xsl:if test="$localfields and $normalizedText='bibframepilot2'">
      <lclocal:batch>BibframePilot2</lclocal:batch>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='906']" mode="adminmetadata">    
      <xsl:param name="serialization" select="'rdfxml'"/>      
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">                    
          <xsl:call-template name="make-literal">          
              <xsl:with-param name="datafield"><xsl:copy-of select="exslt:node-set(.)"/></xsl:with-param>                        
          </xsl:call-template>          
        </xsl:when>
      </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='925']" mode="adminmetadata">    
    <xsl:param name="serialization" select="'rdfxml'"/>                               
        <xsl:call-template name="make-literal">         
          <xsl:with-param name="datafield"><xsl:copy-of select="exslt:node-set(.)"/></xsl:with-param>                        
        </xsl:call-template>                
  </xsl:template>
  <xsl:template match="marc:datafield[@tag='955']" mode="adminmetadata">             
                        
        <xsl:call-template name="make-literal">          
          <xsl:with-param name="datafield"><xsl:copy-of select="exslt:node-set(.)"/></xsl:with-param>                        
        </xsl:call-template>          
  </xsl:template>
<!--  <lclocal:d906>=906  b a $a 7 $b cbc $c origcop $d 3 $e ncip $f 20 $g y-soundrec</lclocal:d906>-->
    <xsl:template name="make-literal">      
      <xsl:param name="datafield"/>
      <xsl:variable name="el"><xsl:value-of select="concat('lclocal:d',exslt:node-set($datafield)//@tag)"/> </xsl:variable>
      <xsl:variable name="ind1">
        <xsl:choose>
          <xsl:when test="exslt:node-set($datafield)//@ind1=' '">\</xsl:when>
          <xsl:otherwise><xsl:value-of select="exslt:node-set($datafield)//@ind1"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="ind2">
        <xsl:choose>
            <xsl:when test="exslt:node-set($datafield)/@ind2=' '">\</xsl:when>
          <xsl:otherwise><xsl:value-of select="exslt:node-set($datafield)//@ind2"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$el}">=<xsl:value-of select="exslt:node-set($datafield)//@tag"/><xsl:text>  </xsl:text><xsl:value-of select="exslt:node-set($datafield)//@ind1"/><xsl:value-of select="$ind2"/><xsl:for-each select="exslt:node-set($datafield)//marc:subfield"><xsl:text> </xsl:text>$<xsl:value-of select="@code"/><xsl:text> </xsl:text><xsl:value-of select="text()"/></xsl:for-each></xsl:element>      

  </xsl:template>
  <!-- mode="adminmetadata" suppressed by batch-->
  <xsl:template name="marc993" >        
      <bf:status>      
          <bf:Status>
            <rdf:type rdf:resource="https://id.loc.gov/vocabulary/mstatus/supp"></rdf:type>
            <rdfs:label>opac suppressed</rdfs:label>
          </bf:Status>               
      </bf:status>
  </xsl:template>
  <xsl:template match="marc:datafield[@tag='993']" mode="adminmetadata">    
    <xsl:choose><xsl:when test="marc:subfield[@code='a']!=''">
      <xsl:variable name="status">
        <xsl:choose><xsl:when test="marc:subfield[@code='a']='opacsuppress'">https://id.loc.gov/vocabulary/mstatus/supp</xsl:when>
          <xsl:when test="marc:subfield[@code='a']='opacunsuppress'">https://id.loc.gov/vocabulary/mstatus/unsupp</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <bf:status>        
          <bf:Status>
            <rdf:type rdf:resource="{$status}"></rdf:type>
            <rdfs:label>opac suppressed</rdfs:label>
            <xsl:if test="marc:subfield[@code='b']!=''">
              <bflc:catalogerId><xsl:value-of select="marc:subfield[@code='b']"/></bflc:catalogerId>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='c']!=''">
              <bf:qualifier><xsl:value-of select="marc:subfield[@code='c']"/></bf:qualifier>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='d']!=''">
              <bf:date><xsl:value-of select="marc:subfield[@code='d']"/></bf:date>
            </xsl:if>            
            <xsl:if test="marc:subfield[@code='n']!=''">
              <bf:note><bf:Note><rdfs:label><xsl:value-of select="marc:subfield[@code='n']"/></rdfs:label></bf:Note></bf:note>
            </xsl:if>
          </bf:Status>               
      </bf:status>
    </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
