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

  <xsl:template match="marc:datafield[@tag='254' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='254')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:musicFormat>
          <bf:MusicFormat>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="marc:subfield[@code='a']"/>
              </xsl:call-template>
            </rdfs:label>
          </bf:MusicFormat>
        </bf:musicFormat>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='255' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='255')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vCoordinates">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="marc:subfield[@code='c']"/>
        <xsl:with-param name="pChopParens" select="true()"/>
        <xsl:with-param name="pForceTerm" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vZone">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="marc:subfield[@code='d']"/>
        <xsl:with-param name="pChopParens" select="true()"/>
        <xsl:with-param name="pForceTerm" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vEquinox">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="marc:subfield[@code='e']"/>
        <xsl:with-param name="pChopParens" select="true()"/>
        <xsl:with-param name="pForceTerm" select="true()"/>
      </xsl:call-template>
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
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
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
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
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
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:outerGRing>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='g']">
                <bf:exclusionGRing>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:exclusionGRing>
              </xsl:for-each>
            </bf:Cartographic>
          </bf:cartographicAttributes>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='257' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='257')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:originPlace>
            <bf:Place>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Place>
          </bf:originPlace>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='250' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='250')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vEditionStatementRaw">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vEditionStatement">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="$vEditionStatementRaw"/>
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
  
  <xsl:template match="marc:datafield[@tag='256' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='256')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <rdf:type>
              <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/computer</xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="marc:subfield[@code='a']"/>
              </xsl:call-template>
            </rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <xsl:template match="marc:datafield[@tag='260' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='260')] |
                       marc:datafield[@tag='262'] |
                       marc:datafield[@tag='264' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='264')]"
                mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vOccurrence">
      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLinkedXmlLang">
      <xsl:if test="$vOccurrence and $vOccurrence != '00'">
        <xsl:apply-templates select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" mode="xmllang"/>
      </xsl:if>
    </xsl:variable>
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
    <xsl:variable name="vLinkedStatement">
      <xsl:if test="$vOccurrence and $vOccurrence != '00'">
        <xsl:apply-templates select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='a' or @code='b' or @code='c']" mode="concat-nodes-delimited"/>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:choose>
          <xsl:when test="$vTag='264' and @ind2='4'">
            <xsl:if test="not(substring(../marc:controlfield[@tag='008'],7,1)='t')">
              <bf:copyrightDate>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="$vStatement"/>
                </xsl:call-template>
              </bf:copyrightDate>
              <xsl:if test="$vLinkedStatement != ''">
                <bf:copyrightDate>
                  <xsl:if test="$vLinkedXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="$vLinkedStatement"/>
                  </xsl:call-template>
                </bf:copyrightDate>
              </xsl:if>
            </xsl:if>
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
                    <xsl:choose>
                      <xsl:when test="not($vOccurrence) or $vOccurrence='00'">
                        <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                          <xsl:with-param name="serialization" select="$serialization"/>
                        </xsl:apply-templates>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="marc:subfield[@code='3']|../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='3']" mode="subfield3">
                          <xsl:with-param name="serialization" select="$serialization"/>
                        </xsl:apply-templates>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                  <xsl:for-each select="marc:subfield[@code='a']">
                    <xsl:variable name="vLabel">
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="vLinkedLabel">
                      <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='a'][position()]"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>
                    <bf:place>
                      <bf:Place>
                        <rdfs:label>
                          <xsl:if test="$vXmlLang != ''">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                          </xsl:if>
                          <xsl:value-of select="$vLabel"/>
                        </rdfs:label>
                        <xsl:if test="$vLinkedLabel != ''">
                          <rdfs:label>
                            <xsl:if test="$vLinkedXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$vLinkedLabel"/>
                          </rdfs:label>
                        </xsl:if>
                      </bf:Place>
                    </bf:place>
                  </xsl:for-each>
                  <xsl:for-each select="marc:subfield[@code='b']">
                    <xsl:variable name="vLabel">
                      <!-- detect if there are unmatched brackets in preceding or following subfield -->
                      <xsl:variable name="vAddBrackets"
                                    select="(not(contains(.,'[')) and
                                            not(contains(.,']')) and
                                            ((contains(preceding-sibling::marc:subfield[@code='a'][1],'[') and
                                            not(contains(preceding-sibling::marc:subfield[@code='a'][1],']'))) or
                                            (contains(following-sibling::marc:subfield[@code='c'][1],']') and
                                            not(contains(following-sibling::marc:subfield[@code='c'][1],'['))))) = true()"/>
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                        <xsl:with-param name="pAddBrackets" select="$vAddBrackets"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="vLinkedLabel">
                      <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                        <!-- detect if there are unmatched brackets in preceding or following subfield -->
                        <xsl:variable name="vAddBrackets"
                                      select="(not(contains(../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()],'[')) and
                                              not(contains(../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()],']')) and
                                              ((contains(../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()]/preceding-sibling::marc:subfield[@code='a'][1],'[') and
                                              not(contains(../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()]/preceding-sibling::marc:subfield[@code='a'][1],']'))) or
                                              (contains(../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()]/following-sibling::marc:subfield[@code='c'][1],']') and
                                              not(contains(../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()]/following-sibling::marc:subfield[@code='c'][1],'['))))) = true()"/>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='b'][position()]"/>
                          <xsl:with-param name="pAddBrackets" select="$vAddBrackets"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>
                    <bf:agent>
                      <bf:Agent>
                        <rdfs:label>
                          <xsl:if test="$vXmlLang != ''">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                          </xsl:if>
                          <xsl:value-of select="$vLabel"/>
                        </rdfs:label>
                        <xsl:if test="$vLinkedLabel != ''">
                          <rdfs:label>
                            <xsl:if test="$vLinkedXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$vLinkedLabel"/>
                          </rdfs:label>
                        </xsl:if>
                      </bf:Agent>
                    </bf:agent>
                  </xsl:for-each>
                  <xsl:for-each select="marc:subfield[@code='c']">
                    <xsl:variable name="vLabel">
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="vLinkedLabel">
                      <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='c'][position()]"/>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:variable>
                    <bf:date>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$vLabel"/>
                    </bf:date>
                    <xsl:if test="$vLinkedLabel != ''">
                      <bf:date>
                        <xsl:if test="$vLinkedXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$vLinkedLabel"/>
                      </bf:date>
                    </xsl:if>
                  </xsl:for-each>
                </bf:ProvisionActivity>
              </bf:provisionActivity>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$vTag = '260' and marc:subfield[@code='e' or @code='f' or @code='g']">
          <bf:provisionActivity>
            <bf:ProvisionActivity>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Manufacture')"/></xsl:attribute>
              </rdf:type>
              <xsl:choose>
                <xsl:when test="not($vOccurrence) or $vOccurrence='00'">
                  <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="marc:subfield[@code='3']|../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='3']" mode="subfield3">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:for-each select="marc:subfield[@code='e']">
                <xsl:variable name="vLabel">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                    <xsl:with-param name="pChopParens" select="true()"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="vLinkedLabel">
                  <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='e'][position()]"/>
                      <xsl:with-param name="pChopParens" select="true()"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:variable>
                <bf:place>
                  <bf:Place>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$vLabel"/>
                    </rdfs:label>
                    <xsl:if test="$vLinkedLabel != ''">
                      <rdfs:label>
                        <xsl:if test="$vLinkedXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$vLinkedLabel"/>
                      </rdfs:label>
                    </xsl:if>
                  </bf:Place>
                </bf:place>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='f']">
                <xsl:variable name="vLabel">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                    <xsl:with-param name="pChopParens" select="true()"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="vLinkedLabel">
                  <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='f'][position()]"/>
                      <xsl:with-param name="pChopParens" select="true()"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:variable>
                <bf:agent>
                  <bf:Agent>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$vLabel"/>
                    </rdfs:label>
                    <xsl:if test="$vLinkedLabel != ''">
                      <rdfs:label>
                        <xsl:if test="$vLinkedXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$vLinkedLabel"/>
                      </rdfs:label>
                    </xsl:if>
                  </bf:Agent>
                </bf:agent>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='g']">
                <xsl:variable name="vLabel">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                    <xsl:with-param name="pChopParens" select="true()"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="vLinkedLabel">
                  <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='g'][position()]"/>
                      <xsl:with-param name="pChopParens" select="true()"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:variable>
                <bf:date>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vLabel"/>
                </bf:date>
                <xsl:if test="$vLinkedLabel != ''">
                  <bf:date>
                    <xsl:if test="$vLinkedXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vLinkedXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$vLinkedLabel"/>
                  </bf:date>
                </xsl:if>
              </xsl:for-each>
            </bf:ProvisionActivity>
          </bf:provisionActivity>
        </xsl:if>
        <xsl:if test="$vTag = '260'">
          <xsl:for-each select="marc:subfield[@code='d']">
            <xsl:variable name="vLinkedValue">
              <xsl:if test="$vOccurrence and $vOccurrence != '00'">
                <xsl:value-of select="../../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='d'][position()]"/>
              </xsl:if>
            </xsl:variable>
            <bf:identifiedBy>
              <bf:PublisherNumber>
                <rdf:value><xsl:value-of select="."/></rdf:value>
                <xsl:if test="$vLinkedValue != ''">
                  <rdf:value><xsl:value-of select="$vLinkedValue"/></rdf:value>
                </xsl:if>
              </bf:PublisherNumber>
            </bf:identifiedBy>
          </xsl:for-each>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='261' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='261')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
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
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
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
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
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
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Place>
              </bf:place>
            </xsl:for-each>
          </bf:ProvisionActivity>
        </bf:provisionActivity>
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
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
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

  <xsl:template match="marc:datafield[@tag='263' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='263')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bflc:projectedProvisionDate>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bflc:projectedProvisionDate>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='265' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='265')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:acquisitionSource>
            <bf:AcquisitionSource>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:AcquisitionSource>
          </bf:acquisitionSource>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
