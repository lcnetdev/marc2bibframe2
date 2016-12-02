<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Templates for processing MARC control subfields -->

  <!--
      create a bf:identifiedBy property from a subfield $0 or $w
  -->
  <xsl:template match="marc:subfield" mode="subfield0orw">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="source" select="substring(substring-after(text(),'('),1,string-length(substring-before(text(),')'))-1)"/>
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="$source != ''"><xsl:value-of select="substring-after(text(),')')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:identifiedBy>
          <bf:Identifier>
            <rdf:value><xsl:value-of select="$value"/></rdf:value>
            <xsl:if test="$source != ''">
              <bf:source>
                <bf:Source>
                  <rdfs:label><xsl:value-of select="$source"/></rdfs:label>
                </bf:Source>
              </bf:source>
            </xsl:if>
          </bf:Identifier>
        </bf:identifiedBy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- create a bf:source property from a subfield $2 -->
  <xsl:template match="marc:subfield" mode="subfield2">
    <xsl:param name="serialization" select="'rdfxsml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:source>
          <bf:Source>
            <rdfs:label><xsl:value-of select="."/></rdfs:label>
          </bf:Source>
        </bf:source>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      create a bflc:appliesTo property from a subfield $3
  -->
  <xsl:template match="marc:subfield" mode="subfield3">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bflc:appliesTo>
          <bflc:AppliesTo>
            <rdfs:label>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </rdfs:label>
          </bflc:AppliesTo>
        </bflc:appliesTo>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      create a bflc:applicableInstitution property from a subfield $5
  -->
  <xsl:template match="marc:subfield" mode="subfield5">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bflc:applicableInstitution>
          <bf:Agent>
            <bf:code><xsl:value-of select="."/></bf:code>
          </bf:Agent>
        </bflc:applicableInstitution>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      create rdf:type and bf:issuance properties from a subfield $7
  -->
  <xsl:template match="marc:subfield" mode="subfield7">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="substring(.,1,1) = 'a'">Text</xsl:when>
        <xsl:when test="substring(.,1,1) = 'c'">NotatedMusic</xsl:when>
        <xsl:when test="substring(.,1,1) = 'd'">NotatedMusic</xsl:when>
        <xsl:when test="substring(.,1,1) = 'e'">Cartography</xsl:when>
        <xsl:when test="substring(.,1,1) = 'f'">Cartography</xsl:when>
        <xsl:when test="substring(.,1,1) = 'g'">MovingImage</xsl:when>
        <xsl:when test="substring(.,1,1) = 'i'">Audio</xsl:when>
        <xsl:when test="substring(.,1,1) = 'j'">Audio</xsl:when>
        <xsl:when test="substring(.,1,1) = 'k'">StillImage</xsl:when>
        <xsl:when test="substring(.,1,1) = 'o'">MixedMaterial</xsl:when>
        <xsl:when test="substring(.,1,1) = 'p'">MixedMaterial</xsl:when>
        <xsl:when test="substring(.,1,1) = 'r'">Object</xsl:when>
        <xsl:when test="substring(.,1,1) = 't'">Text</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="issuance">
      <xsl:choose>
        <xsl:when test="substring(.,2,1) = 'a'">m</xsl:when>
        <xsl:when test="substring(.,2,1) = 'b'">s</xsl:when>
        <xsl:when test="substring(.,2,1) = 'd'">d</xsl:when>
        <xsl:when test="substring(.,2,1) = 'i'">i</xsl:when>
        <xsl:when test="substring(.,2,1) = 'm'">m</xsl:when>
        <xsl:when test="substring(.,2,1) = 's'">s</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:if test="$type != ''">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$bf"/><xsl:value-of select="$type"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
        <xsl:if test="$issuance != ''">
          <bf:issuance>
            <bf:Issuance>
              <bf:code><xsl:value-of select="$issuance"/></bf:code>
            </bf:Issuance>
          </bf:issuance>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
