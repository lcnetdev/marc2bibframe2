<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 250-270 -->

  <xsl:template match="marc:datafield[@tag='250']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance250">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='250' or @tag='880']" mode="instance250">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vEditionStatementRaw">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vEditionStatement">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="$vEditionStatementRaw"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:editionStatement><xsl:value-of select="$vEditionStatement"/></bf:editionStatement>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    
  
  <xsl:template match="marc:datafield[@tag='254']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance254">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='254' or @tag='880']" mode="instance254">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <bf:noteType>Musical presentation</bf:noteType>
            <rdfs:label>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
              </xsl:call-template>
            </rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <xsl:template match="marc:datafield[@tag='255']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance255">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='255' or @tag='880']" mode="instance255">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vCoordinatesChopPunct">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="marc:subfield[@code='c']"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vCoordinates">
      <xsl:call-template name="chopParens">
        <xsl:with-param name="chopString" select="$vCoordinatesChopPunct"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- because $d and $e can have matching parens across subfield boundary,
         some monkey business is required -->
    <xsl:variable name="vZoneChopPunct">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="marc:subfield[@code='d']"/>
        <xsl:with-param name="punctuation"><xsl:text>).:,;/ </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vZone">
      <xsl:choose>
        <xsl:when test="substring($vZoneChopPunct,1,1) = '('">
          <xsl:value-of select="substring($vZoneChopPunct,2,string-length($vZoneChopPunct)-1)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$vZoneChopPunct"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vEquinoxChopPunct">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="marc:subfield[@code='e']"/>
        <xsl:with-param name="punctuation"><xsl:text>).:,;/ </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vEquinox">
      <xsl:choose>
        <xsl:when test="substring($vEquinoxChopPunct,1,1) = '('">
          <xsl:value-of select="substring($vEquinoxChopPunct,2,string-length($vEquinoxChopPunct)-1)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$vEquinoxChopPunct"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:cartographicAttributes>
          <bf:Cartographic>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:scale>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:scale>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:projection>
                <!-- leave trailing period for abbreviations -->
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                  <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </bf:projection>
            </xsl:for-each>
            <xsl:if test="$vCoordinates != ''">
              <bf:coordinates><xsl:value-of select="$vCoordinates"/></bf:coordinates>
            </xsl:if>
            <xsl:if test="$vZone != ''">
              <bf:ascensionAndDeclination><xsl:value-of select="$vZone"/></bf:ascensionAndDeclination>
            </xsl:if>
            <xsl:if test="$vEquinox != ''">
              <bf:equinox><xsl:value-of select="$vEquinox"/></bf:equinox>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='f']">
              <bf:outerGRing>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:outerGRing>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='g']">
              <bf:exclusionGRing>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:exclusionGRing>
            </xsl:for-each>
          </bf:Cartographic>
        </bf:cartographicAttributes>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='256']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance256">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='256' or @tag='880']" mode="instance256">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <bf:noteType>Computer file characteristics</bf:noteType>
            <rdfs:label>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
              </xsl:call-template>
            </rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <xsl:template match="marc:datafield[@tag='257']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance257">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='257' or @tag='880']" mode="instance257">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:provisionActivity>
            <bf:Production>
              <bf:place>
                <bf:Place>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </bf:Place>
              </bf:place>
            </bf:Production>
          </bf:provisionActivity>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
