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
  <xsl:template match="marc:datafield[@tag='130' or @tag='240']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="workUnifTitle" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
    <!-- create translationOf property and Work from uniform title if a translation -->
    <xsl:if test="marc:subfield[@code='l']">
      <xsl:variable name="vWorkUri">
        <xsl:apply-templates mode="generateUri" select=".">
          <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
          <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization='rdfxml'">
          <bf:translationOf>
            <bf:Work>
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vWorkUri"/></xsl:attribute>
              <xsl:apply-templates mode="workUnifTitle" select=".">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pTranslation">true</xsl:with-param>
              </xsl:apply-templates>
            </bf:Work>
          </bf:translationOf>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='630']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="workiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work630" select=".">
      <xsl:with-param name="workiri" select="$workiri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work630">
    <xsl:param name="recordid"/>
    <xsl:param name="workiri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vSourceCode"><xsl:value-of select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/code"/></xsl:variable>
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
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:call-template name="chopPunctuation">
            <xsl:with-param name="chopString" select="$vTitleLabel"/>
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
          <bf:Work>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$workiri"/></xsl:attribute>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$vMADSClass)"/></xsl:attribute>
            </rdf:type>
            <madsrdf:authoritativeLabel><xsl:value-of select="$vMADSLabel"/></madsrdf:authoritativeLabel>
            <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
              <madsrdf:isMemberofMADSScheme>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
              </madsrdf:isMemberofMADSScheme>
            </xsl:for-each>                  
            <xsl:if test="$vSource != ''">
              <xsl:copy-of select="$vSource"/>
            </xsl:if>
            <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pMode">relationship</xsl:with-param>
              <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
            </xsl:apply-templates>
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
            <xsl:apply-templates select="." mode="workUnifTitle">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Work>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='730' or @tag='740']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="workiri">
      <xsl:apply-templates mode="generateUri" select=".">
        <xsl:with-param name="pDefaultUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:with-param>
        <xsl:with-param name="pEntity">bf:Work</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates mode="work730" select=".">
      <xsl:with-param name="workiri" select="$workiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="marc:datafield" mode="work730">
    <xsl:param name="workiri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="@ind2='2'">
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
              <bf:relatedTo><xsl:value-of select="$workiri"/></bf:relatedTo>
            </bflc:Relationship>
          </bflc:relationship>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Processing for 830/440 tags in ConvSpec-Process6-Series.xsl -->

  <!-- can be applied by templates above or by name/subject templates -->
  <xsl:template match="marc:datafield" mode="workUnifTitle">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTranslation"/>
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
      <xsl:apply-templates select="." mode="tTitleLabel">
        <xsl:with-param name="pTranslation"><xsl:value-of select="$pTranslation"/></xsl:with-param>
      </xsl:apply-templates>
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
        <xsl:choose>
          <xsl:when test="substring($tag,2,2)='30' or substring($tag,2,2)='40'">
            <xsl:for-each select="marc:subfield[@code='g']">
              <bf:genreForm>
                <bf:GenreForm>
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
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='g']">
              <bf:genreForm>
                <bf:GenreForm>
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
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:genreForm>
            <bf:GenreForm>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="chopBrackets">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>        
        <xsl:for-each select="marc:subfield[@code='k']">
          <bf:natureOfContent>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:value-of select="."/>
              </xsl:with-param>
            </xsl:call-template>
          </bf:natureOfContent>
          <bf:genreForm>
            <bf:GenreForm>
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
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>        
        <xsl:for-each select="marc:subfield[@code='l']">
          <xsl:choose>
            <xsl:when test="$pTranslation='true'">
              <xsl:if test="count(../../marc:datafield[@tag='041' and @ind1='1']/marc:subfield[@code='h'])=1">
                <bf:language>
                  <xsl:choose>
                    <xsl:when test="../../marc:datafield[@tag='041' and @ind1='1' and marc:subfield[@code='h']]/@ind2 = ' '">
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($languages,../../marc:datafield[@tag='041' and @ind1='1']/marc:subfield[@code='h'])"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <bf:Language>
                        <rdfs:label><xsl:value-of select="../../marc:datafield[@tag='041' and @ind1='1']/marc:subfield[@code='h']"/></rdfs:label>
                      </bf:Language>
                    </xsl:otherwise>
                  </xsl:choose>
                </bf:language>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <bf:language>
                <bf:Language>
                  <rdfs:label>
                    <!-- <xsl:if test="$vXmlLang != ''"> -->
                    <!--   <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute> -->
                    <!-- </xsl:if> -->
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Language>
              </bf:language>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
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
        <xsl:for-each select="marc:subfield[@code='o' or @code='s']">
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
              <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates mode="subfield0orw" select=".">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='t']/following-sibling::marc:subfield[@code='0' or @code='w']">
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
            <bflc:titleSortKey><xsl:value-of select="normalize-space(substring($label,$nfi+1))"/></bflc:titleSortKey>
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
                      <xsl:value-of select="."/>
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
                      <xsl:value-of select="."/>
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
    <xsl:param name="pTranslation"/>
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
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[@code='f' or
                                     @code='g' or 
                                     @code='k' or
                                     @code='l' or
                                     @code='m' or
                                     @code='n' or
                                     @code='o' or
                                     @code='p' or
                                     @code='r' or
                                     @code='s']"/>
      </xsl:when>
      <xsl:when test="substring($tag,2,2)='10'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='t'] |
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[@code='d' or
                                     @code='f' or
                                     @code='g' or
                                     @code='k' or
                                     @code='l' or
                                     @code='m' or
                                     @code='n' or
                                     @code='o' or
                                     @code='p' or
                                     @code='r' or
                                     @code='s']"/>
      </xsl:when>
      <xsl:when test="substring($tag,2,2)='11'">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="marc:subfield[@code='t'] |
                                     marc:subfield[@code='t']/following-sibling::marc:subfield[@code='f' or
                                     @code='g' or
                                     @code='k' or
                                     @code='l' or
                                     @code='n' or
                                     @code='p' or
                                     @code='s']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$pTranslation='true'">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='d' or
                                         @code='f' or
                                         @code='g' or 
                                         @code='k' or
                                         @code='m' or
                                         @code='n' or
                                         @code='o' or
                                         @code='p' or
                                         @code='r' or
                                         @code='s']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='d' or
                                         @code='f' or
                                         @code='g' or 
                                         @code='k' or
                                         @code='l' or
                                         @code='m' or
                                         @code='n' or
                                         @code='o' or
                                         @code='p' or
                                         @code='r' or
                                         @code='s']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
