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
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="substring(.,6,1) = 'a'">
            <bf:status>
              <bf:Status>
                <rdfs:label>increase in encoding level</rdfs:label>
                <bf:code>c</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'c'">
            <bf:status>
              <bf:Status>
                <rdfs:label>corrected or revised</rdfs:label>
                <bf:code>c</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'd'">
            <bf:status>
              <bf:Status>
                <rdfs:label>deleted</rdfs:label>
                <bf:code>d</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'n'">
            <bf:status>
              <bf:Status>
                <rdfs:label>new</rdfs:label>
                <bf:code>n</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'p'">
            <bf:status>
              <bf:Status>
                <rdfs:label>increase in encoding level from prepublication</rdfs:label>
                <bf:code>p</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
        </xsl:choose>
        <bflc:encodingLevel>
          <bflc:EncodingLevel>
            <xsl:choose>
              <xsl:when test="substring(.,18,1) = ' '">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/f</xsl:attribute>
                <rdfs:label>full</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '1'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/1</xsl:attribute>
                <rdfs:label>full not examined</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '2'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/7</xsl:attribute>
                <rdfs:label>less than full not examined</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '3'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/3</xsl:attribute>
                <rdfs:label>abbreviated</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '4'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/4</xsl:attribute>
                <rdfs:label>core</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '5'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/5</xsl:attribute>
                <rdfs:label>preliminary</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '7'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/7</xsl:attribute>
                <rdfs:label>minimal</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,18,1) = '8'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/menclvl/8</xsl:attribute>
                <rdfs:label>prepublication</rdfs:label>
              </xsl:when>
            </xsl:choose>
          </bflc:EncodingLevel>
        </bflc:encodingLevel>
        <bf:descriptionConventions>
          <bf:DescriptionConventions>
            <xsl:choose>
              <xsl:when test="substring(.,19,1) = 'a' or substring(.,19,1) = 'p' or substring(.,19,1) = 'r'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/descriptionConventions/aacr</xsl:attribute>
                <rdfs:label>aacr</rdfs:label>
              </xsl:when>
              <xsl:when test="substring(.,19,1) = 'c' or substring(.,19,1) = 'i'">
                <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/descriptionConventions/isbd</xsl:attribute>
                <rdfs:label>isbd</rdfs:label>
              </xsl:when>
            </xsl:choose>
          </bf:DescriptionConventions>
        </bf:descriptionConventions>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:leader" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:variable name="workType">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">Text</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">NotatedMusic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">NotatedMusic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'">Cartography</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">Cartography</xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'">MovingImage</xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'">Audio</xsl:when>
            <xsl:when test="substring(.,7,1) = 'j'">Audio</xsl:when>
            <xsl:when test="substring(.,7,1) = 'k'">StillImage</xsl:when>
            <xsl:when test="substring(.,7,1) = 'o'">MixedMaterial</xsl:when>
            <xsl:when test="substring(.,7,1) = 'p'">MixedMaterial</xsl:when>
            <xsl:when test="substring(.,7,1) = 'r'">Object</xsl:when>
            <xsl:when test="substring(.,7,1) = 't'">Text</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$workType != ''">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$workType)"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
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
