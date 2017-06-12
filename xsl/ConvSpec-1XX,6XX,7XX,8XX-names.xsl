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
      Conversion specs for names from 1XX, 6XX, 7XX, and 8XX fields
  -->

  <!-- bf:Work properties from name fields -->
  <xsl:template match="marc:datafield[@tag='100' or @tag='110' or @tag='111']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="workName" select=".">
      <xsl:with-param name="agentiri" select="$agentiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='600' or @tag='610' or @tag='611']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="workiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work6XXName" select=".">
      <xsl:with-param name="agentiri" select="$agentiri"/>
      <xsl:with-param name="workiri" select="$workiri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work6XXName">
    <xsl:param name="agentiri"/>
    <xsl:param name="workiri"/>
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vSourceCode"><xsl:value-of select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/code"/></xsl:variable>
    <xsl:variable name="vMADSClass">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">ComplexSubject</xsl:when>
        <xsl:when test="marc:subfield[@code='t']">NameTitle</xsl:when>
        <xsl:when test="$vTag='600'">Name</xsl:when>
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
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:call-template name="chopPunctuation">
            <xsl:with-param name="chopString" select="normalize-space(concat($vNameLabel,' ',$vTitleLabel))"/>
            <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
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
            <xsl:when test="$vSourceCode != ''">
              <bf:source>
                <bf:Source>
                  <bf:code><xsl:value-of select="$vSourceCode"/></bf:code>
                </bf:Source>
              </bf:source>
            </xsl:when>
            <xsl:when test="@ind2='7'">
              <bf:source>
                <bf:Source>
                  <bf:code><xsl:value-of select="marc:subfield[@code='2']"/></bf:code>
                </bf:Source>
              </bf:source>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <bf:subject>
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']">
              <bf:Work>
                <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
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
                  <madsrdf:isMemberofMADSScheme>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                  </madsrdf:isMemberofMADSScheme>
                </xsl:for-each>                  
                <xsl:if test="$vSource != ''">
                  <xsl:copy-of select="$vSource"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="substring($vTag,2,2)='11'">
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
                  <bflc:relationship>
                    <bflc:Relationship>
                      <bflc:relation>
                        <bflc:Relation>
                          <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,substring(.,1,3))"/></xsl:attribute>
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
              </bf:Work>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="agent">
                <xsl:with-param name="agentiri" select="$agentiri"/>
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pMADSClass" select="$vMADSClass"/>
                <xsl:with-param name="pSource" select="$vSource"/>
                <xsl:with-param name="recordid" select="$recordid"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='700' or @tag='710' or @tag='711' or @tag='720']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="workiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work7XX" select=".">
      <xsl:with-param name="agentiri" select="$agentiri"/>
      <xsl:with-param name="workiri" select="$workiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work7XX">
    <xsl:param name="agentiri"/>
    <xsl:param name="workiri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="marc:subfield[@code='t']">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:choose>
              <xsl:when test="@ind2='2'">
                <bf:hasPart>
                  <bf:Work>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
                    <xsl:apply-templates mode="workName" select=".">
                      <xsl:with-param name="agentiri" select="$agentiri"/>
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </bf:Work>
                </bf:hasPart>
              </xsl:when>
              <xsl:otherwise>
                <bf:relatedTo>
                  <bf:Work>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
                    <xsl:apply-templates mode="workName" select=".">
                      <xsl:with-param name="agentiri" select="$agentiri"/>
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </bf:Work>
                </bf:relatedTo>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="marc:subfield[@code='i']">
              <bflc:relationship>
                <bflc:Relationship>
                  <bflc:relation>
                    <bflc:Relation>
                      <rdfs:label>
                        <xsl:if test="$vXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="chopPunctuation">
                          <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                          </xsl:with-param>
                        </xsl:call-template>
                      </rdfs:label>
                    </bflc:Relation>
                  </bflc:relation>
                  <bf:relatedTo>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$workiri"/></xsl:attribute>
                  </bf:relatedTo>
                </bflc:Relationship>
              </bflc:relationship>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="workName" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
        <xsl:for-each select="marc:subfield[@code='i']">
          <bflc:relationship>
            <bflc:Relationship>
              <bflc:relation>
                <bflc:Relation>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bflc:Relation>
              </bflc:relation>
              <bf:relatedTo><xsl:value-of select="$agentiri"/></bf:relatedTo>
            </bflc:Relationship>
          </bflc:relationship>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Processing for 8XX tags in ConvSpec-Process6-Series.xsl -->
  
  <xsl:template match="marc:datafield" mode="workName">
    <xsl:param name="agentiri"/>
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:variable name="tag">
      <xsl:choose>
        <xsl:when test="@tag=880">
          <xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rolesFromSubfields">
      <xsl:choose>
        <xsl:when test="substring($tag,2,2)='11'">
          <xsl:apply-templates select="marc:subfield[@code='j']" mode="contributionRole">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="marc:subfield[@code='4']" mode="contributionRoleCode">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:contribution>
          <bf:Contribution>
            <xsl:if test="substring($tag,1,1) = '1'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bflc,'PrimaryContribution')"/></xsl:attribute>
              </rdf:type>
            </xsl:if>
            <bf:agent>
              <xsl:apply-templates mode="agent" select=".">
                <xsl:with-param name="agentiri" select="$agentiri"/>
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:agent>
            <xsl:choose>
              <xsl:when test="substring($tag,1,1)='6'">
                <bf:role>
                  <bf:Role>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,'ctb')"/></xsl:attribute>
                  </bf:Role>
                </bf:role>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="(substring($tag,3,1) = '0' and marc:subfield[@code='e']) or
                                  (substring($tag,3,1) = '1' and marc:subfield[@code='j']) or
                                  marc:subfield[@code='4']">
                    <xsl:copy-of select="$rolesFromSubfields"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <bf:role>
                      <bf:Role>
                        <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,'ctb')"/></xsl:attribute>
                      </bf:Role>
                    </bf:role>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </bf:Contribution>
        </bf:contribution>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="marc:subfield[@code='t']">
      <xsl:apply-templates mode="workUnifTitle" select=".">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <!-- build bf:role properties from $4 -->
  <xsl:template match="marc:subfield[@code='4']" mode="contributionRoleCode">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:role>
          <bf:Role>
            <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,substring(.,1,3))"/></xsl:attribute>
          </bf:Role>
        </bf:role>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- build bf:role properties from $e or $j -->
  <xsl:template match="marc:subfield" mode="contributionRole">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pMode" select="'role'"/>
    <xsl:param name="pRelatedTo"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="parent::*" mode="xmllang"/></xsl:variable>
    <xsl:call-template name="splitRole">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="roleString" select="."/>
      <xsl:with-param name="pMode" select="$pMode"/>
      <xsl:with-param name="pRelatedTo" select="$pRelatedTo"/>
      <xsl:with-param name="pXmlLang" select="$vXmlLang"/>
    </xsl:call-template>
  </xsl:template>

  <!-- recursive template to split bf:role properties out of a $e or $j -->
  <xsl:template name="splitRole">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="roleString"/>
    <xsl:param name="pMode" select="'role'"/>
    <xsl:param name="pRelatedTo"/>
    <xsl:param name="pXmlLang"/>
    <xsl:choose>
      <xsl:when test="contains($roleString,',')">
        <xsl:if test="string-length(normalize-space(substring-before($roleString,','))) &gt; 0">
          <xsl:variable name="vRole"><xsl:value-of select="normalize-space(substring-before($roleString,','))"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization='rdfxml'">
              <xsl:choose>
                <xsl:when test="$pMode='role'">
                  <bf:role>
                    <bf:Role>
                      <rdfs:label>
                        <xsl:if test="$pXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$vRole"/>
                      </rdfs:label>
                      <bflc:relatorMatchKey>
                        <xsl:call-template name="chopPunctuation">
                          <xsl:with-param name="chopString"><xsl:value-of select="$vRole"/></xsl:with-param>
                        </xsl:call-template>
                      </bflc:relatorMatchKey>
                    </bf:Role>
                  </bf:role>
                </xsl:when>
                <xsl:when test="$pMode='relationship'">
                  <bflc:relationship>
                    <bflc:Relationship>
                      <bflc:relation>
                        <bflc:Relation>
                          <rdfs:label>
                            <xsl:if test="$pXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$vRole"/>
                          </rdfs:label>
                          <bflc:relatorMatchKey>
                            <xsl:call-template name="chopPunctuation">
                              <xsl:with-param name="chopString"><xsl:value-of select="$vRole"/></xsl:with-param>
                            </xsl:call-template>
                          </bflc:relatorMatchKey>
                        </bflc:Relation>
                      </bflc:relation>
                      <xsl:if test="$pRelatedTo != ''">
                        <bf:relatedTo>
                          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pRelatedTo"/></xsl:attribute>
                        </bf:relatedTo>
                      </xsl:if>
                    </bflc:Relationship>
                  </bflc:relationship>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="string-length(normalize-space(substring-after($roleString,','))) &gt; 0">
          <xsl:call-template name="splitRole">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="roleString" select="substring-after($roleString,',')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:when test="contains($roleString,' and')">
        <xsl:if test="string-length(normalize-space(substring-before($roleString,' and'))) &gt; 0">
          <xsl:variable name="vRole"><xsl:value-of select="normalize-space(substring-before($roleString,' and'))"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization='rdfxml'">
              <xsl:choose>
                <xsl:when test="$pMode='role'">
                  <bf:role>
                    <bf:Role>
                      <rdfs:label>
                        <xsl:if test="$pXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(substring-before($roleString,' and'))"/>
                      </rdfs:label>
                      <bflc:relatorMatchKey>
                        <xsl:call-template name="chopPunctuation">
                          <xsl:with-param name="chopString"><xsl:value-of select="$vRole"/></xsl:with-param>
                        </xsl:call-template>
                      </bflc:relatorMatchKey>
                    </bf:Role>
                  </bf:role>
                </xsl:when>
                <xsl:when test="$pMode='relationship'">
                  <bflc:relationship>
                    <bflc:Relationship>
                      <bflc:relation>
                        <bflc:Relation>
                          <rdfs:label>
                            <xsl:if test="$pXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$vRole"/>
                          </rdfs:label>
                          <bflc:relatorMatchKey>
                            <xsl:call-template name="chopPunctuation">
                              <xsl:with-param name="chopString"><xsl:value-of select="$vRole"/></xsl:with-param>
                            </xsl:call-template>
                          </bflc:relatorMatchKey>
                        </bflc:Relation>
                      </bflc:relation>
                      <xsl:if test="$pRelatedTo != ''">
                        <bf:relatedTo>
                          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pRelatedTo"/></xsl:attribute>
                        </bf:relatedTo>
                      </xsl:if>
                    </bflc:Relationship>
                  </bflc:relationship>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:call-template name="splitRole">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="roleString" select="substring-after($roleString,' and')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($roleString,'&amp;')">
        <xsl:if test="string-length(normalize-space(substring-before($roleString,'&amp;'))) &gt; 0">
          <xsl:variable name="vRole"><xsl:value-of select="normalize-space(substring-before($roleString,'&amp;'))"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization='rdfxml'">
              <xsl:choose>
                <xsl:when test="$pMode='role'">
                  <bf:role>
                    <bf:Role>
                      <rdfs:label>
                        <xsl:if test="$pXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(substring-before($roleString,'&amp;'))"/>
                      </rdfs:label>
                      <bflc:relatorMatchKey>
                        <xsl:call-template name="chopPunctuation">
                          <xsl:with-param name="chopString"><xsl:value-of select="$vRole"/></xsl:with-param>
                        </xsl:call-template>
                      </bflc:relatorMatchKey>
                    </bf:Role>
                  </bf:role>
                </xsl:when>
                <xsl:when test="$pMode='relationship'">
                  <bflc:relationship>
                    <bflc:Relationship>
                      <bflc:relation>
                        <bflc:Relation>
                          <rdfs:label>
                            <xsl:if test="$pXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$vRole"/>
                          </rdfs:label>
                          <bflc:relatorMatchKey>
                            <xsl:call-template name="chopPunctuation">
                              <xsl:with-param name="chopString"><xsl:value-of select="$vRole"/></xsl:with-param>
                            </xsl:call-template>
                          </bflc:relatorMatchKey>
                        </bflc:Relation>
                      </bflc:relation>
                      <xsl:if test="$pRelatedTo != ''">
                        <bf:relatedTo>
                          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pRelatedTo"/></xsl:attribute>
                        </bf:relatedTo>
                      </xsl:if>
                    </bflc:Relationship>
                  </bflc:relationship>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:call-template name="splitRole">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="roleString" select="substring-after($roleString,'&amp;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <xsl:choose>
              <xsl:when test="$pMode='role'">
                <bf:role>
                  <bf:Role>
                    <rdfs:label>
                      <xsl:if test="$pXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="normalize-space($roleString)"/>
                    </rdfs:label>
                    <bflc:relatorMatchKey>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString"><xsl:value-of select="normalize-space($roleString)"/></xsl:with-param>
                      </xsl:call-template>
                    </bflc:relatorMatchKey>
                  </bf:Role>
                </bf:role>
              </xsl:when>
                <xsl:when test="$pMode='relationship'">
                  <bflc:relationship>
                    <bflc:Relationship>
                      <bflc:relation>
                        <bflc:Relation>
                          <rdfs:label>
                            <xsl:if test="$pXmlLang != ''">
                              <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="normalize-space($roleString)"/>
                          </rdfs:label>
                          <bflc:relatorMatchKey>
                            <xsl:call-template name="chopPunctuation">
                              <xsl:with-param name="chopString"><xsl:value-of select="normalize-space($roleString)"/></xsl:with-param>
                            </xsl:call-template>
                          </bflc:relatorMatchKey>
                        </bflc:Relation>
                      </bflc:relation>
                      <xsl:if test="$pRelatedTo != ''">
                        <bf:relatedTo>
                          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pRelatedTo"/></xsl:attribute>
                        </bf:relatedTo>
                      </xsl:if>
                    </bflc:Relationship>
                  </bflc:relationship>
                </xsl:when>
              </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- build a bf:Agent entity -->
  <xsl:template match="marc:datafield" mode="agent">
    <xsl:param name="agentiri"/>
    <xsl:param name="pMADSClass"/>
    <xsl:param name="pSource"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="tag">
      <xsl:choose>
        <xsl:when test="@tag=880">
          <xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="tNameLabel"/>
    </xsl:variable>
    <xsl:variable name="vMADSLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:if test="$label != ''">
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="$label"/>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
            <xsl:text>--</xsl:text>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="marckey">
      <xsl:apply-templates mode="marcKey"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:Agent>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$agentiri"/></xsl:attribute>
          <rdf:type>
            <xsl:choose>
              <xsl:when test="$tag='720'">
                <xsl:if test="@ind1='1'">
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$bf"/>Person</xsl:attribute>
                </xsl:if>
              </xsl:when>
              <xsl:when test="substring($tag,2,2)='00'">
                <xsl:choose>
                  <xsl:when test="@ind1='3'">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$bf"/>Family</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$bf"/>Person</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="substring($tag,2,2)='10'">
                <xsl:choose>
                  <xsl:when test="@ind1='1'">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Jurisdiction')"/></xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Organization')"/></xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="substring($tag,2,2)='11'">
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Meeting')"/></xsl:attribute>
              </xsl:when>
            </xsl:choose>
          </rdf:type>
          <xsl:if test="substring($tag,1,1)='6'">
            <xsl:if test="$pMADSClass != ''">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$pMADSClass)"/></xsl:attribute>
              </rdf:type>
              <xsl:if test="$vMADSLabel != ''">
                <madsrdf:authoritativeLabel>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vMADSLabel"/>
                </madsrdf:authoritativeLabel>
              </xsl:if>
              <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
                <madsrdf:isMemberofMADSScheme>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                </madsrdf:isMemberofMADSScheme>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$pSource != ''">
              <xsl:copy-of select="$pSource"/>
            </xsl:if>
            <xsl:if test="not(marc:subfield[@code='t'])">
              <xsl:choose>
                <xsl:when test="substring($tag,2,2)='11'">
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
                <bflc:relationship>
                  <bflc:Relationship>
                    <bflc:relation>
                      <bflc:Relation>
                        <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,substring(.,1,3))"/></xsl:attribute>
                      </bflc:Relation>
                    </bflc:relation>
                    <bf:relatedTo>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                    </bf:relatedTo>
                  </bflc:Relationship>
                </bflc:relationship>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2)='00'">
              <xsl:if test="$label != ''">
                <bflc:name00MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:name00MatchKey>
                <xsl:if test="substring($tag,1,1) = '1'">
                  <bflc:primaryContributorName00MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:primaryContributorName00MatchKey>
                </xsl:if>
              </xsl:if>
              <bflc:name00MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name00MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='10'">
              <xsl:if test="$label != ''">
                <bflc:name10MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:name10MatchKey>
              </xsl:if>
              <bflc:name10MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name10MarcKey>
                <xsl:if test="substring($tag,1,1) = '1'">
                  <bflc:primaryContributorName10MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:primaryContributorName10MatchKey>
                </xsl:if>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='11'">
              <xsl:if test="$label != ''">
                <bflc:name11MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:name11MatchKey>
              </xsl:if>
              <bflc:name11MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name11MarcKey>
                <xsl:if test="substring($tag,1,1) = '1'">
                  <bflc:primaryContributorName11MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:primaryContributorName11MatchKey>
                </xsl:if>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$label != ''">
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space($label)"/>
            </rdfs:label>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']">
              <xsl:for-each select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='0' or @code='w']">
                <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
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
            </xsl:otherwise>
          </xsl:choose>
        </bf:Agent>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="tNameLabel">
    <xsl:variable name="tag">
      <xsl:choose>
        <xsl:when test="@tag=880">
          <xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$tag='720'"><xsl:value-of select="marc:subfield[@code='a']"/></xsl:when>
      <xsl:when test="substring($tag,2,2)='00'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='a' or
                                     @code='b' or 
                                     @code='c' or
                                     @code='d' or
                                     @code='j' or
                                     @code='q']"/>
      </xsl:when>
      <xsl:when test="substring($tag,2,2)='10'">
        <xsl:choose>
          <xsl:when test="marc:subfield[@code='t']">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='a' or
                                         @code='b' or 
                                         @code='c' or
                                         @code='d' or
                                         @code='n' or
                                         @code='g']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='b' or 
                                         @code='c' or
                                         @code='d' or
                                         @code='n' or
                                         @code='g']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="substring($tag,2,2)='11'">
        <xsl:choose>
          <xsl:when test="marc:subfield[@code='t']">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='a' or
                                         @code='c' or
                                         @code='d' or
                                         @code='e' or
                                         @code='n' or
                                         @code='g' or
                                         @code='q']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='c' or
                                         @code='d' or
                                         @code='e' or
                                         @code='n' or
                                         @code='g' or
                                         @code='q']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
