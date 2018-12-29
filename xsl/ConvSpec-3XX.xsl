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

  <!-- Conversion specs for 3XX -->

  <xsl:template match="marc:datafield[@tag='336']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:content</xsl:with-param>
      <xsl:with-param name="pResource">bf:Content</xsl:with-param>
      <xsl:with-param name="pUriStem"><xsl:value-of select="$contentType"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='351']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work351">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='351' or @tag='880']" mode="work351">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:arrangement>
          <bf:Arrangement>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:hierarchicalLevel>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </bf:hierarchicalLevel>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:organization>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </bf:organization>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:pattern>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </bf:pattern>
            </xsl:for-each>
          </bf:Arrangement>
        </bf:arrangement>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='380']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work380">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='380' or @tag='880']" mode="work380">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:genreForm</xsl:with-param>
          <xsl:with-param name="pResource">bf:GenreForm</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='382']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work382">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='382' or @tag='880']" mode="work382">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='d' or @code='p']">
          <xsl:variable name="vNodeId" select="generate-id()"/>
          <bf:musicMedium>
            <bf:MusicMedium>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="@code='b'"><xsl:value-of select="concat(text(),' soloist')"/></xsl:when>
                  <xsl:when test="@code='d'"><xsl:value-of select="concat('doubling ',text())"/></xsl:when>
                  <xsl:when test="@code='p'"><xsl:value-of select="concat('alternate ',text())"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                </xsl:choose>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='a' or @code='b' or @code='d' or @code='p' or @code='r' or @code='s' or @code='t'][position()=1]/preceding-sibling::marc:subfield[@code='n' or @code='e']">
                <xsl:if test="generate-id(preceding-sibling::marc:subfield[@code='a' or @code='b' or @code='d' or @code='p'][position()=1])=$vNodeId">
                  <bf:count>
                    <xsl:value-of select="."/>
                  </bf:count>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="following-sibling::marc:subfield[@code='a' or @code='b' or @code='d' or @code='p' or @code='r' or @code='s' or @code='t'][position()=1]/preceding-sibling::marc:subfield[@code='v']">
                <xsl:if test="generate-id(preceding-sibling::marc:subfield[@code='a' or @code='b' or @code='d' or @code='p'][position()=1])=$vNodeId">
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
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:MusicMedium>
          </bf:musicMedium>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='r' or @code='s' or @code='t'] | marc:subfield[@code='v'][preceding-sibling::marc:subfield[@code='r' or @code='s' or @code='t']]">
          <xsl:variable name="vDisplayConstant">
            <xsl:choose>
              <xsl:when test="@code='r'">Total performers alongside ensembles: </xsl:when>
              <xsl:when test="@code='s'">Total performers: </xsl:when>
              <xsl:when test="@code='t'">Total ensembles: </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <bf:musicMedium>
            <bf:MusicMedium>
              <bf:note>
                <bf:Note>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="concat($vDisplayConstant,.)"/>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:MusicMedium>
          </bf:musicMedium>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='383']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work383">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='383' or @tag='880']" mode="work383">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:musicSerialNumber>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:musicSerialNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:musicOpusNumber><xsl:value-of select="."/></bf:musicOpusNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c' or @code='d']">
          <bf:musicThematicNumber><xsl:value-of select="."/></bf:musicThematicNumber>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='385' or @tag='386']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work385or386">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='385' or @tag='386' or @tag='880']" mode="work385or386">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vProp">
      <xsl:choose>
        <xsl:when test="$vTag='385'">bf:intendedAudience</xsl:when>
        <xsl:when test="$vTag='386'">bflc:creatorCharacteristic</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vResource">
      <xsl:choose>
        <xsl:when test="$vTag='385'">bf:IntendedAudience</xsl:when>
        <xsl:when test="$vTag='386'">bflc:CreatorCharacteristic</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:element name="{$vProp}">
            <xsl:element name="{$vResource}">
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='b'][position()=1]">
                <bf:code><xsl:value-of select="."/></bf:code>
                <xsl:if test="starts-with(substring-after(../marc:subfield[@code='0'][1],')'),'dg')">
                  <xsl:variable name="encoded">
                    <xsl:call-template name="url-encode">
                      <xsl:with-param name="str" select="normalize-space(substring-after(../marc:subfield[@code='0'][1],')'))"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <bflc:target>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($demographicTerms,$encoded)"/></xsl:attribute>
                  </bflc:target>
                </xsl:if>
              </xsl:for-each>
              <xsl:if test="../marc:subfield[@code='m'] or ../marc:subfield[@code='n']">
                <bflc:demographicGroup>
                  <bflc:DemographicGroup>
                    <xsl:for-each select="../marc:subfield[@code='m']">
                      <rdfs:label>
                        <xsl:if test="$vXmlLang != ''">
                          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                      </rdfs:label>
                    </xsl:for-each>
                    <xsl:for-each select="../marc:subfield[@code='n']">
                      <xsl:variable name="encoded">
                        <xsl:call-template name="url-encode">
                          <xsl:with-param name="str" select="normalize-space(.)"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <bf:code><xsl:value-of select="."/></bf:code>
                      <bflc:target>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($demographicTerms,$encoded)"/></xsl:attribute>
                      </bflc:target>
                    </xsl:for-each>
                  </bflc:DemographicGroup>
                </bflc:demographicGroup>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='336' or @tag='337' or @tag='338' or @tag='880']" mode="rdaResource">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pProp"/>
    <xsl:param name="pResource"/>
    <xsl:param name="pUriStem"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='b']">
          <xsl:variable name="encoded">
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:element name="{$pProp}">
            <xsl:element name="{$pResource}">
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($pUriStem,$encoded)"/></xsl:attribute>
              <xsl:if test="preceding-sibling::marc:subfield[position()=1]/@code = 'a'">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="preceding-sibling::marc:subfield[position()=1]"/>
                </rdfs:label>
              </xsl:if>
              <xsl:if test="following-sibling::marc:subfield[position()=1]/@code = '0'">
                <xsl:apply-templates select="following-sibling::marc:subfield[position()=1]" mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:if test="following-sibling::marc:subfield[position()=1]/@code != 'b'">
            <xsl:element name="{$pProp}">
              <xsl:element name="{$pResource}">
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </rdfs:label>
                <xsl:if test="following-sibling::marc:subfield[position()=1]/@code = '0'">
                  <xsl:apply-templates select="following-sibling::marc:subfield[position()=1]" mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
                <xsl:for-each select="../marc:subfield[@code='2']">
                  <xsl:choose>
                    <xsl:when test="contains(.,'rda')">
                      <bf:source>
                        <bf:Source>
                          <rdfs:label>rda</rdfs:label>
                        </bf:Source>
                      </bf:source>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="." mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
                <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:element>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='300']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance300">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='300' or @tag='880']" mode="instance300">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vExtentRaw">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='f' or @code='g']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vExtent">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString" select="$vExtentRaw"/>
        <xsl:with-param name="punctuation"><xsl:text>+:,;/ </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:if test="$vExtent != ''">
          <bf:extent>
            <bf:Extent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space($vExtent)"/>
              </rdfs:label>
              <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Extent>
          </bf:extent>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='b' or @code='e']">
          <bf:note>
            <bf:Note>
              <bf:noteType>
                <xsl:choose>
                  <xsl:when test="@code='b'">Physical details</xsl:when>
                  <xsl:when test="@code='e'">Accompanying materials</xsl:when>
                </xsl:choose>
              </bf:noteType>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                  <xsl:with-param name="punctuation"><xsl:text>+:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:dimensions>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>+:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:dimensions>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='306']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance306">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='306' or @tag='880']" mode="instance306">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:duration>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </bf:duration>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='310' or @tag='321']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance310">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='310' or @tag='321' or @tag='880']" mode="instance310">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:frequency>
            <bf:Frequency>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                  <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="../marc:subfield[@code='b']">
                <bf:date>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </bf:date>
              </xsl:for-each>
            </bf:Frequency>
          </bf:frequency>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='337']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:media</xsl:with-param>
      <xsl:with-param name="pResource">bf:Media</xsl:with-param>
      <xsl:with-param name="pUriStem"><xsl:value-of select="$mediaType"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='338']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:carrier</xsl:with-param>
      <xsl:with-param name="pResource">bf:Carrier</xsl:with-param>
      <xsl:with-param name="pUriStem"><xsl:value-of select="$carriers"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='340']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance340">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='340' or @tag='880']" mode="instance340">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:baseMaterial</xsl:with-param>
          <xsl:with-param name="pResource">bf:BaseMaterial</xsl:with-param>
        </xsl:apply-templates>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:dimensions><xsl:value-of select="."/></bf:dimensions>
        </xsl:for-each>
        <xsl:apply-templates select="marc:subfield[@code='c']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:appliedMaterial</xsl:with-param>
          <xsl:with-param name="pResource">bf:AppliedMaterial</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='d']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:productionMethod</xsl:with-param>
          <xsl:with-param name="pResource">bf:ProductionMethod</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='e']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:mount</xsl:with-param>
          <xsl:with-param name="pResource">bf:Mount</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='f']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:reductionRatio</xsl:with-param>
          <xsl:with-param name="pResource">bf:ReductionRatio</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='i']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:systemRequirement</xsl:with-param>
          <xsl:with-param name="pResource">bf:SystemRequirement</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='j']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:generation</xsl:with-param>
          <xsl:with-param name="pResource">bf:Generation</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='k']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:layout</xsl:with-param>
          <xsl:with-param name="pResource">bf:Layout</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='m']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:bookFormat</xsl:with-param>
          <xsl:with-param name="pResource">bf:BookFormat</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='n']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:fontSize</xsl:with-param>
          <xsl:with-param name="pResource">bf:FontSize</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='o']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:polarity</xsl:with-param>
          <xsl:with-param name="pResource">bf:Polarity</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='344' or @tag='345' or @tag='346' or @tag='347' or @tag='348']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance34X">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='344' or @tag='345' or @tag='346' or @tag='347' or @tag='348' or @tag='880']" mode="instance34X">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vProp">
      <xsl:choose>
        <xsl:when test="$vTag='344'">bf:soundCharacteristic</xsl:when>
        <xsl:when test="$vTag='345'">bf:projectionCharacteristic</xsl:when>
        <xsl:when test="$vTag='346'">bf:videoCharacteristic</xsl:when>
        <xsl:when test="$vTag='347'">bf:digitalCharacteristic</xsl:when>
        <xsl:when test="$vTag='348'">bf:musicFormat</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="marc:subfield">
      <xsl:variable name="vResource">
        <xsl:choose>
          <xsl:when test="$vTag='344'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:RecordingMethod</xsl:when>
              <xsl:when test="@code='b'">bf:RecordingMedium</xsl:when>
              <xsl:when test="@code='c'">bf:PlayingSpeed</xsl:when>
              <xsl:when test="@code='d'">bf:GrooveCharacteristic</xsl:when>
              <xsl:when test="@code='e'">bf:TrackConfig</xsl:when>
              <xsl:when test="@code='f'">bf:TapeConfig</xsl:when>
              <xsl:when test="@code='g'">bf:PlaybackChannels</xsl:when>
              <xsl:when test="@code='h'">bf:PlaybackCharacteristic</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='345'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:PresentationFormat</xsl:when>
              <xsl:when test="@code='b'">bf:ProjectionSpeed</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='346'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:VideoFormat</xsl:when>
              <xsl:when test="@code='b'">bf:BroadcastStandard</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='347'">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:FileType</xsl:when>
              <xsl:when test="@code='b'">bf:EncodingFormat</xsl:when>
              <xsl:when test="@code='c'">bf:FileSize</xsl:when>
              <xsl:when test="@code='d'">bf:Resolution</xsl:when>
              <xsl:when test="@code='e'">bf:RegionalEncoding</xsl:when>
              <xsl:when test="@code='f'">bf:EncodedBitrate</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='348'">
            <xsl:if test="@code='a'">bf:MusicFormat</xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vTarget">
        <xsl:choose>
          <xsl:when test="$vTag='344'">
            <xsl:choose>
              <xsl:when test="@code='a'">
                <xsl:choose>
                  <xsl:when test="text()='analog'">
                    <xsl:value-of select="concat($mrectype,'analog')"/>
                  </xsl:when>
                  <xsl:when test="text()='digital'">
                    <xsl:value-of select="concat($mrectype,'digital')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='b'">
                <xsl:choose>
                  <xsl:when test="text()='magnetic'">
                    <xsl:value-of select="concat($mrecmedium,'mag')"/>
                  </xsl:when>
                  <xsl:when test="text()='optical'">
                    <xsl:value-of select="concat($mrecmedium,'opt')"/>
                  </xsl:when>
                  <xsl:when test="text()='magneto-optical'">
                    <xsl:value-of select="concat($mrecmedium,'magopt')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='d'">
                <xsl:choose>
                  <xsl:when test="text()='coarse groove'">
                    <xsl:value-of select="concat($mgroove,'coarse')"/>
                  </xsl:when>
                  <xsl:when test="text()='microgroove'">
                    <xsl:value-of select="concat($mgroove,'micro')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='g'">
                <xsl:choose>
                  <xsl:when test="text()='mono'">
                    <xsl:value-of select="concat($mplayback,'mon')"/>
                  </xsl:when>
                  <xsl:when test="text()='quadraphonic' or text()='surround'">
                    <xsl:value-of select="concat($mplayback,'mul')"/>
                  </xsl:when>
                  <xsl:when test="text()='stereo'">
                    <xsl:value-of select="concat($mplayback,'ste')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='h'">
                <xsl:choose>
                  <xsl:when test="text()='CCIR encoded'">
                    <xsl:value-of select="concat($mspecplayback,'ccir')"/>
                  </xsl:when>
                  <xsl:when test="text()='CX encoded'">
                    <xsl:value-of select="concat($mspecplayback,'cx')"/>
                  </xsl:when>
                  <xsl:when test="text()='dbx encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dbx')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby'">
                    <xsl:value-of select="concat($mspecplayback,'dolby')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby-A encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dolbya')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby-B encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dolbyb')"/>
                  </xsl:when>
                  <xsl:when test="text()='Dolby-C encoded'">
                    <xsl:value-of select="concat($mspecplayback,'dolbyc')"/>
                  </xsl:when>
                  <xsl:when test="text()='LPCM'">
                    <xsl:value-of select="concat($mspecplayback,'lpcm')"/>
                  </xsl:when>
                  <xsl:when test="text()='NAB standard'">
                    <xsl:value-of select="concat($mspecplayback,'nab')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='345'">
            <xsl:if test="@code='a'">
              <xsl:choose>
                <xsl:when test="text()='3D'">
                  <xsl:value-of select="concat($mpresformat,'3d')"/>
                </xsl:when>
                <xsl:when test="text()='Cinemiracle'">
                  <xsl:value-of select="concat($mpresformat,'ciner')"/>
                </xsl:when>
                <xsl:when test="text()='Cinemiracle'">
                  <xsl:value-of select="concat($mpresformat,'cinem')"/>
                </xsl:when>
                <xsl:when test="text()='Cinerama'">
                  <xsl:value-of select="concat($mpresformat,'ciner')"/>
                </xsl:when>
                <xsl:when test="text()='Circarama'">
                  <xsl:value-of select="concat($mpresformat,'circa')"/>
                </xsl:when>
                <xsl:when test="text()='IMAX'">
                  <xsl:value-of select="concat($mpresformat,'imax')"/>
                </xsl:when>
                <xsl:when test="text()='multiprojector'">
                  <xsl:value-of select="concat($mpresformat,'mproj')"/>
                </xsl:when>
                <xsl:when test="text()='multiscreen'">
                  <xsl:value-of select="concat($mpresformat,'mscreen')"/>
                </xsl:when>
                <xsl:when test="text()='Panavision'">
                  <xsl:value-of select="concat($mpresformat,'pana')"/>
                </xsl:when>
                <xsl:when test="text()='standard silent aperture'">
                  <xsl:value-of select="concat($mpresformat,'silent')"/>
                </xsl:when>
                <xsl:when test="text()='standard sound aperture'">
                  <xsl:value-of select="concat($mpresformat,'sound')"/>
                </xsl:when>
                <xsl:when test="text()='stereoscopic'">
                  <xsl:value-of select="concat($mpresformat,'stereo')"/>
                </xsl:when>
                <xsl:when test="text()='Techniscope'">
                  <xsl:value-of select="concat($mpresformat,'tech')"/>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$vTag='346'">
            <xsl:choose>
              <xsl:when test="@code='a'">
                <xsl:choose>
                  <xsl:when test="text()='8 mm'">
                    <xsl:value-of select="concat($mvidformat,'8mm')"/>
                  </xsl:when>
                  <xsl:when test="text()='Betacam'">
                    <xsl:value-of select="concat($mvidformat,'betacam')"/>
                  </xsl:when>
                  <xsl:when test="text()='Betacam SP'">
                    <xsl:value-of select="concat($mvidformat,'betasp')"/>
                  </xsl:when>
                  <xsl:when test="text()='Betamax'">
                    <xsl:value-of select="concat($mvidformat,'betamax')"/>
                  </xsl:when>
                  <xsl:when test="text()='CED'">
                    <xsl:value-of select="concat($mvidformat,'ced')"/>
                  </xsl:when>
                  <xsl:when test="text()='D-2'">
                    <xsl:value-of select="concat($mvidformat,'d2')"/>
                  </xsl:when>
                  <xsl:when test="text()='EIAJ'">
                    <xsl:value-of select="concat($mvidformat,'eiaj')"/>
                  </xsl:when>
                  <xsl:when test="text()='Hi-8 mm'">
                    <xsl:value-of select="concat($mvidformat,'hi8mm')"/>
                  </xsl:when>
                  <xsl:when test="text()='laser optical'">
                    <xsl:value-of select="concat($mvidformat,'laser')"/>
                  </xsl:when>
                  <xsl:when test="text()='M-II'">
                    <xsl:value-of select="concat($mvidformat,'mii')"/>
                  </xsl:when>
                  <xsl:when test="text()='Quadruplex'">
                    <xsl:value-of select="concat($mvidformat,'quad')"/>
                  </xsl:when>
                  <xsl:when test="text()='Super-VHS'">
                    <xsl:value-of select="concat($mvidformat,'svhs')"/>
                  </xsl:when>
                  <xsl:when test="text()='Type C'">
                    <xsl:value-of select="concat($mvidformat,'typec')"/>
                  </xsl:when>
                  <xsl:when test="text()='U-matic'">
                    <xsl:value-of select="concat($mvidformat,'umatic')"/>
                  </xsl:when>
                  <xsl:when test="text()='VHS'">
                    <xsl:value-of select="concat($mvidformat,'vhs')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='b'">
                <xsl:choose>
                  <xsl:when test="text()='HDTV'">
                    <xsl:value-of select="concat($mbroadstd,'hdtv')"/>
                  </xsl:when>
                  <xsl:when test="text()='NTSC'">
                    <xsl:value-of select="concat($mbroadstd,'ntsc')"/>
                  </xsl:when>
                  <xsl:when test="text()='PAL'">
                    <xsl:value-of select="concat($mbroadstd,'pal')"/>
                  </xsl:when>
                  <xsl:when test="text()='SECAM'">
                    <xsl:value-of select="concat($mbroadstd,'secam')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='347'">
            <xsl:choose>
              <xsl:when test="@code='a'">
                <xsl:choose>
                  <xsl:when test="text()='audio file'">
                    <xsl:value-of select="concat($mfiletype,'audio')"/>
                  </xsl:when>
                  <xsl:when test="text()='data file'">
                    <xsl:value-of select="concat($mfiletype,'data')"/>
                  </xsl:when>
                  <xsl:when test="text()='image file'">
                    <xsl:value-of select="concat($mfiletype,'image')"/>
                  </xsl:when>
                  <xsl:when test="text()='program file'">
                    <xsl:value-of select="concat($mfiletype,'program')"/>
                  </xsl:when>
                  <xsl:when test="text()='text file'">
                    <xsl:value-of select="concat($mfiletype,'text')"/>
                  </xsl:when>
                  <xsl:when test="text()='video file'">
                    <xsl:value-of select="concat($mfiletype,'video')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@code='e'">
                <xsl:choose>
                  <xsl:when test="text()='all regions'">
                    <xsl:value-of select="concat($mregencoding,'all')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 1'">
                    <xsl:value-of select="concat($mregencoding,'region1')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 2'">
                    <xsl:value-of select="concat($mregencoding,'region2')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 3'">
                    <xsl:value-of select="concat($mregencoding,'region3')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 4'">
                    <xsl:value-of select="concat($mregencoding,'region4')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 5'">
                    <xsl:value-of select="concat($mregencoding,'region5')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 6'">
                    <xsl:value-of select="concat($mregencoding,'region6')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 7'">
                    <xsl:value-of select="concat($mregencoding,'region7')"/>
                  </xsl:when>
                  <xsl:when test="text()='region 8'">
                    <xsl:value-of select="concat($mregencoding,'region8')"/>
                  </xsl:when>
                  <xsl:when test="text()='region A'">
                    <xsl:value-of select="concat($mregencoding,'regionA')"/>
                  </xsl:when>
                  <xsl:when test="text()='region B'">
                    <xsl:value-of select="concat($mregencoding,'regionB')"/>
                  </xsl:when>
                  <xsl:when test="text()='region C (Blu-Ray)'">
                    <xsl:value-of select="concat($mregencoding,'regionCblu')"/>
                  </xsl:when>
                  <xsl:when test="text()='region C (video game)'">
                    <xsl:value-of select="concat($mregencoding,'regionCgame')"/>
                  </xsl:when>
                  <xsl:when test="text()='region J'">
                    <xsl:value-of select="concat($mregencoding,'regionJ')"/>
                  </xsl:when>
                  <xsl:when test="text()='region U/C'">
                    <xsl:value-of select="concat($mregencoding,'regionU')"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$vTag='348'">
            <xsl:if test="@code='a'">
              <xsl:choose>
                <xsl:when test="text()='choir book'">
                  <xsl:value-of select="concat($mmusicformat,'choirbk')"/>
                </xsl:when>
                <xsl:when test="text()='chorus score'">
                  <xsl:value-of select="concat($mmusicformat,'chscore')"/>
                </xsl:when>
                <xsl:when test="text()='condensed score'">
                  <xsl:value-of select="concat($mmusicformat,'conscore')"/>
                </xsl:when>
                <xsl:when test="text()='part'">
                  <xsl:value-of select="concat($mmusicformat,'part')"/>
                </xsl:when>
                <xsl:when test="text()='piano conductor part'">
                  <xsl:value-of select="concat($mmusicformat,'pianoconpt')"/>
                </xsl:when>
                <xsl:when test="text()='piano score'">
                  <xsl:value-of select="concat($mmusicformat,'pianoscore')"/>
                </xsl:when>
                <xsl:when test="text()='score'">
                  <xsl:value-of select="concat($mmusicformat,'score')"/>
                </xsl:when>
                <xsl:when test="text()='study score'">
                  <xsl:value-of select="concat($mmusicformat,'study score')"/>
                </xsl:when>
                <xsl:when test="text()='table book'">
                  <xsl:value-of select="concat($mmusicformat,'tablebk')"/>
                </xsl:when>
                <xsl:when test="text()='violin conductor part'">
                  <xsl:value-of select="concat($mmusicformat,'violconpart')"/>
                </xsl:when>
                <xsl:when test="text()='vocal score'">
                  <xsl:value-of select="concat($mmusicformat,'vocalscore')"/>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$vResource != ''">
        <xsl:apply-templates select="." mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp" select="$vProp"/>
          <xsl:with-param name="pResource" select="$vResource"/>
          <xsl:with-param name="pTarget" select="$vTarget"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='350']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance350">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='350' or @tag='880']" mode="instance350">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:acquisitionSource>
            <bf:AcquisitionSource>
              <bf:acquisitionTerms>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:acquisitionTerms>
            </bf:AcquisitionSource>
          </bf:acquisitionSource>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='352']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance352">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='352' or @tag='880']" mode="instance352">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='q']">
          <xsl:variable name="vResource">
            <xsl:choose>
              <xsl:when test="@code='a'">bf:CartographicDataType</xsl:when>
              <xsl:when test="@code='q'">bf:EncodingFormat</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="vProcess">
            <xsl:choose>
              <xsl:when test="@code='a'">chopPunctuation</xsl:when>
              <xsl:when test="@code='q'">chopPunctuation</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:apply-templates select="." mode="generateProperty">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
            <xsl:with-param name="pResource" select="$vResource"/>
            <xsl:with-param name="pProcess" select="$vProcess"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:digitalCharacteristic>
            <bf:CartographicObjectType>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:if test="following-sibling::marc:subfield[position()=1]/@code = 'c'">
                <bf:count>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="chopParens">
                    <xsl:with-param name="chopString" select="following-sibling::marc:subfield[position()=1]"/>
                  </xsl:call-template>
                </bf:count>
              </xsl:if>
            </bf:CartographicObjectType>
          </bf:digitalCharacteristic>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='362']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance362">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='362' or @tag='880']" mode="instance362">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vFirstIssue"><xsl:value-of select="substring-before(marc:subfield[@code='a'],'-')"/></xsl:variable>
    <xsl:variable name="vLastIssue"><xsl:value-of select="substring-after(marc:subfield[@code='a'],'-')"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="@ind1='0'">
            <xsl:if test="$vFirstIssue != ''">
              <bf:firstIssue>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$vFirstIssue"/>
              </bf:firstIssue>
            </xsl:if>
            <xsl:if test="$vLastIssue != ''">
              <bf:lastIssue>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$vLastIssue"/>
              </bf:lastIssue>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <bf:note>
              <bf:Note>
                <bf:noteType>Numbering</bf:noteType>
                <rdfs:label>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="marc:subfield[@code='a']"/>
                </rdfs:label>
              </bf:Note>
            </bf:note>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
