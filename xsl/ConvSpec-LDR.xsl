<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for LDR
  -->

  <xsl:template match="marc:leader" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:adminMetadata>
          <bf:AdminMetadata>
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
          </bf:AdminMetadata>
        </bf:adminMetadata>
        <xsl:choose>
          <xsl:when test="substring(.,7,1) = 'a'"><rdf:type>bf:Text</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'c'"><rdf:type>bf:NotatedMusic</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'd'"><rdf:type>bf:NotatedMusic</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'e'"><rdf:type>bf:Cartography</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'f'"><rdf:type>bf:Cartography</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'g'"><rdf:type>bf:MovingImage</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'i'"><rdf:type>bf:Audio</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'j'"><rdf:type>bf:Audio</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'k'"><rdf:type>bf:StillImage</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'o'"><rdf:type>bf:MixedMaterial</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'p'"><rdf:type>bf:MixedMaterial</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'r'"><rdf:type>bf:Object</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 't'"><rdf:type>bf:Text</rdf:type></xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:leader" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="substring(.,7,1) = 'd'"><rdf:type>bf:Manuscript</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'f'"><rdf:type>bf:Manuscript</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'm'"><rdf:type>bf:Electronic</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 't'"><rdf:type>bf:Manuscript</rdf:type></xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="substring(.,8,1) = 'a'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>m</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'b'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>s</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'c'"><rdf:type>bf:Collection</rdf:type></xsl:when>
          <xsl:when test="substring(.,8,1) = 'd'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>d</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'i'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>i</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'm'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>m</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 's'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>s</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="substring(.,9,1) = 'a'"><rdf:type>bf:Archival</rdf:type></xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
