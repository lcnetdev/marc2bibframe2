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

  <!-- Conversion specs for 8XX (and obsolete 4XX) - Series -->

  <xsl:template match="marc:datafield[@tag='800' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='800')] |
                       marc:datafield[@tag='810' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='810')] |
                       marc:datafield[@tag='811' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='811')] |
                       marc:datafield[@tag='830' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='830')] |
                       marc:datafield[@tag='400' or @tag='410' or @tag='411' or @tag='440']"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vCurrentPos">
        <xsl:choose>
          <xsl:when test="substring(@tag,1,1)='8'">
            <xsl:value-of select="count(preceding-sibling::marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830' or (@tag='880' and (substring(marc:subfield[@code='6'],1,3)='800' or substring(marc:subfield[@code='6'],1,3)='810' or substring(marc:subfield[@code='6'],1,3)='811' or substring(marc:subfield[@code='6'],1,3)='830') and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)='00')]) + 1"/>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vHubIri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space"
                           select="marc:subfield[not(contains('hvwx012345678',@code))]"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasSeries>
          <bf:Hub>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$vHubIri"/></xsl:attribute>
            <xsl:choose>
              <xsl:when test="$vTag='830' or $vTag='440'">
                <xsl:apply-templates mode="hubUnifTitle" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pLabel" select="$vLabel"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="workName" select=".">
                  <xsl:with-param name="agentiri" select="$agentiri"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="marc:subfield[@code='w']">
              <xsl:variable name="vIdClass">
                <xsl:choose>
                  <xsl:when test="starts-with(.,'(DLC)')">bf:Lccn</xsl:when>
                  <xsl:otherwise>bf:Identifier</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:apply-templates mode="subfield0orw" select=".">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pIdClass" select="$vIdClass"/>
              </xsl:apply-templates>
            </xsl:for-each>
            <xsl:choose>
              <xsl:when test="marc:subfield[@code='x']">
                <xsl:for-each select="marc:subfield[@code='x']">
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
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="substring($vTag,1,1)='8' and count(../marc:datafield[@tag='490' and @ind1 = '1']) &gt; 0">
                  <xsl:variable name="vIssn">
                    <xsl:call-template name="tIssn490">
                      <xsl:with-param name="pLastPos" select="$pCurrentPos"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:if test="$vIssn != ''">
                    <bf:identifiedBy>
                      <bf:Issn>
                        <rdf:value><xsl:value-of select="$vIssn"/></rdf:value>
                      </bf:Issn>
                    </bf:identifiedBy>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
            <!-- $3 processed by hubUnifTitle template -->
            <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="subfield7" select="marc:subfield[@code='7']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Hub>
        </bf:hasSeries>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      extract ISSN for series from matching 490
      if there is no matching 490 (or the matching 490 has no $x),
      return empty string
  -->
  <xsl:template name="tIssn490">
    <xsl:param name="pCurrentPos" select="1"/>
    <xsl:param name="pLastPos"/>
    <xsl:param name="pCompositePos" select="1"/>
    <xsl:if test="../marc:datafield[@tag='490' and @ind1='1'][$pCurrentPos]/marc:subfield[@code='a']">
      <xsl:choose>
        <xsl:when test="$pCompositePos &lt;= $pLastPos">
          <xsl:variable name="vParallel">
            <xsl:choose>
              <xsl:when test="substring(../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='a'][1],string-length(../marc:datafield[@tag='490' and @ind1='1'][$pCurrentPos]/marc:subfield[@code='a'][1])) = '=' or
                              substring(../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='v'][1],string-length(../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='v'][1])) = '='">
                <xsl:text>parallel</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$vParallel != ''">
              <xsl:choose>
                <xsl:when test="$pCompositePos=$pLastPos">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='x'][1]"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="tIssn490">
                    <xsl:with-param name="pCurrentPos" select="$pCurrentPos + 1"/>
                    <xsl:with-param name="pLastPos" select="$pLastPos"/>
                    <xsl:with-param name="pCompositePos" select="$pCompositePos + 1"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='a']">
                <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
                <xsl:if test="$pCompositePos + position() - 1 = $pLastPos">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="following-sibling::marc:subfield[@code='x' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode]"/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
              <xsl:if test="$pCompositePos + count(../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='a']) &lt; $pLastPos">
                <xsl:call-template name="tIssn490">
                  <xsl:with-param name="pCurrentPos" select="$pCurrentPos + 1"/>
                  <xsl:with-param name="pLastPos" select="$pLastPos"/>
                  <xsl:with-param name="pCompositePos" select="$pCompositePos + count(../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1'][$pCurrentPos]/marc:subfield[@code='a'])"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='800' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='800')] |
                       marc:datafield[@tag='810' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='810')] |
                       marc:datafield[@tag='811' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='811')] |
                       marc:datafield[@tag='830' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='830')] |
                       marc:datafield[@tag='400' or @tag='410' or @tag='411' or @tag='440']"
                mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vCurrentPos">
        <xsl:choose>
          <xsl:when test="substring(@tag,1,1)='8'">
            <xsl:value-of select="count(preceding-sibling::marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830' or (@tag='880' and (substring(marc:subfield[@code='6'],1,3)='800' or substring(marc:subfield[@code='6'],1,3)='810' or substring(marc:subfield[@code='6'],1,3)='811' or substring(marc:subfield[@code='6'],1,3)='830') and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)='00')]) + 1"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="." mode="instance8XX">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pCurrentPos" select="$vCurrentPos"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instance8XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pCurrentPos" select="1"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="count(../marc:datafield[((@tag='880' and substring(marc:subfield[@code='6'],1,3)='490') or (@tag='490' and not(marc:subfield[@code='6']))) and @ind1='1']) &lt; $pCurrentPos or substring($vTag,1,1)='4'">
      <xsl:variable name="vStatement">
        <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[not(contains('wx012345678',@code))]"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:seriesStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$vStatement"/>
            </xsl:call-template>
          </bf:seriesStatement>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
