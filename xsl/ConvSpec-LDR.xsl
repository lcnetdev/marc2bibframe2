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

  <xsl:template match="marc:leader" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="substring(.,6,1) = 'a'">
            <bf:status>
              <bf:Status>
                <bf:code>c</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'c'">
            <bf:status>
              <bf:Status>
                <bf:code>c</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'n'">
            <bf:status>
              <bf:Status>
                <bf:code>n</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
          <xsl:when test="substring(.,6,1) = 'p'">
            <bf:status>
              <bf:Status>
                <bf:code>p</bf:code>
              </bf:Status>
            </bf:status>
          </xsl:when>
        </xsl:choose>
        <bflc:encodingLevel>
          <bflc:EncodingLevel>
            <bf:code>
              <xsl:choose>
                <xsl:when test="substring(.,18,1) = ' '">f</xsl:when>
                <xsl:when test="substring(.,18,1) = '1'">1</xsl:when>
                <xsl:when test="substring(.,18,1) = '2'">7</xsl:when>
                <xsl:when test="substring(.,18,1) = '3'">3</xsl:when>
                <xsl:when test="substring(.,18,1) = '4'">4</xsl:when>
                <xsl:when test="substring(.,18,1) = '5'">5</xsl:when>
                <xsl:when test="substring(.,18,1) = '7'">7</xsl:when>
                <xsl:when test="substring(.,18,1) = '8'">8</xsl:when>
                <xsl:otherwise>u</xsl:otherwise>
              </xsl:choose>
            </bf:code>
          </bflc:EncodingLevel>
        </bflc:encodingLevel>
        <bf:descriptionConventions>
          <bf:DescriptionConventions>
            <bf:code>
              <xsl:choose>
                <xsl:when test="substring(.,19,1) = 'a'">aacr</xsl:when>
                <xsl:when test="substring(.,19,1) = 'c'">isbd</xsl:when>
                <xsl:when test="substring(.,19,1) = 'i'">isbd</xsl:when>
                <xsl:when test="substring(.,19,1) = 'p'">aacr</xsl:when>
                <xsl:when test="substring(.,19,1) = 'r'">aacr</xsl:when>
                <xsl:otherwise>unknown</xsl:otherwise>
              </xsl:choose>
            </bf:code>
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
        <xsl:variable name="instanceType">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'd'">Manuscript</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">Manuscript</xsl:when>
            <xsl:when test="substring(.,7,1) = 'm'">Electronic</xsl:when>
            <xsl:when test="substring(.,7,1) = 't'">Manuscript</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$instanceType != ''">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$instanceType)"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="substring(.,8,1) = 'c' or substring(.,8,1) = 'd'">
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Collection')"/></xsl:attribute>
            </rdf:type>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="$issuanceUri != ''">
          <bf:issuance>
            <bf:Issuance>
              <xsl:attribute name="rdf:about"><xsl:value-of select="$issuanceUri"/></xsl:attribute>
            </bf:Issuance>
          </bf:issuance>
        </xsl:if>
        <xsl:if test="substring(.,9,1) = 'a'">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$bf"/>Archival</xsl:attribute>
          </rdf:type>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
