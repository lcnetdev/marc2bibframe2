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

  <!-- Templates for processing MARC control subfields -->

  <!--
      generate agent or work URI from 1XX, 6XX, 7XX, or 8XX, taking $0 or $w into account
      generated URI will come from the first URI in a $0 or $w
  -->
  <xsl:template match="marc:datafield" mode="generateUri">
    <xsl:param name="pDefaultUri"/>
    <xsl:param name="pEntity"/>
    <xsl:variable name="vGeneratedUri">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='t']">
          <xsl:variable name="vIdentifier">
            <xsl:choose>
              <xsl:when test="$pEntity='bf:Agent'">
                <xsl:value-of select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')][1]"/>
              </xsl:when>
              <xsl:when test="$pEntity='bf:Work' or $pEntity = 'bf:Hub'">
                <xsl:value-of select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')][1]"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="starts-with($vIdentifier,'(uri)')">
              <xsl:value-of select="substring-after($vIdentifier,'(uri)')"/>
            </xsl:when>
            <xsl:when test="starts-with($vIdentifier,'http')">
              <xsl:value-of select="$vIdentifier"/>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="vIdentifier">
            <xsl:value-of select="marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')][1]"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="starts-with($vIdentifier,'(uri)')">
              <xsl:value-of select="substring-after($vIdentifier,'(uri)')"/>
            </xsl:when>
            <xsl:when test="starts-with($vIdentifier,'http')">
              <xsl:value-of select="$vIdentifier"/>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$vGeneratedUri != ''"><xsl:value-of select="$vGeneratedUri"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$pDefaultUri"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      create a bf:identifiedBy property from a subfield $0 or $w
  -->
  <xsl:template match="marc:subfield" mode="subfield0orw">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pIdClass" select="'bf:Identifier'"/>
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
          <xsl:element name="{$pIdClass}">
            <rdf:value>
              <xsl:choose>
                <xsl:when test="contains($value,'://')">
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$value"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$value"/>
                </xsl:otherwise>
              </xsl:choose>
            </rdf:value>
            <xsl:if test="$source != '' and $source != 'uri'">
              <xsl:choose>
                <xsl:when test="@code='w'">
                  <bf:assigner>
                    <bf:Agent>
                      <xsl:if test="$source='DLC'">
                        <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                      </xsl:if>
                      <bf:code><xsl:value-of select="$source"/></bf:code>
                    </bf:Agent>
                  </bf:assigner>
                </xsl:when>
                <xsl:otherwise>
                  <bf:source>
                    <bf:Source>
                      <xsl:if test="$source='DLC'">
                        <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                      </xsl:if>
                      <bf:code><xsl:value-of select="$source"/></bf:code>
                    </bf:Source>
                  </bf:source>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:element>
        </bf:identifiedBy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- create a bf:source property from a subfield $2 -->
  <xsl:template match="marc:subfield" mode="subfield2">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pVocabStem"/>
    <xsl:param name="pStripPunct" select="false()"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:source>
          <bf:Source>
            <xsl:if test="$pVocabStem != ''">
              <xsl:variable name="vNormCode">
                <xsl:call-template name="tNormalizeCode">
                  <xsl:with-param name="pCode" select="."/>
                  <xsl:with-param name="pStripPunct" select="$pStripPunct"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($pVocabStem,$vNormCode)"/></xsl:attribute>
            </xsl:if>
            <bf:code>
              <xsl:value-of select="."/>
            </bf:code>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="parent::*" mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bflc:appliesTo>
          <bflc:AppliesTo>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="."/>
              </xsl:call-template>
            </rdfs:label>
          </bflc:AppliesTo>
        </bflc:appliesTo>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      create a bf:role property from a subfield $4
  -->
  <xsl:template match="marc:subfield" mode="subfield4">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:role>
          <bf:Role>
            <xsl:choose>
              <xsl:when test="contains(.,'://')">
                <xsl:attribute name="rdf:about"><xsl:value-of select="."/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </xsl:otherwise>
            </xsl:choose>
          </bf:Role>
        </bf:role>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      create a bflc:applicableInstitution property from a subfield $5
  -->
  <xsl:template match="marc:subfield" mode="subfield5">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vNormCode">
      <xsl:call-template name="tNormalizeCode">
        <xsl:with-param name="pCode" select="."/>
        <xsl:with-param name="pStripPunct" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bflc:applicableInstitution>
          <bf:Agent>
            <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,$vNormCode)"/></xsl:attribute>
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

  <!--
      create an rdfs:label property with datatype xs:anyURI from a
      subfield u
  -->
  <xsl:template match="marc:subfield" mode="subfieldu">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <rdf:value>
          <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'anyURI')"/></xsl:attribute>
          <xsl:value-of select="."/>
        </rdf:value>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
