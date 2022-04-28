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

  <!-- Conversion specs for 3XX -->

  <xsl:template match="marc:datafield[@tag='336' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='336')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:content</xsl:with-param>
      <xsl:with-param name="pResource">bf:Content</xsl:with-param>
      <xsl:with-param name="pUriStem"><xsl:value-of select="$contentType"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='340' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='340')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='g']">
      <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
      <xsl:variable name="vCurrentNodeUri">
        <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="starts-with(.,'(uri)')">
                <xsl:value-of select="substring-after(.,'(uri)')"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:colorContent>
            <bf:ColorContent>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and not(contains(text(),'://'))]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:ColorContent>
          </bf:colorContent>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='p']">
      <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
      <xsl:variable name="vCurrentNodeUri">
        <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="starts-with(.,'(uri)')">
                <xsl:value-of select="substring-after(.,'(uri)')"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:illustrativeContent>
            <bf:Illustration>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and not(contains(text(),'://'))]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Illustration>
          </bf:illustrativeContent>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='341' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='341')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a']">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:contentAccessibility>
            <bf:ContentAccessibility>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:text>Content access mode: </xsl:text>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="../marc:subfield[@code='b']">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:text>Textual assistive features: </xsl:text>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:for-each>
              <xsl:for-each select="../marc:subfield[@code='c']">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:text>Visual assistive features: </xsl:text>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:for-each>
              <xsl:for-each select="../marc:subfield[@code='d']">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:text>Auditory assistive features: </xsl:text>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:for-each>
              <xsl:for-each select="../marc:subfield[@code='e']">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:text>Tactile assistive features: </xsl:text>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:for-each>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:ContentAccessibility>
          </bf:contentAccessibility>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='344' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='344')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='i']">
      <xsl:variable name="vLabel">
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="vUri">
        <xsl:choose>
          <xsl:when test="translate($vLabel,$upper,$lower)='silent'">http://id.loc.gov/vocabulary/msoundcontent/silent</xsl:when>
          <xsl:when test="translate($vLabel,$upper,$lower)='sound'">http://id.loc.gov/vocabulary/msoundcontent/sound</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization='rdfxml'">
          <bf:soundContent>
            <bf:SoundContent>
              <xsl:if test="$vUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="$vLabel"/></rdfs:label>
            </bf:SoundContent>
          </bf:soundContent>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
    
  <xsl:template match="marc:datafield[@tag='348' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='348')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="marc:subfield[@code='c']" mode="generateProperty">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:notation</xsl:with-param>
      <xsl:with-param name="pResource">bf:Notation</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='351' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='351')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:collectionArrangement>
          <bf:CollectionArrangement>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:hierarchicalLevel>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </bf:hierarchicalLevel>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:collectionOrganization>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </bf:collectionOrganization>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:pattern>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </bf:pattern>
            </xsl:for-each>
          </bf:CollectionArrangement>
        </bf:collectionArrangement>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='353' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='353')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vUri">
      <xsl:if test="marc:subfield[@code='b']">
        <xsl:value-of select="concat($msupplcont,marc:subfield[@code='b'][1])"/>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:supplementaryContent>
          <bf:SupplementaryContent>
            <xsl:if test="$vUri != ''">
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vUri"/></xsl:attribute>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b'][position() &gt; 1]">
              <!-- process like $0 -->
              <bf:identifiedBy>
                <bf:Identifier>
                  <rdf:value>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($msupplcont,.)"/></xsl:attribute>
                  </rdf:value>
                </bf:Identifier>
              </bf:identifiedBy>
            </xsl:for-each>
            <xsl:apply-templates select="marc:subfield[@code='0']" mode="subfield0orw">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:SupplementaryContent>
        </bf:supplementaryContent>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='370' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='370')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='c' or @code='g']">
      <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
      <xsl:variable name="vCurrentNodeUri">
        <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="starts-with(.,'(uri)')">
                <xsl:value-of select="substring-after(.,'(uri)')"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:originPlace>
            <bf:Place>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[(@code != '0') and (@code != '2')][1])=$vCurrentNode and not(contains(text(),'://'))]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:for-each select="following-sibling::marc:subfield[@code='2' and generate-id(preceding-sibling::marc:subfield[(@code != '0') and (@code != '1')][1])=$vCurrentNode]">
                <bf:source>
                  <bf:Source>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="concat($subjectSchemes,.)"/></xsl:attribute>
                  </bf:Source>
                </bf:source>
              </xsl:for-each>
            </bf:Place>
          </bf:originPlace>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='377' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='377')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a' or @code='l']">
      <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:language>
            <bf:Language>
              <xsl:choose>
                <xsl:when test="@code='a'">
                  <xsl:choose>
                    <xsl:when test="../@ind2=' '">
                      <xsl:attribute name="rdf:about">
                        <xsl:value-of select="concat($languages,.)"/>
                      </xsl:attribute>
                      <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode]" mode="subfield0orw">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                      <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                      <rdf:value><xsl:value-of select="."/></rdf:value>
                      <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@code='l'">
                  <xsl:variable name="vCurrentNodeUri">
                    <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                      <xsl:if test="position() = 1">
                        <xsl:choose>
                          <xsl:when test="starts-with(.,'(uri)')">
                            <xsl:value-of select="substring-after(.,'(uri)')"/>
                          </xsl:when>
                          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test="$vCurrentNodeUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                  <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                    <xsl:if test="position() != 1">
                      <xsl:apply-templates select="." mode="subfield0orw">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:if>
                  </xsl:for-each>
                  <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and not(contains(text(),'://'))]" mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:when>
              </xsl:choose>
            </bf:Language>
          </bf:language>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='380' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='380')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:genreForm</xsl:with-param>
      <xsl:with-param name="pResource">bf:GenreForm</xsl:with-param>
      <xsl:with-param name="pVocabStem" select="$genreFormSchemes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='382' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='382')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:musicMedium>
          <bf:MusicMedium>
            <xsl:if test="@ind1='1'">
              <bf:status>
                <bf:Status>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($mstatus,'part')"/></xsl:attribute>
                  <rdfs:label>partial</rdfs:label>
                </bf:Status>
              </bf:status>
            </xsl:if>
            <bflc:readMarc382>
              <xsl:apply-templates select="marc:subfield" mode="marcKey"/>
            </bflc:readMarc382>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:MusicMedium>
        </bf:musicMedium>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='383' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='383')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:musicSerialNumber>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:musicSerialNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:musicOpusNumber>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:musicOpusNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:musicThematicNumber>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="normalize-space(concat(.,' ',../marc:subfield[@code='d']))"/>
            </xsl:call-template>
          </bf:musicThematicNumber>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='384' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='384')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a']">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:musicKey>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:musicKey>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='385' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='385')] |
                       marc:datafield[@tag='386' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='386')]"
                mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vProp">
      <xsl:choose>
        <xsl:when test="$vTag='385'">bf:intendedAudience</xsl:when>
        <xsl:when test="$vTag='386'">bflc:creatorCharacteristic</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vResource">
      <xsl:choose>
        <xsl:when test="$vTag='385'">bf:IntendedAudience</xsl:when>
        <xsl:when test="$vTag='386'">bflc:CreatorCharacteristic</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:element name="{$vProp}">
            <xsl:element name="{$vResource}">
              <xsl:if test="starts-with(substring-after(../marc:subfield[@code='0'][1],')'),'dg')">
                <xsl:variable name="encoded">
                  <xsl:call-template name="url-encode">
                    <xsl:with-param name="str" select="normalize-space(substring-after(../marc:subfield[@code='0'][1],')'))"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="rdf:about"><xsl:value-of select="concat($demographicTerms,$encoded)"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='b'][position()=1]">
                <bf:code><xsl:value-of select="."/></bf:code>
              </xsl:for-each>
              <xsl:for-each select="../marc:subfield[@code='m']">
                <bflc:demographicGroup>
                  <bflc:DemographicGroup>
                    <xsl:if test="../marc:subfield[@code='n']">
                      <xsl:variable name="encoded">
                        <xsl:call-template name="url-encode">
                          <xsl:with-param name="str" select="normalize-space(../marc:subfield[@code='n'][1])"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($demographicTerms,$encoded)"/></xsl:attribute>
                    </xsl:if>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bflc:DemographicGroup>
                </bflc:demographicGroup>
              </xsl:for-each>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pVocabStem" select="$subjectSchemes"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='336' or @tag='337' or @tag='338' or @tag='880']" mode="rdaResource">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pProp"/>
    <xsl:param name="pResource"/>
    <xsl:param name="pUriStem"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='b']">
          <xsl:variable name="encoded">
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:element name="{$pProp}">
            <xsl:element name="{$pResource}">
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($pUriStem,$encoded)"/></xsl:attribute>
              <xsl:if test="preceding-sibling::marc:subfield[position()=1]/@code = 'a'">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="preceding-sibling::marc:subfield[position()=1]"/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:if>
              <xsl:if test="following-sibling::marc:subfield[position()=1]/@code = '0'">
                <xsl:apply-templates select="following-sibling::marc:subfield[position()=1]" mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='2']">
                <xsl:variable name="vCode">
                  <xsl:call-template name="tNormalizeCode">
                    <xsl:with-param name="pCode" select="."/>
                  </xsl:call-template>
                </xsl:variable>
                <bf:source>
                  <bf:Source>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="concat($genreFormSchemes,$vCode)"/></xsl:attribute>
                  </bf:Source>
                </bf:source>
              </xsl:for-each>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:if test="following-sibling::marc:subfield[position()=1]/@code != 'b'">
            <xsl:element name="{$pProp}">
              <xsl:element name="{$pResource}">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </rdfs:label>
                <xsl:if test="following-sibling::marc:subfield[position()=1]/@code = '0'">
                  <xsl:apply-templates select="following-sibling::marc:subfield[position()=1]" mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
                <xsl:for-each select="../marc:subfield[@code='2']">
                  <xsl:variable name="vCode">
                    <xsl:call-template name="tNormalizeCode">
                      <xsl:with-param name="pCode" select="."/>
                    </xsl:call-template>
                  </xsl:variable>
                  <bf:source>
                    <bf:Source>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($genreFormSchemes,$vCode)"/></xsl:attribute>
                    </bf:Source>
                  </bf:source>
                </xsl:for-each>
                <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:element>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='300' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='300')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vExtent">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='f' or @code='g']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:if test="$vExtent != ''">
          <bf:extent>
            <bf:Extent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="$vExtent"/>
                  <xsl:with-param name="pEndPunct" select="':;,/=+'"/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Extent>
          </bf:extent>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='b' or @code='e']">
          <bf:note>
            <bf:Note>
                <xsl:choose>
                  <xsl:when test="@code='b'">
                    <rdf:type>
                      <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/physical</xsl:attribute>
                    </rdf:type>
                  </xsl:when>
                  <xsl:when test="@code='e'">
                    <rdf:type>
                      <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/accmat</xsl:attribute>
                    </rdf:type>
                  </xsl:when>
                </xsl:choose>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                  <xsl:with-param name="pEndPunct" select="':;,/=+'"/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:dimensions>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
              <xsl:with-param name="pEndPunct" select="':;,/=+'"/>
            </xsl:call-template>
          </bf:dimensions>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='306' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='306')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:duration>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'duration')"/></xsl:attribute>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:duration>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='310' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='310')] |
                       marc:datafield[@tag='321' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='321')]"
                mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:frequency>
            <bf:Frequency>
              <xsl:if test="../marc:subfield[@code='0'][contains(.,'://')]">
                <xsl:attribute name="rdf:about"><xsl:value-of select="../marc:subfield[@code='0'][contains(.,'://')]"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="../marc:subfield[@code='b']">
                <bf:date>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:date>
              </xsl:for-each>
              <xsl:if test="$vTag='321'">
                <bf:note>
                  <bf:Note>
                    <rdfs:label>former frequency</rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='0'][not(contains(.,'://'))]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Frequency>
          </bf:frequency>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='337' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='337')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:media</xsl:with-param>
      <xsl:with-param name="pResource">bf:Media</xsl:with-param>
      <xsl:with-param name="pUriStem"><xsl:value-of select="$mediaType"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='338' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='338')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:carrier</xsl:with-param>
      <xsl:with-param name="pResource">bf:Carrier</xsl:with-param>
      <xsl:with-param name="pUriStem"><xsl:value-of select="$carriers"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='340' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='340')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a' or @code='c' or @code='d' or @code='e' or @code='f' or @code='j' or @code='k' or @code='m' or @code='n' or @code='o']">
      <xsl:variable name="vProp">
        <xsl:choose>
          <xsl:when test="@code='a'">bf:baseMaterial</xsl:when>
          <xsl:when test="@code='c'">bf:appliedMaterial</xsl:when>
          <xsl:when test="@code='d'">bf:productionMethod</xsl:when>
          <xsl:when test="@code='e'">bf:mount</xsl:when>
          <xsl:when test="@code='f'">bf:reductionRatio</xsl:when>
          <xsl:when test="@code='j'">bf:generation</xsl:when>
          <xsl:when test="@code='k'">bf:layout</xsl:when>
          <xsl:when test="@code='m'">bf:bookFormat</xsl:when>
          <xsl:when test="@code='n'">bf:fontSize</xsl:when>
          <xsl:when test="@code='o'">bf:polarity</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vObject">
        <xsl:choose>
          <xsl:when test="@code='a'">bf:BaseMaterial</xsl:when>
          <xsl:when test="@code='c'">bf:AppliedMaterial</xsl:when>
          <xsl:when test="@code='d'">bf:ProductionMethod</xsl:when>
          <xsl:when test="@code='e'">bf:Mount</xsl:when>
          <xsl:when test="@code='f'">bf:ReductionRatio</xsl:when>
          <xsl:when test="@code='j'">bf:Generation</xsl:when>
          <xsl:when test="@code='k'">bf:Layout</xsl:when>
          <xsl:when test="@code='m'">bf:BookFormat</xsl:when>
          <xsl:when test="@code='n'">bf:FontSize</xsl:when>
          <xsl:when test="@code='o'">bf:Polarity</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
      <xsl:variable name="vCurrentNodeUri">
        <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="starts-with(.,'(uri)')">
                <xsl:value-of select="substring-after(.,'(uri)')"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:element name="{$vProp}">
            <xsl:element name="{$vObject}">
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and not(contains(text(),'://'))]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='b']">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:dimensions>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:dimensions>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='i']">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:systemRequirement>
            <bf:SystemRequirement>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:SystemRequirement>
          </bf:systemRequirement>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='344' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='344')] |
                       marc:datafield[@tag='345' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='345')] |
                       marc:datafield[@tag='346' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='346')] |
                       marc:datafield[@tag='347' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='347')] |
                       marc:datafield[@tag='348' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='348')]"
                mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="marc:subfield">
      <xsl:variable name="vProp">
        <xsl:choose>
          <xsl:when test="$vTag='344'">bf:soundCharacteristic</xsl:when>
          <xsl:when test="$vTag='345'">
            <xsl:choose>
              <xsl:when test="@code='c' or @code='d'">bf:aspectRatio</xsl:when>
              <xsl:otherwise>bf:projectionCharacteristic</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='346'">bf:videoCharacteristic</xsl:when>
          <xsl:when test="$vTag='347'">bf:digitalCharacteristic</xsl:when>
          <xsl:when test="$vTag='348'">bf:musicFormat</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vResource">
        <xsl:choose>
          <xsl:when test="$vTag='344'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:RecordingMethod</xsl:when>
              <xsl:when test="@code='b'">bf:RecordingMedium</xsl:when>
              <xsl:when test="@code='c'">bf:PlayingSpeed</xsl:when>
              <xsl:when test="@code='d'">bf:GrooveCharacteristic</xsl:when>
              <xsl:when test="@code='e'">bf:TrackConfig</xsl:when>
              <xsl:when test="@code='f'">bf:TapeConfig</xsl:when>
              <xsl:when test="@code='g'">bf:PlaybackChannels</xsl:when>
              <xsl:when test="@code='h'">bf:PlaybackCharacteristic</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='345'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:PresentationFormat</xsl:when>
              <xsl:when test="@code='b'">bf:ProjectionSpeed</xsl:when>
              <xsl:when test="@code='c' or @code='d'">bf:AspectRatio</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='346'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:VideoFormat</xsl:when>
              <xsl:when test="@code='b'">bf:BroadcastStandard</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='347'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:FileType</xsl:when>
              <xsl:when test="@code='b'">bf:EncodingFormat</xsl:when>
              <xsl:when test="@code='c'">bf:FileSize</xsl:when>
              <xsl:when test="@code='d'">bf:Resolution</xsl:when>
              <xsl:when test="@code='e'">bf:RegionalEncoding</xsl:when>
              <xsl:when test="@code='f'">bf:EncodedBitrate</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='348'">
            <xsl:if test="@code='a'">bf:MusicFormat</xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vTarget">
        <xsl:choose>
          <xsl:when test="$vTag='344'">
            <xsl:choose>
              <xsl:when test="@code='a'">
                <xsl:choose>
                  <xsl:when test="text()='analog'">
                    <xsl:value-of select="concat($mrectype,'analog')"/>
                  </xsl:when>
                  <xsl:when test="text()='digital'">
                    <xsl:value-of select="concat($mrectype,'digital')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='b'">
                <xsl:choose>
                  <xsl:when test="text()='magnetic'">
                    <xsl:value-of select="concat($mrecmedium,'mag')"/>
                  </xsl:when>
                  <xsl:when test="text()='optical'">
                    <xsl:value-of select="concat($mrecmedium,'opt')"/>
                  </xsl:when>
                  <xsl:when test="text()='magneto-optical'">
                    <xsl:value-of select="concat($mrecmedium,'magopt')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='d'">
                <xsl:choose>
                  <xsl:when test="text()='coarse groove'">
                    <xsl:value-of select="concat($mgroove,'coarse')"/>
                  </xsl:when>
                  <xsl:when test="text()='microgroove'">
                    <xsl:value-of select="concat($mgroove,'micro')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='g'">
                <xsl:choose>
                  <xsl:when test="text()='mono'">
                    <xsl:value-of select="concat($mplayback,'mon')"/>
                  </xsl:when>
                  <xsl:when test="text()='quadraphonic' or text()='surround'">
                    <xsl:value-of select="concat($mplayback,'mul')"/>
                  </xsl:when>
                  <xsl:when test="text()='stereo'">
                    <xsl:value-of select="concat($mplayback,'ste')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='h'">
                <xsl:choose>
                  <xsl:when test="text()='CCIR encoded'">
                    <xsl:value-of select="concat($mspecplayback,'ccir')"/>
                  </xsl:when>
                  <xsl:when test="text()='CX encoded'">
                    <xsl:value-of select="concat($mspecplayback,'cx')"/>
                  </xsl:when>
                  <xsl:when test="text()='dbx encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dbx')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby'">
                    <xsl:value-of select="concat($mspecplayback,'dolby')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby-A encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dolbya')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby-B encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dolbyb')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby-C encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dolbyc')"/>
                  </xsl:when>
                  <xsl:when test="text()='LPCM'">
                    <xsl:value-of select="concat($mspecplayback,'lpcm')"/>
                  </xsl:when>
                  <xsl:when test="text()='NAB standard'">
                    <xsl:value-of select="concat($mspecplayback,'nab')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='345'">
            <xsl:if test="@code='a'">
              <xsl:choose>
                <xsl:when test="text()='3D'">
                  <xsl:value-of select="concat($mpresformat,'3d')"/>
                </xsl:when>
                <xsl:when test="text()='Cinemiracle'">
                  <xsl:value-of select="concat($mpresformat,'ciner')"/>
                </xsl:when>
                <xsl:when test="text()='Cinemiracle'">
                  <xsl:value-of select="concat($mpresformat,'cinem')"/>
                </xsl:when>
                <xsl:when test="text()='Cinerama'">
                  <xsl:value-of select="concat($mpresformat,'ciner')"/>
                </xsl:when>
                <xsl:when test="text()='Circarama'">
                  <xsl:value-of select="concat($mpresformat,'circa')"/>
                </xsl:when>
                <xsl:when test="text()='IMAX'">
                  <xsl:value-of select="concat($mpresformat,'imax')"/>
                </xsl:when>
                <xsl:when test="text()='multiprojector'">
                  <xsl:value-of select="concat($mpresformat,'mproj')"/>
                </xsl:when>
                <xsl:when test="text()='multiscreen'">
                  <xsl:value-of select="concat($mpresformat,'mscreen')"/>
                </xsl:when>
                <xsl:when test="text()='Panavision'">
                  <xsl:value-of select="concat($mpresformat,'pana')"/>
                </xsl:when>
                <xsl:when test="text()='standard silent aperture'">
                  <xsl:value-of select="concat($mpresformat,'silent')"/>
                </xsl:when>
                <xsl:when test="text()='standard sound aperture'">
                  <xsl:value-of select="concat($mpresformat,'sound')"/>
                </xsl:when>
                <xsl:when test="text()='stereoscopic'">
                  <xsl:value-of select="concat($mpresformat,'stereo')"/>
                </xsl:when>
                <xsl:when test="text()='Techniscope'">
                  <xsl:value-of select="concat($mpresformat,'tech')"/>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$vTag='346'">
            <xsl:choose>
              <xsl:when test="@code='a'">
                <xsl:choose>
                  <xsl:when test="text()='8 mm'">
                    <xsl:value-of select="concat($mvidformat,'8mm')"/>
                  </xsl:when>
                  <xsl:when test="text()='Betacam'">
                    <xsl:value-of select="concat($mvidformat,'betacam')"/>
                  </xsl:when>
                  <xsl:when test="text()='Betacam SP'">
                    <xsl:value-of select="concat($mvidformat,'betasp')"/>
                  </xsl:when>
                  <xsl:when test="text()='Betamax'">
                    <xsl:value-of select="concat($mvidformat,'betamax')"/>
                  </xsl:when>
                  <xsl:when test="text()='CED'">
                    <xsl:value-of select="concat($mvidformat,'ced')"/>
                  </xsl:when>
                  <xsl:when test="text()='D-2'">
                    <xsl:value-of select="concat($mvidformat,'d2')"/>
                  </xsl:when>
                  <xsl:when test="text()='EIAJ'">
                    <xsl:value-of select="concat($mvidformat,'eiaj')"/>
                  </xsl:when>
                  <xsl:when test="text()='Hi-8 mm'">
                    <xsl:value-of select="concat($mvidformat,'hi8mm')"/>
                  </xsl:when>
                  <xsl:when test="text()='laser optical'">
                    <xsl:value-of select="concat($mvidformat,'laser')"/>
                  </xsl:when>
                  <xsl:when test="text()='M-II'">
                    <xsl:value-of select="concat($mvidformat,'mii')"/>
                  </xsl:when>
                  <xsl:when test="text()='Quadruplex'">
                    <xsl:value-of select="concat($mvidformat,'quad')"/>
                  </xsl:when>
                  <xsl:when test="text()='Super-VHS'">
                    <xsl:value-of select="concat($mvidformat,'svhs')"/>
                  </xsl:when>
                  <xsl:when test="text()='Type C'">
                    <xsl:value-of select="concat($mvidformat,'typec')"/>
                  </xsl:when>
                  <xsl:when test="text()='U-matic'">
                    <xsl:value-of select="concat($mvidformat,'umatic')"/>
                  </xsl:when>
                  <xsl:when test="text()='VHS'">
                    <xsl:value-of select="concat($mvidformat,'vhs')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='b'">
                <xsl:choose>
                  <xsl:when test="text()='HDTV'">
                    <xsl:value-of select="concat($mbroadstd,'hdtv')"/>
                  </xsl:when>
                  <xsl:when test="text()='NTSC'">
                    <xsl:value-of select="concat($mbroadstd,'ntsc')"/>
                  </xsl:when>
                  <xsl:when test="text()='PAL'">
                    <xsl:value-of select="concat($mbroadstd,'pal')"/>
                  </xsl:when>
                  <xsl:when test="text()='SECAM'">
                    <xsl:value-of select="concat($mbroadstd,'secam')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='347'">
            <xsl:choose>
              <xsl:when test="@code='a'">
                <xsl:choose>
                  <xsl:when test="text()='audio file'">
                    <xsl:value-of select="concat($mfiletype,'audio')"/>
                  </xsl:when>
                  <xsl:when test="text()='data file'">
                    <xsl:value-of select="concat($mfiletype,'data')"/>
                  </xsl:when>
                  <xsl:when test="text()='image file'">
                    <xsl:value-of select="concat($mfiletype,'image')"/>
                  </xsl:when>
                  <xsl:when test="text()='program file'">
                    <xsl:value-of select="concat($mfiletype,'program')"/>
                  </xsl:when>
                  <xsl:when test="text()='text file'">
                    <xsl:value-of select="concat($mfiletype,'text')"/>
                  </xsl:when>
                  <xsl:when test="text()='video file'">
                    <xsl:value-of select="concat($mfiletype,'video')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='b'">
                <xsl:variable name="vNormalizedFormat">
                  <xsl:value-of select="normalize-space(translate(translate(normalize-space(.),$upper,$lower),'-',''))"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="contains($vNormalizedFormat,'bluray')">
                    <xsl:value-of select="concat($mencformat,'bluray')"/>
                  </xsl:when>
                  <xsl:when test="contains($vNormalizedFormat,'dvd')">
                    <xsl:value-of select="concat($mencformat,'dvdv')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='e'">
                <xsl:choose>
                  <xsl:when test="text()='all regions'">
                    <xsl:value-of select="concat($mregencoding,'all')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 1'">
                    <xsl:value-of select="concat($mregencoding,'region1')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 2'">
                    <xsl:value-of select="concat($mregencoding,'region2')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 3'">
                    <xsl:value-of select="concat($mregencoding,'region3')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 4'">
                    <xsl:value-of select="concat($mregencoding,'region4')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 5'">
                    <xsl:value-of select="concat($mregencoding,'region5')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 6'">
                    <xsl:value-of select="concat($mregencoding,'region6')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 7'">
                    <xsl:value-of select="concat($mregencoding,'region7')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 8'">
                    <xsl:value-of select="concat($mregencoding,'region8')"/>
                  </xsl:when>
                  <xsl:when test="text()='region A'">
                    <xsl:value-of select="concat($mregencoding,'regionA')"/>
                  </xsl:when>
                  <xsl:when test="text()='region B'">
                    <xsl:value-of select="concat($mregencoding,'regionB')"/>
                  </xsl:when>
                  <xsl:when test="text()='region C (Blu-Ray)'">
                    <xsl:value-of select="concat($mregencoding,'regionCblu')"/>
                  </xsl:when>
                  <xsl:when test="text()='region C (video game)'">
                    <xsl:value-of select="concat($mregencoding,'regionCgame')"/>
                  </xsl:when>
                  <xsl:when test="text()='region J'">
                    <xsl:value-of select="concat($mregencoding,'regionJ')"/>
                  </xsl:when>
                  <xsl:when test="text()='region U/C'">
                    <xsl:value-of select="concat($mregencoding,'regionU')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='348'">
            <xsl:if test="@code='a'">
              <xsl:choose>
                <xsl:when test="text()='choir book'">
                  <xsl:value-of select="concat($mmusicformat,'choirbk')"/>
                </xsl:when>
                <xsl:when test="text()='chorus score'">
                  <xsl:value-of select="concat($mmusicformat,'chscore')"/>
                </xsl:when>
                <xsl:when test="text()='condensed score'">
                  <xsl:value-of select="concat($mmusicformat,'conscore')"/>
                </xsl:when>
                <xsl:when test="text()='part'">
                  <xsl:value-of select="concat($mmusicformat,'part')"/>
                </xsl:when>
                <xsl:when test="text()='piano conductor part'">
                  <xsl:value-of select="concat($mmusicformat,'pianoconpt')"/>
                </xsl:when>
                <xsl:when test="text()='piano score'">
                  <xsl:value-of select="concat($mmusicformat,'pianoscore')"/>
                </xsl:when>
                <xsl:when test="text()='score'">
                  <xsl:value-of select="concat($mmusicformat,'score')"/>
                </xsl:when>
                <xsl:when test="text()='study score'">
                  <xsl:value-of select="concat($mmusicformat,'study score')"/>
                </xsl:when>
                <xsl:when test="text()='table book'">
                  <xsl:value-of select="concat($mmusicformat,'tablebk')"/>
                </xsl:when>
                <xsl:when test="text()='violin conductor part'">
                  <xsl:value-of select="concat($mmusicformat,'violconpart')"/>
                </xsl:when>
                <xsl:when test="text()='vocal score'">
                  <xsl:value-of select="concat($mmusicformat,'vocalscore')"/>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vLabel">
        <xsl:choose>
          <xsl:when test="$vTag='347' and @code='b'">
            <xsl:choose>
              <xsl:when test="$vTarget=concat($mencformat,'bluray')">Blu-Ray video</xsl:when>
              <xsl:when test="$vTarget=concat($mencformat,'dvdv')">DVD video</xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vObjStringProp">
        <xsl:choose>
          <xsl:when test="$vTag='345' and @code='c'">rdf:value</xsl:when>
          <xsl:otherwise>rdfs:label</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- We need to eliminate duplicates. The second condition looks for a preceding tag with the same value. -->
      <xsl:if test="$vResource != '' and count(../preceding-sibling::marc:datafield[@tag = $vTag and marc:subfield[. = $vLabel]]) = 0">
        <xsl:apply-templates select="." mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp" select="$vProp"/>
          <xsl:with-param name="pResource" select="$vResource"/>
          <xsl:with-param name="pTarget" select="$vTarget"/>
          <xsl:with-param name="pLabel" select="$vLabel"/>
          <xsl:with-param name="pObjStringProp" select="$vObjStringProp"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='350' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='350')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:acquisitionSource>
            <bf:AcquisitionSource>
              <bf:acquisitionTerms>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:acquisitionTerms>
            </bf:AcquisitionSource>
          </bf:acquisitionSource>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='352' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='352')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='q']">
          <xsl:variable name="vResource">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:CartographicDataType</xsl:when>
              <xsl:when test="@code='q'">bf:EncodingFormat</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="vProcess">
            <xsl:choose>
              <xsl:when test="@code='a'">chopPunctuation</xsl:when>
              <xsl:when test="@code='q'">chopPunctuation</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:apply-templates select="." mode="generateProperty">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
            <xsl:with-param name="pResource" select="$vResource"/>
            <xsl:with-param name="pProcess" select="$vProcess"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:digitalCharacteristic>
            <bf:CartographicObjectType>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:if test="following-sibling::marc:subfield[position()=1]/@code = 'c'">
                <bf:count>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="following-sibling::marc:subfield[position()=1][@code='c']"/>
                    <xsl:with-param name="pChopParens" select="true()"/>
                  </xsl:call-template>
                </bf:count>
              </xsl:if>
            </bf:CartographicObjectType>
          </bf:digitalCharacteristic>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='362' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='362')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="@ind1='0'">
        <xsl:choose>
          <!-- process as a note under some conditions -->
          <xsl:when test="contains(marc:subfield[@code='a'],';')
                          or not(contains(marc:subfield[@code='a'],'-'))">
            <xsl:call-template name="numberingNote">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
              <xsl:with-param name="pNote" select="marc:subfield[@code='a']/text()"/>
            </xsl:call-template>
          </xsl:when>
          <!-- '=' indicates parallel statements -->
          <xsl:when test="contains(marc:subfield[@code='a'],'=')">
            <xsl:choose>
              <xsl:when test="not(contains(substring-after(marc:subfield[@code='a'],'='),'='))">
                <xsl:variable name="vStatement1">
                  <xsl:value-of select="normalize-space(substring-before(marc:subfield[@code='a'],'='))"/>
                </xsl:variable>
                <xsl:variable name="vStatement2">
                  <xsl:value-of select="normalize-space(substring-after(marc:subfield[@code='a'],'='))"/>
                </xsl:variable>
                <!-- first statement -->
                <xsl:choose>
                  <xsl:when test="contains($vStatement1,'&#x00029;-')">
                    <xsl:call-template name="firstLastIssue">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      <xsl:with-param name="pFirstIssue" select="concat(substring-before($vStatement1,'&#x00029;-'),'&#x00029;')"/>
                      <xsl:with-param name="pLastIssue" select="substring-after($vStatement1,'&#x00029;-')"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="contains($vStatement1,'-')
                                  and not(contains(substring-after($vStatement1,'-'),'-'))">
                    <xsl:call-template name="firstLastIssue">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      <xsl:with-param name="pFirstIssue" select="substring-before($vStatement1,'-')"/>
                      <xsl:with-param name="pLastIssue" select="substring-after($vStatement1,'-')"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="numberingNote">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      <xsl:with-param name="pNote" select="$vStatement1"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                <!-- second statement -->
                <xsl:choose>
                  <xsl:when test="contains($vStatement2,'&#x00029;-')">
                    <xsl:call-template name="firstLastIssue">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      <xsl:with-param name="pFirstIssue" select="concat(substring-before($vStatement2,'&#x00029;-'),'&#x00029;')"/>
                      <xsl:with-param name="pLastIssue" select="substring-after($vStatement2,'&#x00029;-')"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="contains($vStatement2,'-')
                                  and not(contains(substring-after($vStatement2,'-'),'-'))">
                    <xsl:call-template name="firstLastIssue">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      <xsl:with-param name="pFirstIssue" select="substring-before($vStatement2,'-')"/>
                      <xsl:with-param name="pLastIssue" select="substring-after($vStatement2,'-')"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="numberingNote">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      <xsl:with-param name="pNote" select="$vStatement2"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="numberingNote">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                  <xsl:with-param name="pNote" select="marc:subfield[@code='a']/text()"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- ')-' as split between first/last -->
          <xsl:when test="contains(marc:subfield[@code='a'],'&#x00029;-')">
            <xsl:call-template name="firstLastIssue">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
              <xsl:with-param name="pFirstIssue" select="concat(substring-before(marc:subfield[@code='a'],'&#x00029;-'),'&#x00029;')"/>
              <xsl:with-param name="pLastIssue" select="substring-after(marc:subfield[@code='a'],'&#x00029;-')"/>
            </xsl:call-template>
          </xsl:when>            
          <!-- more than one hyphen, too hard to parse -->
          <xsl:when test="contains(substring-after(marc:subfield[@code='a'],'-'),'-')">
            <xsl:call-template name="numberingNote">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
              <xsl:with-param name="pNote" select="marc:subfield[@code='a']/text()"/>
            </xsl:call-template>
          </xsl:when>
          <!-- the standard case (one hyphen, not parallel) -->
          <xsl:otherwise>
            <xsl:call-template name="firstLastIssue">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
              <xsl:with-param name="pFirstIssue" select="substring-before(marc:subfield[@code='a'],'-')"/>
              <xsl:with-param name="pLastIssue" select="substring-after(marc:subfield[@code='a'],'-')"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="numberingNote">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
          <xsl:with-param name="pNote" select="marc:subfield[@code='a']/text()"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="numberingNote">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pXmlLang"/>
    <xsl:param name="pNote"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:note>
          <bf:Note>
            <rdf:type>
              <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/number</xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$pXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$pNote"/>
            </rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="firstLastIssue">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pXmlLang"/>
    <xsl:param name="pFirstIssue"/>
    <xsl:param name="pLastIssue"/>
    <xsl:if test="$pFirstIssue != ''">
      <xsl:choose>
        <xsl:when test="$serialization='rdfxml'">
          <bf:firstIssue>
            <xsl:if test="$pXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$pFirstIssue"/>
            </xsl:call-template>
          </bf:firstIssue>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="$pLastIssue != ''">
      <xsl:choose>
        <xsl:when test="$serialization='rdfxml'">
          <bf:lastIssue>
            <xsl:if test="$pXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$pLastIssue"/>
            </xsl:call-template>
          </bf:lastIssue>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
