<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:marc="http://www.loc.gov/MARC21/slim"
  xmlns:bf="http://id.loc.gov/ontologies/bibframe/" xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
  xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="xsl marc">


  <!-- Conversion specs for 8XX (and obsolete 4XX) ,490 - Series -->
  <!-- convert 490 unless there's an 8xx with the same issn -->
  <xsl:template match="marc:datafield[@tag = '490' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='490' and substring(marc:subfield[@code='6'],4,3)='-00')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>    
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang">
      <xsl:apply-templates select="." mode="xmllang"/>
    </xsl:variable>
    
    <xsl:variable name="hasParallel">
      <xsl:choose>
        <xsl:when
          test="
              count(marc:subfield[@code = 'a']) &gt; 1 and
              (
                substring(marc:subfield[@code = 'a'][1], string-length(marc:subfield[@code = 'a'][1])) = '=' or
                substring(marc:subfield[@code = 'v'][1], string-length(marc:subfield[@code = 'v'][1])) = '='
              )"
            >parallel</xsl:when>
        <xsl:otherwise>separate</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="vXMLLang">
      <xsl:apply-templates select="." mode="xmllang"/>
    </xsl:variable>
    
    <xsl:variable name="vOccurrence">
      <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
        <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vRelated880" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='490' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" />
    <xsl:variable name="v880XmlLang"><xsl:apply-templates select="$vRelated880" mode="xmllang"/></xsl:variable>
    
    <xsl:variable name="gpos" select="1"/>
    <xsl:variable name="pos" select="1"/>
    <xsl:variable name="grouped490InfoPreNS">
      <xsl:apply-templates select="." mode="groupify490">
        <xsl:with-param name="pGPos" select="$gpos" />
        <xsl:with-param name="pPos" select="$pos" />
        <xsl:with-param name="pXmllang" select="$vXMLLang" />
        <xsl:with-param name="pRelated880" select="$vRelated880" />
        <xsl:with-param name="p880Xmllang" select="$v880XmlLang" />
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="grouped490Info" select="exsl:node-set($grouped490InfoPreNS)"/>
    <!-- <xsl:message><xsl:copy-of select="$grouped490Info"/></xsl:message> -->
    
    <!-- Find the group numbers. -->
    <xsl:variable name="tThisDF" select="."/>
      <xsl:variable name="tGroupNums" select="$grouped490Info//@groupNum[not(.=preceding::bf:*/@groupNum[1])]" />
      <xsl:for-each select="$tGroupNums">
        <xsl:variable name="tGNum" select="."/>    
        <bf:relation>
          <bf:Relation>
            <bf:relationship>
              <bf:Relationship rdf:about="http://id.loc.gov/ontologies/bibframe/hasSeries">
                <rdfs:label>Has Series</rdfs:label>
              </bf:Relationship>
            </bf:relationship>
            <bf:associatedResource>
              <bf:Series>
                <!--
                <xsl:attribute name="rdf:about">
                  <xsl:value-of select="$vHubIri"/>
                </xsl:attribute>
                -->
                <rdf:type rdf:resource="http://id.loc.gov/ontologies/bflc/Uncontrolled"/>
                <bf:status>
                  <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/t">
                    <rdfs:label>transcribed</rdfs:label>
                  </bf:Status>
                </bf:status>
                <xsl:if test="$tThisDF/@ind1='1'">
                  <bf:status>
                    <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/tr">
                      <rdfs:label>traced</rdfs:label>
                    </bf:Status>
                  </bf:status>
                </xsl:if>
                <xsl:for-each select="$grouped490Info/bf:title[@groupNum=$tGNum] |
                                      $grouped490Info/bf:identifiedBy[@groupNum=$tGNum]">
                  <xsl:element name="{name()}">
                    <xsl:copy-of select="child::node()" />
                  </xsl:element>
                </xsl:for-each>
              </bf:Series>
            </bf:associatedResource>
            <xsl:for-each select="$grouped490Info/bf:seriesEnumeration[@groupNum=$tGNum]">
              <xsl:element name="{name()}">
                <xsl:if test="@xml:lang">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>  
                </xsl:if>
                <xsl:copy-of select="child::node()" />
              </xsl:element>
            </xsl:for-each>
            <xsl:if test="$tThisDF/marc:subfield[@code='l']">
              <bf:classification>
                <bf:ClassificationLcc>
                  <bf:assigner>
                    <bf:Agent rdf:about="http://id.loc.gov/vocabulary/organizations/dlc"/>
                  </bf:assigner>
                  <bf:classificationPortion>
                    <xsl:value-of select="$tThisDF/marc:subfield[@code='l'][1]"/>
                  </bf:classificationPortion>
                </bf:ClassificationLcc>
              </bf:classification>
            </xsl:if>
            <xsl:if test="$tThisDF/marc:subfield[@code='3']">
              <bflc:appliesTo>
                <bflc:AppliesTo>
                  <rdfs:label>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="$tThisDF/marc:subfield[@code='3'][1]"/>
                    </xsl:call-template>
                  </rdfs:label>
                </bflc:AppliesTo>
              </bflc:appliesTo>
            </xsl:if>
          </bf:Relation>
        </bf:relation>
      </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="marc:datafield" mode="groupify490">
    <xsl:param name="pGPos" />
    <xsl:param name="pPos" />
    <xsl:param name="pXmllang" />
    
    <xsl:param name="pRelated880" />
    <xsl:param name="p880Xmllang" />
    
    <xsl:variable name="tSF" select="marc:subfield[$pPos]"/>
    <!-- The position should, in theory, be sufficient, but let's match on the code too just to be safe. -->
    <xsl:variable name="tSF880Val">
      <xsl:if test="$pRelated880 != ''">
        <xsl:value-of select="$pRelated880/marc:subfield[$pPos][@code=$tSF/@code]"/>
      </xsl:if>
    </xsl:variable>
    
    <!--
          a = title
          v = enumeration
      -->
      <xsl:if test="$tSF/@code='a'">
        <bf:title>
          <xsl:attribute name="groupNum"><xsl:value-of select="$pGPos" /></xsl:attribute>
          <bf:Title>
            <bf:mainTitle>
              <xsl:if test="$pXmllang != ''">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$pXmllang"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="$tSF"/>
              </xsl:call-template>
            </bf:mainTitle>
            <xsl:if test="$tSF880Val != ''">
              <bf:mainTitle>
                <xsl:if test="$p880Xmllang != ''">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$p880Xmllang"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="$tSF880Val"/>
                </xsl:call-template>
              </bf:mainTitle>
            </xsl:if>
          </bf:Title>
        </bf:title>
      </xsl:if>
    <xsl:if test="$tSF/@code='v'">
        <bf:seriesEnumeration>
          <xsl:attribute name="groupNum"><xsl:value-of select="$pGPos" /></xsl:attribute>
          <xsl:if test="$pXmllang != ''">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="$pXmllang"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="$tSF"/>
          </xsl:call-template>
        </bf:seriesEnumeration>
      <xsl:if test="$tSF880Val != ''">
        <bf:seriesEnumeration>
          <xsl:attribute name="groupNum"><xsl:value-of select="$pGPos" /></xsl:attribute>
          <xsl:if test="$p880Xmllang != ''">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="$p880Xmllang"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="$tSF880Val"/>
          </xsl:call-template>
        </bf:seriesEnumeration>
      </xsl:if>
      </xsl:if>
    <xsl:if test="$tSF/@code='x'">
    <bf:identifiedBy>
      <xsl:attribute name="groupNum"><xsl:value-of select="$pGPos" /></xsl:attribute>
      <bf:Issn>
        <rdf:value>
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="$tSF"/>
          </xsl:call-template>
        </rdf:value>
      </bf:Issn>
    </bf:identifiedBy>
    </xsl:if>
    <xsl:if test="$tSF/@code='y'">
      <bf:identifiedBy>
        <xsl:attribute name="groupNum"><xsl:value-of select="$pGPos" /></xsl:attribute>
        <bf:Issn>
          <rdf:value>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$tSF"/>
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
    </xsl:if>
    <xsl:if test="$tSF/@code='z'">
      <bf:identifiedBy>
        <xsl:attribute name="groupNum"><xsl:value-of select="$pGPos" /></xsl:attribute>
        <Issn>
          <rdf:value>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$tSF"/>
            </xsl:call-template>
          </rdf:value>
          <bf:status>
            <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/cancinv">
              <rdfs:label>canceled</rdfs:label>
            </bf:Status>
          </bf:status>
        </Issn>
      </bf:identifiedBy>
    </xsl:if>
    
    <xsl:variable name="next_gpos" select="$pGPos + 1"/>
    <xsl:variable name="next_pos" select="$pPos + 1"/>
    
    <xsl:choose>
      <xsl:when test="$tSF/@code = '6'">
        <xsl:apply-templates select="." mode="groupify490">
          <xsl:with-param name="pGPos" select="$pGPos" />
          <xsl:with-param name="pPos" select="$next_pos" />
          <xsl:with-param name="pXmllang" select="$pXmllang" />
          <xsl:with-param name="pRelated880" select="$pRelated880" />
          <xsl:with-param name="p880Xmllang" select="$p880Xmllang" />
        </xsl:apply-templates>
      </xsl:when>
      <!-- This subfield is the end of a parallel title.  Start a new group. -->
      <xsl:when test="substring($tSF, string-length($tSF))='='">
        <xsl:apply-templates select="." mode="groupify490">
          <xsl:with-param name="pGPos" select="$next_gpos" />
          <xsl:with-param name="pPos" select="$next_pos" />
          <xsl:with-param name="pXmllang" select="$pXmllang" />
        </xsl:apply-templates>
      </xsl:when>
      <!-- The next subfield is an 'a' and this subfield is not. Start a new group. -->
      <xsl:when test="$tSF/@code != 'a' and marc:subfield[$next_pos]/@code='a'">
        <xsl:apply-templates select="." mode="groupify490">
          <xsl:with-param name="pGPos" select="$next_gpos" />
          <xsl:with-param name="pPos" select="$next_pos" />
          <xsl:with-param name="pXmllang" select="$pXmllang" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="marc:subfield[$next_pos]">
        <xsl:apply-templates select="." mode="groupify490">
          <xsl:with-param name="pGPos" select="$pGPos" />
          <xsl:with-param name="pPos" select="$next_pos" />
          <xsl:with-param name="pXmllang" select="$pXmllang" />
          <xsl:with-param name="pRelated880" select="$pRelated880" />
          <xsl:with-param name="p880Xmllang" select="$p880Xmllang" />
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
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
    
    <xsl:variable name="vOccurrence">
      <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
        <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vRelated880" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" />
    <xsl:variable name="v880XmlLang"><xsl:apply-templates select="$vRelated880" mode="xmllang"/></xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:relation>
          <bf:Relation>
            <bf:relationship>
              <bf:Relationship rdf:about="http://id.loc.gov/ontologies/bibframe/hasSeries">
                <rdfs:label>Has Series</rdfs:label>
              </bf:Relationship>
            </bf:relationship>
            <bf:associatedResource>
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
            </bf:associatedResource>
            <xsl:for-each select="marc:subfield[@code = 'v']">
              <bf:seriesEnumeration>
                <xsl:value-of  select="."/>                
              </bf:seriesEnumeration>
            </xsl:for-each>
            <xsl:for-each select="$vRelated880/marc:subfield[@code='v']">
              <bf:seriesEnumeration>
                <xsl:if test="$v880XmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of  select="."/>  
              </bf:seriesEnumeration>
            </xsl:for-each>
            
          </bf:Relation>
        </bf:relation>

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
