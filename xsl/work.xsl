<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Templates for building a BIBFRAME 2.0 Work Resource from MARCXML
      All templates should have the mode "work"
  -->
  
  <xsl:template match="marc:record" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>work</xsl:attribute>
          <xsl:apply-templates mode="work">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          <bf:hasInstance>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>instance</xsl:attribute>
          </bf:hasInstance>
        </bf:Work>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

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
          <xsl:when test="substring(.,7,1) = 'a'"><rdf:type>Text</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'c'"><rdf:type>NotatedMusic</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'd'"><rdf:type>NotatedMusic</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'e'"><rdf:type>Cartography</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'f'"><rdf:type>Cartography</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'g'"><rdf:type>MovingImage</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'i'"><rdf:type>Audio</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'j'"><rdf:type>Audio</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'k'"><rdf:type>StillImage</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'o'"><rdf:type>MixedMaterial</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'p'"><rdf:type>MixedMaterial</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'r'"><rdf:type>Object</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 't'"><rdf:type>Text</rdf:type></xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='243']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:Title>
            <xsl:apply-templates mode="title243" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="@ind1 = 1">
      <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:attribute>
            </bf:title>
            <xsl:for-each select="marc:subfield[@code='f' or @code='g']">
              <bf:originDate><xsl:value-of select="."/></bf:originDate>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='h']">
              <bf:genreForm>
                <bf:GenreForm>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='s']">
              <bf:version><xsl:value-of select="."/></bf:version>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='880']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'243')">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <bf:Title>
                <xsl:apply-templates mode="title243" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Title>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'245')">
        <xsl:if test="@ind1 = 1">
          <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
            <xsl:choose>
              <xsl:when test="$serialization = 'rdfxml'">
                <bf:title>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:attribute>
                </bf:title>
                <xsl:for-each select="marc:subfield[@code='f' or @code='g']">
                  <bf:originDate><xsl:value-of select="."/></bf:originDate>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='h']">
                  <bf:genreForm>
                    <bf:GenreForm>
                      <rdfs:label><xsl:value-of select="."/></rdfs:label>
                    </bf:GenreForm>
                  </bf:genreForm>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code='s']">
                  <bf:version><xsl:value-of select="."/></bf:version>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
        
  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="work"/>

</xsl:stylesheet>
