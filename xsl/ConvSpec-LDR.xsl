<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for LDR
  -->

  <!-- determine rdf:type for Instance from LDR -->
  <xsl:template match="marc:leader" mode="instanceType">
    <xsl:choose>
      <xsl:when test="substring(.,7,1) = 'd'">Manuscript</xsl:when>
      <xsl:when test="substring(.,7,1) = 'f'">Manuscript</xsl:when>
      <xsl:when test="substring(.,7,1) = 'm'">Electronic</xsl:when>
      <xsl:when test="substring(.,7,1) = 't'">Manuscript</xsl:when>
      <xsl:when test="substring(.,7,1) = 'a' and contains('abims',substring(.,8,1))">Print</xsl:when>
      <xsl:when test="substring(.,8,1) = 'c'">Collection</xsl:when>
      <xsl:when test="substring(.,8,1) = 'd'">Collection</xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:leader" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vStatus" select="substring(.,6,1)"/>
    <xsl:for-each select="$codeMaps/maps/mstatus/*[name() = $vStatus]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:status>
            <bf:Status>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Status>
          </bf:status>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:variable name="vEncLvl" select="concat('_',translate(substring(.,18,1),' ','0'))"/>
    <xsl:for-each select="$codeMaps/maps/menclvl/*[name() = $vEncLvl]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bflc:encodingLevel>
            <bflc:EncodingLevel>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bflc:EncodingLevel>
          </bflc:encodingLevel>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:variable name="vDescriptionConventions" select="translate(substring(.,19,1),' ','_')"/>
    <xsl:for-each select="$codeMaps/maps/descriptionConventions/*[name() = $vDescriptionConventions]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:descriptionConventions>
            <bf:DescriptionConventions>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <bf:code><xsl:value-of select="."/></bf:code>
            </bf:DescriptionConventions>
          </bf:descriptionConventions>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:leader" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vContentType" select="substring(.,7,1)"/>
    <xsl:for-each select="$codeMaps/maps/contentTypes/*[name() = $vContentType]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,@class)"/></xsl:attribute>
          </rdf:type>
          <xsl:if test="not(../marc:datafield[@tag='336'])">
            <bf:content>
              <bf:Content>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:Content>
            </bf:content>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:leader" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType"/>
    <xsl:variable name="issuanceUri">
      <xsl:choose>
        <xsl:when test="substring(.,8,1) = 'a'"><xsl:value-of select="concat($issuance,'mono')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'b'"><xsl:value-of select="concat($issuance,'serl')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'i'"><xsl:value-of select="concat($issuance,'intg')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'm'"><xsl:value-of select="concat($issuance,'mono')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 's'"><xsl:value-of select="concat($issuance,'serl')"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$pInstanceType != ''">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$pInstanceType)"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
        <xsl:if test="substring(.,9,1) = 'a'">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Archival')"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
        <xsl:if test="$issuanceUri != ''">
          <bf:issuance>
            <bf:Issuance>
              <xsl:attribute name="rdf:about"><xsl:value-of select="$issuanceUri"/></xsl:attribute>
            </bf:Issuance>
          </bf:issuance>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
