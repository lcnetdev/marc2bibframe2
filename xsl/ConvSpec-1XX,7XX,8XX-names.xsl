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
      Conversion specs for names from 1XX, 7XX, and 8XX fields
  -->

  <!-- bf:Work properties from name fields -->
  <xsl:template match="marc:datafield[@tag='100' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='100')] |
                       marc:datafield[@tag='110' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='110')] |
                       marc:datafield[@tag='111' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='100')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="pAgentIri"/>
    <xsl:variable name="agentiri">
      <xsl:choose>
        <xsl:when test="$pAgentIri != ''"><xsl:value-of select="$pAgentIri"/></xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="generateUri" select=".">
            <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
            <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates mode="workName" select=".">
      <xsl:with-param name="agentiri" select="$agentiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='700' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='700')] |
                       marc:datafield[@tag='710' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='710')] |
                       marc:datafield[@tag='711' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='711')] |
                       marc:datafield[@tag='720' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='720')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
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
      <xsl:apply-templates mode="work7XX" select=".">
        <xsl:with-param name="agentiri" select="$agentiri"/>
        <xsl:with-param name="pHubIri" select="$vHubIri"/>
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work7XX">
    <xsl:param name="agentiri"/>
    <xsl:param name="pHubIri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="marc:subfield[@code='t']">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:choose>
              <xsl:when test="@ind2='2' and count(marc:subfield[@code='i']) = 0">
                <bf:hasPart>
                  <bf:Hub>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$pHubIri"/></xsl:attribute>
                    <xsl:apply-templates mode="workName" select=".">
                      <xsl:with-param name="agentiri" select="$agentiri"/>
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </bf:Hub>
                </bf:hasPart>
              </xsl:when>
              <xsl:otherwise>
                <bf:relatedTo>
                  <bf:Hub>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$pHubIri"/></xsl:attribute>
                    <xsl:apply-templates mode="workName" select=".">
                      <xsl:with-param name="agentiri" select="$agentiri"/>
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </bf:Hub>
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
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </rdfs:label>
                    </bflc:Relation>
                  </bflc:relation>
                  <bf:relatedTo>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$pHubIri"/></xsl:attribute>
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
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
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
    <xsl:param name="pSource"/>
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
                <xsl:with-param name="pSource" select="$pSource"/>
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
            <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Contribution>
        </bf:contribution>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="marc:subfield[@code='t']">
      <xsl:choose>
        <xsl:when test="substring($tag,1,1) = '1'">
          <bf:expressionOf>
            <bf:Hub>
              <xsl:attribute name="rdf:about">
                <xsl:value-of select="concat(substring-before($agentiri,'#Agent'),'#Hub',substring-after($agentiri,'#Agent'))"/>
              </xsl:attribute>
              <xsl:apply-templates mode="hubUnifTitle" select=".">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pSource" select="$pSource"/>
              </xsl:apply-templates>
            </bf:Hub>
          </bf:expressionOf>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="hubUnifTitle" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pSource" select="$pSource"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <!-- build bf:role properties from $4 -->
  <xsl:template match="marc:subfield[@code='4']" mode="contributionRoleCode">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vRoleUri">
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
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:role>
          <bf:Role>
            <xsl:choose>
              <xsl:when test="$vRoleUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vRoleUri"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <bf:code><xsl:value-of select="."/></bf:code>
              </xsl:otherwise>
            </xsl:choose>
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
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="$vRole"/>
                        </xsl:call-template>
                      </rdfs:label>
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
                            <xsl:call-template name="tChopPunct">
                              <xsl:with-param name="pString" select="$vRole"/>
                            </xsl:call-template>
                          </rdfs:label>
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
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="normalize-space(substring-before($roleString,' and'))"/>
                        </xsl:call-template>
                      </rdfs:label>
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
                            <xsl:call-template name="tChopPunct">
                              <xsl:with-param name="pString" select="$vRole"/>
                            </xsl:call-template>
                          </rdfs:label>
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
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="normalize-space(substring-before($roleString,'&amp;'))"/>
                        </xsl:call-template>
                      </rdfs:label>
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
                            <xsl:call-template name="tChopPunct">
                              <xsl:with-param name="pString" select="$vRole"/>
                            </xsl:call-template>
                          </rdfs:label>
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
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="$roleString"/>
                      </xsl:call-template>
                    </rdfs:label>
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
                            <xsl:call-template name="tChopPunct">
                              <xsl:with-param name="pString" select="$roleString"/>
                            </xsl:call-template>
                          </rdfs:label>
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
    <xsl:param name="pMADSLabel"/>
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
      <xsl:variable name="vUnchopped">
        <xsl:apply-templates select="." mode="tNameLabel"/>
      </xsl:variable>
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="$vUnchopped"/>
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
              <xsl:if test="$pMADSLabel != ''">
                <madsrdf:authoritativeLabel>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="$pMADSLabel"/>
                  </xsl:call-template>
                </madsrdf:authoritativeLabel>
              </xsl:if>
              <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
                <madsrdf:isMemberOfMADSScheme>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                </madsrdf:isMemberOfMADSScheme>
              </xsl:for-each>
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
            </xsl:if>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2)='00'">
              <xsl:if test="$label != ''">
                <bflc:name00MatchKey><xsl:value-of select="$label"/></bflc:name00MatchKey>
                <xsl:if test="substring($tag,1,1) = '1'">
                  <bflc:primaryContributorName00MatchKey><xsl:value-of select="$label"/></bflc:primaryContributorName00MatchKey>
                </xsl:if>
              </xsl:if>
              <bflc:name00MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name00MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='10'">
              <xsl:if test="$label != ''">
                <bflc:name10MatchKey><xsl:value-of select="$label"/></bflc:name10MatchKey>
              </xsl:if>
              <bflc:name10MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name10MarcKey>
                <xsl:if test="substring($tag,1,1) = '1'">
                  <bflc:primaryContributorName10MatchKey><xsl:value-of select="$label"/></bflc:primaryContributorName10MatchKey>
                </xsl:if>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='11'">
              <xsl:if test="$label != ''">
                <bflc:name11MatchKey><xsl:value-of select="$label"/></bflc:name11MatchKey>
              </xsl:if>
              <bflc:name11MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name11MarcKey>
                <xsl:if test="substring($tag,1,1) = '1'">
                  <bflc:primaryContributorName11MatchKey><xsl:value-of select="$label"/></bflc:primaryContributorName11MatchKey>
                </xsl:if>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$label != ''">
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$label"/>
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
              <xsl:choose>
                <xsl:when test="$pSource">
                  <xsl:copy-of select="$pSource"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="subfield2" select="marc:subfield[@code='2']">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pVocabStem" select="$nametitleschemes"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates mode="subfield3" select="marc:subfield[@code='3']">
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
