<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:local="local:"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc local">

  <!--
      Conversion specs for 010-048
  -->

  <!-- Lookup tables -->
  <local:marctimeperiod>
    <a0>-XXXX/-3000</a0>
    <b0>-29XX</b0>
    <b1>-28XX</b1>
    <b2>-27XX</b2>
    <b3>-26XX</b3>
    <b4>-25XX</b4>
    <b5>-24XX</b5>
    <b6>-23XX</b6>
    <b7>-22XX</b7>
    <b8>-21XX</b8>
    <b9>-20XX</b9>
    <c0>-19XX</c0>
    <c1>-18XX</c1>
    <c2>-17XX</c2>
    <c3>-16XX</c3>
    <c4>-15XX</c4>
    <c5>-14XX</c5>
    <c6>-13XX</c6>
    <c7>-12XX</c7>
    <c8>-11XX</c8>
    <c9>-10XX</c9>
    <d0>-09XX</d0>
    <d1>-08XX</d1>
    <d2>-07XX</d2>
    <d3>-06XX</d3>
    <d4>-05XX</d4>
    <d5>-04XX</d5>
    <d6>-03XX</d6>
    <d7>-02XX</d7>
    <d8>-01XX</d8>
    <d9>-00XX</d9>
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

  <local:instrumentCode>
    <ba property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType><rdfs:label>horn</rdfs:label></ba>
    <bb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType><rdfs:label>trumpet</rdfs:label></bb>
    <bc property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType><rdfs:label>coronet</rdfs:label></bc>
    <bd property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType><rdfs:label>trombone</rdfs:label></bd>
    <be property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType><rdfs:label>tuba</rdfs:label></be>
    <bf property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType><rdfs:label>baritone</rdfs:label></bf>
    <bn property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType></bn>
    <bu property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType></bu>
    <by property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass, ethnic</bf:instrumentalType></by>
    <bz property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>brass</bf:instrumentalType></bz>
    <ea property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType><rdfs:label>electronic synthesizer</rdfs:label></ea>
    <eb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType><rdfs:label>electronic tape</rdfs:label></eb>
    <ec property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType><rdfs:label>computer</rdfs:label></ec>
    <ed property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType><rdfs:label>ondes martinot</rdfs:label></ed>
    <en property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType></en>
    <eu property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType></eu>
    <ez property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>electronic</bf:instrumentalType></ez>
    <ka property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType><rdfs:label>piano</rdfs:label></ka>
    <kb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType><rdfs:label>organ</rdfs:label></kb>
    <kc property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType><rdfs:label>harpsichord</rdfs:label></kc>
    <kd property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType><rdfs:label>clavichord</rdfs:label></kd>
    <ke property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType><rdfs:label>continuo</rdfs:label></ke>
    <kf property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType><rdfs:label>celeste</rdfs:label></kf>
    <kn property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType></kn>
    <ku property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType></ku>
    <ky property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard, ethnic</bf:instrumentalType></ky>
    <kz property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>keyboard</bf:instrumentalType></kz>
    <pa property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType><rdfs:label>timpani</rdfs:label></pa>
    <pb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType><rdfs:label>xylophone</rdfs:label></pb>
    <pc property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType><rdfs:label>marimba</rdfs:label></pc>
    <pd property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType><rdfs:label>drum</rdfs:label></pd>
    <pn property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType></pn>
    <pu property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType></pu>
    <py property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion, ethnic</bf:instrumentalType></py>
    <pz property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>percussion</bf:instrumentalType></pz>
    <sa property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>violin</rdfs:label></sa>
    <sb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>viola</rdfs:label></sb>
    <sc property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>violoncello</rdfs:label></sc>
    <sd property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>double bass</rdfs:label></sd>
    <se property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>viol</rdfs:label></se>
    <sf property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>viola d'amore</rdfs:label></sf>
    <sg property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType><rdfs:label>viola da gamba</rdfs:label></sg>
    <sn property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType></sn>
    <su property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType></su>
    <sy property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed, ethnic</bf:instrumentalType></sy>
    <sz property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, bowed</bf:instrumentalType></sz>
    <ta property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType><rdfs:label>harp</rdfs:label></ta>
    <tb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType><rdfs:label>guitar</rdfs:label></tb>
    <tc property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType><rdfs:label>lute</rdfs:label></tc>
    <td property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType><rdfs:label>mandolin</rdfs:label></td>
    <tn property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType></tn>
    <tu property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType></tu>
    <ty property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked, ethnic</bf:instrumentalType></ty>
    <tz property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>string, plucked</bf:instrumentalType></tz>
    <wa property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>flute</rdfs:label></wa>
    <wb property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>oboe</rdfs:label></wb>
    <wc property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>clarinet</rdfs:label></wc>
    <wd property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>bassoon</rdfs:label></wd>
    <we property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>piccolo</rdfs:label></we>
    <wf property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>English horn</rdfs:label></wf>
    <wg property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>bass clarinet</rdfs:label></wg>
    <wh property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>recorder</rdfs:label></wh>
    <wi property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType><rdfs:label>saxophone</rdfs:label></wi>
    <wn property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType></wn>
    <wu property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType></wu>
    <wy property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind, ethnic</bf:instrumentalType></wy>
    <wz property="bf:instrument" entity="bf:MusicInstrument"><bf:instrumentalType>woodwind</bf:instrumentalType></wz>
    <oa property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType><rdfs:label>orchestra</rdfs:label></oa>
    <ob property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType><rdfs:label>chamber orchestra</rdfs:label></ob>
    <oc property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType><rdfs:label>string orchestra</rdfs:label></oc>
    <od property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType><rdfs:label>band</rdfs:label></od>
    <oe property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType><rdfs:label>dance orchestra</rdfs:label></oe>
    <of property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType><rdfs:label>brass band</rdfs:label></of>
    <on property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType></on>
    <oo property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType></oo>
    <ou property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType></ou>
    <oy property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental, ethnic</bf:ensembleType></oy>
    <oz property="bf:ensemble" entity="bf:MusicEnsemble"><bf:ensembleType>instrumental</bf:ensembleType></oz>
    <ca property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType><rdfs:label>mixed chorus</rdfs:label></ca>
    <cb property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType><rdfs:label>female chorus</rdfs:label></cb>
    <cc property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType><rdfs:label>male chorus</rdfs:label></cc>
    <cd property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType><rdfs:label>children chorus</rdfs:label></cd>
    <cn property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType></cn>
    <cu property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType></cu>
    <cy property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus, ethnic</bf:voiceType></cy>
    <cz property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>chorus</bf:voiceType></cz>
    <va property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>soprano</rdfs:label></va>
    <vb property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>mezzo soprano</rdfs:label></vb>
    <vc property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>alto</rdfs:label></vc>
    <vd property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>tenor</rdfs:label></vd>
    <ve property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>baritone</rdfs:label></ve>
    <vf property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>bass</rdfs:label></vf>
    <vg property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>counter tenor</rdfs:label></vg>
    <vh property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>high voice</rdfs:label></vh>
    <vi property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>medium voice</rdfs:label></vi>
    <vj property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType><rdfs:label>low voice</rdfs:label></vj>
    <vn property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType></vn>
    <vo property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType></vo>
    <vu property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice</bf:voiceType></vu>
    <vy property="bf:voice" entity="bf:MusicVoice"><bf:voiceType>voice, ethnic</bf:voiceType></vy>
  </local:instrumentCode>

  <xsl:template match="marc:datafield[@tag='016']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Local</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='038']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bflc:metadataLicensor>
            <bflc:MetadataLicensor>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bflc:MetadataLicensor>
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
          <xsl:variable name="vUri">
            <xsl:if test="text() = 'DLC'">
              <xsl:value-of select="concat($organizations,'dlc')"/>
            </xsl:if>
          </xsl:variable>
          <bf:source>
            <bf:Source>
              <xsl:if test="$vUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vUri"/></xsl:attribute>
              </xsl:if>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Agent')"/></xsl:attribute>
              </rdf:type>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Source>
          </bf:source>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <!-- this should be a code -->
          <!-- assume MARC code if 3 characters -->
          <bf:descriptionLanguage>
            <bf:Language>
              <xsl:if test="string-length(.) = 3">
                <xsl:variable name="encoded">
                  <xsl:call-template name="url-encode">
                    <xsl:with-param name="str" select="normalize-space(.)"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="rdf:about"><xsl:value-of select="concat($languages,$encoded)"/></xsl:attribute>
              </xsl:if>
              <bf:code><xsl:value-of select="."/></bf:code>
            </bf:Language>
          </bf:descriptionLanguage>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='d']">
          <bf:descriptionModifier>
            <bf:Agent>
              <xsl:variable name="vUri">
                <xsl:if test="text() = 'DLC'">
                  <xsl:value-of select="concat($organizations,'dlc')"/>
                </xsl:if>
              </xsl:variable>
              <xsl:if test="$vUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Agent>
          </bf:descriptionModifier>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='e']">
          <bf:descriptionConventions>
            <bf:DescriptionConventions>
              <xsl:if test="not(contains(normalize-space(.),' '))">
                <xsl:variable name="vUri">
                  <xsl:call-template name="url-encode">
                    <xsl:with-param name="str" select="normalize-space(.)"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="rdf:about"><xsl:value-of select="concat($descriptionConventions,$vUri)"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
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
          <xsl:variable name="encoded">
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:variable>
          <bf:descriptionAuthentication>
            <bf:DescriptionAuthentication>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcauthen,$encoded)"/></xsl:attribute>
              <rdf:value><xsl:value-of select="."/></rdf:value>
            </bf:DescriptionAuthentication>
          </bf:descriptionAuthentication>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='010']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:identifiedBy>
            <bf:Lccn>
              <rdf:value><xsl:value-of select="."/></rdf:value>
            </bf:Lccn>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='022']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instanceId">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pIdentifier">bf:Issn</xsl:with-param>
      <xsl:with-param name="pIncorrectLabel">incorrect</xsl:with-param>
      <xsl:with-param name="pInvalidLabel">canceled</xsl:with-param>
    </xsl:apply-templates>
    <xsl:for-each select="marc:subfield[@code='l'] | marc:subfield[@code='m']">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:identifiedBy>
            <bf:IssnL>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'm'">
                <bf:status>
                  <bf:Status>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mstatus/cancinv</xsl:attribute>
                    <rdfs:label>canceled</rdfs:label>
                  </bf:Status>
                </bf:status>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:IssnL>
          </bf:identifiedBy>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='024']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="@ind1='7' and marc:subfield[@code='2' and text()='eidr']">
      <xsl:apply-templates select="." mode="instanceId">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pIdentifier">bflc:Eidr</xsl:with-param>
        <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        <xsl:with-param name="pChopPunct" select="true()"/>
      </xsl:apply-templates>
    </xsl:if>
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
    <xsl:variable name="vCoordinates">
      <xsl:apply-templates select="marc:subfield[@code='d' or @code='e' or @code='f' or @code='g']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$vCoordinates != ''">
          <bf:cartographicAttributes>
            <bf:Cartographic>
              <bf:coordinates><xsl:value-of select="normalize-space($vCoordinates)"/></bf:coordinates>
              <xsl:for-each select="marc:subfield[@code='3']">
                <xsl:apply-templates select="." mode="subfield3">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </bf:Cartographic>
          </bf:cartographicAttributes>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:if test="text() = 'a' and not(../marc:subfield[@code='b' or @code='c'])">
            <bf:scale>
              <bf:Scale>
                <bf:note>
                  <bf:Note>
                    <rdfs:label>Linear scale</rdfs:label>
                  </bf:Note>
                </bf:note>
              </bf:Scale>
            </bf:scale>
          </xsl:if>
        </xsl:for-each>
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
                <rdfs:label><xsl:value-of select="$pScaleType"/></rdfs:label>
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
                              marc:subfield[@code = 'n'] |
                              marc:subfield[@code = 'p'] |
                              marc:subfield[@code = 'q'] |
                              marc:subfield[@code = 'r']">
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
              <xsl:when test="@code = 'p'">captions</xsl:when>
              <xsl:when test="@code = 'q'">accessible audio</xsl:when>
              <xsl:when test="@code = 'r'">accessible visual material</xsl:when>
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
                  <rdf:value><xsl:value-of select="."/></rdf:value>
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
  <!-- convert to lowercase -->
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
              <xsl:if test="$pPart != ''">
                <bf:part><xsl:value-of select="$pPart"/></bf:part>
              </xsl:if>
              <xsl:variable name="encoded">
                <xsl:call-template name="url-encode">
                  <xsl:with-param name="str" select="translate(normalize-space(substring($pLang,$pStart,3)),$upper,$lower)"/>
                </xsl:call-template>
              </xsl:variable>
              <rdf:value>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($languages,$encoded)"/></xsl:attribute>
              </rdf:value>
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
                  <xsl:variable name="vCode">
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="encoded">
                    <xsl:call-template name="url-encode">
                      <xsl:with-param name="str" select="normalize-space($vCode)"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($geographicAreas,$encoded)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="@code='b' or @code='c'">
                  <rdf:value><xsl:value-of select="."/></rdf:value>
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
        <xsl:otherwise><xsl:value-of select="concat(document('')/*/local:marctimeperiod/*[name() = substring($pDate,1,1)],substring($pDate,2,1),'X')"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vDate2">
      <xsl:choose>
        <xsl:when test="substring($pDate,3,1) = 'a'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'b'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'c'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'd'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:when test="substring($pDate,3,1) = 'e'"><xsl:value-of select="document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,2)]"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="concat(document('')/*/local:marctimeperiod/*[name() = substring($pDate,3,1)],substring($pDate,4,1),'X')"/></xsl:otherwise>
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
          <xsl:choose>
            <xsl:when test="../@ind2 = ' '">
              <xsl:call-template name="compForm008">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="code" select="."/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <bf:genreForm>
                <bf:GenreForm>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='048']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <!-- only attempt to code if ind2 = ' ' -->
    <xsl:if test="@ind2 = ' '">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:for-each select="marc:subfield[@code='a' or @code='b']">
            <xsl:variable name="vCode" select="substring(.,1,2)"/>
            <xsl:variable name="vCount" select="substring(.,3,2)"/>
            <xsl:if test="document('')/*/local:instrumentCode/*[name() = $vCode]">
              <xsl:element name="{document('')/*/local:instrumentCode/*[name() = $vCode]/@property}">
                <xsl:element name="{document('')/*/local:instrumentCode/*[name() = $vCode]/@entity}">
                  <xsl:for-each select="document('')/*/local:instrumentCode/*[name() = $vCode]/*">
                    <xsl:element name="{name()}"><xsl:value-of select="."/></xsl:element>
                  </xsl:for-each>
                  <xsl:if test="$vCount != ''">
                    <bf:count><xsl:value-of select="number($vCount)"/></bf:count>
                  </xsl:if>
                </xsl:element>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="instance" match="marc:datafield[@tag='010'] |
                                       marc:datafield[@tag='015'] |
                                       marc:datafield[@tag='017'] |
                                       marc:datafield[@tag='020'] |
                                       marc:datafield[@tag='024'] |
                                       marc:datafield[@tag='025'] |
                                       marc:datafield[@tag='027'] |
                                       marc:datafield[@tag='028'] |
                                       marc:datafield[@tag='030'] |
                                       marc:datafield[@tag='032'] |
                                       marc:datafield[@tag='035'] |
                                       marc:datafield[@tag='036'] |
                                       marc:datafield[@tag='074'] |
                                       marc:datafield[@tag='088']">
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
          <xsl:with-param name="pChopPunct" select="true()"/>
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
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
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
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Isbn</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
          <xsl:with-param name="pChopPunct" select="true()"/>
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
            <xsl:when test="@ind1 = '7'">
              <xsl:choose>
                <xsl:when test="marc:subfield[@code='2' and text()='ansi']">bf:Ansi</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='doi']">bf:Doi</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='hdl']">bf:Hdl</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='isan']">bf:Isan</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='isni']">bf:Isni</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='iso']">bf:Iso</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='istc']">bf:Istc</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='iswc']">bf:Iswc</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='matrix-number']">bf:MatrixNumber</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='music-plate']">bf:MusicPlate</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='music-publisher']">bf:MusicPublisherNumber</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='stock-number']">bf:StockNumber</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='urn']">bf:Urn</xsl:when>
                <xsl:when test="marc:subfield[@code='2' and text()='videorecording-identifier']">bf:VideoRecordingNumber</xsl:when>
                <!-- do not process EIDR here, process as a Work identifier instead -->
                <xsl:when test="marc:subfield[@code='2' and text()='eidr']"/>
                <xsl:otherwise>bf:Identifier</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>bf:Identifier</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
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
        <xsl:if test="$vIdentifier != ''">
          <xsl:apply-templates select="." mode="instanceId">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pIdentifier"><xsl:value-of select="$vIdentifier"/></xsl:with-param>
            <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
            <xsl:with-param name="pChopPunct" select="true()"/>
          </xsl:apply-templates>
        </xsl:if>
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
          <xsl:with-param name="pChopPunct" select="true()"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='028'">
        <xsl:variable name="vIdentifier">
          <xsl:choose>
            <xsl:when test="@ind1 = '0'">bf:AudioIssueNumber</xsl:when>
            <xsl:when test="@ind1 = '1'">bf:MatrixNumber</xsl:when>
            <xsl:when test="@ind1 = '2'">bf:MusicPlate</xsl:when>
            <xsl:when test="@ind1 = '3'">bf:MusicPublisherNumber</xsl:when>
            <xsl:when test="@ind1 = '4'">bf:VideoRecordingNumber</xsl:when>
            <xsl:when test="@ind1 = '6'">bf:MusicDistributorNumber</xsl:when>
            <xsl:otherwise>bf:PublisherNumber</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier"><xsl:value-of select="$vIdentifier"/></xsl:with-param>
          <xsl:with-param name="pChopPunct" select="true()"/>
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
      <xsl:when test="@tag='074'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:Identifier</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@tag='088'">
        <xsl:apply-templates select="." mode="instanceId">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pIdentifier">bf:ReportNumber</xsl:with-param>
          <xsl:with-param name="pInvalidLabel">invalid</xsl:with-param>
        </xsl:apply-templates>
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
              <!-- for 015,020,024,027,028 extract value outside parentheses -->
              <xsl:when test="(../@tag='015' or ../@tag='020' or ../@tag='024' or ../@tag='027' or ../@tag='028') and
                              contains(.,'(') and contains(.,')')">
                <xsl:value-of select="concat(substring-before(.,'('),substring-after(.,')'))"/>
              </xsl:when>
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
                <bf:status>
                  <bf:Status>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mstatus/cancinv</xsl:attribute>
                    <rdfs:label><xsl:value-of select="$pInvalidLabel"/></rdfs:label>
                  </bf:Status>
                </bf:status>
              </xsl:if>
              <xsl:if test="@code = 'y'">
                <bf:status>
                  <bf:Status>
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mstatus/incorrect</xsl:attribute>
                    <rdfs:label><xsl:value-of select="$pIncorrectLabel"/></rdfs:label>
                  </bf:Status>
                </bf:status>
              </xsl:if>
              <!-- special handling for 015, 020, 024, 027, 028 -->
              <xsl:if test="(../@tag='015' or ../@tag='020' or ../@tag='024' or ../@tag='027' or ../@tag='028') and
                            contains(.,'(') and contains(.,')')">
                <xsl:variable name="vQualifier" select="substring-before(substring-after(.,'('),')')"/>
                <xsl:if test="$vQualifier != ''">
                  <bf:qualifier>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString"><xsl:value-of select="$vQualifier"/></xsl:with-param>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </bf:qualifier>
                </xsl:if>
              </xsl:if>
              <!-- special handling for 036 -->
              <xsl:if test="../@tag='036'">
                <xsl:for-each select="../marc:subfield[@code='c']">
                  <bf:acquisitionTerms>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </bf:acquisitionTerms>
                </xsl:for-each>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='q']">
                <bf:qualifier>
                  <xsl:call-template name="chopParens">
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
                  <xsl:choose>
                    <xsl:when test="$pIdentifier = 'bf:Identifier'">
                      <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                        <xsl:with-param name="serialization" select="$serialization"/>
                      </xsl:apply-templates>
                    </xsl:when>
                  </xsl:choose>
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
                <xsl:when test="../@tag='074'">
                  <bf:source>
                    <bf:Source>
                      <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/organizations/dgpo</xsl:attribute>
                    </bf:Source>
                  </bf:source>
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

  <xsl:template match="marc:datafield[@tag='037']" mode="instance">
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
            <xsl:for-each select="marc:subfield[@code='f']">
              <bf:note>
                <bf:Note>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Note>
              </bf:note>
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
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
