<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:local="local:"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc local">

  <!--
      Conversion specs for 010-048
  -->

  <!-- Lookup tables -->
  <local:marctimeperiod>
    <a0>-uuuu/-3000</a0>
    <b0>-29uu</b0>
    <b1>-28uu</b1>
    <b2>-27uu</b2>
    <b3>-26uu</b3>
    <b4>-25uu</b4>
    <b5>-24uu</b5>
    <b6>-23uu</b6>
    <b7>-22uu</b7>
    <b8>-21uu</b8>
    <b9>-20uu</b9>
    <c0>-19uu</c0>
    <c1>-18uu</c1>
    <c2>-17uu</c2>
    <c3>-16uu</c3>
    <c4>-15uu</c4>
    <c5>-14uu</c5>
    <c6>-13uu</c6>
    <c7>-12uu</c7>
    <c8>-11uu</c8>
    <c9>-10uu</c9>
    <d0>-09uu</d0>
    <d1>-08uu</d1>
    <d2>-07uu</d2>
    <d3>-06uu</d3>
    <d4>-05uu</d4>
    <d5>-04uu</d5>
    <d6>-03uu</d6>
    <d7>-02uu</d7>
    <d8>-01uu</d8>
    <d9>-00uu</d9>
    <e>00</e>
    <f>01</f>
    <g>02</g>
    <h>03</h>
    <i>04</i>
    <j>05</j>
    <k>06</k>
    <l>07</l>
    <m>08</m>
    <n>09</n>
    <o>10</o>
    <p>11</p>
    <q>12</q>
    <r>13</r>
    <s>14</s>
    <t>15</t>
    <u>16</u>
    <v>17</v>
    <w>18</w>
    <x>19</x>
    <y>20</y>
  </local:marctimeperiod>

  <xsl:template match="marc:datafield[@tag='038']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bflc:metadataLicensor>
            <rdfs:label><xsl:value-of select="."/></rdfs:label>
          </bflc:metadataLicensor>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='040']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='c']">
          <bf:source>
            <bf:Source>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Agent')"/></xsl:attribute>
              </rdf:type>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Source>
          </bf:source>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:descriptionLanguage>
            <bf:Language>
              <xsl:choose>
                <xsl:when test="string-length(.) = 3">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($languages,.)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <bf:code><xsl:value-of select="."/></bf:code>
                </xsl:otherwise>
              </xsl:choose>
            </bf:Language>
          </bf:descriptionLanguage>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='d']">
          <bf:descriptionModifier>
            <bf:Agent>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Agent>
          </bf:descriptionModifier>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='e']">
          <bf:descriptionConventions>
            <bf:DescriptionConventions>
              <xsl:choose>
                <xsl:when test=
                  "string-length(normalize-space(.))
                  -
                  string-length(translate(normalize-space(.),' ','')) +1
                  = 1">
                <xsl:attribute name="rdf:about"><xsl:value-of select="concat($descriptionConventions,.)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </xsl:otherwise>
              </xsl:choose>
            </bf:DescriptionConventions>
          </bf:descriptionConventions>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='042']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:descriptionAuthentication>
            <bf:DescriptionAuthentication>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcauthen,.)"/></xsl:attribute>
            </bf:DescriptionAuthentication>
          </bf:descriptionAuthentication>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='022']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='l'] | marc:subfield[@code='m']">
          <bf:identifiedBy>
            <bf:IssnL>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'm'">
                <rdfs:label>canceled</rdfs:label>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:IssnL>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='033']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vDate">
      <xsl:choose>
        <xsl:when test="@ind1 = '0'">
          <xsl:call-template name="edtfFormat">
            <xsl:with-param name="pDateString" select="marc:subfield[@code='a']"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@ind1 = '2'">
          <xsl:variable name="vConcatDate">
            <xsl:for-each select="marc:subfield[@code='a']">
              <xsl:variable name="vFormattedDate">
                <xsl:call-template name="edtfFormat">
                  <xsl:with-param name="pDateString" select="."/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="concat('/',$vFormattedDate)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:value-of select="substring-after($vConcatDate,'/')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vNote">
      <xsl:choose>
        <xsl:when test="@ind2 = '1'">broadcast</xsl:when>
        <xsl:when test="@ind2 = '2'">finding</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:capture>
          <bf:Capture>
            <xsl:if test="$vNote != ''">
              <bf:note>
                <bf:Note>
                  <rdfs:label><xsl:value-of select="$vNote"/></rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:if>
            <xsl:if test="$vDate != ''">
              <bf:date>
                <xsl:attribute name="rdf:datatype"><xsl:value-of select="$edtf"/>edtf</xsl:attribute>
                <xsl:value-of select="$vDate"/>
              </bf:date>
            </xsl:if>
            <xsl:if test="@ind1 = '1'">
              <xsl:for-each select="marc:subfield[@code='a']">
                <bf:date>
                  <xsl:attribute name="rdf:datatype"><xsl:value-of select="$edtf"/>edtf</xsl:attribute>
                  <xsl:call-template name="edtfFormat">
                    <xsl:with-param name="pDateString" select="."/>
                  </xsl:call-template>
                </bf:date>
              </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:place>
                <bf:Place>
                  <rdf:value><xsl:value-of select="normalize-space(concat(.,' ',following-sibling::*[position()=1][@code='c']))"/></rdf:value>
                  <bf:source>
                    <bf:Source>
                      <rdfs:label>lcc-g</rdfs:label>
                    </bf:Source>
                  </bf:source>
                </bf:Place>
              </bf:place>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='p']">
              <bf:place>
                <bf:Place>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  <xsl:apply-templates mode="subfield2" select="following-sibling::*[position()=1][@code='2']">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </bf:Place>
              </bf:place>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='3']">
              <xsl:apply-templates mode="subfield3" select=".">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </bf:Capture>
        </bf:capture>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='034']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vCartProp">
      <xsl:choose>
        <xsl:when test="@ind2 = 0">bf:outerGRing</xsl:when>
        <xsl:when test="@ind2 = 1">bf:exclusionGRing</xsl:when>
        <xsl:otherwise>bf:coordinates</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vCoordinates">
      <xsl:apply-templates select="marc:subfield[@code='d' or @code='e' or @code='f' or @code='g']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:cartographicAttributes>
          <bf:Cartographic>
            <xsl:element name="{$vCartProp}"><xsl:value-of select="normalize-space($vCoordinates)"/></xsl:element>
            <xsl:for-each select="marc:subfield[@code='3']">
              <xsl:apply-templates select="." mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </bf:Cartographic>
        </bf:cartographicAttributes>
        <xsl:for-each select="marc:subfield[@code='b']">
          <xsl:apply-templates mode="work034scale" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pScaleType">linear horizontal</xsl:with-param>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <xsl:apply-templates mode="work034scale" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pScaleType">linear vertical</xsl:with-param>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield" mode="work034scale">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pScaleType"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:scale>
          <bf:Scale>
            <rdfs:label><xsl:value-of select="."/></rdfs:label>
            <bf:note>
              <bf:Note>
                <rdfs:label><xsl:value-of select="pScaleType"/></rdfs:label>
              </bf:Note>
            </bf:note>
            <xsl:for-each select="../marc:subfield[@code='3']">
              <xsl:apply-templates select="." mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </bf:Scale>
        </bf:scale>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='041']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vSource">
      <xsl:choose>
        <xsl:when test="@ind2 = ' '">marc</xsl:when>
        <xsl:when test="@ind2 = '7'"><xsl:value-of select="marc:subfield[@code='2']"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="@ind1 = '1'">
          <bf:note>
            <bf:Note>
              <rdfs:label>Includes translation</rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'a'] |
                              marc:subfield[@code = 'b'] |
                              marc:subfield[@code = 'd'] |
                              marc:subfield[@code = 'e'] |
                              marc:subfield[@code = 'f'] |
                              marc:subfield[@code = 'g'] |
                              marc:subfield[@code = 'h'] |
                              marc:subfield[@code = 'j'] |
                              marc:subfield[@code = 'k'] |
                              marc:subfield[@code = 'm'] |
                              marc:subfield[@code = 'n']">
          <xsl:variable name="vPart">
            <xsl:choose>
              <xsl:when test="@code = 'b'">summary</xsl:when>
              <xsl:when test="@code = 'd'">sung or spoken text</xsl:when>
              <xsl:when test="@code = 'e'">libretto</xsl:when>
              <xsl:when test="@code = 'f'">table of contents</xsl:when>
              <xsl:when test="@code = 'g'">accompanying material</xsl:when>
              <xsl:when test="@code = 'h'">original</xsl:when>
              <xsl:when test="@code = 'j'">subtitles or captions</xsl:when>
              <xsl:when test="@code = 'k'">intermediate translations</xsl:when>
              <xsl:when test="@code = 'm'">original accompanying materials</xsl:when>
              <xsl:when test="@code = 'n'">original libretto</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <!-- marc language codes can be stacked in the subfield -->
            <xsl:when test="$vSource = 'marc'">
              <xsl:call-template name="parse041">
                <xsl:with-param name="pLang" select="."/>
                <xsl:with-param name="pPart" select="$vPart"/>
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <bf:language>
                <bf:Language>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  <xsl:if test="$vPart != ''">
                    <bf:part><xsl:value-of select="$vPart"/></bf:part>
                  </xsl:if>
                  <xsl:if test="$vSource != ''">
                    <bf:source>
                      <bf:Source>
                        <xsl:choose>
                          <xsl:when test="$vSource = 'iso639-1'">
                            <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/iso639-1</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <rdfs:label><xsl:value-of select="$vSource"/></rdfs:label>
                          </xsl:otherwise>
                        </xsl:choose>
                      </bf:Source>
                    </bf:source>
                  </xsl:if>
                </bf:Language>
              </bf:language>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- unstack language codes in 041 subfields -->
  <xsl:template name="parse041">
    <xsl:param name="pLang"/>
    <xsl:param name="pPart"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pStart" select="1"/>
    <xsl:if test="string-length(substring($pLang,$pStart,3)) = 3">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:language>
            <bf:Language>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($languages,substring($pLang,$pStart,3))"/></xsl:attribute>
              <xsl:if test="$pPart != ''">
                <bf:part><xsl:value-of select="$pPart"/></bf:part>
              </xsl:if>
              <bf:source>
                <bf:Source>
                  <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/languages</xsl:attribute>
                </bf:Source>
              </bf:source>
            </bf:Language>
          </bf:language>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="parse041">
        <xsl:with-param name="pLang" select="$pLang"/>
        <xsl:with-param name="pPart" select="$pPart"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pStart" select="$pStart + 3"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='043']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c']">
          <bf:geographicCoverage>
            <bf:GeographicCoverage>
              <xsl:choose>
                <xsl:when test="@code='a'">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($geographicAreas,.)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="@code='b' or @code='c'">
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  <xsl:choose>
                    <xsl:when test="@code='c'">
                      <bf:source>
                        <bf:Source>
                          <rdfs:label>ISO 3166</rdfs:label>
                        </bf:Source>
                      </bf:source>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="following-sibling::*[position()=1 or position()=2][@code='2']" mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
              <xsl:for-each select="following-sibling::*[position()=1 or position()=2][@code='0']">
                <xsl:apply-templates select="." mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </bf:GeographicCoverage>
          </bf:geographicCoverage>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='045']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:temporalCoverage>
            <xsl:attribute name="rdf:datatype"><xsl:value-of select="$edtf"/>edtf</xsl:attribute>
            <xsl:call-template name="work045aDate">
              <xsl:with-param name="pDate" select="."/>
            </xsl:call-template>
          </bf:temporalCoverage>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="@ind1 = '2'">
            <xsl:variable name="vDate1">
              <xsl:call-template name="work045bDate">
                <xsl:with-param name="pDate" select="marc:subfield[@code='b'][1]"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="vDate2">
              <xsl:call-template name="work045bDate">
                <xsl:with-param name="pDate" select="marc:subfield[@code='b'][2]"/>
              </xsl:call-template>
            </xsl:variable>
            <bf:temporalCoverage>
              <xsl:attribute name="rdf:datatype"><xsl:value-of select="$edtf"/>edtf</xsl:attribute>
              <xsl:value-of select="concat($vDate1,'/',$vDate2)"/>
            </bf:temporalCoverage>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:temporalCoverage>
                <xsl:attribute name="rdf:datatype"><xsl:value-of select="$edtf"/>edtf</xsl:attribute>
                <xsl:call-template name="work045bDate">
                  <xsl:with-param name="pDate" select="."/>
                </xsl:call-template>
              </bf:temporalCoverage>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="work045aDate">
    <xsl:param name="pDate"/>
    <xsl:variable name="vDate1">
      <xsl:choose>
        <xsl:when test="substring($pDate,1,1) = 'a'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,1,1) = 'b'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,1,1) = 'c'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,1,1) = 'd'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,1,1) = 'e'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,2)]"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="concat(document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,1)],substring($pDate,2,1),'u')"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vDate2">
      <xsl:choose>
        <xsl:when test="substring($pDate,3,1) = 'a'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'b'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'c'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'd'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'e'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="concat(document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,1)],substring($pDate,4,1),'u')"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$vDate1 = $vDate2"><xsl:value-of select="$vDate1"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="concat($vDate1,'/',$vDate2)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="work045bDate">
    <xsl:param name="pDate"/>
    <xsl:variable name="vYear">
      <xsl:choose>
        <xsl:when test="substring($pDate,1,1) = 'c'"><xsl:value-of select="concat('-',substring($pDate,2,4))"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="substring($pDate,2,4)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vMonth" select="substring($pDate,6,2)"/>
    <xsl:variable name="vDay" select="substring($pDate,8,2)"/>
    <xsl:variable name="vHour" select="substring($pDate,10,2)"/>
    <xsl:choose>
      <xsl:when test="$vHour != ''"><xsl:value-of select="concat($vYear,'-',$vMonth,'-',$vDay,'T',$vHour)"/></xsl:when>
      <xsl:when test="$vDay != ''"><xsl:value-of select="concat($vYear,'-',$vMonth,'-',$vDay)"/></xsl:when>
      <xsl:when test="$vMonth != ''"><xsl:value-of select="concat($vYear,'-',$vMonth)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$vYear"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='047']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:choose>
                <xsl:when test="../@ind2 = ' '">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcmuscomp,.)"/></xsl:attribute>
                  <bf:source>
                    <bf:Source>
                      <bf:code>marcmuscomp</bf:code>
                    </bf:Source>
                  </bf:source>
                </xsl:when>
                <xsl:otherwise>
                  <bf:code><xsl:value-of select="."/></bf:code>
                  <xsl:for-each select="../marc:subfield[@code='2']">
                    <bf:source>
                      <bf:Source>
                        <bf:code><xsl:value-of select="."/></bf:code>
                      </bf:Source>
                    </bf:source>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="instance" match="marc:datafield[@tag='010'] |
                                       marc:datafield[@tag='015'] |
                                       marc:datafield[@tag='016'] |
                                       marc:datafield[@tag='017'] |
                                       marc:datafield[@tag='020'][not(preceding-sibling::marc:datafield[@tag='020'])] |
                                       marc:datafield[@tag='022'] |
                                       marc:datafield[@tag='024'] |
                                       marc:datafield[@tag='025'] |
                                       marc:datafield[@tag='027'] |
                                       marc:datafield[@tag='028'] |
                                       marc:datafield[@tag='030'] |
                                       marc:datafield[@tag='032'] |
                                       marc:datafield[@tag='035'] |
                                       marc:datafield[@tag='036']">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="@tag='010'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Lccn</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='015'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Nbn</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='016'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Nban</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='017'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:CopyrightNumber</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='020'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Isbn</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
          <xsl:with-param name="pChopPunct" select="true()"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='022'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Issn</xsl:with-param>
          <xsl:with-param name="pIncorrectLabel">incorrect</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">canceled</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='024'">
        <xsl:variable name="vIdentifier">
          <xsl:choose>
            <xsl:when test="@ind1 = '0'">bf:Isrc</xsl:when>
            <xsl:when test="@ind1 = '1'">bf:Upc</xsl:when>
            <xsl:when test="@ind1 = '2'">bf:Ismn</xsl:when>
            <xsl:when test="@ind1 = '3'">bf:Ean</xsl:when>
            <xsl:when test="@ind1 = '4'">bf:Sici</xsl:when>
            <xsl:otherwise>bf:Identifier</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier"><xsl:value-of select="$vIdentifier"/></xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='025'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:LcOverseasAcq</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='027'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Strn</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='028'">
        <xsl:variable name="vIdentifier">
          <xsl:choose>
            <xsl:when test="@ind1 = '0'">bf:IssueNumber</xsl:when>
            <xsl:when test="@ind1 = '1'">bf:MatrixNumber</xsl:when>
            <xsl:when test="@ind1 = '2'">bf:MusicPlate</xsl:when>
            <xsl:when test="@ind1 = '3'">bf:MusicNumber</xsl:when>
            <xsl:when test="@ind1 = '4'">bf:VideorecordingNumber</xsl:when>
            <xsl:otherwise>bf:PublisherNumber</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier"><xsl:value-of select="$vIdentifier"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='030'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Coden</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='032'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:PostalRegistration</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='035'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Local</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='036'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:StudyNumber</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      generate new Instances from multiple 020s
  -->
  <xsl:template match="marc:datafield[@tag='020'][preceding-sibling::marc:datafield[@tag='020']]" mode="newInstance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="instanceiri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Instance>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$instanceiri"/></xsl:attribute>
          <xsl:apply-templates select="." mode="instanceId">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pIdentifier">bf:Isbn</xsl:with-param>
            <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
            <xsl:with-param name="pChopPunct" select="true()"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          </bf:instanceOf>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instanceId">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pIdentifier" select="'bf:Identifier'"/>
    <xsl:param name="pIncorrectLabel" select="'incorrect'"/>
    <xsl:param name="pInvalidLabel" select="'invalid'"/>
    <xsl:param name="pChopPunct" select="false()"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='y' or @code='z']">
          <xsl:variable name="vId">
            <xsl:choose>
              <!-- for 035, extract value after parentheses -->
              <xsl:when test="../@tag='035' and contains(.,')')"><xsl:value-of select="substring-after(.,')')"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <bf:identifiedBy>
            <xsl:element name="{$pIdentifier}">
              <rdf:value>
                <xsl:choose>
                  <xsl:when test="$pChopPunct">
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString"><xsl:value-of select="$vId"/></xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$vId"/>
                  </xsl:otherwise>
                </xsl:choose>
              </rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label><xsl:value-of select="$pInvalidLabel"/></rdfs:label>
              </xsl:if>
              <xsl:if test="@code = 'y'">
                <rdfs:label><xsl:value-of select="$pIncorrectLabel"/></rdfs:label>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='q']">
                <bf:qualifier>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                    <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                  </xsl:call-template>
                </bf:qualifier>
              </xsl:for-each>
              <!-- special handling for 017 -->
              <xsl:if test="../@tag='017'">
                <xsl:variable name="date"><xsl:value-of select="../marc:subfield[@code='d'][1]"/></xsl:variable>
                <xsl:variable name="dateformatted"><xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))"/></xsl:variable>
                <xsl:if test="$date != ''">
                  <bf:date>
                    <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>date</xsl:attribute>
                    <xsl:value-of select="$dateformatted"/>
                  </bf:date>
                </xsl:if>
                <xsl:for-each select="../marc:subfield[@code='i']">
                  <bf:note>
                    <bf:Note>
                      <rdfs:label>
                        <xsl:call-template name="chopPunctuation">
                          <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                          <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                          </xsl:with-param>
                        </xsl:call-template>
                      </rdfs:label>
                    </bf:Note>
                  </bf:note>
                </xsl:for-each>
              </xsl:if>
              <!-- special handling for 024 -->
              <xsl:if test="../@tag='024'">
                <xsl:if test="@code = 'a'">
                  <xsl:for-each select="../marc:subfield[@code='d']">
                    <bf:note>
                      <bf:Note>
                        <bf:noteType>additional codes</bf:noteType>
                        <rdfs:label><xsl:value-of select="."/></rdfs:label>
                      </bf:Note>
                    </bf:note>
                  </xsl:for-each>
                </xsl:if>
              </xsl:if>
              <!-- special handling for 030 -->
              <xsl:if test="../@tag='030'">
                <xsl:if test="@code = 'z'">
                  <bf:adminMetadata>
                    <bf:AdminMetadata>
                      <bf:status>
                        <bf:Status>
                          <rdfs:label>invalid</rdfs:label>
                        </bf:Status>
                      </bf:status>
                    </bf:AdminMetadata>
                  </bf:adminMetadata>
                </xsl:if>
              </xsl:if>
              <!-- special handling for source ($2) -->
              <xsl:choose>
                <xsl:when test="../@tag='016'">
                  <xsl:choose>
                    <xsl:when test="../@ind1 = ' '">
                      <bf:source>
                        <bf:Source>
                          <rdfs:label>Library and Archives Canada</rdfs:label>
                        </bf:Source>
                      </bf:source>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="../@tag='017' or ../@tag='028' or ../@tag='032' or ../@tag='036'">
                  <xsl:for-each select="../marc:subfield[@code='b']">
                    <bf:source>
                      <bf:Source>
                        <rdfs:label>
                          <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                              <xsl:value-of select="."/>
                            </xsl:with-param>
                          </xsl:call-template>
                        </rdfs:label>
                      </bf:Source>
                    </bf:source>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="../@tag='024'">
                  <xsl:if test="../@ind1='7'">
                    <xsl:for-each select="../marc:subfield[@code='2']">
                      <rdfs:label><xsl:value-of select="."/></rdfs:label>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="../@tag='035'">
                  <xsl:variable name="vSource" select="substring-before(substring-after(.,'('),')')"/>
                  <xsl:if test="$vSource != ''">
                    <bf:source>
                      <bf:Source>
                        <rdfs:label><xsl:value-of select="$vSource"/></rdfs:label>
                      </bf:Source>
                    </bf:source>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:acquisitionTerms>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:acquisitionTerms>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 026 requires special handling -->
  <xsl:template match="marc:datafield[@tag='026']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="parsed">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:identifiedBy>
          <bf:Fingerprint>
            <xsl:choose>
              <xsl:when test="$parsed != ''">
                <rdf:value><xsl:value-of select="normalize-space($parsed)"/></rdf:value>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="marc:subfield[@code='e']">
                  <rdf:value><xsl:value-of select="."/></rdf:value>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="marc:subfield[@code='2']">
              <xsl:apply-templates select="." mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='5']">
              <xsl:apply-templates select="." mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </bf:Fingerprint>
        </bf:identifiedBy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 037 requires special handling -->
  <xsl:template match="marc:datafield[@tag='037'][@ind1='3' or (@ind1=' ' and count(../marc:datafield[@tag='037'])=1)]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance037">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- create new instances from multiple 037s -->
  <xsl:template match="marc:datafield[@tag='037'][@ind1='2' or (@ind1=' ' and count(../marc:datafield[@tag='037']) &gt; 1)]" mode="newInstance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="instanceiri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Instance>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$instanceiri"/></xsl:attribute>
          <xsl:apply-templates select="." mode="instance037">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          </bf:instanceOf>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instance037">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vAcqSource">
      <xsl:choose>
        <xsl:when test="@ind1 = '2'">intervening source</xsl:when>
        <xsl:when test="@ind1 = '3'">current source</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:acquisitionSource>
          <bf:AcquisitionSource>
            <xsl:if test="$vAcqSource != ''">
              <bf:note>
                <bf:Note>
                  <rdfs:label><xsl:value-of select="$vAcqSource"/></rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='3']">
              <xsl:apply-templates select="." mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:identifiedBy>
                <bf:StockNumber>
                  <rdf:value><xsl:value-of select="."/></rdf:value>
                </bf:StockNumber>
              </bf:identifiedBy>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:acquisitionTerms><xsl:value-of select="."/></bf:acquisitionTerms>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='g' or @code='n']">
              <bf:note>
                <bf:Note>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='5']">
              <xsl:apply-templates select="." mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </bf:AcquisitionSource>
        </bf:acquisitionSource>
        <xsl:for-each select="marc:subfield[@code='f']">
          <bf:carrier>
            <bf:Carrier>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Carrier>
          </bf:carrier>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 044 requires special handling -->
  <xsl:template match="marc:datafield[@tag='044']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c']">
          <bf:place>
            <bf:Place>
              <xsl:choose>
                <xsl:when test="@code='a'">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,.)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="@code='b' or @code='c'">
                  <bf:code><xsl:value-of select="."/></bf:code>
                  <xsl:choose>
                    <xsl:when test="@code='c'">
                      <bf:source>
                        <bf:Source>
                          <rdfs:label>ISO 3166</rdfs:label>
                        </bf:Source>
                      </bf:source>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="following-sibling::*[position()=1 or position()=2][@code='2']" mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
            </bf:Place>
          </bf:place>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
