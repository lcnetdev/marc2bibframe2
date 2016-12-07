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
                                       marc:datafield[@tag='032']">
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
          <bf:identifiedBy>
            <xsl:element name="{$pIdentifier}">
              <rdf:value>
                <xsl:choose>
                  <xsl:when test="$pChopPunct">
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="."/>
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
                <xsl:when test="../@tag='017' or ../@tag='028' or ../@tag='032'">
                  <xsl:for-each select="../marc:subfield[@code='b']">
                    <bf:source>
                      <bf:Source>
                        <rdfs:label><xsl:value-of select="normalize-space(.)"/></rdfs:label>
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

</xsl:stylesheet>
