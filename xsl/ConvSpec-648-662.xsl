<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for 648-662
  -->

  <xsl:template match="marc:datafield[@tag='648' or @tag='650' or @tag='651'] |
                       marc:datafield[@tag='655'][@ind1=' ']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTopicUri">
      <xsl:choose>
        <xsl:when test="@tag='655'">
          <xsl:value-of select="$recordid"/>#GenreForm<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$recordid"/>#Topic<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="." mode="work6XXAuth">
      <xsl:with-param name="pTopicUri" select="$vTopicUri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work6XXAuth">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:param name="pTopicUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProp">
      <xsl:choose>
        <xsl:when test="$vTag='655'">bf:genreForm</xsl:when>
        <xsl:otherwise>bf:subject</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vResource">
      <xsl:choose>
        <xsl:when test="$vTag='655'">bf:GenreForm</xsl:when>
        <xsl:otherwise>bf:Topic</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vSourceCode"><xsl:value-of select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/code"/></xsl:variable>
    <xsl:variable name="vMADSClass">
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='v' or @code='x' or @code='y' or @code='z']">ComplexSubject</xsl:when>
        <xsl:when test="$vTag='648'">Temporal</xsl:when>
        <xsl:when test="$vTag='650'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='b']">ComplexSubject</xsl:when>
            <xsl:otherwise>Topic</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='651'">Geographic</xsl:when>
        <xsl:when test="$vTag='655'">GenreForm</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:choose>
            <xsl:when test="$vTag='650'">
              <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='v' or @code='x' or @code='y' or @code='z']">
                <xsl:value-of select="concat(.,'--')"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="marc:subfield[@code='a' or @code='v' or @code='x' or @code='y' or @code='z']">
                <xsl:value-of select="concat(.,'--')"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vProp}">
          <xsl:element name="{$vResource}">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$pTopicUri"/></xsl:attribute>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,$vMADSClass)"/></xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
            <madsrdf:authoritativeLabel>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </madsrdf:authoritativeLabel>
            <xsl:for-each select="$subjectThesaurus/subjectThesaurus/subject[@ind2=current()/@ind2]/madsscheme">
              <madsrdf:isMemberofMADSScheme>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
              </madsrdf:isMemberofMADSScheme>
            </xsl:for-each>
            <!-- special handling for other subfields in 650 -->
            <xsl:if test="$vTag='650'">
              <xsl:for-each select="marc:subfield[@code='c']">
                <bf:place>
                  <bf:Place>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="."/>
                    </rdfs:label>
                  </bf:Place>
                </bf:place>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='d']">
                <bf:date>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </bf:date>
              </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='g']">
              <bf:note>
                <bf:Note>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
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
            <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pMode">relationship</xsl:with-param>
              <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
            </xsl:apply-templates>
            <xsl:for-each select="marc:subfield[@code='4']">
              <bflc:relationship>
                <bflc:Relationship>
                  <bflc:relation>
                    <rdfs:Resource>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,substring(.,1,3))"/></xsl:attribute>
                    </rdfs:Resource>
                  </bflc:relation>
                  <bf:relatedTo>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                  </bf:relatedTo>
                </bflc:Relationship>
              </bflc:relationship>
            </xsl:for-each>
            <xsl:apply-templates mode="subfield0orw" select="marc:subfield[@code='0']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="subfield3" select="marc:subfield[@code='3']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='653']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work653">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work653">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='a']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:subject>
          <bf:Topic>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
          </bf:Topic>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='656']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work656">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work656">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:subject>
          <bf:Topic>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'ComplexSubject')"/></xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
            <madsrdf:componentList rdf:parseType="Collection">
              <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
                <xsl:variable name="vResource">
                  <xsl:choose>
                    <xsl:when test="@code='a'">madsrdf:Occupation</xsl:when>
                    <xsl:when test="@code='z'">madsrdf:Geographic</xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$vResource}">
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </xsl:element>
              </xsl:for-each>
            </madsrdf:componentList>
            <xsl:apply-templates select="marc:subfield[@code='0']" mode="subfield0orw">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Topic>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='662']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work662">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work662">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:subject>
          <bf:Topic>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'HierarchicalGeographic')"/></xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$vLabel"/>
            </rdfs:label>
            <madsrdf:componentList rdf:parseType="Collection">
              <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
                <xsl:variable name="vResource">
                  <xsl:choose>
                    <xsl:when test="@code='a'">madsrdf:Country</xsl:when>
                    <xsl:when test="@code='b'">madsrdf:County</xsl:when>
                    <xsl:when test="@code='c'">madsrdf:State</xsl:when>
                    <xsl:when test="@code='d'">madsrdf:City</xsl:when>
                    <xsl:otherwise>madsrdf:Geographic</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$vResource}">
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </xsl:element>
              </xsl:for-each>
            </madsrdf:componentList>
            <xsl:apply-templates select="marc:subfield[@code='0']" mode="subfield0orw">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Topic>
        </bf:subject>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
