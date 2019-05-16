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
      Conversion specs for 760-788
  -->

  <xsl:template mode="work" match="marc:datafield[@tag='765'] |
                                   marc:datafield[@tag='767'] |
                                   marc:datafield[@tag='770'] |
                                   marc:datafield[@tag='772'] |
                                   marc:datafield[@tag='773'] |
                                   marc:datafield[@tag='774'] |
                                   marc:datafield[@tag='775'] |
                                   marc:datafield[@tag='780'] |
                                   marc:datafield[@tag='785'] |
                                   marc:datafield[@tag='786'] |
                                   marc:datafield[@tag='787']">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="work7XXLinks">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="instance" match="marc:datafield[@tag='777']">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="work7XXLinks">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work7XXLinks">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pWorkUri"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="$vTag='765'">bf:translationOf</xsl:when>
        <xsl:when test="$vTag='767'">bf:translation</xsl:when>
        <xsl:when test="$vTag='770'">bf:supplement</xsl:when>
        <xsl:when test="$vTag='772'">bf:supplementTo</xsl:when>
        <xsl:when test="$vTag='773'">bf:partOf</xsl:when>
        <xsl:when test="$vTag='774'">bf:hasPart</xsl:when>
        <xsl:when test="$vTag='775'">bf:otherEdition</xsl:when>
        <xsl:when test="$vTag='777'">bf:issuedWith</xsl:when>
        <xsl:when test="$vTag='780'">
          <xsl:choose>
            <xsl:when test="@ind2='0'">bf:continues</xsl:when>
            <xsl:when test="@ind2='1'">bf:continuesInPart</xsl:when>
            <xsl:when test="@ind2='4'">bf:mergerOf</xsl:when>
            <xsl:when test="@ind2='5' or @ind2='6'">bf:absorbed</xsl:when>
            <xsl:when test="@ind2='7'">bf:separatedFrom</xsl:when>
            <xsl:otherwise>bf:precededBy</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='785'">
          <xsl:choose>
            <xsl:when test="@ind2='0' or @ind2='8'">bf:continuedBy</xsl:when>
            <xsl:when test="@ind2='1'">bf:continuedInPartBy</xsl:when>
            <xsl:when test="@ind2='4' or @ind2='5'">bf:absorbedBy</xsl:when>
            <xsl:when test="@ind2='6'">bf:splitInto</xsl:when>
            <xsl:when test="@ind2='7'">bf:mergedToForm</xsl:when>
            <xsl:otherwise>bf:succeededBy</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='786'">bf:dataSource</xsl:when>
        <xsl:when test="$vTag='787'">bf:relatedTo</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="." mode="link7XX">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTag" select="$vTag"/>
      <xsl:with-param name="pProperty" select="$vProperty"/>
      <xsl:with-param name="pElement">bf:Work</xsl:with-param>
      <xsl:with-param name="pWorkUri" select="$pWorkUri"/>
      <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag=776]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work</xsl:variable>
    <xsl:apply-templates select="." mode="work776">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
      <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='776' or @tag='880']" mode="work776">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:param name="pWorkUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="." mode="link7XX">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTag" select="$vTag"/>
      <xsl:with-param name="pProperty">bf:hasInstance</xsl:with-param>
      <xsl:with-param name="pElement">bf:Instance</xsl:with-param>
      <xsl:with-param name="pWorkUri" select="$pWorkUri"/>
      <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='760' or @tag='762']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="instance7XXLinks">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instance7XXLinks">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pWorkUri"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="$vTag='760'">bf:hasSeries</xsl:when>
        <xsl:when test="$vTag='762'">bf:hasSubseries</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="." mode="link7XX">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTag" select="$vTag"/>
      <xsl:with-param name="pProperty" select="$vProperty"/>
      <xsl:with-param name="pElement">bf:Work</xsl:with-param>
      <xsl:with-param name="pWorkUri" select="$pWorkUri"/>
      <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='776']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="instance776">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='776' or @tag='880']" mode="instance776">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:otherPhysicalFormat>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
        </bf:otherPhysicalFormat>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="link7XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTag"/>
    <xsl:param name="pProperty"/>
    <xsl:param name="pElement"/>
    <xsl:param name="pWorkUri"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:variable name="vElementUri">
      <xsl:apply-templates mode="generateUri" select="."/>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$pProperty}">
          <xsl:element name="{$pElement}">
            <xsl:attribute name="rdf:about">
              <xsl:choose>
                <xsl:when test="$vElementUri != ''"><xsl:value-of select="$vElementUri"/></xsl:when>
                <xsl:when test="$pTag='776'"><xsl:value-of select="$pInstanceUri"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$pWorkUri"/></xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:contribution>
                <bflc:PrimaryContribution>
                  <bf:agent>
                    <bf:Agent>
                      <rdfs:label>
                        <xsl:if test="$vXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                      </rdfs:label>
                    </bf:Agent>
                  </bf:agent>
                </bflc:PrimaryContribution>
              </bf:contribution>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:title>
                <bf:Title>
                  <bf:qualifier>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </bf:qualifier>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='e']">
              <xsl:variable name="encoded">
                <xsl:call-template name="url-encode">
                  <xsl:with-param name="str" select="normalize-space(.)"/>
                </xsl:call-template>
              </xsl:variable>
              <bf:language>
                <bf:Language>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($languages,$encoded)"/></xsl:attribute>
                </bf:Language>
              </bf:language>
            </xsl:for-each>
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
                    <xsl:attribute name="rdf:resource">
                      <xsl:choose>
                        <xsl:when test="$pTag='776'"><xsl:value-of select="substring-before($pWorkUri,'#')"/>#Instance</xsl:when>
                        <xsl:otherwise><xsl:value-of select="substring-before($pWorkUri,'#')"/>#Work</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </bf:relatedTo>
                </bflc:Relationship>
              </bflc:relationship>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='s']">
              <bf:title>
                <bf:Title>
                  <bf:mainTitle>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </bf:mainTitle>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='v']">
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
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:choose>
              <xsl:when test="$pTag='776'">
                <xsl:apply-templates select="." mode="link7XXinstance">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pWorkUri" select="$pWorkUri"/>
                  <xsl:with-param name="pTag" select="$pTag"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <bf:hasInstance>
                  <bf:Instance>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
                    <xsl:apply-templates select="." mode="link7XXinstance">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pWorkUri" select="$pWorkUri"/>
                      <xsl:with-param name="pTag" select="$pTag"/>
                    </xsl:apply-templates>
                  </bf:Instance>
                </bf:hasInstance>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="link7XXinstance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pWorkUri"/>
    <xsl:param name="pTag"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:editionStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:editionStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='d']">
          <bf:provisionActivityStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:provisionActivityStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='f']">
          <xsl:variable name="encoded">
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:variable>
          <bf:provisionActivity>
            <bf:ProvisionActivity>
              <bf:place>
                <bf:Place>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,$encoded)"/></xsl:attribute>
                </bf:Place>
              </bf:place>
            </bf:ProvisionActivity>
          </bf:provisionActivity>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='g']">
          <bf:part>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:part>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:extent>
            <bf:Extent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
            </bf:Extent>
          </bf:extent>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='k']">
          <bf:seriesStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:seriesStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='m' or @code='n']">
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
        <xsl:for-each select="marc:subfield[@code='r']">
          <bf:identifiedBy>
            <bf:ReportNumber>
              <rdf:value><xsl:value-of select="."/></rdf:value>
            </bf:ReportNumber>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='t']">
          <bf:title>
            <bf:Title>
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:mainTitle>
            </bf:Title>
          </bf:title>
        </xsl:for-each>
        <xsl:if test="$pTag='776' and not(marc:subfield[@code='t'])">
          <xsl:if test="../marc:datafield[@tag='245']/marc:subfield[@code='a']">
            <bf:title>
              <bf:Title>
                <bf:mainTitle>
                  <xsl:value-of select="../marc:datafield[@tag='245']/marc:subfield[@code='a']"/>
                </bf:mainTitle>
              </bf:Title>
            </bf:title>
          </xsl:if>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='u' or @code='x' or @code='y' or @code='z']">
          <xsl:variable name="vIdentifier">
            <xsl:choose>
              <xsl:when test="@code='u'">bf:Strn</xsl:when>
              <xsl:when test="@code='x'">bf:Issn</xsl:when>
              <xsl:when test="@code='y'">bf:Coden</xsl:when>
              <xsl:when test="@code='z'">bf:Isbn</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <bf:identifiedBy>
            <xsl:element name="{$vIdentifier}">
              <rdf:value><xsl:value-of select="."/></rdf:value>
            </xsl:element>
          </bf:identifiedBy>
        </xsl:for-each>
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
        <bf:instanceOf>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pWorkUri"/></xsl:attribute>
        </bf:instanceOf>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
