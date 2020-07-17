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
      Conversion specs for 050-088
  -->

  <xsl:template match="marc:datafield[@tag='050']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work050" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='050' or @tag='880']" mode="work050">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:variable name="vValidLCC">
            <xsl:call-template name="validateLCC">
              <xsl:with-param name="pCall" select="text()"/>
            </xsl:call-template>
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
          <xsl:if test="$vValidLCC='true'">
            <bf:classification>
              <bf:ClassificationLcc>
                <xsl:if test="$vCurrentNodeUri != ''">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="../@ind2 = '0'">
                  <bf:source>
                    <bf:Source>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                    </bf:Source>
                  </bf:source>
                </xsl:if>
                <bf:classificationPortion>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </bf:classificationPortion>
                <xsl:if test="position() = 1">
                  <xsl:for-each select="../marc:subfield[@code='b'][position()=1]">
                    <bf:itemPortion>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="."/>
                    </bf:itemPortion>
                  </xsl:for-each>
                </xsl:if>
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
              </bf:ClassificationLcc>
            </bf:classification>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='052']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vLabel1">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vLabel2">
      <xsl:if test="marc:subfield[@code='d']">
        <xsl:apply-templates select="marc:subfield[@code='a' or @code='d']" mode="concat-nodes-space"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vNodeUri">
      <xsl:for-each select="marc:subfield[@code='0' and contains(text(),'://')][1]">
        <xsl:choose>
          <xsl:when test="starts-with(.,'(uri)')">
            <xsl:value-of select="substring-after(.,'(uri)')"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="($vLabel1 != '') or ($vLabel2 != '') or ($vNodeUri != '')">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:geographicCoverage>
            <bf:GeographicCoverage>
              <xsl:if test="$vNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vNodeUri"/></xsl:attribute>
              </xsl:if>
              <xsl:if test="@ind1 = ' '">
                <bf:source>
                  <bf:Source>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/authorities/classification/G</xsl:attribute>
                  </bf:Source>
                </bf:source>
              </xsl:if>
              <xsl:if test="$vLabel1 != ''">
                <rdfs:label><xsl:value-of select="normalize-space($vLabel1)"/></rdfs:label>
              </xsl:if>
              <xsl:if test="$vLabel2 != ''">
                <rdfs:label><xsl:value-of select="normalize-space($vLabel2)"/></rdfs:label>
              </xsl:if>
              <xsl:for-each select="marc:subfield[@code='0' and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='0' and not(contains(text(),'://'))]">
                <xsl:apply-templates select="." mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </bf:GeographicCoverage>
          </bf:geographicCoverage>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='055']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vNodeUri">
      <xsl:for-each select="marc:subfield[@code='0' and contains(text(),'://')][1]">
        <xsl:choose>
          <xsl:when test="starts-with(.,'(uri)')">
            <xsl:value-of select="substring-after(.,'(uri)')"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
          <bf:classification>
            <bf:ClassificationLcc>
              <xsl:if test="$vNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vNodeUri"/></xsl:attribute>
              </xsl:if>
              <xsl:for-each select="marc:subfield[@code='a']">
                <bf:classificationPortion>
                  <xsl:value-of select="."/>
                </bf:classificationPortion>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:itemPortion>
                  <xsl:value-of select="."/>
                </bf:itemPortion>
              </xsl:for-each>
              <xsl:if test="@ind2 = '0' or @ind2 = '1' or @ind2 = '2'">
                <bf:assigner>
                  <bf:Agent>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/authorities/names/no2004037399</xsl:attribute>
                  </bf:Agent>
                </bf:assigner>
              </xsl:if>
              <xsl:for-each select="marc:subfield[@code='0' and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='0' and not(contains(text(),'://'))]">
                <xsl:apply-templates select="." mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </bf:ClassificationLcc>
          </bf:classification>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='060']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
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
          <bf:classification>
            <bf:ClassificationNlm>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <bf:classificationPortion><xsl:value-of select="."/></bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion><xsl:value-of select="."/></bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="../@ind2 = '0'">
                <bf:assigner>
                  <bf:Agent>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/organizations/dnlm</xsl:attribute>
                  </bf:Agent>
                </bf:assigner>
              </xsl:if>
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
            </bf:ClassificationNlm>
          </bf:classification>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='070']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
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
          <bf:classification>
            <bf:Classification>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <bf:classificationPortion><xsl:value-of select="."/></bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion><xsl:value-of select="."/></bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
              <bf:source>
                <bf:Source>
                  <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/organizations/dnal</xsl:attribute>
                  <rdfs:label>National Agricultural Library</rdfs:label>
                </bf:Source>
              </bf:source>
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
            </bf:Classification>
          </bf:classification>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='072']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work072" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='072' or @tag='880']" mode="work072">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vSubjectValue">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='x']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:subject>
          <bf:Topic>
            <bf:code><xsl:value-of select="normalize-space($vSubjectValue)"/></bf:code>
            <xsl:choose>
              <xsl:when test="@ind2 = '0'">
                <bf:source>
                  <bf:Source>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/classSchemes/agricola</xsl:attribute>
                  </bf:Source>
                </bf:source>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="marc:subfield[@code='2']">
                  <xsl:choose>
                    <xsl:when test="text()='bisacsh'">
                      <bf:source>
                        <bf:Source>
                          <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/classSchemes/bisacsh</xsl:attribute>
                        </bf:Source>
                      </bf:source>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="." mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </bf:Topic>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='082']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work082" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='082' or @tag='880']" mode="work082">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:classification>
            <bf:ClassificationDdc>
              <bf:classificationPortion>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='2']">
                <bf:edition>
                  <xsl:choose>
                    <xsl:when test="string-length(.)=2 and contains('0123456789',substring(.,1,1)) and contains('0123456789',substring(.,2,1))">
                      <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'anyURI')"/></xsl:attribute>
                      <xsl:value-of select="concat('http://id.loc.gov/vocabulary/classSchemes/ddc',.)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </bf:edition>
              </xsl:for-each>
              <xsl:choose>
                <xsl:when test="../@ind1 = '0'"><bf:edition>full</bf:edition></xsl:when>
                <xsl:when test="../@ind1 = '1'"><bf:edition>abridged</bf:edition></xsl:when>
              </xsl:choose>
              <xsl:if test="../@ind2 = '0'">
                <bf:assigner>
                  <bf:Agent>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                  </bf:Agent>
                </bf:assigner>
              </xsl:if>
            </bf:ClassificationDdc>
          </bf:classification>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='084']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work084" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='084' or @tag='880']" mode="work084">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
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
          <bf:classification>
            <bf:Classification>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <bf:classificationPortion>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
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
                <xsl:with-param name="serialization" select="'rdfxml'"/>
              </xsl:apply-templates>
            </bf:Classification>
          </bf:classification>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- instance match for field 074 in ConvSpec-010-048.xsl -->

  <xsl:template match="marc:datafield[@tag='086']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance086">
      <xsl:with-param name="serialization" select="'rdfxml'"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='086' or @tag='880']" mode="instance086">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
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
          <bf:classification>
            <bf:Classification>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
              <xsl:if test="@code='z'">
                <bf:status>
                  <bf:Status>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mstatus/cancinv</xsl:attribute>
                    <rdfs:label>invalid</rdfs:label>
                  </bf:Status>
                </bf:status>
              </xsl:if>
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
              <xsl:choose>
                <xsl:when test="../@ind1='0'">
                  <bf:source>
                    <bf:Source>
                      <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/classSchemes/sudocs</xsl:attribute>
                    </bf:Source>
                  </bf:source>
                </xsl:when>
                <xsl:when test="../@ind1='1'">
                  <bf:source>
                    <bf:Source>
                      <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/classSchemes/cacodoc</xsl:attribute>
                    </bf:Source>
                  </bf:source>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../marc:subfield[@code='2']">
                    <bf:source>
                      <bf:Source>
                        <rdfs:label>
                          <xsl:if test="$vXmlLang != ''">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                          </xsl:if>
                          <xsl:value-of select="."/>
                        </rdfs:label>
                      </bf:Source>
                    </bf:source>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </bf:Classification>
          </bf:classification>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- instance match for fields 074, 088 in ConvSpec-010-048.xsl -->

  <xsl:template match="marc:datafield[@tag='050']" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasItem>
          <xsl:apply-templates select="." mode="newItem">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="pItemUri" select="$vItemUri"/>
          </xsl:apply-templates>
        </bf:hasItem>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='050']" mode="newItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pItemUri"/>
    <xsl:variable name="vShelfMark">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='b']">
          <xsl:choose>
            <xsl:when test="substring(marc:subfield[@code='b'],1,1) = '.'"><xsl:value-of select="normalize-space(concat(marc:subfield[@code='a'][1],marc:subfield[@code='b'][1]))"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(concat(marc:subfield[@code='a'][1],' ',marc:subfield[@code='b']))"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="normalize-space(marc:subfield[@code='a'][1])"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vValidLCC">
      <xsl:call-template name="validateLCC">
        <xsl:with-param name="pCall" select="marc:subfield[@code='a'][1]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vShelfMarkClass">
      <xsl:choose>
        <xsl:when test="$vValidLCC='true'">bf:ShelfMarkLcc</xsl:when>
        <xsl:otherwise>bf:ShelfMark</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Item>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$pItemUri"/></xsl:attribute>
          <bf:shelfMark>
            <xsl:element name="{$vShelfMarkClass}">
              <rdfs:label><xsl:value-of select="$vShelfMark"/></rdfs:label>
              <xsl:if test="@ind2 = '0'">
                <bf:source>
                  <bf:Source>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/organizations/dlc</xsl:attribute>
                  </bf:Source>
                </bf:source>
              </xsl:if>
            </xsl:element>
          </bf:shelfMark>
          <xsl:for-each select="../marc:datafield[@tag='051']">
            <xsl:variable name="vClassLabel">
              <xsl:choose>
                <xsl:when test="marc:subfield[@code='b']">
                  <xsl:choose>
                    <xsl:when test="substring(marc:subfield[@code='b'],1,1) = '.'"><xsl:value-of select="normalize-space(concat(marc:subfield[@code='a'],marc:subfield[@code='b'],' ',marc:subfield[@code='c']))"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="normalize-space(concat(marc:subfield[@code='a'],' ',marc:subfield[@code='b'],' ',marc:subfield[@code='c']))"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="normalize-space(concat(marc:subfield[@code='a'],' ',marc:subfield[@code='c']))"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <bf:shelfMark>
              <bf:ShelfMarkLcc>
                <rdfs:label>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString"><xsl:value-of select="$vClassLabel"/></xsl:with-param>
                  </xsl:call-template>
                </rdfs:label>
              </bf:ShelfMarkLcc>
            </bf:shelfMark>
          </xsl:for-each>
          <bf:itemOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
          </bf:itemOf>
        </bf:Item>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
