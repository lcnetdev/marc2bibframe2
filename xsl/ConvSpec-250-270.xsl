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

  <!-- Conversion specs for 250-270 -->

  <xsl:template match="marc:datafield[@tag='255']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work255">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='255' or @tag='880']" mode="work255">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
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
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:scale>
            <bf:Scale>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Scale>
          </bf:scale>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code='b' or @code='c' or @code='d' or @code='f' or @code='g']">
          <bf:cartographicAttributes>
            <bf:Cartographic>
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:projection>
                  <bf:Projection>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <!-- leave trailing period for abbreviations -->
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                        <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Projection>
                </bf:projection>
              </xsl:for-each>
              <xsl:if test="$vCoordinates != ''">
                <bf:coordinates>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vCoordinates"/>
                </bf:coordinates>
              </xsl:if>
              <xsl:if test="$vZone != ''">
                <bf:ascensionAndDeclination>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vZone"/>
                </bf:ascensionAndDeclination>
              </xsl:if>
              <xsl:if test="$vEquinox != ''">
                <bf:equinox>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vEquinox"/>
                </bf:equinox>
              </xsl:if>
              <xsl:for-each select="marc:subfield[@code='f']">
                <bf:outerGRing>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                  </xsl:call-template>
                </bf:outerGRing>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='g']">
                <bf:exclusionGRing>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                  </xsl:call-template>
                </bf:exclusionGRing>
              </xsl:for-each>
            </bf:Cartographic>
          </bf:cartographicAttributes>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='250']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance250">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='250' or @tag='880']" mode="instance250">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
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
        <bf:editionStatement>
          <xsl:if test="$vXmlLang != ''">
            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$vEditionStatement"/>
        </bf:editionStatement>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <bf:noteType>Musical presentation</bf:noteType>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="marc:subfield[@code='a']"/>
              </xsl:call-template>
            </rdfs:label>
          </bf:Note>
        </bf:note>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <bf:noteType>Computer file characteristics</bf:noteType>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:provisionActivity>
            <bf:Production>
              <bf:place>
                <bf:Place>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </rdfs:label>
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
  
  <xsl:template match="marc:datafield[@tag='260' or @tag='262' or @tag='264']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance260">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='260' or @tag='262' or @tag='264' or @tag='880']" mode="instance260">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProvisionActivity">
      <xsl:choose>
        <xsl:when test="$vTag='264'">
          <xsl:choose>
            <xsl:when test="@ind2='0'">Production</xsl:when>
            <xsl:when test="@ind2='1'">Publication</xsl:when>
            <xsl:when test="@ind2='2'">Distribution</xsl:when>
            <xsl:when test="@ind2='3'">Manufacture</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>Publication</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vStatement">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b' or @code='c']" mode="concat-nodes-delimited"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:choose>
          <xsl:when test="$vTag='264' and @ind2='4'">
            <bf:copyrightDate>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vStatement"/>
            </bf:copyrightDate>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="marc:subfield[@code='a' or @code='b' or @code='c']">
              <bf:provisionActivity>
                <bf:ProvisionActivity>
                  <xsl:if test="$vProvisionActivity != ''">
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$vProvisionActivity)"/></xsl:attribute>
                    </rdf:type>
                  </xsl:if>
                  <xsl:if test="$vTag='260' or $vTag='264'">
                    <xsl:if test="@ind1 = '3'">
                      <bf:status>
                        <bf:Status>
                          <rdfs:label>current</rdfs:label>
                        </bf:Status>
                      </bf:status>
                    </xsl:if>
                    <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </xsl:if>
                  <xsl:for-each select="marc:subfield[@code='a']">
                    <bf:place>
                      <bf:Place>
                        <rdfs:label>
                          <xsl:if test="$vXmlLang != ''">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                          </xsl:if>
                          <xsl:call-template name="chopBrackets">
                            <xsl:with-param name="chopString" select="."/>
                            <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                          </xsl:call-template>
                        </rdfs:label>
                      </bf:Place>
                    </bf:place>
                  </xsl:for-each>
                  <xsl:for-each select="marc:subfield[@code='b']">
                    <bf:agent>
                      <bf:Agent>
                        <rdfs:label>
                          <xsl:if test="$vXmlLang != ''">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                          </xsl:if>
                          <xsl:call-template name="chopBrackets">
                            <xsl:with-param name="chopString" select="."/>
                            <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                          </xsl:call-template>
                        </rdfs:label>
                      </bf:Agent>
                    </bf:agent>
                  </xsl:for-each>
                  <xsl:for-each select="marc:subfield[@code='c']">
                    <bf:date>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </bf:date>
                  </xsl:for-each>
                </bf:ProvisionActivity>
              </bf:provisionActivity>
              <bf:provisionActivityStatement>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$vStatement"/>
              </bf:provisionActivityStatement>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$vTag = '260' and marc:subfield[@code='e' or @code='f' or @code='g']">
          <bf:provisionActivity>
            <bf:ProvisionActivity>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Manufacture')"/></xsl:attribute>
              </rdf:type>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:for-each select="marc:subfield[@code='e']">
                <bf:place>
                  <bf:Place>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopParens">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Place>
                </bf:place>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='f']">
                <bf:agent>
                  <bf:Agent>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopParens">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Agent>
                </bf:agent>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='g']">
                <bf:date>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopParens">
                    <xsl:with-param name="chopString" select="."/>
                  </xsl:call-template>
                </bf:date>
              </xsl:for-each>
            </bf:ProvisionActivity>
          </bf:provisionActivity>
        </xsl:if>
        <xsl:if test="$vTag = '260'">
          <xsl:for-each select="marc:subfield[@code='d']">
            <bf:identifiedBy>
              <bf:PublisherNumber>
                <rdf:value><xsl:value-of select="."/></rdf:value>
              </bf:PublisherNumber>
            </bf:identifiedBy>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='261']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance261">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='261' or @tag='880']" mode="instance261">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vStatement">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b' or @code='d' or @code='f']" mode="concat-nodes-delimited"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:provisionActivity>
          <bf:ProvisionActivity>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Production')"/></xsl:attribute>
            </rdf:type>
            <xsl:for-each select="marc:subfield[@code='a' or @code='b']">
              <bf:agent>
                <bf:Agent>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Agent>
              </bf:agent>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='d']">
              <bf:date>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:date>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='f']">
              <bf:place>
                <bf:Place>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Place>
              </bf:place>
            </xsl:for-each>
          </bf:ProvisionActivity>
        </bf:provisionActivity>
        <bf:provisionActivityStatement>
          <xsl:if test="$vXmlLang != ''">
            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$vStatement"/>
        </bf:provisionActivityStatement>
        <xsl:if test="marc:subfield[@code='e']">
          <bf:provisionActivity>
            <bf:ProvisionActivity>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Manufacture')"/></xsl:attribute>
              </rdf:type>
              <xsl:for-each select="marc:subfield[@code='e']">
                <bf:agent>
                  <bf:Agent>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Agent>
                </bf:agent>
              </xsl:for-each>
            </bf:ProvisionActivity>
          </bf:provisionActivity>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='263']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance263">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='263' or @tag='880']" mode="instance263">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vDate">
      <xsl:call-template name="edtfFormat">
        <xsl:with-param name="pDateString" select="marc:subfield[@code='a']"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$vDate != ''">
          <bflc:projectedProvisionDate>
            <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($edtf,'edtf')"/></xsl:attribute>
            <xsl:value-of select="$vDate"/>
          </bflc:projectedProvisionDate>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='265']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:acquisitionSource>
            <bf:AcquisitionSource>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:AcquisitionSource>
          </bf:acquisitionSource>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
