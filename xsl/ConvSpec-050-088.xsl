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

  <xsl:template match="marc:datafield[@tag='050' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='050')]" mode="work">
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
            <bf:ClassificationLcc>
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <bf:classificationPortion>
                <xsl:value-of select="."/>
              </bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b'][position()=1]">
                  <bf:itemPortion>
                    <xsl:value-of select="."/>
                  </bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="../@ind2 = '0'">
                <bf:assigner>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                </bf:assigner>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="../@ind1 = '0'">
                  <bf:status>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'uba')"/></xsl:attribute>
                  </bf:status>
                </xsl:when>
                <xsl:when test="../@ind1 = '1'">
                  <bf:status>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'nuba')"/></xsl:attribute>
                  </bf:status>
                </xsl:when>
              </xsl:choose>
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
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[(@tag='052' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='052')) and @ind1=' ']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="marc:subfield[@code='b']">
        <xsl:for-each select="marc:subfield[@code='b']">
          <xsl:variable name="vUri">
            <xsl:value-of select="concat($classG,../marc:subfield[@code='a'],'.',.)"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bf:geographicCoverage>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$vUri"/></xsl:attribute>
              </bf:geographicCoverage>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:geographicCoverage>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($classG,.)"/></xsl:attribute>
              </bf:geographicCoverage>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work052">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='d']">
          <bf:place>
            <bf:Place>
              <rdfs:label>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Place>
          </bf:place>
        </xsl:for-each>
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
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='055' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='055')]" mode="work">
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
                <xsl:attribute name="rdf:resource">http://id.loc.gov/authorities/names/no2004037399</xsl:attribute>
              </bf:assigner>
              <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                  <bf:status>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'uba')"/></xsl:attribute>
                  </bf:status>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                  <bf:status>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'nuba')"/></xsl:attribute>
                  </bf:status>
                </xsl:when>
              </xsl:choose>
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

  <xsl:template match="marc:datafield[@tag='060' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='060')]" mode="work">
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
                  <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/organizations/dnlm</xsl:attribute>
                </bf:assigner>
                <xsl:choose>
                  <xsl:when test="../@ind1 = '0'">
                    <bf:status>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'uba')"/></xsl:attribute>
                    </bf:status>
                  </xsl:when>
                  <xsl:when test="../@ind1 = '1'">
                    <bf:status>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'nuba')"/></xsl:attribute>
                    </bf:status>
                  </xsl:when>
                </xsl:choose>
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
  
  <xsl:template match="marc:datafield[@tag='070' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='070')]" mode="work">
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
              <xsl:if test="../@ind1='0'">
                <bf:assigner>
                    <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/organizations/dnal</xsl:attribute>
                </bf:assigner>
                <bf:status>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($mstatus,'uba')"/></xsl:attribute>
                </bf:status>
              </xsl:if>
              <bf:classificationPortion><xsl:value-of select="."/></bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion><xsl:value-of select="."/></bf:itemPortion>
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
            </bf:Classification>
          </bf:classification>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='072' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='072')]" mode="work">
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

  <xsl:template match="marc:datafield[@tag='082' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='082')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:classification>
          <bf:ClassificationDdc>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:classificationPortion>
                <xsl:value-of select="."/>
              </bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion>
                    <xsl:value-of select="."/>
                  </bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='q']">
              <bf:assigner>
                <bf:Agent>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Agent>
              </bf:assigner>
            </xsl:for-each>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:choose>
              <xsl:when test="@ind1 = '0'"><bf:edition>full</bf:edition></xsl:when>
              <xsl:when test="@ind1 = '1'"><bf:edition>abridged</bf:edition></xsl:when>
            </xsl:choose>
            <xsl:if test="@ind2 = '0'">
              <bf:assigner>
                <bf:Agent>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                </bf:Agent>
              </bf:assigner>
            </xsl:if>
          </bf:ClassificationDdc>
        </bf:classification>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='084' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='084')]" mode="work">
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
              <bf:classificationPortion>
                <xsl:value-of select="."/>
              </bf:classificationPortion>
              <xsl:if test="position() = 1">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:itemPortion>
                    <xsl:value-of select="."/>
                  </bf:itemPortion>
                </xsl:for-each>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='q']">
                <bf:assigner>
                  <bf:Agent>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Agent>
                </bf:assigner>
              </xsl:for-each>
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

  <xsl:template match="marc:datafield[@tag='086' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='086')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
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
                        <bf:code>
                          <xsl:value-of select="."/>
                        </bf:code>
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

  <xsl:template match="marc:datafield[@tag='051']" mode="item">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:classification>
            <bf:ClassificationLcc>
              <bf:classificationPortion>
                <xsl:value-of select="marc:subfield[@code='a']"/>
              </bf:classificationPortion>
                  <xsl:if test="marc:subfield[@code='b']">
                <bf:itemPortion>
                  <xsl:value-of select="marc:subfield[@code='b']"/>
                </bf:itemPortion>
              </xsl:if>                  
              <xsl:if test="marc:subfield[@code='c']">
                <bf:note>
                  <bf:Note>
                    <rdfs:label><xsl:value-of select="marc:subfield[@code='c']"/></rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:if>
              <bf:assigner>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
              </bf:assigner>
            </bf:ClassificationLcc>
          </bf:classification>
        </xsl:when>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
