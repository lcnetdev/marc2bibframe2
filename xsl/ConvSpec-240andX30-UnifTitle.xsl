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
    <!-- kefo note - all main entry uniform titles generate an expressionOf relationship to a Hub. -->
    <xsl:variable name="vWorkUri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="vProp" select="'bf:expressionOf'" />
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:element name="{$vProp}">
          <bf:Work>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$vWorkUri"/></xsl:attribute>
            <xsl:apply-templates mode="workUnifTitle" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pUnifTitleMode" select='expression' />
              <xsl:with-param name="pWorkUri"><xsl:value-of select="$vWorkUri"/></xsl:with-param>
            </xsl:apply-templates>
          </bf:Work>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Processing for 630 tags in ConvSpec-600-662.xsl -->

  <xsl:template match="marc:datafield[@tag='730' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='730')] |
                       marc:datafield[@tag='740' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='740')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:variable name="workiri">
        <xsl:apply-templates mode="generateUri" select=".">
          <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:with-param>
          <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:choose>
            <xsl:when test="@ind2='2' and count(marc:subfield[@code='i']) = 0">
              <bf:hasPart>
                <bf:Work>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
                  <xsl:apply-templates select="." mode="workUnifTitle">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </bf:Work>
              </bf:hasPart>
            </xsl:when>
            <xsl:otherwise>
              <bf:relatedTo>
                <bf:Work>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
                  <xsl:apply-templates select="." mode="workUnifTitle">
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
    </xsl:if>
  </xsl:template>

  <!-- Processing for 830/440 tags in ConvSpec-Process6-Series.xsl -->

  <!-- can be applied by templates above or by name/subject templates -->
  <xsl:template match="marc:datafield" mode="workUnifTitle">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pUnifTitleMode"/>
    <xsl:param name="pWorkUri"/>
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
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <!-- 
      kefo note - 20210715
      We should evaluate the value of these labels.  The label does not include the contributors.
      THat makes them not very useful since a title frequently means nothing without the context
      of a contributor when one exists.
    -->
    <xsl:variable name="label">
      <!-- 8XX fields construct the label differently -->
      <xsl:if test="substring($tag,1,1) != '8' and substring($tag,1,1) != '4'">
        <xsl:apply-templates select="." mode="tTitleLabel">
          <xsl:with-param name="pUnifTitleMode"><xsl:value-of select="$pUnifTitleMode"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$label != ''">
          <rdfs:label>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="normalize-space($label)"/>
          </rdfs:label>
        </xsl:if>
        <xsl:if test="$tag='240'">
          <xsl:apply-templates select="../marc:datafield[@tag='100' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='100')] |
                                       ../marc:datafield[@tag='110' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='110')] |
                                       ../marc:datafield[@tag='111' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='111')]"
                               mode="mProcessWork880">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pAgentIri" select="concat($pWorkUri,'-Agent')"/>
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
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="chopParens">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
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
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="chopParens">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
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
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:value-of select="."/>
              </xsl:with-param>
            </xsl:call-template>
          </bf:originDate>
        </xsl:for-each>
        <!-- 
        <xsl:if test="$pUnifTitleMode='translation'">
          <xsl:if test="count(../marc:datafield[@tag='041' and @ind1='1']/marc:subfield[@code='h'])=1">
            <bf:language>
              <xsl:choose>
                <xsl:when test="../marc:datafield[@tag='041' and @ind1='1' and marc:subfield[@code='h']]/@ind2 = ' '">
                  <xsl:variable name="encoded">
                    <xsl:call-template name="url-encode">
                      <xsl:with-param name="str" select="normalize-space(../marc:datafield[@tag='041' and @ind1='1']/marc:subfield[@code='h'])"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($languages,$encoded)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <bf:Language>
                    <rdfs:label><xsl:value-of select="../marc:datafield[@tag='041' and @ind1='1']/marc:subfield[@code='h']"/></rdfs:label>
                  </bf:Language>
                </xsl:otherwise>
              </xsl:choose>
            </bf:language>
          </xsl:if>
        </xsl:if>
        -->
        <!-- 
          kefo note - I'm really not clear what this rule is for. 
          The first 'not' will evaluate to true if tag is not 130 or 240.
          The second 'not' will evaluate to true if the record does NOT contain a 382.
          So if it is a 730 (or anything other than a 130 or 240), it will evaluate to true because the first 'not' will be true and so the code will always run.
          If it is a 240 with a 382, the first will evaluate to false and the second will also evaluate to false, and so the If will not run.
          If it is a 240 with NO 382, the first will be false and the second will be true, because there's no 382, and the code will run.
          In short, the code will run if not 130 or 240;  that makes sense.
          And it will run if it is a 130 or 240 and there is no 382.  That's not what we want.
            For a Hub, we want to take the $m and leave the 382 business for the Work/Expression.
          Man, that warped my mind.
          <xsl:if test="not($tag='130' or $tag='240') or not(../marc:datafield[@tag='382'])">
          
          Basically, we always want the $m used.  Going to remove the If.
        -->
          <xsl:for-each select="marc:subfield[@code='m']">
            <bf:musicMedium>
              <bf:MusicMedium>
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
              </bf:MusicMedium>
            </bf:musicMedium>
          </xsl:for-each>
        
        <!-- 
          See long comment above.  Same issue here.
          <xsl:if test="not($tag='130' or $tag='240') or not(../marc:datafield[@tag='384'])">
        -->
          <xsl:for-each select="marc:subfield[@code='r']">
            <bf:musicKey>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:musicKey>
          </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code='s']">
          <bf:version>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:value-of select="."/>
              </xsl:with-param>
            </xsl:call-template>
          </bf:version>
        </xsl:for-each>
        <xsl:if test="substring($tag,1,1)='7'"> <!-- $x processed in ConvSpec-Process for 8XX -->
         <xsl:for-each select="marc:subfield[@code='x']">
           <bf:identifiedBy>
             <bf:Issn>
               <rdf:value>
                 <xsl:call-template name="chopPunctuation">
                   <xsl:with-param name="chopString" select="."/>
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
        <xsl:when test="$tag='130' or $tag='630' or $tag='730' or $tag='740'">
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
                <bflc:title00MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:title00MatchKey>
              </xsl:if>
              <bflc:title00MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title00MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='10'">
              <xsl:if test="$label != ''">
                <bflc:title10MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:title10MatchKey>
              </xsl:if>
              <bflc:title10MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title10MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='11'">
              <xsl:if test="$label != ''">
                <bflc:title11MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:title11MatchKey>
              </xsl:if>
              <bflc:title11MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title11MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='30'">
              <xsl:if test="$label != ''">
                <bflc:title30MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:title30MatchKey>
              </xsl:if>
              <bflc:title30MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title30MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='40' and $tag != '740'">
              <xsl:if test="$label != ''">
                <bflc:title40MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:title40MatchKey>
              </xsl:if>
              <bflc:title40MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:title40MarcKey>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="normalize-space($label)"/></rdfs:label>
            <bflc:titleSortKey>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space(substring($label,$nfi+1))"/>
            </bflc:titleSortKey>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2)='30' or substring($tag,2,2)='40'">
              <xsl:for-each select="marc:subfield[@code='a']">
                <bf:mainTitle>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                      <xsl:apply-templates mode="concat-nodes-space"
                                           select="../marc:subfield[contains('agk',@code)]"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </bf:mainTitle>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="marc:subfield[@code='t']">
                <bf:mainTitle>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                      <xsl:apply-templates mode="concat-nodes-space"
                                           select="../marc:subfield[@code='t'] |
                                                   ../marc:subfield[@code='t']/following-sibling::marc:subfield[contains('gk',@code)]"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </bf:mainTitle>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2) = '11'">
              <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='n']">
                <bf:partNumber>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                      <xsl:value-of select="."/>
                    </xsl:with-param>
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
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                      <xsl:value-of select="."/>
                    </xsl:with-param>
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
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partName>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- can be applied by templates above or by name/subject templates -->
  <xsl:template match="marc:datafield" mode="tTitleLabel">
    <xsl:param name="pUnifTitleMode"/>
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
      <xsl:when test="substring($tag,2,2)='00'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='t'] |
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[not(contains('ivwx012345678',@code))]"/>
      </xsl:when>
      <xsl:when test="substring($tag,2,2)='10'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='t'] |
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[not(contains('ivwx012345678',@code))]"/>
      </xsl:when>
      <xsl:when test="substring($tag,2,2)='11'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='t'] |
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[not(contains('ivwx012345678',@code))]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$pUnifTitleMode='translation'">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[not(contains('ilvwx012345678',@code))]"/>
          </xsl:when>
          <xsl:when test="$pUnifTitleMode='arrangement'">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[not(contains('iovwx012345678',@code))]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[not(contains('ivwx012345678',@code))]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
