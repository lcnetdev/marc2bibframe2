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
      Conversion specs for 600-662
  -->

  <xsl:template match="marc:datafield[@tag='600' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='600')] |
                       marc:datafield[@tag='610' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='610')] |
                       marc:datafield[@tag='611' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='611')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="vHubIri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="vTopicUri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Topic<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Topic</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work6XXName" select=".">
      <xsl:with-param name="agentiri" select="$agentiri"/>
      <xsl:with-param name="pHubIri" select="$vHubIri"/>
      <xsl:with-param name="pTopicUri" select="$vTopicUri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work6XXName">
    <xsl:param name="agentiri"/>
    <xsl:param name="pHubIri"/>
    <xsl:param name="pTopicUri"/>
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vSourceURI"><xsl:value-of select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/bfsource"/></xsl:variable>
    <xsl:variable name="vMADSClass">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">ComplexSubject</xsl:when>
        <xsl:when test="marc:subfield[@code='t']">NameTitle</xsl:when>
        <xsl:when test="$vTag='600'">
          <xsl:choose>
            <xsl:when test="@ind1='3'">FamilyName</xsl:when>
            <xsl:otherwise>PersonalName</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='610'">CorporateName</xsl:when>
        <xsl:when test="$vTag='611'">ConferenceName</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vMADSNameClass">
      <xsl:choose>
        <xsl:when test="$vTag='600'">
          <xsl:choose>
            <xsl:when test="@ind1='3'">FamilyName</xsl:when>
            <xsl:otherwise>PersonalName</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='610'">CorporateName</xsl:when>
        <xsl:when test="$vTag='611'">ConferenceName</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vNameLabel">
      <xsl:apply-templates select="." mode="tNameLabel"/>
    </xsl:variable>
    <xsl:variable name="vTitleLabel">
      <xsl:apply-templates select="." mode="tTitleLabel"/>
    </xsl:variable>
    <xsl:variable name="vMADSLabel">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pEndPunct" select="'-'"/>
        <xsl:with-param name="pString">
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="concat($vNameLabel,' ',$vTitleLabel)"/>
          </xsl:call-template>
          <xsl:text>--</xsl:text>
          <xsl:for-each select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:variable name="vSource">
          <xsl:choose>
            <xsl:when test="$vSourceURI != ''">
              <bf:source>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$vSourceURI"/></xsl:attribute>
              </bf:source>
            </xsl:when>
            <xsl:when test="@ind2='4' or @ind2='7'">
              <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pVocabStem" select="$subjectSchemes"/>
              </xsl:apply-templates>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <bf:subject>
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']">
              <xsl:choose>
                <xsl:when test="$vMADSClass='ComplexSubject'">
                  <bf:Topic>
                    <xsl:if test="$pTopicUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$pTopicUri"/></xsl:attribute>
                    </xsl:if>
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$vMADSClass)"/></xsl:attribute>
                    </rdf:type>
                    <madsrdf:authoritativeLabel>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$vMADSLabel"/>
                    </madsrdf:authoritativeLabel>
                    <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
                      <madsrdf:isMemberOfMADSScheme>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                      </madsrdf:isMemberOfMADSScheme>
                    </xsl:for-each>                  
                    <xsl:if test="$vSource">
                      <xsl:copy-of select="$vSource"/>
                    </xsl:if>
                    <!-- build the ComplexSubject -->
                    <madsrdf:componentList rdf:parseType="Collection">
                      <xsl:apply-templates select="." mode="work6XXHub">
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="pHubIri" select="$pHubIri"/>
                        <xsl:with-param name="agentiri" select="$agentiri"/>
                        <xsl:with-param name="recordid" select="$recordid"/>
                        <xsl:with-param name="pMADSClass" select="'NameTitle'"/>
                        <xsl:with-param name="pMADSLabel">
                          <xsl:call-template name="tChopPunct">
                            <xsl:with-param name="pString" select="normalize-space(concat($vNameLabel,' ',$vTitleLabel))"/>
                          </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="pSource" select="$vSource"/>
                        <xsl:with-param name="pTag" select="$vTag"/>
                      </xsl:apply-templates>
                      <xsl:apply-templates select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="pTag" select="$vTag"/>
                        <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      </xsl:apply-templates>
                    </madsrdf:componentList>
                  </bf:Topic>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="work6XXHub">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pHubIri" select="$pHubIri"/>
                    <xsl:with-param name="agentiri" select="$agentiri"/>
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="pMADSClass" select="$vMADSClass"/>
                    <xsl:with-param name="pMADSLabel" select="$vMADSLabel"/>
                    <xsl:with-param name="pSource" select="$vSource"/>
                    <xsl:with-param name="pTag" select="$vTag"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$vMADSClass='ComplexSubject'">
                  <bf:Topic>
                    <xsl:if test="$pTopicUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$pTopicUri"/></xsl:attribute>
                    </xsl:if>
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$vMADSClass)"/></xsl:attribute>
                    </rdf:type>
                    <madsrdf:authoritativeLabel>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="$vMADSLabel"/>
                    </madsrdf:authoritativeLabel>
                    <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
                      <madsrdf:isMemberOfMADSScheme>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                      </madsrdf:isMemberOfMADSScheme>
                    </xsl:for-each>                  
                    <xsl:if test="$vSource">
                      <xsl:copy-of select="$vSource"/>
                    </xsl:if>
                    <!-- build the ComplexSubject -->
                    <madsrdf:componentList rdf:parseType="Collection">
                      <xsl:apply-templates select="." mode="agent">
                        <xsl:with-param name="agentiri" select="$agentiri"/>
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="recordid" select="$recordid"/>
                        <xsl:with-param name="pMADSClass" select="$vMADSNameClass"/>
                        <xsl:with-param name="pMADSLabel">
                          <xsl:call-template name="tChopPunct">
                            <xsl:with-param name="pString" select="normalize-space(concat($vNameLabel,' ',$vTitleLabel))"/>
                          </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="pSource" select="$vSource"/>
                      </xsl:apply-templates>
                      <xsl:apply-templates select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="pTag" select="$vTag"/>
                        <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                      </xsl:apply-templates>
                    </madsrdf:componentList>
                  </bf:Topic>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="agent">
                    <xsl:with-param name="agentiri" select="$agentiri"/>
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="pMADSClass" select="$vMADSClass"/>
                    <xsl:with-param name="pMADSLabel" select="$vMADSLabel"/>
                    <xsl:with-param name="pSource" select="$vSource"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work6XXHub">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHubIri"/>
    <xsl:param name="agentiri"/>
    <xsl:param name="recordid"/>
    <xsl:param name="pMADSClass"/>
    <xsl:param name="pMADSLabel"/>
    <xsl:param name="pSource"/>
    <xsl:param name="pTag"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Hub>
          <xsl:if test="$pHubIri != ''">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$pHubIri"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$pMADSClass != ''">
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$pMADSClass)"/></xsl:attribute>
            </rdf:type>
          </xsl:if>
          <xsl:if test="$pMADSLabel != ''">
            <madsrdf:authoritativeLabel>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$pMADSLabel"/>
            </madsrdf:authoritativeLabel>
          </xsl:if>
          <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
            <madsrdf:isMemberOfMADSScheme>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
            </madsrdf:isMemberOfMADSScheme>
          </xsl:for-each>
          <xsl:if test="$pSource != ''">
            <xsl:copy-of select="$pSource"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="substring($pTag,2,2)='11'">
              <xsl:apply-templates select="marc:subfield[@code='j']" mode="contributionRole">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pMode">relationship</xsl:with-param>
                <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pMode">relationship</xsl:with-param>
                <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:for-each select="marc:subfield[@code='4']">
            <xsl:variable name="vRelationUri">
              <xsl:choose>
                <xsl:when test="string-length(.) = 3">
                  <xsl:variable name="encoded">
                    <xsl:call-template name="url-encode">
                      <xsl:with-param name="str" select="."/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:value-of select="concat($relators,$encoded)"/>
                </xsl:when>
                <xsl:when test="contains(.,'://')">
                  <xsl:value-of select="."/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <bflc:relationship>
              <bflc:Relationship>
                <bflc:relation>
                  <bflc:Relation>
                    <xsl:choose>
                      <xsl:when test="$vRelationUri != ''">
                        <xsl:attribute name="rdf:about"><xsl:value-of select="$vRelationUri"/></xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <bf:code><xsl:value-of select="."/></bf:code>
                      </xsl:otherwise>
                    </xsl:choose>
                  </bflc:Relation>
                </bflc:relation>
                <bf:relatedTo>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                </bf:relatedTo>
              </bflc:Relationship>
            </bflc:relationship>
          </xsl:for-each>
          <xsl:apply-templates select="." mode="workName">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="agentiri" select="$agentiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Hub>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="marc:datafield[@tag='630' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='630')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vHubIri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="vTopicUri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Topic<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Topic</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work630" select=".">
      <xsl:with-param name="pHubIri" select="$vHubIri"/>
      <xsl:with-param name="pTopicUri" select="$vTopicUri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work630">
    <xsl:param name="recordid"/>
    <xsl:param name="pHubIri"/>
    <xsl:param name="pTopicUri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vSourceURI"><xsl:value-of select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/bfsource"/></xsl:variable>
    <xsl:variable name="vMADSClass">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">ComplexSubject</xsl:when>
        <xsl:otherwise>Title</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vTitleLabel">
      <xsl:apply-templates select="." mode="tTitleLabel"/>
    </xsl:variable>
    <xsl:variable name="vMADSLabel">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pEndPunct" select="'-'"/>
        <xsl:with-param name="pString">
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="$vTitleLabel"/>
          </xsl:call-template>
          <xsl:text>--</xsl:text>
          <xsl:for-each select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:variable name="vSource">
          <xsl:choose>
            <xsl:when test="$vSourceURI != ''">
              <bf:source>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$vSourceURI"/></xsl:attribute>
              </bf:source>
            </xsl:when>
            <xsl:when test="@ind2='4' or @ind2='7'">
              <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pVocabStem" select="$subjectSchemes"/>
              </xsl:apply-templates>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <bf:subject>
          <xsl:choose>
            <xsl:when test="$vMADSClass='ComplexSubject'">
              <bf:Topic>
                <xsl:if test="$pTopicUri != ''">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$pTopicUri"/></xsl:attribute>
                </xsl:if>
                <rdf:type>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$vMADSClass)"/></xsl:attribute>
                </rdf:type>
                <madsrdf:authoritativeLabel>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vMADSLabel"/>
                </madsrdf:authoritativeLabel>
                <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
                  <madsrdf:isMemberOfMADSScheme>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                  </madsrdf:isMemberOfMADSScheme>
                </xsl:for-each>                  
                <xsl:if test="$vSource">
                  <xsl:copy-of select="$vSource"/>
                </xsl:if>
                <!-- build the ComplexSubject -->
                <madsrdf:componentList rdf:parseType="Collection">
                  <xsl:apply-templates select="." mode="work630Hub">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pHubIri" select="$pHubIri"/>
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="pMADSClass" select="'Title'"/>
                    <xsl:with-param name="pMADSLabel">
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="normalize-space($vTitleLabel)"/>
                      </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="pSource" select="$vSource"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pTag" select="$vTag"/>
                    <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                  </xsl:apply-templates>
                </madsrdf:componentList>
              </bf:Topic>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="work630Hub">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pHubIri" select="$pHubIri"/>
                <xsl:with-param name="recordid" select="$recordid"/>
                <xsl:with-param name="pMADSClass" select="'Title'"/>
                <xsl:with-param name="pMADSLabel" select="$vMADSLabel"/>
                <xsl:with-param name="pSource" select="$vSource"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work630Hub">
    <xsl:param name="recordid"/>
    <xsl:param name="pHubIri"/>
    <xsl:param name="pMADSClass"/>
    <xsl:param name="pMADSLabel"/>
    <xsl:param name="pSource"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Hub>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$pHubIri"/></xsl:attribute>
          <xsl:if test="$pMADSClass != ''">
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$pMADSClass)"/></xsl:attribute>
            </rdf:type>
          </xsl:if>
          <madsrdf:authoritativeLabel><xsl:value-of select="$pMADSLabel"/></madsrdf:authoritativeLabel>
          <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
            <madsrdf:isMemberOfMADSScheme>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
            </madsrdf:isMemberOfMADSScheme>
          </xsl:for-each>                  
          <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pMode">relationship</xsl:with-param>
            <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
          </xsl:apply-templates>
          <xsl:for-each select="marc:subfield[@code='4']">
            <xsl:variable name="encoded">
              <xsl:call-template name="url-encode">
                <xsl:with-param name="str" select="normalize-space(substring(.,1,3))"/>
              </xsl:call-template>
            </xsl:variable>
            <bflc:relationship>
              <bflc:Relationship>
                <bflc:relation>
                  <bflc:Relation>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,$encoded)"/></xsl:attribute>
                  </bflc:Relation>
                </bflc:relation>
                <bf:relatedTo>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                </bf:relatedTo>
              </bflc:Relationship>
            </bflc:relationship>
          </xsl:for-each>
          <xsl:apply-templates select="." mode="hubUnifTitle">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pSource" select="$pSource"/>
          </xsl:apply-templates>
        </bf:Hub>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    
  
  <xsl:template match="marc:datafield[@tag='648' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='648')] |
                       marc:datafield[@tag='650' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='650')] |
                       marc:datafield[@tag='651' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='651')] |
                       marc:datafield[@tag='655' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='655')][@ind1=' ']"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <!-- special processing only for 655 -->
    <xsl:if test="@tag != '655' or $pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vDefaultUri">
        <xsl:choose>
          <xsl:when test="@tag='648'">
            <xsl:value-of select="$recordid"/>#Temporal<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/>
          </xsl:when>
          <xsl:when test="@tag='651'">
            <xsl:value-of select="$recordid"/>#Place<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/>
          </xsl:when>
          <xsl:when test="@tag='655'">
            <xsl:value-of select="$recordid"/>#GenreForm<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$recordid"/>#Topic<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vTopicUri">
        <xsl:apply-templates mode="generateUri" select=".">
          <xsl:with-param name="pDefaultUri" select="$vDefaultUri"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:apply-templates select="." mode="work6XXAuth">
        <xsl:with-param name="pTopicUri" select="$vTopicUri"/>
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work6XXAuth">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:param name="pTopicUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProp">
      <xsl:choose>
        <xsl:when test="$vTag='655'">bf:genreForm</xsl:when>
        <xsl:otherwise>bf:subject</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vResource">
      <xsl:choose>
        <xsl:when test="$vTag='648'">bf:Temporal</xsl:when>
        <xsl:when test="$vTag='651'">bf:Place</xsl:when>
        <xsl:when test="$vTag='655'">bf:GenreForm</xsl:when>
        <xsl:otherwise>bf:Topic</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vSourceURI"><xsl:value-of select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/bfsource"/></xsl:variable>
    <xsl:variable name="vMADSClass">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">ComplexSubject</xsl:when>
        <xsl:when test="$vTag='648'">Temporal</xsl:when>
        <xsl:when test="$vTag='650'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='b' or @code='c' or @code='d']">ComplexSubject</xsl:when>
            <xsl:otherwise>Topic</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='651'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='b']">ComplexSubject</xsl:when>
            <xsl:otherwise>Geographic</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='655'">Topic</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pEndPunct" select="'-'"/>
        <xsl:with-param name="pString">
          <xsl:choose>
            <xsl:when test="$vTag='650'">
              <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='v' or @code='x' or @code='y' or @code='z']">
                <xsl:value-of select="concat(.,'--')"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="$vTag='651'">
              <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='v' or @code='x' or @code='y' or @code='z']">
                <xsl:value-of select="concat(.,'--')"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="marc:subfield[@code='a' or @code='v' or @code='x' or @code='y' or @code='z']">
                <xsl:value-of select="concat(.,'--')"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vProp}">
          <xsl:element name="{$vResource}">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$pTopicUri"/></xsl:attribute>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$vMADSClass)"/></xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
            <madsrdf:authoritativeLabel>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </madsrdf:authoritativeLabel>
            <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
              <madsrdf:isMemberOfMADSScheme>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
              </madsrdf:isMemberOfMADSScheme>
            </xsl:for-each>
            <!-- build the ComplexSubject -->
            <xsl:if test="$vMADSClass='ComplexSubject'">
              <madsrdf:componentList rdf:parseType="Collection">
                <xsl:choose>
                  <xsl:when test="$vTag='650'">
                    <xsl:apply-templates select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pTag" select="$vTag"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$vTag='651'">
                    <xsl:apply-templates select="marc:subfield[@code='a' or @code='b' or @code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pTag" select="$vTag"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="marc:subfield[@code='a' or @code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pTag" select="$vTag"/>
                      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
                    </xsl:apply-templates>
                  </xsl:otherwise>
                </xsl:choose>
              </madsrdf:componentList>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='g']">
              <bf:note>
                <bf:Note>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:choose>
              <xsl:when test="$vSourceURI != ''">
                <bf:source>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$vSourceURI"/></xsl:attribute>
                </bf:source>
              </xsl:when>
              <xsl:when test="@ind2='4' or @ind2='7'">
                <xsl:variable name="vVocabStem">
                  <xsl:choose>
                    <xsl:when test="$vTag='655'"><xsl:value-of select="$genreFormSchemes"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$subjectSchemes"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pVocabStem" select="$vVocabStem"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
            <xsl:for-each select="marc:subfield[@code='e']">
              <bf:role>
                <bf:Role>
                  <rdfs:label>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Role>
              </bf:role>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:if test="position() != 1">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w']">
              <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates mode="subfield3" select="marc:subfield[@code='3']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='653' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='653')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProp">
      <xsl:choose>
        <xsl:when test="@ind2='6'">bf:genreForm</xsl:when>
        <xsl:otherwise>bf:subject</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vResource">
      <xsl:choose>
        <xsl:when test="@ind2='1'">bf:Person</xsl:when>
        <xsl:when test="@ind2='2'">bf:Organization</xsl:when>
        <xsl:when test="@ind2='3'">bf:Meeting</xsl:when>
        <xsl:when test="@ind2='4'">bf:Temporal</xsl:when>
        <xsl:when test="@ind2='5'">bf:Place</xsl:when>
        <xsl:when test="@ind2='6'">bf:GenreForm</xsl:when>
        <xsl:otherwise>bf:Topic</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:element name="{$vProp}">
            <xsl:element name="{$vResource}">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='656' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='656')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vDefaultUri">
      <xsl:value-of select="$recordid"/>#Topic<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/>
    </xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pEndPunct" select="'-'"/>
        <xsl:with-param name="pString">
          <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vTopicUri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri" select="$vDefaultUri"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:subject>
          <bf:Topic>
            <xsl:if test="$vTopicUri != ''">
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vTopicUri"/></xsl:attribute>
            </xsl:if>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'ComplexSubject')"/></xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
            <madsrdf:componentList rdf:parseType="Collection">
              <xsl:apply-templates select="marc:subfield[@code='a' or @code='k' or @code='v' or @code='x' or @code='y' or @code='z']" mode="complexSubject">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pTag" select="$vTag"/>
                <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
              </xsl:apply-templates>
            </madsrdf:componentList>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:if test="position() != 1">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w']">
              <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Topic>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='662' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='662')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vDefaultUri">
      <xsl:value-of select="$recordid"/>#Place<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pEndPunct" select="'-'"/>
        <xsl:with-param name="pString">
          <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vPlaceUri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri" select="$vDefaultUri"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:subject>
          <bf:Place>
            <xsl:if test="$vPlaceUri != ''">
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vPlaceUri"/></xsl:attribute>
            </xsl:if>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'HierarchicalGeographic')"/></xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
            <madsrdf:componentList rdf:parseType="Collection">
              <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
                <xsl:variable name="vResource">
                  <xsl:choose>
                    <xsl:when test="@code='a'">madsrdf:Country</xsl:when>
                    <xsl:when test="@code='b'">madsrdf:State</xsl:when>
                    <xsl:when test="@code='c'">madsrdf:County</xsl:when>
                    <xsl:when test="@code='d'">madsrdf:City</xsl:when>
                    <xsl:when test="@code='f'">madsrdf:CitySection</xsl:when>
                    <xsl:when test="@code='g'">madsrdf:Region</xsl:when>
                    <xsl:when test="@code='h'">madsrdf:ExtraterrestrialArea</xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$vResource}">
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </xsl:element>
              </xsl:for-each>
            </madsrdf:componentList>
            <xsl:for-each select="marc:subfield[@code='e']">
              <bf:role>
                <bf:Role>
                  <rdfs:label>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Role>
              </bf:role>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:if test="position() != 1">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w']">
              <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pVocabStem" select="$subjectSchemes"/>
            </xsl:apply-templates>
          </bf:Place>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield" mode="complexSubject">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTag"/>
    <xsl:param name="pXmlLang"/>
    <xsl:variable name="vLabelProp">
      <xsl:choose>
        <xsl:when test="$pTag='656'">rdfs:label</xsl:when>
        <xsl:otherwise>madsrdf:authoritativeLabel</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vMADSClass">
      <xsl:choose>
        <xsl:when test="@code='v'">madsrdf:GenreForm</xsl:when>
        <xsl:when test="@code='x'">madsrdf:Topic</xsl:when>
        <xsl:when test="@code='y'">madsrdf:Temporal</xsl:when>
        <xsl:when test="@code='z'">madsrdf:Geographic</xsl:when>
        <xsl:when test="$pTag='648'">madsrdf:Temporal</xsl:when>
        <xsl:when test="$pTag='650'">
          <xsl:choose>
            <xsl:when test="@code='c'">madsrdf:Geographic</xsl:when>
            <xsl:when test="@code='d'">madsrdf:Temporal</xsl:when>
            <xsl:otherwise>madsrdf:Topic</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$pTag='651'">madsrdf:Geographic</xsl:when>
        <xsl:when test="$pTag='655'">madsrdf:GenreForm</xsl:when>
        <xsl:when test="$pTag='656'">
          <xsl:choose>
            <xsl:when test="@code='a'">madsrdf:Occupation</xsl:when>
            <xsl:when test="@code='k'">madsrdf:GenreForm</xsl:when>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vMADSClass}">
          <xsl:element name="{$vLabelProp}">
            <xsl:if test="$pXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
