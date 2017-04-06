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
          <xsl:if test="$vValidLCC='true'">
            <bf:classification>
              <bf:ClassificationLcc>
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
              </bf:ClassificationLcc>
            </bf:classification>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='052']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work052" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='052' or @tag='880']" mode="work052">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="marc:subfield[@code='b']">
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:geographicCoverage>
                <bf:Place>
                  <xsl:apply-templates mode="place052" select="..">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pBpos" select="position()"/>
                  </xsl:apply-templates>
                </bf:Place>
              </bf:geographicCoverage>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <bf:geographicCoverage>
              <bf:Place>
                <xsl:apply-templates mode="place052" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Place>
            </bf:geographicCoverage>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='052' or @tag='880']" mode="place052">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pBpos"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vPlaceValue">
      <xsl:choose>
        <xsl:when test="$pBpos != ''"><xsl:value-of select="concat(marc:subfield[@code='a'],' ',marc:subfield[@code='b'][position()=$pBpos])"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="marc:subfield[@code='a']"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <rdf:value><xsl:value-of select="$vPlaceValue"/></rdf:value>
        <xsl:for-each select="marc:subfield[@code='d']">
          <rdfs:label>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </rdfs:label>
        </xsl:for-each>
        <xsl:if test="@ind1 = ' '">
          <bf:source>
            <bf:Source>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($classSchemes,'lcc')"/></xsl:attribute>
            </bf:Source>
          </bf:source>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='055']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work055" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='055' or @tag='880']" mode="work055">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
          <bf:classification>
            <bf:ClassificationLcc>
              <xsl:for-each select="marc:subfield[@code='a']">
                <bf:classificationPortion>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </bf:classificationPortion>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:itemPortion>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </bf:itemPortion>
              </xsl:for-each>
              <xsl:if test="@ind2 = '0' or @ind2 = '1' or @ind2 = '2'">
                <bf:source>
                  <bf:Source>
                    <rdfs:label>Library and Archives Canada</rdfs:label>
                  </bf:Source>
                </bf:source>
              </xsl:if>
            </bf:ClassificationLcc>
          </bf:classification>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='060']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:classification>
          <bf:ClassificationNlm>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:classificationPortion><xsl:value-of select="."/></bf:classificationPortion>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:itemPortion><xsl:value-of select="."/></bf:itemPortion>
            </xsl:for-each>
            <xsl:if test="@ind2 = '0'">
              <bf:source>
                <bf:Source>
                  <rdfs:label>National Library of Medicine</rdfs:label>
                </bf:Source>
              </bf:source>
            </xsl:if>
          </bf:ClassificationNlm>
        </bf:classification>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='070']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:classification>
          <bf:Classification>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:classificationPortion><xsl:value-of select="."/></bf:classificationPortion>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:itemPortion><xsl:value-of select="."/></bf:itemPortion>
            </xsl:for-each>
            <bf:source>
              <bf:Source>
                <rdfs:label>National Agricultural Library</rdfs:label>
              </bf:Source>
            </bf:source>
          </bf:Classification>
        </bf:classification>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vSubjectValue">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='x']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:subject>
          <rdfs:Resource>
            <rdf:value>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space($vSubjectValue)"/>
            </rdf:value>
            <xsl:choose>
              <xsl:when test="@ind2 = '0'">
                <bf:source>
                  <bf:Source>
                    <rdfs:label>agricola</rdfs:label>
                  </bf:Source>
                </bf:source>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
          </rdfs:Resource>
        </bf:subject>
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
          <bf:classification>
            <bf:Classification>
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
              <xsl:if test="../marc:subfield[@code='q']">
                <bf:adminMetadata>
                  <bf:AdminMetadata>
                    <xsl:for-each select="../marc:subfield[@code='q']">
                      <bf:assigner>
                        <bf:Agent>
                          <rdfs:label>
                            <xsl:if test="$vXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                          </rdfs:label>
                        </bf:Agent>
                      </bf:assigner>
                    </xsl:for-each>
                  </bf:AdminMetadata>
                </bf:adminMetadata>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="'rdfxml'"/>
              </xsl:apply-templates>
            </bf:Classification>
          </bf:classification>
        </xsl:for-each>
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
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </bf:edition>
              </xsl:for-each>
              <xsl:choose>
                <xsl:when test="../@ind1 = '0'"><bf:edition>full</bf:edition></xsl:when>
                <xsl:when test="../@ind1 = '1'"><bf:edition>abridged</bf:edition></xsl:when>
              </xsl:choose>
              <xsl:apply-templates select="../marc:subfield[@code='q']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:if test="../@ind2 = '0'">
                <bf:source>
                  <bf:Source>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                  </bf:Source>
                </bf:source>
              </xsl:if>
            </bf:ClassificationDdc>
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
          <bf:classification>
            <bf:Classification>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
              <xsl:if test="@code='z'">
                <bf:status>
                  <bf:Status>
                    <rdfs:label>invalid</rdfs:label>
                  </bf:Status>
                </bf:status>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="../@ind1='0'">
                  <bf:source>
                    <bf:Source>
                      <rdfs:label>sudocs</rdfs:label>
                    </bf:Source>
                  </bf:source>
                </xsl:when>
                <xsl:when test="../@ind1='1'">
                  <bf:source>
                    <bf:Source>
                      <rdfs:label>Government of Canada Publications</rdfs:label>
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
  
  <!-- instance match for field 074 in ConvSpec-010-048.xsl -->

  <xsl:template match="marc:datafield[@tag='050' or @tag='060']" mode="hasItem">
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

  <xsl:template match="marc:datafield[@tag='060']" mode="newItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pItemUri"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="@ind1='0'">
          <bf:Item>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$pItemUri"/></xsl:attribute>
            <bf:heldBy>
              <bf:Agent>
                <rdfs:label>National Library of Medicine</rdfs:label>
              </bf:Agent>
            </bf:heldBy>
          </bf:Item>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
