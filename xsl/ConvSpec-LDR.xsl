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
  <!-- 
     At this time - 3 Aug 2022 - the notion of Instance type is close to non-existent,
     at least with respect to default typing for every MARC record.  (An Instance can
     still receive typing from the 007.)  This is basically a Hub check (is it a Hub?).
     vinstanceType, which tends to be set as a result of this, doesn't appear to be used.
     Point is this:  A future refactor could involve rewriting this to be a simple Hub
     check and then not passing vinstanceType all over since it is not really used.
  -->
  <xsl:template match="marc:leader" mode="instanceType">
    <xsl:choose>
      <!--
      <xsl:when test="substring(.,7,1) = 'd'">Manuscript</xsl:when>
      <xsl:when test="substring(.,7,1) = 'f'">Manuscript</xsl:when>
      <xsl:when test="substring(.,7,1) = 'm'">Electronic</xsl:when>
      <xsl:when test="substring(.,7,1) = 't'">Manuscript</xsl:when>
      -->
      <xsl:when test="substring(.,7,1) = 'q'">Hub</xsl:when>
      <!-- <xsl:when test="substring(.,7,1) = 'a' and contains('abims',substring(.,8,1))">Print</xsl:when> -->
      <xsl:when test="../marc:datafield[@tag='758' and marc:subfield[@code='4']='http://id.loc.gov/ontologies/bibframe/instanceOf']">SecondaryInstance</xsl:when>
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
          <xsl:if test="not(../marc:datafield[@tag='336']) and not($vContentType='q') and @href">
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
    <xsl:variable name="vleader07Type">
      <xsl:choose>
        <xsl:when test="substring(.,8,1) = 'a'">Monograph</xsl:when>
        <xsl:when test="substring(.,8,1) = 'b'">Serial</xsl:when>
        <xsl:when test="substring(.,8,1) = 'c'">Collection</xsl:when>
        <xsl:when test="substring(.,8,1) = 'd'">Collection</xsl:when>
        <xsl:when test="substring(.,8,1) = 'm'">Monograph</xsl:when>
        <xsl:when test="substring(.,8,1) = 'i'">Integrating</xsl:when>
        <xsl:when test="substring(.,8,1) = 's'">Serial</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$vleader07Type != ''">
      <rdf:type>
        <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf, $vleader07Type)"/></xsl:attribute>
      </rdf:type>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:leader" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType"/>
    <xsl:variable name="issuanceUri">
      <xsl:choose>
        <xsl:when test="substring(.,8,1) = 'a'"><xsl:value-of select="concat($issuance,'mono')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'b'"><xsl:value-of select="concat($issuance,'serl')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'c'"><xsl:value-of select="concat($issuance,'mulm')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'd'"><xsl:value-of select="concat($issuance,'mono')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'i'"><xsl:value-of select="concat($issuance,'intg')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 'm'"><xsl:value-of select="concat($issuance,'mono')"/></xsl:when>
        <xsl:when test="substring(.,8,1) = 's'"><xsl:value-of select="concat($issuance,'serl')"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <!-- setting rdf:type for Hub is redundant here, already set in Work template -->
        <xsl:if test="$pInstanceType != '' and $pInstanceType != 'Hub'">
          <xsl:choose>
            <xsl:when test="$pInstanceType = 'SecondaryInstance'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bflc,$pInstanceType)"/></xsl:attribute>
              </rdf:type>
            </xsl:when>
            <xsl:otherwise>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$pInstanceType)"/></xsl:attribute>
              </rdf:type>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <!-- Output an issuance type based on Leader/07 if there is no 334 present in record. -->
        <xsl:if test="$issuanceUri != '' and not (../marc:datafield[@tag = '334'])">
          <bf:issuance>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$issuanceUri"/></xsl:attribute>
          </bf:issuance>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
