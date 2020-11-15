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

  <!-- Conversion specs for 490, 510, 530-535 - Other linking entries -->

  <xsl:template match="marc:datafield[@tag='490']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vCurrentPos">
      <xsl:choose>
        <xsl:when test="@ind1 = '1'">
          <xsl:value-of select="count(preceding-sibling::marc:datafield[@tag='490' and @ind1='1']) + 1"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="." mode="work490">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pCurrentPos" select="$vCurrentPos"/>
    </xsl:apply-templates>
  </xsl:template>
    
  <xsl:template match="marc:datafield[@tag='490' or @tag='880']" mode="work490">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pCurrentPos"/>
    <xsl:if test="@ind1=0 or @tag='880' or
                  (@ind1='1' and count(../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830']) &lt; $pCurrentPos)">
      <xsl:for-each select="marc:subfield[@code='x']">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:hasSeries>
              <bf:Work>
                <bf:identifiedBy>
                  <bf:Issn>
                    <rdf:value>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdf:value>
                  </bf:Issn>
                </bf:identifiedBy>
              </bf:Work>
            </bf:hasSeries>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='510']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work510">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='510' or @tag='880']" mode="work510">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="@ind1='0' or @ind1='1' or @ind1='2'">bflc:indexedIn</xsl:when>
        <xsl:otherwise>bf:references</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vProperty}">
          <bf:Work>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:title>
                <bf:Title>
                  <bf:mainTitle>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </bf:mainTitle>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b' or @code='c']">
              <bf:note>
                <bf:Note>
                  <bf:noteType>
                    <xsl:choose>
                      <xsl:when test="@code='b'">Coverage</xsl:when>
                      <xsl:when test="@code='c'">Location</xsl:when>
                    </xsl:choose>
                  </bf:noteType>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='x']">
              <bf:identifiedBy>
                <bf:Issn>
                  <rdf:value>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdf:value>
                </bf:Issn>
              </bf:identifiedBy>
            </xsl:for-each>
          </bf:Work>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='533' or @tag='534']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="hasInstance5XX">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- create a new Instance from a 5XX field -->
  <xsl:template match="marc:datafield[@tag='533' or @tag='534' or @tag='880']" mode="hasInstance5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasInstance>
          <bf:Instance>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
            <bf:instanceOf>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
            </bf:instanceOf>
            <xsl:choose>
              <xsl:when test="$vTag='533'">
                <bf:title>
                  <xsl:apply-templates mode="title245" select="../marc:datafield[@tag='245']">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="label">
                      <xsl:apply-templates mode="concat-nodes-space"
                                           select="../marc:datafield[@tag='245']/marc:subfield[@code='a' or
                                                   @code='b' or
                                                   @code='f' or 
                                                   @code='g' or
                                                   @code='k' or
                                                   @code='n' or
                                                   @code='p' or
                                                   @code='s']"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                </bf:title>
              </xsl:when>                  
              <xsl:when test="$vTag='534' and marc:subfield[@code='t']">
                <bf:title>
                  <bf:Title>
                    <bf:mainTitle>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="marc:subfield[@code='t']"/>
                    </bf:mainTitle>
                  </bf:Title>
                </bf:title>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="../marc:datafield[@tag='130']">
                    <bf:title>
                      <xsl:apply-templates mode="titleUnifTitle" select="../marc:datafield[@tag='130']">
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="label">
                          <xsl:apply-templates mode="concat-nodes-space"
                                               select="../marc:datafield[@tag='130']/marc:subfield[@code='a' or
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
                        </xsl:with-param>                    
                      </xsl:apply-templates>
                    </bf:title>
                  </xsl:when>
                  <xsl:when test="../marc:datafield[@tag='240']">
                    <bf:title>
                      <xsl:apply-templates mode="titleUnifTitle" select="../marc:datafield[@tag='240']">
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="label">
                          <xsl:apply-templates mode="concat-nodes-space"
                                               select="../marc:datafield[@tag='240']/marc:subfield[@code='a' or
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
                        </xsl:with-param>                    
                      </xsl:apply-templates>
                    </bf:title>
                  </xsl:when>
                  <xsl:otherwise>
                    <bf:title>
                      <xsl:apply-templates mode="title245" select="../marc:datafield[@tag='245']">
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="label">
                          <xsl:apply-templates mode="concat-nodes-space"
                                               select="../marc:datafield[@tag='245']/marc:subfield[@code='a' or
                                                       @code='b' or
                                                       @code='f' or 
                                                       @code='g' or
                                                       @code='k' or
                                                       @code='n' or
                                                       @code='p' or
                                                       @code='s']"/>
                        </xsl:with-param>
                      </xsl:apply-templates>
                    </bf:title>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="$vTag='533'">
                <xsl:apply-templates select="." mode="hasInstance533">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
                  <xsl:with-param name="recordid" select="$recordid"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="$vTag='534'">
                <xsl:apply-templates select="." mode="hasInstance534">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
                  <xsl:with-param name="recordid" select="$recordid"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
          </bf:Instance>
        </bf:hasInstance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='533' or @tag='880']" mode="hasInstance533">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:reproductionOf>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
        </bf:reproductionOf>
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:carrier>
            <bf:Carrier>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Carrier>
          </bf:carrier>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code='b' or @code='c' or @code='d']">
          <bf:provisionActivity>
            <bf:ProvisionActivity>
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:place>
                  <bf:Place>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Place>
                </bf:place>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='c']">
                <bf:agent>
                  <bf:Agent>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Agent>
                </bf:agent>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='d']">
                <bf:date>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                  </xsl:call-template>
                </bf:date>
              </xsl:for-each>
            </bf:ProvisionActivity>
          </bf:provisionActivity>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='e']">
          <bf:extent>
            <bf:Extent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Extent>
          </bf:extent>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='f']">
          <bf:seriesStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopParens">
              <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
          </bf:seriesStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='n']">
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
        <xsl:for-each select="marc:subfield[@code='3' or @code='m']">
          <xsl:apply-templates select="." mode="subfield3">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='5']">
          <xsl:apply-templates select="." mode="subfield5">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:if test="(following-sibling::marc:datafield[position()=1]/@tag='535'
                      and following-sibling::marc:datafield[position()=1]/@ind1='2') or
                      (following-sibling::marc:datafield[position()=1]/@tag='880'
                      and following-sibling::marc:datafield[position()=1]/marc:subfield[@code='6'][starts-with(.,'535')]
                      and following-sibling::marc:datafield[position()=1]/@ind1='2')">
          <xsl:apply-templates select="following-sibling::marc:datafield[position()=1]" mode="hasItem535">
            <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='534' or @tag='880']" mode="hasInstance534">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:originalVersionOf>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
        </bf:originalVersionOf>
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:contribution>
            <bf:Contribution>
              <bf:agent>
                <bf:Agent>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Agent>
              </bf:agent>
            </bf:Contribution>
          </bf:contribution>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:editionStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
          </bf:editionStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:provisionActivityStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
          </bf:provisionActivityStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='e']">
          <bf:extent>
            <bf:Extent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Extent>
          </bf:extent>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='f']">
          <bf:seriesStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopParens">
              <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
          </bf:seriesStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='k']">
          <bf:title>
            <bf:KeyTitle>
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:mainTitle>
            </bf:KeyTitle>
          </bf:title>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='m' or @code='n']">
          <bf:note>
            <bf:Note>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='x' or @code='z']">
          <xsl:variable name="vIdentifier">
            <xsl:choose>
              <xsl:when test="@code='x'">bf:Issn</xsl:when>
              <xsl:when test="@code='z'">bf:Isbn</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <bf:identifiedBy>
            <xsl:element name="{$vIdentifier}">
              <rdf:value>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdf:value>
            </xsl:element>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:apply-templates select="marc:subfield[@code='p' or @code='3']" mode="subfield3">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
        <xsl:if test="(following-sibling::marc:datafield[position()=1]/@tag='535'
                      and following-sibling::marc:datafield[position()=1]/@ind1='1') or
                      (following-sibling::marc:datafield[position()=1]/@tag='880'
                      and following-sibling::marc:datafield[position()=1]/marc:subfield[@code='6'][starts-with(.,'535')]
                      and following-sibling::marc:datafield[position()=1]/@ind1='1')">
          <xsl:apply-templates select="following-sibling::marc:datafield[position()=1]" mode="hasItem535">
            <xsl:with-param name="pInstanceUri" select="$pInstanceUri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='535' or @tag='880']" mode="hasItem535">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vAddress">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='b' or @code='c' or @code='d']">
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
              <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
            <xsl:text>; </xsl:text>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasItem>
          <bf:Item>
            <bf:itemOf>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
            </bf:itemOf>
            <xsl:if test="marc:subfield[@code='a' or @code='b' or @code='c']">
              <bf:heldBy>
                <bf:Agent>
                  <xsl:for-each select="marc:subfield[@code='a']">
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </xsl:for-each>
                  <xsl:if test="$vAddress != ''">
                    <bf:place>
                      <bf:Place>
                        <rdf:type>
                          <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'Address')"/></xsl:attribute>
                        </rdf:type>
                        <rdfs:label><xsl:value-of select="$vAddress"/></rdfs:label>
                      </bf:Place>
                    </bf:place>
                  </xsl:if>
                </bf:Agent>
              </bf:heldBy>
            </xsl:if>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Item>
        </bf:hasItem>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='490']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance490">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
    
  <xsl:template match="marc:datafield[@tag='490' or @tag='880']" mode="instance490">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="count(marc:subfield[@code='a']) &gt; 1 and
        (substring(marc:subfield[@code='a'][1],string-length(marc:subfield[@code='a'][1])) = '=' or
        substring(marc:subfield[@code='v'][1],string-length(marc:subfield[@code='v'][1])) = '=')">
        <!-- parallel titles -->
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
          <xsl:variable name="vStatement">
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>= </xsl:text></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="vIssn">
            <xsl:apply-templates mode="concat-nodes-space" select="../marc:subfield[@code='x']"/>
          </xsl:variable>
          <xsl:variable name="vVolume">
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="following-sibling::marc:subfield[@code='v' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode]"/>
              <xsl:with-param name="punctuation"><xsl:text>= </xsl:text></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bf:seriesStatement>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="normalize-space(concat($vStatement,' ',$vIssn,' ',$vVolume))"/>
                  <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </bf:seriesStatement>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
          <xsl:variable name="vStatement">
            <xsl:apply-templates mode="concat-nodes-space" select=".|following-sibling::marc:subfield[(@code='x' or @code='v') and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode]"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bf:seriesStatement>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="$vStatement"/>
                  <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </bf:seriesStatement>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='533']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance533-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="instance533">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='533' or @tag='880']" mode="instance533">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasReproduction>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
        </bf:hasReproduction>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <xsl:template match="marc:datafield[@tag='534']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance534-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="instance534">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='534' or @tag='880']" mode="instance534">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:originalVersion>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
        </bf:originalVersion>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

</xsl:stylesheet>
