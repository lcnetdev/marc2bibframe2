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

  <!-- Conversion specs for 490/8XX (and obsolete 4XX) - Series -->

  <!-- Process 490/8XX pairs -->
  <xsl:template match="marc:record" mode="hasSeries">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vCount490" select="count(marc:datafield[@tag='490' and count(marc:subfield[@code='a']) &gt; 1 and contains(string(.),'=')]) + count(marc:datafield[@tag='490' and not(contains(string(.),'='))]/marc:subfield[@code='a'])"/>
    <xsl:for-each select="marc:datafield[@tag='490']">
      <xsl:variable name="vCurrentPos" select="count(preceding-sibling::marc:datafield[@tag='490' and count(marc:subfield[@code='a']) &gt; 1 and contains(string(.),'=')]) + count(preceding-sibling::marc:datafield[@tag='490' and not(contains(string(.),'='))]/marc:subfield[@code='a']) + 1"/>
      <xsl:variable name="vParallelSeriesStatement">
        <xsl:apply-templates select="." mode="mParallelSeriesStatement"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$vParallelSeriesStatement != ''">
          <xsl:variable name="vSeriesEnumeration">
            <xsl:choose>
              <xsl:when test="../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCurrentPos]/marc:subfield[@code='v']"><xsl:value-of select="../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCurrentPos]/marc:subfield[@code='v']"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="marc:subfield[@code='v'][1]"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="vIssn">
            <xsl:choose>
              <xsl:when test="marc:subfield[@code='x']"><xsl:value-of select="marc:subfield[@code='x'][1]"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCurrentPos]/marc:subfield[@code='x']"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="vAppliesTo">
            <xsl:choose>
              <xsl:when test="marc:subfield[@code='3']"><xsl:value-of select="marc:subfield[@code='3']"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCurrentPos]/marc:subfield[@code='3']"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="vWork">
            <xsl:apply-templates select="../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCurrentPos]" mode="seriesWork">
              <xsl:with-param name="recordid" select="$recordid"/>
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pIssn" select="$vIssn"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="buildSeries">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pLabel" select="marc:subfield[@code='a'][1]"/>
            <xsl:with-param name="pSeriesStatement" select="$vParallelSeriesStatement"/>
            <xsl:with-param name="pSeriesEnumeration" select="$vSeriesEnumeration"/>
            <xsl:with-param name="pIssn" select="$vIssn"/>
            <xsl:with-param name="pAppliesTo" select="$vAppliesTo"/>
            <xsl:with-param name="pWork" select="$vWork"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="marc:subfield[@code='a']">
            <xsl:variable name="vCompositePos">
              <xsl:choose>
                <xsl:when test="position() = 1"><xsl:value-of select="$vCurrentPos"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$vCurrentPos + position() - 1"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="vSeriesEnumeration">
              <xsl:choose>
                <xsl:when test="../../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCompositePos]/marc:subfield[@code='v']"><xsl:value-of select="../../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCompositePos]/marc:subfield[@code='v']"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="following-sibling::marc:subfield[@code='v'][1]"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="vIssn">
              <xsl:choose>
                <xsl:when test="following-sibling::marc:subfield[@code='x']"><xsl:value-of select="following-sibling::marc:subfield[@code='x'][1]"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="../../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCompositePos]/marc:subfield[@code='x']"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="vAppliesTo">
              <xsl:choose>
                <xsl:when test="../marc:subfield[@code='3']"><xsl:value-of select="../marc:subfield[@code='3']"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="../../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCompositePos]/marc:subfield[@code='3']"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="vWork">
              <xsl:apply-templates select="../../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position()=$vCompositePos]" mode="seriesWork">
                <xsl:with-param name="recordid" select="$recordid"/>
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pIssn" select="$vIssn"/>
              </xsl:apply-templates>
            </xsl:variable>
            <xsl:call-template name="buildSeries">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pLabel" select="."/>
              <xsl:with-param name="pSeriesStatement">
                <xsl:apply-templates mode="concat-nodes-space" select=". | following-sibling::marc:subfield[@code='v'][1]"/>
              </xsl:with-param>
              <xsl:with-param name="pSeriesEnumeration" select="$vSeriesEnumeration"/>
              <xsl:with-param name="pIssn" select="$vIssn"/>
              <xsl:with-param name="pAppliesTo" select="$vAppliesTo"/>
              <xsl:with-param name="pWork" select="$vWork"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:if test="count(marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830']) &gt; $vCount490">
      <xsl:for-each select="marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830'][position() &gt; $vCount490]">
        <xsl:variable name="vWork">
          <xsl:apply-templates select="." mode="seriesWork">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pIssn" select="marc:subfield[@code='x']"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:call-template name="buildSeries">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pLabel">
            <xsl:choose>
              <xsl:when test="@tag='830'">
                <xsl:apply-templates mode="concat-nodes-space"
                                     select="marc:subfield[@code='a' or @code='n' or @code='p']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="concat-nodes-space"
                                     select="marc:subfield[@code='t' or @code='n' or @code='p']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="pSeriesStatement">
            <xsl:choose>
              <xsl:when test="@tag='830'">
                <xsl:apply-templates mode="concat-nodes-space"
                                     select="marc:subfield[@code='a' or @code='n' or @code='p' or @code='v']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="concat-nodes-space"
                                     select="marc:subfield[@code='t' or @code='n' or @code='p' or @code='v']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="pSeriesEnumeration" select="marc:subfield[@code='v']"/>
          <xsl:with-param name="pIssn" select="marc:subfield[@code='x']"/>
          <xsl:with-param name="pAppliesTo" select="marc:subfield[@code='3']"/>
          <xsl:with-param name="pWork" select="$vWork"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Process legacy 4XX fields -->
  <xsl:template match="marc:datafield[@tag='400' or @tag='410' or @tag='411' or @tag='440']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vWork">
      <xsl:apply-templates select="." mode="seriesWork">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pIssn" select="marc:subfield[@code='x']"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="buildSeries">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pLabel">
        <xsl:choose>
          <xsl:when test="@tag='440'">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or @code='n' or @code='p']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='t' or @code='n' or @code='p']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="pSeriesStatement">
        <xsl:choose>
          <xsl:when test="@tag='440'">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or @code='n' or @code='p' or @code='v']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='t' or @code='n' or @code='p' or @code='v']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="pSeriesEnumeration" select="marc:subfield[@code='v']"/>
      <xsl:with-param name="pIssn" select="marc:subfield[@code='x']"/>
      <xsl:with-param name="pAppliesTo" select="marc:subfield[@code='3']"/>
      <xsl:with-param name="pWork" select="$vWork"/>
    </xsl:call-template>
  </xsl:template>

  <!-- build a series statement if a 490 contains multiple $a as a parallel series statement -->
  <xsl:template match="marc:datafield[@tag='490']" mode="mParallelSeriesStatement">
    <xsl:if test="count(marc:subfield[@code='a']) &gt; 1 and contains(string(.),'=')">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='v']"/>
    </xsl:if>
  </xsl:template>

  <!-- build the hasSeries property -->
  <xsl:template name="buildSeries">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pLabel"/>
    <xsl:param name="pSeriesStatement"/>
    <xsl:param name="pSeriesEnumeration"/>
    <xsl:param name="pIssn"/>
    <xsl:param name="pAppliesTo"/>
    <xsl:param name="pWork"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasSeries>
          <bf:Instance>
            <rdfs:label>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="$pLabel"/>
                <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
              </xsl:call-template>
            </rdfs:label>
            <bf:seriesStatement>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="$pSeriesStatement"/>
                <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
              </xsl:call-template>
            </bf:seriesStatement>
            <xsl:if test="$pSeriesEnumeration != ''">
              <bf:seriesEnumeration>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="$pSeriesEnumeration"/>
                  <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </bf:seriesEnumeration>
            </xsl:if>
            <xsl:if test="$pIssn != ''">
              <bf:identifiedBy>
                <bf:Issn>
                  <rdf:value>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="$pIssn"/>
                      <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdf:value>
                </bf:Issn>
              </bf:identifiedBy>
            </xsl:if>
            <xsl:if test="$pAppliesTo != ''">
              <bflc:appliesTo>
                <bflc:AppliesTo>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="$pAppliesTo"/>
                      <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bflc:AppliesTo>
              </bflc:appliesTo>
            </xsl:if>
            <xsl:if test="$pWork != ''">
              <bf:instanceOf>
                <xsl:copy-of select="$pWork"/>
              </bf:instanceOf>
            </xsl:if>
          </bf:Instance>
        </bf:hasSeries>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- build a Work entity for the Series -->
  <xsl:template match="marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='400' or @tag='410' or @tag='411']" mode="seriesWork">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pIssn"/>
    <xsl:variable name="vTagOrd">
      <xsl:apply-templates select="." mode="tagord"/>
    </xsl:variable>
    <xsl:variable name="agentiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="$vTagOrd"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Agent</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="workiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$vTagOrd"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work8XX" select=".">
      <xsl:with-param name="agentiri" select="$agentiri"/>
      <xsl:with-param name="workiri" select="$workiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pIssn" select="$pIssn"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work8XX">
    <xsl:param name="agentiri"/>
    <xsl:param name="workiri"/>
    <xsl:param name="pIssn"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
          <xsl:apply-templates mode="workName" select=".">
            <xsl:with-param name="agentiri" select="$agentiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          <xsl:if test="$pIssn != ''">
            <bf:identifiedBy>
              <bf:Issn>
                <rdf:value>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$pIssn"/>
                    <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                  </xsl:call-template>
                </rdf:value>
              </bf:Issn>
            </bf:identifiedBy>
          </xsl:if>
          <xsl:apply-templates mode="subfield7" select="marc:subfield[@code='7']">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Work>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='830' or @tag='440']" mode="seriesWork">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pIssn"/>
    <xsl:variable name="vTagOrd">
      <xsl:apply-templates select="." mode="tagord"/>
    </xsl:variable>
    <xsl:variable name="workiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$vTagOrd"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work830" select=".">
      <xsl:with-param name="workiri" select="$workiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pIssn" select="$pIssn"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work830">
    <xsl:param name="workiri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pIssn"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
          <xsl:apply-templates mode="workUnifTitle" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          <xsl:if test="$pIssn != ''">
            <bf:identifiedBy>
              <bf:Issn>
                <rdf:value>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$pIssn"/>
                    <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                  </xsl:call-template>
                </rdf:value>
              </bf:Issn>
            </bf:identifiedBy>
          </xsl:if>
          <xsl:apply-templates mode="subfield7" select="marc:subfield[@code='7']">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Work>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
        
</xsl:stylesheet>
