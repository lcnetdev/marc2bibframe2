<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 3XX -->

  <xsl:template match="marc:datafield[@tag='336']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:content</xsl:with-param>
      <xsl:with-param name="pResource">bf:Content</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='336' or @tag='337' or @tag='338' or @tag='880']" mode="rdaResource">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pProp"/>
    <xsl:param name="pResource"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:element name="{$pProp}">
            <xsl:element name="{$pResource}">
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='b'][position()=1]">
                <bf:code><xsl:value-of select="."/></bf:code>
              </xsl:for-each>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0'][position()=1]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b'][count(preceding-sibling::marc:subfield[@code='a'][position()=1])=0]">
          <bf:content>
            <bf:Content>
              <bf:code><xsl:value-of select="."/></bf:code>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0'][position()=1]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Content>
          </bf:content>
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
              <rdfs:label><xsl:value-of select="normalize-space($vExtent)"/></rdfs:label>
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
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:duration><xsl:value-of select="."/></bf:duration>
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
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:frequency>
            <bf:Frequency>
              <rdfs:label>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                  <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
              <xsl:for-each select="../marc:subfield[@code='b']">
                <bf:date><xsl:value-of select="."/></bf:date>
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
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='338']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="rdaResource">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pProp">bf:carrier</xsl:with-param>
      <xsl:with-param name="pResource">bf:Carrier</xsl:with-param>
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
        <xsl:for-each select="marc:subfield[@code='i']">
          <bf:systemRequirements><xsl:value-of select="."/></bf:systemRequirements>
        </xsl:for-each>
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

  <xsl:template match="marc:datafield[@tag='344']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance344">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='344' or @tag='880']" mode="instance344">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:RecordingMethod</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='b']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:RecordingMedium</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='c']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:PlayingSpeed</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='d']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:GrooveCharacteristics</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='e']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:TrackConfig</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='f']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:TapeConfig</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='g']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:PlaybackChannels</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='h']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:soundCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:PlaybackCharacteristic</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='345']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance345">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='345' or @tag='880']" mode="instance345">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:projectionCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:PresentationFormat</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='b']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:projectionCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:ProjectionSpeed</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='346']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance346">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='346' or @tag='880']" mode="instance346">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:videoCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:VideoFormat</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='b']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:videoCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:BroadcastStandard</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='347']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance347">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='347' or @tag='880']" mode="instance347">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="marc:subfield[@code='a']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:FileType</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='b']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:EncodingFormat</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='c']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:FileSize</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='d']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:Resolution</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='e']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:RegionalEncoding</xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='f']" mode="generateProperty">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:digitalCharacteristic</xsl:with-param>
          <xsl:with-param name="pResource">bf:EncodedBitrate</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='348']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance348">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='348' or @tag='880']" mode="instance348">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:musicFormat>
            <bf:MusicFormat>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
              <xsl:for-each select="../marc:subfield[@code='b'][position()=1]">
                <bf:code><xsl:value-of select="."/></bf:code>
              </xsl:for-each>
              <xsl:apply-templates select="../marc:subfield[@code='0'][position()=1]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:MusicFormat>
          </bf:musicFormat>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
