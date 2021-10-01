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

  <!-- Conversion specs for 5XX fields -->

  <xsl:template match="marc:datafield[@tag='502' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='502')]" mode="work">
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:dissertation>
          <bf:Dissertation>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:degree>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:degree>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:grantingInstitution>
                <bf:Agent>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Agent>
              </bf:grantingInstitution>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='d']">
              <bf:date>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:date>
            </xsl:for-each>
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
            <xsl:for-each select="marc:subfield[@code='o']">
              <bf:identifiedBy>
                <bf:DissertationIdentifier>
                  <rdf:value>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdf:value>
                </bf:DissertationIdentifier>
              </bf:identifiedBy>
            </xsl:for-each>
          </bf:Dissertation>
        </bf:dissertation>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='505' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='505')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='g' or @code='r' or @code='t']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:tableOfContents>
          <bf:TableOfContents>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space($vLabel)"/>
            </rdfs:label>
            <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:TableOfContents>
        </bf:tableOfContents>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='507' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='507')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:scale>
          <bf:Scale>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space($vLabel)"/>
            </rdfs:label>
          </bf:Scale>
        </bf:scale>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='518' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='518')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:capture>
          <bf:Capture>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='d']">
              <bf:date>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:date>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='o']">
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
            <xsl:for-each select="marc:subfield[@code='p']">
              <bf:place>
                <bf:Place>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Place>
              </bf:place>
            </xsl:for-each>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Capture>
        </bf:capture>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='520' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='520')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b' or @code='c']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:summary>
          <bf:Summary>
            <xsl:if test="normalize-space($vLabel) != ''">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space($vLabel)"/>
              </rdfs:label>
            </xsl:if>
            <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Summary>
        </bf:summary>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='521' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='521')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vNote">
      <xsl:choose>
        <xsl:when test="@ind1='0'">reading grade level</xsl:when>
        <xsl:when test="@ind1='1'">interest age level</xsl:when>
        <xsl:when test="@ind1='2'">interest grade level</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:intendedAudience>
          <bf:IntendedAudience>
            <xsl:if test="normalize-space($vLabel) != ''">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space($vLabel)"/>
              </rdfs:label>
            </xsl:if>
            <xsl:if test="$vNote != ''">
              <bf:note>
                <bf:Note>
                  <rdfs:label><xsl:value-of select="$vNote"/></rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:if>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:IntendedAudience>
        </bf:intendedAudience>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='522' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='522')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:geographicCoverage>
            <bf:GeographicCoverage>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </bf:GeographicCoverage>
          </bf:geographicCoverage>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='525' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='525')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:supplementaryContent>
            <bf:SupplementaryContent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </bf:SupplementaryContent>
          </bf:supplementaryContent>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='546' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='546')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:language>
            <bf:Language>
              <bf:note>
                <bf:Note>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                      <xsl:with-param name="pEndPunct" select="':;,/='"/>
                    </xsl:call-template>
                  </rdfs:label>
                  <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </bf:Note>
              </bf:note>
            </bf:Language>
          </bf:language>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:notation>
            <bf:Notation>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Notation>
          </bf:notation>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='580' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='580')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </xsl:for-each>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='586' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='586')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:awards>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:awards>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='500' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='500')] |
                       marc:datafield[@tag='501' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='501')] |
                       marc:datafield[@tag='513' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='513')] |
                       marc:datafield[@tag='515' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='515')] |
                       marc:datafield[@tag='516' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='516')] |
                       marc:datafield[@tag='530' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='530')] |
                       marc:datafield[@tag='533' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='533')] |
                       marc:datafield[@tag='534' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='534')] |
                       marc:datafield[@tag='536' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='536')] |
                       marc:datafield[@tag='544' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='544')] |
                       marc:datafield[@tag='545' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='545')] |
                       marc:datafield[@tag='547' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='547')] |
                       marc:datafield[@tag='550' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='550')] |
                       marc:datafield[@tag='555' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='555')] |
                       marc:datafield[@tag='556' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='556')] |
                       marc:datafield[@tag='581' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='581')] |
                       marc:datafield[@tag='585' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='585')] |
                       marc:datafield[@tag='588' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='588')]"
                mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:apply-templates select="." mode="instanceNote5XX">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='504' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='504')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:supplementaryContent>
          <bf:SupplementaryContent>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:count>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:count>
            </xsl:for-each>
          </bf:SupplementaryContent>
        </bf:supplementaryContent>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='506' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='506')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
      <xsl:variable name="vLabel">
        <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='e' or @code='f' or @code='g' or @code='q']"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:usageAndAccessPolicy>
            <bf:AccessPolicy>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space($vLabel)"/>
              </rdfs:label>
              <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:AccessPolicy>
          </bf:usageAndAccessPolicy>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='508' or @tag='511' or (@tag='880' and (substring(marc:subfield[@code='6'],1,3)='508' or substring(marc:subfield[@code='6'],1,3)='511'))]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vDisplayConst">
      <xsl:choose>
        <xsl:when test="$vTag='511' and @ind1='1'">Cast: </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:credits>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$vDisplayConst"/><xsl:value-of select="."/>
          </bf:credits>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='524' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='524')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:preferredCitation>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:preferredCitation>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='532' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='532')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a']">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:contentAccessibility>
            <bf:ContentAccessibility>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </bf:ContentAccessibility>
          </bf:contentAccessibility>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='538' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='538')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:systemRequirement>
            <bf:SystemRequirement>
              <xsl:for-each select="marc:subfield[@code='a']">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </rdfs:label>
              </xsl:for-each>
              <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:SystemRequirement>
          </bf:systemRequirement>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='540' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='540')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
      <xsl:variable name="vLabel">
        <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='c' or @code='f' or @code='g' or @code='q']"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:usageAndAccessPolicy>
            <bf:UsePolicy>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space($vLabel)"/>
              </rdfs:label>
              <xsl:for-each select="marc:subfield[@code='d']">
                <xsl:variable name="vNoteLabel">
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </xsl:variable>
                <bf:note>
                  <bf:Note>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:text>Authorized users: </xsl:text><xsl:value-of select="$vNoteLabel"/>
                    </rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:for-each>
              <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:UsePolicy>
          </bf:usageAndAccessPolicy>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield" mode="instanceNote5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pNoteType"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:choose>
        <xsl:when test="$vTag='513' or $vTag='545'">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
        </xsl:when>
        <xsl:when test="$vTag='530'">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[contains('abc',@code)]"/>
        </xsl:when>
        <xsl:when test="$vTag='533'">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[contains('abcdefn',@code)]"/>
        </xsl:when>
        <xsl:when test="$vTag='534'">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[contains('abcefkmnt',@code)]"/>
        </xsl:when>
        <xsl:when test="$vTag='544'">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='e' or @code='n']"/>
        </xsl:when>
        <xsl:when test="$vTag='555'">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d']"/>
        </xsl:when>
        <xsl:when test="$vTag='588'">
          <xsl:variable name="vDisplayConstant">
            <xsl:choose>
              <xsl:when test="@ind1='0'">Description based on:</xsl:when>
              <xsl:when test="@ind1='1'">Latest issue consulted:</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="concat($vDisplayConstant,' ',marc:subfield[@code='a'])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a']"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vNoteType">
      <xsl:choose>
        <xsl:when test="$vTag='501'">with</xsl:when>
        <xsl:when test="$vTag='513'">report</xsl:when>
        <xsl:when test="$vTag='515'">issuance</xsl:when>
        <xsl:when test="$vTag='516'">computer</xsl:when>
        <xsl:when test="$vTag='530'">addphys</xsl:when>
        <xsl:when test="$vTag='533'">repro</xsl:when>
        <xsl:when test="$vTag='534'">orig</xsl:when>
        <xsl:when test="$vTag='536'">fundinfo</xsl:when>
        <xsl:when test="$vTag='544' or $vTag='581'">related</xsl:when>
        <xsl:when test="$vTag='545'">
          <xsl:choose>
            <xsl:when test="@ind1='0'">biogdata</xsl:when>
            <xsl:when test="@ind1='1'">adminhist</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='550'">issuing</xsl:when>
        <xsl:when test="$vTag='555'">
          <xsl:choose>
            <xsl:when test="@ind1=' '">index</xsl:when>
            <xsl:when test="@ind1='0'">finding</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='585'">exhibit</xsl:when>
        <xsl:when test="$vTag='588'">descsource</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <xsl:if test="$vLabel != ''">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space($vLabel)"/>
              </rdfs:label>
            </xsl:if>
            <xsl:if test="$vNoteType != ''">
              <rdf:type>
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="concat('http://id.loc.gov/vocabulary/mnotetype/', $vNoteType)"/>
                </xsl:attribute>
              </rdf:type>
            </xsl:if>
            <!-- special handling for other subfields -->
            <xsl:choose>
              <xsl:when test="$vTag='530'">
                <xsl:for-each select="marc:subfield[@code='d']">
                  <bf:identifiedBy>
                    <bf:StockNumber>
                      <rdf:value>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </rdf:value>
                    </bf:StockNumber>
                    </bf:identifiedBy>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$vTag='533'">
                <xsl:apply-templates select="marc:subfield[@code='m']" mode="subfield3">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="$vTag='534'">
                <xsl:apply-templates select="marc:subfield[@code='p']" mode="subfield3">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
                <xsl:for-each select="marc:subfield[@code='x' or @code='z']">
                  <xsl:variable name="vIdClass">
                    <xsl:choose>
                      <xsl:when test="@code='x'">bf:Issn</xsl:when>
                      <xsl:when test="@code='z'">bf:Isbn</xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <bf:identifiedBy>
                    <xsl:element name="{$vIdClass}">
                      <rdf:value>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </rdf:value>
                    </xsl:element>
                  </bf:identifiedBy>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$vTag='536'">
                <xsl:for-each select="marc:subfield[@code='b' or @code='c' or @code='d' or @code='e' or @code='f' or @code='g' or @code='h']">
                  <xsl:variable name="vDisplayConst">
                    <xsl:choose>
                      <xsl:when test="@code='b'">Contract: </xsl:when>
                      <xsl:when test="@code='c'">Grant: </xsl:when>
                      <xsl:when test="@code='e'">Program element: </xsl:when>
                      <xsl:when test="@code='f'">Project: </xsl:when>
                      <xsl:when test="@code='g'">Task: </xsl:when>
                      <xsl:when test="@code='h'">Work unit: </xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="concat($vDisplayConst,.)"/>
                    </xsl:call-template>
                  </rdfs:label>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$vTag='581'">
                <xsl:for-each select="marc:subfield[@code='z']">
                  <bf:identifiedBy>
                    <bf:Isbn>
                      <rdf:value>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </rdf:value>
                    </bf:Isbn>
                  </bf:identifiedBy>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='541' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='541')] |
                       marc:datafield[@tag='561' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='561')] |
                       marc:datafield[@tag='563' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='563')] |
                       marc:datafield[@tag='583' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='583')]"
                mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:variable>
    <xsl:apply-templates select="." mode="hasItem5XX">
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serializaiton" select="$serialization"/>
      <xsl:with-param name="pItemUri" select="$vItemUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="hasItem5XX">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pItemUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="not($localfields)">
      <xsl:choose>
        <xsl:when test="$serialization='rdfxml'">
          <xsl:if test="generate-id(.) = generate-id(../marc:datafield[((@tag='541' or @tag='561' or @tag='563' or @tag='583') and not(marc:subfield[@code='6'])) or (@tag='880' and (substring(marc:subfield[@code='6'],1,3)='541' or substring(marc:subfield[@code='6'],1,3)='561' or substring(marc:subfield[@code='6'],1,3)='563' or substring(marc:subfield[@code='6'],1,3)='583'))][not(marc:subfield[@code='3' or @code='5'])][position()=1]) or marc:subfield[@code='3' or @code='5']">
            <bf:hasItem>
              <bf:Item>
                <xsl:attribute name="rdf:about"><xsl:value-of select="$pItemUri"/></xsl:attribute>
                <xsl:choose>
                  <xsl:when test="marc:subfield[@code='3' or @code='5']">
                    <xsl:apply-templates select="." mode="item5XX">
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="../marc:datafield[((@tag='541' or @tag='561' or @tag='563' or @tag='583') and not(marc:subfield[@code='6'])) or (@tag='880' and (substring(marc:subfield[@code='6'],1,3)='541' or substring(marc:subfield[@code='6'],1,3)='561' or substring(marc:subfield[@code='6'],1,3)='563' or substring(marc:subfield[@code='6'],1,3)='583'))][not(marc:subfield[@code='3' or @code='5'])]" mode="item5XX">
                      <xsl:with-param name="serialization" select="$serialization"/>
                    </xsl:apply-templates>
                  </xsl:otherwise>
                </xsl:choose>
                <bf:itemOf>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
                </bf:itemOf>
              </bf:Item>
            </bf:hasItem>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='541' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='541')]" mode="item5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='e' or @code='f' or @code='h' or @code='n' or @code='o']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:immediateAcquisition>
          <bf:ImmediateAcquisition>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space($vLabel)"/>
            </rdfs:label>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:ImmediateAcquisition>
        </bf:immediateAcquisition>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='561' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='561')]" mode="item5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:custodialHistory>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:custodialHistory>
        </xsl:for-each>
        <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='563' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='563')]" mode="item5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:note>
            <bf:Note>
              <rdf:type>
                <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/binding</xsl:attribute>
              </rdf:type>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='583' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='583')]" mode="item5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <rdf:type>
              <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/action</xsl:attribute>
            </rdf:type>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:date>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:date>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='h']">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='k']">
              <bf:agent>
                <bf:Agent>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Agent>
              </bf:agent>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='l']">
              <bf:status>
                <bf:Status>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Status>
              </bf:status>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='z']">
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
            <xsl:apply-templates select="marc:subfield[@code='u']" mode="subfieldu">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
