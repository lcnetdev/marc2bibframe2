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
      Conversion specs for Uniform Titles
  -->

  <!-- bf:Work properties from Uniform Title fields -->
  <xsl:template match="marc:datafield[@tag='130' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='130')] |
                       marc:datafield[@tag='240' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='240')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:variable name="vHubIri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:expressionOf>
          <bf:Hub>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$vHubIri"/></xsl:attribute>
            <xsl:apply-templates mode="hubUnifTitle" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pHubIri" select="$vHubIri"/>
            </xsl:apply-templates>
          </bf:Hub>
        </bf:expressionOf>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Processing for 630 tags in ConvSpec-600-662.xsl -->

  <xsl:template match="marc:datafield[@tag='730' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='730')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="vHubIri">
        <xsl:apply-templates mode="generateUri" select=".">
          <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Hub<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
          <xsl:with-param name="pEntity">bf:Hub</xsl:with-param>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:choose>
            <xsl:when test="@ind2='2' and count(marc:subfield[@code='i']) = 0">
              <bf:hasPart>
                <bf:Hub>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$vHubIri"/></xsl:attribute>
                  <xsl:apply-templates select="." mode="hubUnifTitle">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pHubIri" select="$vHubIri"/>
                  </xsl:apply-templates>
                </bf:Hub>
              </bf:hasPart>
            </xsl:when>
            <xsl:otherwise>
              <bf:relatedTo>
                <bf:Hub>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$vHubIri"/></xsl:attribute>
                  <xsl:apply-templates select="." mode="hubUnifTitle">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pHubIri" select="$vHubIri"/>
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
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$vHubIri"/></xsl:attribute>
                </bf:relatedTo>
              </bflc:Relationship>
            </bflc:relationship>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Processing for 830/440 tags in ConvSpec-Process6-Series.xsl -->

  <!-- can be applied by templates above or by name/subject templates -->
  <xsl:template match="marc:datafield" mode="hubUnifTitle">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHubIri"/>
    <xsl:param name="pSource"/>
    <xsl:param name="pLabel"/>
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
      <!-- 8XX fields construct the label differently, prefer the passed-in parameter -->
      <xsl:choose>
        <xsl:when test="$pLabel != ''"><xsl:value-of select="$pLabel"/></xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="tTitleLabel"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="marc:subfield[@code='o']">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Arrangement')"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
        <xsl:if test="$tag='240'">
          <xsl:apply-templates select="../marc:datafield[@tag='100' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='100')] |
                                       ../marc:datafield[@tag='110' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='110')] |
                                       ../marc:datafield[@tag='111' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='111')]"
                               mode="mProcessWork880">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pAgentIri" select="concat($pHubIri,'-Agent')"/>
          </xsl:apply-templates>
        </xsl:if>
        <bf:title>
          <xsl:apply-templates mode="titleUnifTitle" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="label" select="$label"/>
          </xsl:apply-templates>
        </bf:title>
        <xsl:choose>
          <xsl:when test="substring($tag,2,2='10')">
            <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='d']">
              <bf:legalDate>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                  <xsl:with-param name="pChopParens" select="true()"/>
                </xsl:call-template>
              </bf:legalDate>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="substring($tag,2,2)='30' or substring($tag,2,2)='40'">
            <xsl:for-each select="marc:subfield[@code='d']">
              <bf:legalDate>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                  <xsl:with-param name="pChopParens" select="true()"/>
                </xsl:call-template>
              </bf:legalDate>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
        <xsl:for-each select="marc:subfield[@code='f']">
          <bf:originDate>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:originDate>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='l']">
          <bf:language>
            <bf:Language>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Language>
          </bf:language>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='m']">
          <bf:musicMedium>
            <bf:MusicMedium>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:MusicMedium>
          </bf:musicMedium>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='r']">
          <bf:musicKey>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:musicKey>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='s']">
          <bf:version>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:version>
        </xsl:for-each>
        <xsl:if test="substring($tag,1,1)='7'"> <!-- $x processed in ConvSpec-Process for 8XX -->
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
        </xsl:if>
        <xsl:if test="substring($tag,2,2)='30' or $tag='240' or marc:subfield[@code='t']">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']">
              <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='0'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='0']">
                <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="marc:subfield[@code='0'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='0']">
                <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$pSource != ''">
              <xsl:copy-of select="$pSource"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="subfield2" select="marc:subfield[@code='2']">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates mode="subfield3" select="marc:subfield[@code='3']">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- build a bf:Title entity -->
  <xsl:template match="marc:datafield" mode="titleUnifTitle">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="label"/>
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
    <xsl:variable name="nfi">
      <xsl:choose>
        <xsl:when test="$tag='130' or $tag='630' or $tag='730'">
          <xsl:value-of select="@ind1"/>
        </xsl:when>
        <xsl:when test="$tag='240' or $tag='830' or $tag='440'">
          <xsl:value-of select="@ind2"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marckey">
      <xsl:apply-templates mode="marcKey"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2)='00'">
              <xsl:if test="$label != ''">
                <bflc:title00MatchKey>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="normalize-space($label)"/>
                  </xsl:call-template>
                </bflc:title00MatchKey>
              </xsl:if>
              <bflc:title00MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title00MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='10'">
              <xsl:if test="$label != ''">
                <bflc:title10MatchKey>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="normalize-space($label)"/>
                  </xsl:call-template>
                </bflc:title10MatchKey>                  
              </xsl:if>
              <bflc:title10MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title10MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='11'">
              <xsl:if test="$label != ''">
                <bflc:title11MatchKey>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="normalize-space($label)"/>
                  </xsl:call-template>
                </bflc:title11MatchKey>                  
              </xsl:if>
              <bflc:title11MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title11MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='30'">
              <xsl:if test="$label != ''">
                <bflc:title30MatchKey>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="normalize-space($label)"/>
                  </xsl:call-template>
                </bflc:title30MatchKey>                  
              </xsl:if>
              <bflc:title30MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title30MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='40'">
              <xsl:if test="$label != ''">
                <bflc:title40MatchKey>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="normalize-space($label)"/>
                  </xsl:call-template>
                </bflc:title40MatchKey>                  
              </xsl:if>
              <bflc:title40MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title40MarcKey>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$nfi != 0">
            <bflc:titleSortKey>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="normalize-space(substring($label,$nfi+1))"/>
              </xsl:call-template>
            </bflc:titleSortKey>
          </xsl:if>
          <bf:mainTitle>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$label"/>
            </xsl:call-template>
          </bf:mainTitle>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2) = '11'">
              <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='n']">
                <bf:partNumber>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:partNumber>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="marc:subfield[@code='n']">
                <bf:partNumber>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:partNumber>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:for-each select="marc:subfield[@code='p']">
            <bf:partName>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="."/>
              </xsl:call-template>
            </bf:partName>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- can be applied by templates above or by name/subject templates -->
  <xsl:template match="marc:datafield" mode="tTitleLabel">
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
      <xsl:when test="substring($tag,2,2)='00' or
                      substring($tag,2,2)='10' or
                      substring($tag,2,2)='11'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='t'] |
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[not(contains('hivwxyz012345678',@code))]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[not(contains('hivwxyz012345678',@code))]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
