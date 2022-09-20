<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:marc="http://www.loc.gov/MARC21/slim"
  xmlns:bf="http://id.loc.gov/ontologies/bibframe/" xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
  xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 8XX (and obsolete 4XX) ,490 - Series -->
  <!--convert 490 unless there's an 8xx with the same issn-->
  <xsl:template match="marc:datafield[@tag = '490' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='490')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>    
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang">
      <xsl:apply-templates select="." mode="xmllang"/>
    </xsl:variable>
  
    <!--490 and 880 are now decoupled -->
           
        <xsl:variable name="hasParallel">
          <xsl:choose>
            <xsl:when
              test="
                count(marc:subfield[@code = 'a']) &gt; 1 and
                (substring(marc:subfield[@code = 'a'][1], string-length(marc:subfield[@code = 'a'][1])) = '=' or
                substring(marc:subfield[@code = 'v'][1], string-length(marc:subfield[@code = 'v'][1])) = '=')">parallel</xsl:when>
            <xsl:otherwise>separate</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!--for 880 pairing-->
        <xsl:variable name="vOccurrence">
          <xsl:value-of select="substring(substring-after(marc:subfield[@code = '6'], '-'), 1, 2)"/>
        </xsl:variable>
        <xsl:variable name="v880Title">
          <xsl:if test="@tag = '490' and marc:subfield[@code = '6']">
            <xsl:for-each
              select="../marc:datafield[@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490' and substring(substring-after(marc:subfield[@code = '6'], '-'), 1, 2) = $vOccurrence]">
              <xsl:variable name="v880Lang">
                <xsl:apply-templates select="." mode="xmllang"/>
              </xsl:variable>
              <bf:mainTitle>
                <xsl:if test="$v880Lang != ''">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$v880Lang"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="marc:subfield[@code = 'a']"/>
                </xsl:call-template>
              </bf:mainTitle>
            </xsl:for-each>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="v880Enumeration">
          <xsl:if test="marc:subfield[@code = '6']">
            <xsl:for-each
              select="../marc:datafield[@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490' and substring(substring-after(marc:subfield[@code = '6'], '-'), 1, 2) = $vOccurrence]">
              <xsl:variable name="v880Lang">
                <xsl:apply-templates select="." mode="xmllang"/>
              </xsl:variable>
              <bf:seriesEnumeration>
                <xsl:if test="$v880Lang != ''">                
                    <xsl:attribute name="xml:lang">
                      <xsl:value-of select="$v880Lang"/>
                    </xsl:attribute>
                </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString"
                        select="normalize-space(marc:subfield[@code = 'v'])"/>
                    </xsl:call-template>                  
              </bf:seriesEnumeration>
                              
            </xsl:for-each>
          </xsl:if>
        </xsl:variable>
        <xsl:for-each select="marc:subfield[@code = 'a']">          
          <xsl:choose>            
            <xsl:when test="preceding-sibling::*[@code = 'a'] and $hasParallel = 'parallel'">
            <!-- skip this a; it's the parallel title on the previous Hub-->
            </xsl:when>
            <xsl:otherwise>
              <!--<build a new rel-->
              <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
              <xsl:variable name="vTitle">
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                  <xsl:with-param name="pEndPunct">
                    <xsl:choose>
                      <xsl:when test="$hasParallel">
                        <xsl:value-of select="'='"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="';,'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="vPosition"><xsl:value-of select="position() + $pPosition"/></xsl:variable>
              <xsl:variable name="vHubIri">
                <xsl:apply-templates mode="generateUri" select="parent::marc:datafield">
                  <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of select="../@tag"/>-<xsl:value-of select="$vPosition"/></xsl:with-param>
                  <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
                </xsl:apply-templates>
              </xsl:variable>
              <xsl:variable name="vParallelTitle">
                <xsl:if test="$hasParallel = 'parallel' ">
                <xsl:for-each select="following-sibling::marc:subfield[@code = 'a'][text()]">
                  <xsl:variable name="vParallelNode" select="generate-id(.)"/>
                  <xsl:variable name="vParallelEnumeration">
                    <xsl:value-of
                      select="normalize-space(following-sibling::marc:subfield[@code = 'v' and generate-id(preceding-sibling::marc:subfield[@code = 'a'][1]) = $vParallelNode])"
                    />
                  </xsl:variable>
                  <bf:title>
                    <bf:ParallelTitle>
                      <bf:mainTitle>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                          <xsl:with-param name="pEndPunct" select="';,='"/>
                        </xsl:call-template>
                      </bf:mainTitle>
                    </bf:ParallelTitle>
                  </bf:title>
                </xsl:for-each>
                </xsl:if>
              </xsl:variable>
              <xsl:variable name="vXIssn">
              
                <xsl:value-of
                  select="normalize-space(following-sibling::marc:subfield[@code = 'x' and generate-id(preceding-sibling::marc:subfield[@code = 'a'][1]) = $vCurrentNode])"
                />
              </xsl:variable>
              <xsl:variable name="vLcc">
                <xsl:value-of
                  select="normalize-space(following-sibling::marc:subfield[@code = 'l' and generate-id(preceding-sibling::marc:subfield[@code = 'a'][1]) = $vCurrentNode])"
                />
              </xsl:variable>            
              <xsl:variable name="vEnumeration">
                <xsl:value-of
                  select="normalize-space(following-sibling::marc:subfield[@code = 'v' and ($vParallelTitle != '' or generate-id(preceding-sibling::marc:subfield[@code = 'a'][1])) = $vCurrentNode])"
                />
              </xsl:variable>
              <xsl:variable name="vYIssn">
                <xsl:value-of
                  select="normalize-space(following-sibling::marc:subfield[@code = 'y' and generate-id(preceding-sibling::marc:subfield[@code = 'a'][1]) = $vCurrentNode])"
                />
              </xsl:variable>
              <xsl:variable name="vZIssn">
                <xsl:value-of
                  select="normalize-space(following-sibling::marc:subfield[@code = 'z' and generate-id(preceding-sibling::marc:subfield[@code = 'a'][1]) = $vCurrentNode])"
                />
              </xsl:variable>
              <xsl:variable name="vAppliesTo">
                <xsl:value-of select="preceding-sibling::marc:subfield[1][@code = '3']"/>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$serialization = 'rdfxml'">
                  <bflc:relationship>
                    <bflc:Relationship>
                      <bflc:relation>
                        <bflc:Relation rdf:about="http://id.loc.gov/ontologies/bibframe/hasSeries">
                          <rdfs:label>Has Series</rdfs:label>
                        </bflc:Relation>
                      </bflc:relation>
                      <bf:relatedTo>
                        <bf:Series>
                          <xsl:attribute name="rdf:about">
                            <xsl:value-of select="$vHubIri"/>
                          </xsl:attribute>
                          <rdf:type rdf:resource="http://id.loc.gov/ontologies/bflc/Uncontrolled"/>
                          <bf:status>
                            <bf:Status  rdf:about="http://id.loc.gov/vocabulary/mstatus/t">
                              <rdfs:label>transcribed</rdfs:label>
                            </bf:Status>
                          </bf:status>
                          <bf:title>
                            <bf:Title>
                              <bf:mainTitle>
                                <xsl:value-of select="$vTitle"/>
                              </bf:mainTitle>
                              <xsl:if test="$v880Title != ''">
                                <xsl:copy-of select="$v880Title"/>
                              </xsl:if>
                            </bf:Title>
                          </bf:title>
                          <xsl:if test="$vParallelTitle != ''">
                            <xsl:copy-of select="$vParallelTitle"/>
                          </xsl:if>

                          <xsl:if test="$vXIssn != ''">
                            <bf:identifiedBy>
                              <bf:Issn>
                                <rdf:value>
                                  <xsl:value-of select="$vXIssn"/>
                                </rdf:value>
                              </bf:Issn>
                            </bf:identifiedBy>
                          </xsl:if>

                          <xsl:if test="$vYIssn != ''">
                            <bf:identifiedBy>
                              <bf:Issn>
                                <rdf:value>
                                  <xsl:value-of select="$vYIssn"/>
                                </rdf:value>
                              </bf:Issn>
                              <bf:status>
                                <bf:Status
                                  rdf:about="http://id.loc.gov/vocabulary/mstatus/incorrect">
                                  <rdfs:label>incorrect</rdfs:label>
                                </bf:Status>
                              </bf:status>
                            </bf:identifiedBy>
                          </xsl:if>
                          <xsl:if test="$vZIssn != ''">
                            <identifiedBy>
                              <Issn>
                                <rdf:value>
                                  <xsl:value-of select="$vZIssn"/>
                                </rdf:value>
                              </Issn>
                              <bf:status>
                                <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/cancinv">
                                  <rdfs:label>canceled</rdfs:label>
                                </bf:Status>
                              </bf:status>
                            </identifiedBy>
                          </xsl:if>
                          
                          
                        </bf:Series>
                        <xsl:if test="$vLcc != ''">
                          <bf:classification>
                            <bf:ClassificationLcc>
                              <bf:assigner>
                                <bf:Agent
                                  rdf:about="http://id.loc.gov/vocabulary/organizations/dlc"/>
                              </bf:assigner>
                              <bf:classificationPortion>
                                <xsl:value-of select="$vLcc"/>
                              </bf:classificationPortion>
                            </bf:ClassificationLcc>
                          </bf:classification>
                          
                        </xsl:if>
                        
                        <xsl:if test="$vAppliesTo != ''">
                          <bflc:appliesTo>
                            <bflc:AppliesTo>
                              <xsl:value-of select="$vAppliesTo"/>
                            </bflc:AppliesTo>
                          </bflc:appliesTo>
                        </xsl:if>
                      </bf:relatedTo>
                      <xsl:if test="$vEnumeration != ''">
                        <bf:seriesEnumeration>
                          <xsl:value-of select="$vEnumeration"/>
                        </bf:seriesEnumeration>
                      </xsl:if>
                      <xsl:if
                        test="$v880Enumeration != '' and not($vEnumeration = $v880Enumeration)">
                        
                          <xsl:copy-of select="$v880Enumeration"/>
                        
                      </xsl:if>
                    </bflc:Relationship>
                  </bflc:relationship>
                </xsl:when>
              </xsl:choose>
              <!--end building a series  -->
            </xsl:otherwise>
          </xsl:choose>
            
        </xsl:for-each>
  
  </xsl:template>
  <xsl:template
    match="
      marc:datafield[@tag = '800' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '800')] |
      marc:datafield[@tag = '810' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '810')] |
      marc:datafield[@tag = '811' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '811')] |
      marc:datafield[@tag = '830' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '830')] |
      marc:datafield[@tag = '400' or @tag = '410' or @tag = '411' or @tag = '440']"
    mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code = '5'])">
      <xsl:variable name="vCurrentPos">
        <xsl:choose>
          <xsl:when test="substring(@tag, 1, 1) = '8'">
            <xsl:value-of
              select="count(preceding-sibling::marc:datafield[@tag = '800' or @tag = '810' or @tag = '811' or @tag = '830' or (@tag = '880' and (substring(marc:subfield[@code = '6'], 1, 3) = '800' or substring(marc:subfield[@code = '6'], 1, 3) = '810' or substring(marc:subfield[@code = '6'], 1, 3) = '811' or substring(marc:subfield[@code = '6'], 1, 3) = '830') and substring(substring-after(marc:subfield[@code = '6'], '-'), 1, 2) = '00')]) + 1"
            />
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="." mode="work8XX">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pCurrentPos" select="$vCurrentPos"/>
        <xsl:with-param name="pPosition" select="$pPosition"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work8XX">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pCurrentPos"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:variable name="vXmlLang">
      <xsl:apply-templates select="." mode="xmllang"/>
    </xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag = '880'">
          <xsl:value-of select="substring(marc:subfield[@code = '6'], 1, 3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vHubIri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of
            select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of
            select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
  <!--  <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space"
        select="marc:subfield[not(contains('hvwx012345678', @code))]"/>
    </xsl:variable>-->
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bflc:relationship>
          <bflc:Relationship>
            <bflc:relation>
              <bflc:Relation rdf:about="http://id.loc.gov/ontologies/bibframe/hasSeries">
                <rdfs:label>Has Series</rdfs:label>
              </bflc:Relation>
            </bflc:relation>
            <bf:relatedTo>
              <bf:Hub>
                <xsl:attribute name="rdf:about">
                  <xsl:value-of select="$vHubIri"/>
                </xsl:attribute>
                <rdf:type rdf:resource="http://id.loc.gov/ontologies/bibframe/Series"/>
                <!--see if this works  for 830, and 8xx both names and titles eg-->              
               <xsl:choose>
                  <xsl:when test="$vTag = '830' or $vTag = '440'">
                    <xsl:apply-templates mode="hubUnifTitle" select=".">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pLabel" select="marc:subfield[@code='a']"/>                      
                    </xsl:apply-templates>
                  </xsl:when>
              <xsl:otherwise>
                
                    <xsl:apply-templates mode="workName" select=".">
                      <xsl:with-param name="agentiri" select="$agentiri"/>
                      <xsl:with-param name="serialization" select="$serialization"/>
                             
                    </xsl:apply-templates>
              </xsl:otherwise>
               </xsl:choose>
                 
                <xsl:for-each select="marc:subfield[@code = 'w']">
                  <xsl:variable name="vIdClass">
                    <xsl:choose>
                      <xsl:when test="starts-with(., '(DLC)')">bf:Lccn</xsl:when>
                      <xsl:otherwise>bf:Identifier</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pIdClass" select="$vIdClass"/>
                  </xsl:apply-templates>
                </xsl:for-each>              
                <xsl:for-each select="marc:subfield[@code = 'x']">
                    <bf:identifiedBy>
                      <bf:Issn>
                        <rdf:value>
                          <xsl:call-template name="tChopPunct">
                            <xsl:with-param name="pString" select="."/>
                          </xsl:call-template>
                        </rdf:value>
                      </bf:Issn>
                    </bf:identifiedBy>
                  </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'y']">
                  <bf:identifiedBy>
                    <bf:Issn>
                      <rdf:value>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </rdf:value>
                      <bf:status>
                        <bf:Status
                          rdf:about="http://id.loc.gov/vocabulary/mstatus/incorrect">
                          <rdfs:label>incorrect</rdfs:label>
                        </bf:Status>
                      </bf:status>
                    </bf:Issn>
                  </bf:identifiedBy>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                  <bf:identifiedBy>
                    <bf:Issn>
                      <rdf:value>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </rdf:value>
                      <bf:status>
                        <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/cancinv">
                          <rdfs:label>canceled</rdfs:label>
                        </bf:Status>
                      </bf:status>
                    </bf:Issn>
                  </bf:identifiedBy>
                </xsl:for-each>              
              
                <!-- $3 processed by hubUnifTitle template -->
                <xsl:apply-templates mode="subfield5" select="marc:subfield[@code = '5']">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="subfield7" select="marc:subfield[@code = '7']">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Hub>
            </bf:relatedTo>
            <xsl:for-each select="marc:subfield[@code = 'v']">
              <bf:seriesEnumeration>
                <xsl:value-of  select="."/>                
              </bf:seriesEnumeration>                
            </xsl:for-each>
            
          </bflc:Relationship>
        </bflc:relationship>

      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      extract ISSN for series from matching 490
      if there is no matching 490 (or the matching 490 has no $x),
      return empty string
      2022-07-22 No longer matching up 490/8xx.
  -->
  <!--<xsl:template name="tIdentifier490">
    <xsl:param name="pCurrentPos" select="1"/>
    <xsl:param name="pLastPos"/>
    <xsl:param name="pCompositePos" select="1"/>
    <xsl:param name="pCode" />
    
    <xsl:if
      test="../marc:datafield[@tag = '490' and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'a']">
      <xsl:choose>
        <xsl:when test="$pCompositePos &lt;= $pLastPos">
          <xsl:variable name="vParallel">
            <xsl:choose>
              <xsl:when
                test="
                  substring(../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'a'][1], string-length(../marc:datafield[@tag = '490' and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'a'][1])) = '=' or
                  substring(../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'v'][1], string-length(../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'v'][1])) = '='">
                <xsl:text>parallel</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$vParallel != ''">
              <xsl:choose>
                <xsl:when test="$pCompositePos = $pLastPos">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString"
                      select="../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'x'][1]"
                    />
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="tIdentifier490">
                    <xsl:with-param name="pCurrentPos" select="$pCurrentPos + 1"/>
                    <xsl:with-param name="pLastPos" select="$pLastPos"/>
                    <xsl:with-param name="pCompositePos" select="$pCompositePos + 1"/>
                    <xsl:with-param name="pCode"><xsl:value-of select="$pCode"/></xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each
                select="../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'a']">
                <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
                <xsl:if test="$pCompositePos + position() - 1 = $pLastPos">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString"
                      select="following-sibling::marc:subfield[@code = $pCode and generate-id(preceding-sibling::marc:subfield[@code = 'a'][1]) = $vCurrentNode]"
                    />
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
              <xsl:if
                test="$pCompositePos + count(../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'a']) &lt; $pLastPos">
                <xsl:call-template name="tIdentifier490">
                  <xsl:with-param name="pCurrentPos" select="$pCurrentPos + 1"/>
                  <xsl:with-param name="pLastPos" select="$pLastPos"/>
                  <xsl:with-param name="pCompositePos"
                    select="$pCompositePos + count(../marc:datafield[((@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = '490') or (@tag = '490' and not(marc:subfield[@code = '6']))) and @ind1 = '1'][$pCurrentPos]/marc:subfield[@code = 'a'])"
                  />
                  <xsl:with-param name="pCode"><xsl:value-of select="$pCode"/></xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
-->
  
</xsl:stylesheet>
