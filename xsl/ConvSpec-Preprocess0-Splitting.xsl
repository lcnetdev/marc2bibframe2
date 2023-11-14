<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
  xmlns:marc="http://www.loc.gov/MARC21/slim"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xsl">
  
  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  
  <!-- base for minting URIs -->
  <xsl:param name="baseuri" select="'http://example.org/'"/>

  <!--
      MARC field in which to find the record ID
      Defaults to subfield $a, to use a different subfield,
      add to the end of the tag (e.g. "035a")
  -->
  <xsl:param name="idfield" select="'001'"/>
  
  <!--
      Use field conversion for locally defined fields.
      Some fields in the conversion (e.g. 859) are locally defined by
      LoC for conversion. By default these fields will not be
      converted unless this parameter evaluates to true()
  -->
  <xsl:param name="localfields" select="true()" />

  <xsl:include href="variables.xsl"/>
  <xsl:include href="utils.xsl"/>
  
  <xsl:template match="/">
    <marc:collection>
      <xsl:apply-templates />
    </marc:collection>
  </xsl:template>
  
  <xsl:template match="marc:record[@type='Bibliographic' or not(@type)]">
    <xsl:variable name="recordno"><xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="recordid">
      <xsl:apply-templates mode="recordid" select=".">
        <xsl:with-param name="baseuri" select="$baseuri"/>
        <xsl:with-param name="idfield" select="$idfield"/>
        <xsl:with-param name="recordno" select="$recordno"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:variable name="leader06" select="substring(marc:leader,7,1)"/>
    <xsl:variable name="count006" select="count(marc:controlfield[@tag='006'])"/>
    <xsl:variable name="count007" select="count(marc:controlfield[@tag='007'])"/>
    <xsl:variable name="count007minusC" select="count(marc:controlfield[@tag='007' and substring(.,1,1) != 'c'])"/>
    <xsl:variable name="countOrig300" select="count(marc:datafield[@tag='300'])"/>
    
    <xsl:variable name="groups">
      <marc:groups>
        <xsl:variable name="the300s">
          <xsl:apply-templates select="marc:datafield[@tag='300']" mode="groupify">
            <xsl:with-param name="pcountOrig300" select="$countOrig300" />
          </xsl:apply-templates>    
        </xsl:variable>
        <xsl:variable name="the300sNS" select="exsl:node-set($the300s)"/>

        <xsl:variable name="df3XXs" select="marc:datafield[
                                              @tag='336' or @tag='337' or @tag='338' or 
                                              @tag='344' or 
                                              @tag='346' or @tag='347' or @tag='348'
                                            ]"/>
        <xsl:for-each select="$the300sNS/marc:datafield">
          <marc:group>
            <xsl:copy-of select="." />
            <xsl:for-each select="marc:subfield[@code='3']">
              <xsl:variable name="c3" select="."/>
              <xsl:apply-templates select="$df3XXs[marc:subfield[@code='3' and contains(., $c3)]]">
                <xsl:with-param name="genId">1</xsl:with-param>
              </xsl:apply-templates>
              <xsl:apply-templates select="$df3XXs[not(marc:subfield[@code='3']) and marc:subfield[@code='a' and .=$c3]]">
                <xsl:with-param name="genId">1</xsl:with-param>
              </xsl:apply-templates>
            </xsl:for-each>    
          </marc:group>
        </xsl:for-each>
      </marc:groups>
    </xsl:variable>
    <xsl:variable name="groupsNS" select="exsl:node-set($groups)" />
    <xsl:variable name="count300" select="count($groupsNS/marc:groups/marc:group/marc:datafield[@tag='300'])"/>
    
    <!-- <xsl:message><xsl:copy-of select="$groups" /></xsl:message> -->
    
    <xsl:variable name="exclusions" select="document('conf/exclusions.xml')"/>
    <xsl:variable name="viable856s">
      <xsl:for-each select="marc:datafield[
            @tag='856' and 
            (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and
            marc:subfield[@code='u'] and 
            not( contains(marc:subfield[@code='3'], 'able of contents') )
        ]">
        <xsl:variable name="theU" select="marc:subfield[@code='u']" />
        <xsl:if test="count($exclusions/exclusions/exclusion/@text[contains($theU, .)]) = 0">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="viable856sNS" select="exsl:node-set($viable856s)" />
    <xsl:variable name="countViable856s" select="count($viable856sNS/marc:datafield)" />
    
    <xsl:variable name="viable859s">
      <xsl:if test="$localfields">
      <xsl:for-each select="marc:datafield[
          @tag='859' and 
          (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and
          marc:subfield[@code='u'] and 
          not( contains(marc:subfield[@code='3'], 'able of contents') )
          ]">
          <xsl:variable name="theU" select="marc:subfield[@code='u']" />
          <xsl:if test="count($exclusions/exclusions/exclusion/@text[contains($theU, .)]) = 0">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="viable859sNS" select="exsl:node-set($viable859s)" />
    <xsl:variable name="countViable859s" select="count($viable859sNS/marc:datafield)" />

    <!-- Going to want to check if this record is already a 'split' record and, if so, just return it. -->
    <!-- But until then.... -->
    
    <xsl:choose>
      <xsl:when test="$count007 &lt; 2 and $countViable856s = 0 and $countViable859s = 0 and $countOrig300 = 1">
        <!-- 
          There is either no 007 or one 007, no 856s, and one 300. Basically let's pass this through. 
          In this scenario, even if the 300 indicates additional materials, the assumption is that they 
          are all bundled together.
        -->
        <marc:record>
          <marc:leader xml:space="preserve"><xsl:value-of select="marc:leader" /></marc:leader>
          <xsl:apply-templates select="marc:controlfield" />
          <xsl:apply-templates select="marc:datafield" />
        </marc:record>
      </xsl:when>
      <!--<xsl:when test="$count007 &lt; 2 and $countViable856s &gt; 0">
        <!-\- 
          There is either no 007 or one 007, and at least one 856. Create one Principal Instance.
          If there is an 007 that is not a 'c', make it part of the Principal Instance.  Otherwise, ignore any 007.
          Create mini MARC records - Secondary Instances - from the 856s.
        -\->
        <marc:record>
          <marc:leader xml:space="preserve"><xsl:value-of select="marc:leader" /></marc:leader>
          <xsl:apply-templates select="marc:controlfield[@tag != '007' and substring(., 1, 1) != 'c']" />
          <xsl:apply-templates select="marc:datafield[@tag != '856']" />
          <xsl:apply-templates select="marc:datafield[@tag = '856' and (@ind2='2' or @ind2='3' or @ind2='4') and marc:subfield[@code='u']]" />
        </marc:record>
        
        <xsl:for-each select="marc:datafield[
                                              @tag='856' and 
                                              (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and 
                                              ( 
                                                contains(marc:subfield[@code='u'], 'loc.gov') or 
                                                contains(marc:subfield[@code='u'], 'fdlp.gov') or 
                                                contains(marc:subfield[@code='u'], 'gpo.gov') or 
                                                contains(marc:subfield[@code='u'], 'congress.gov') or 
                                                contains(marc:subfield[@code='u'], 'hathitrust.org') or 
                                                contains(marc:subfield[@code='u'], 'hdl.handle.net')
                                              ) and not( contains(marc:subfield[@code='3'], 'able of contents') )
                                             ]">
          <xsl:apply-templates select="." mode="split">
            <xsl:with-param name="base_recordid" select="$recordid" />
            <xsl:with-param name="pos" select="position()" />
          </xsl:apply-templates>
        </xsl:for-each>

      </xsl:when>-->
      <xsl:otherwise>
        <!-- 
          There are two or more 007s and an unknown number of 856s.
          Create a Principal Instance and use the first 007 (if any).
          Associate the first 300 with the Principal Instance.
        -->
        <marc:record>
          <marc:leader xml:space="preserve"><xsl:value-of select="marc:leader" /></marc:leader>
          <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="marc:controlfield[@tag = '001']" /></marc:controlfield>
          <!-- <xsl:for-each select="marc:controlfield[@tag != preceding-sibling::marc:controlfield[1]/@tag and substring(.,1,1) != 'c']"> -->
          <xsl:for-each select="marc:controlfield[@tag='003'][1]|
                                marc:controlfield[@tag='005'][1]|
                                marc:controlfield[@tag='006'][1]|
                                marc:controlfield[@tag='007' and substring(.,1,1) != 'c'][1]|
                                marc:controlfield[@tag='008'][1]
          ">
            <xsl:sort select="@tag"/>
            <marc:controlfield>
              <xsl:attribute name="xml:space">preserve</xsl:attribute>
              <xsl:attribute name="tag"><xsl:value-of select="@tag"/></xsl:attribute>
              <xsl:value-of select="." />
            </marc:controlfield>            
          </xsl:for-each>
          <xsl:for-each select="marc:datafield[@tag &lt; 300]">
            <xsl:sort select="@tag"/>
            <xsl:apply-templates select="." />
          </xsl:for-each>
          <xsl:copy-of select="$groupsNS/marc:groups/marc:group[1]/marc:datafield" />
          <xsl:for-each select="marc:datafield[@tag='336' or @tag='337' or @tag='338' or @tag='344' or @tag='346' or @tag='347' or @tag='348']">
            <xsl:variable name="dfId" select="generate-id(.)" />
            <xsl:if test="not($groupsNS/marc:groups/marc:group/marc:datafield[@id = $dfId])">
              <xsl:apply-templates select="." />
            </xsl:if>
          </xsl:for-each>
          <xsl:if test="not(marc:controlfield[@tag='007' and substring(.,1,1) != 'c'][1]) and not(marc:datafield[@tag='337'])">
            <xsl:apply-templates select="$groupsNS/marc:groups/marc:group[1]/marc:datafield[@tag='300']" mode="add337" />
          </xsl:if>
          <xsl:for-each select="marc:datafield[
                                    @tag &gt; 300 and 
                                    @tag != '856' and @tag != '859' and 
                                    @tag != '336' and @tag != '337' and @tag != '338' and
                                    @tag != '344' and @tag != '346' and @tag != '347' and @tag != '348']">
            <xsl:sort select="@tag"/>
            <xsl:apply-templates select="." />            
          </xsl:for-each>
          <xsl:apply-templates select="marc:datafield[@tag = '856' and (@ind2='2' or @ind2='3' or @ind2='4') and marc:subfield[@code='u']]" />
        </marc:record>
        
        <!-- 
          Create Secondary Instances from any 007s, other than the initial one, that do not begin with 'c'.
          The split code will associate any positional 300 with each 007.  Second 300 goes with second 007,
          third 300 goes with third 007, etc.
        -->
        <xsl:for-each select="marc:controlfield[@tag='007' and substring(.,1,1) != 'c']">
          <xsl:if test="position() &gt; 1">
            <xsl:apply-templates select="." mode="split">
              <xsl:with-param name="base_recordid" select="$recordid" />
              <xsl:with-param name="pos" select="position()" />
              <xsl:with-param name="groupsNS" select="$groupsNS" />
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
        
        <!-- 
          If there are any 856s that fit the criteria (electronic resource, electronic version, LC URL, etc.)
          generate Secondary Instances from them.
          This will take any existing 007 in the source MARC that begins with a 'c' and use it for the Secondary Instance
          or it will create a canned one.
        -->
        <xsl:if test="count($viable856sNS/marc:datafield|$viable859sNS/marc:datafield) &gt; 0">
          <xsl:variable name="record" select="." />
          <xsl:for-each select="$viable856sNS/marc:datafield|$viable859sNS/marc:datafield">
            <xsl:apply-templates select="." mode="split">
              <xsl:with-param name="base_recordid" select="$recordid" />
              <xsl:with-param name="pos" select="position()" />
              <xsl:with-param name="record" select="$record" />
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="$count300 &gt; 1 and $count300 &gt; $count007minusC">
          <!--  
            This 'if' statement establishes that we have more 300s than we do 007s.
            The 'extra' 300s will not be outputted via the logic above and we need to make sure we output them.
          -->
          <xsl:variable name="record" select="." />
          <xsl:for-each select="$groupsNS/marc:groups/marc:group/marc:datafield[@tag='300']">
            <xsl:choose>
              <xsl:when test="$count007minusC &gt; 0 and position() &gt; $count007minusC">
                <!-- There are Cs and extra 300s. -->
                <xsl:apply-templates select="." mode="split">
                  <xsl:with-param name="base_recordid" select="$recordid" />
                  <xsl:with-param name="pos" select="position()" />
                  <xsl:with-param name="record" select="$record" />
                </xsl:apply-templates>  
              </xsl:when>
              <xsl:when test="$count007minusC = 0 and position() &gt; 1">
                <!-- 
                  We have multiple 300s but no Cs, basically.  
                  But the first 300 has been output already, by default.
                -->
                <xsl:apply-templates select="." mode="split">
                  <xsl:with-param name="base_recordid" select="$recordid" />
                  <xsl:with-param name="pos" select="position()" />
                  <xsl:with-param name="record" select="$record" />
                </xsl:apply-templates>  
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>

        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:controlfield[@tag = '007']" mode="split">
    <xsl:param name="base_recordid" />
    <xsl:param name="pos" />
    <xsl:param name="groupsNS" />
    <xsl:variable name="cf007-01" select="substring(.,1,1)"/>
    <marc:record>
      <marc:leader xml:space="preserve"><xsl:value-of select="../marc:leader" /></marc:leader>
      <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="concat(../marc:controlfield[@tag = '001'], '-0', $pos)" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="005"><xsl:value-of select="../marc:controlfield[@tag = '005']" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="007"><xsl:value-of select="." /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="008"><xsl:value-of select="../marc:controlfield[@tag = '008']" /></marc:controlfield>
      <xsl:apply-templates select="../marc:datafield[@tag = '040']" />
      <marc:datafield tag="245" ind1="0" ind2="0">
        <marc:subfield code="a">
          <xsl:call-template name="getTitleStr">
            <xsl:with-param name="df300" select="$groupsNS/marc:groups/marc:group[$pos]/marc:datafield[@tag = '300']" />
            <xsl:with-param name="cf007" select="." />
          </xsl:call-template>
        </marc:subfield>
      </marc:datafield>
      <xsl:if test="$groupsNS/marc:groups/marc:group[$pos]/marc:datafield[@tag = '300']">
        <xsl:copy-of select="$groupsNS/marc:groups/marc:group[$pos]/marc:datafield" />
      </xsl:if>    
      <marc:datafield tag="758" ind1=" " ind2=" ">
        <marc:subfield code="4">http://id.loc.gov/ontologies/bibframe/instanceOf</marc:subfield>
        <marc:subfield code="1"><xsl:value-of select="concat($base_recordid, '#Work')" /></marc:subfield>
      </marc:datafield>
    </marc:record>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag = '300']" mode="split">
    <xsl:param name="base_recordid" />
    <xsl:param name="pos" />
    <xsl:param name="record" />
    <xsl:variable name="pos_offset" select="count($record/marc:controlfield[@tag='007' and substring(.,1,1) != 'c']) + count($record/marc:datafield[@tag='856']) + $pos"/>
    <marc:record>
      <marc:leader xml:space="preserve"><xsl:value-of select="$record/marc:leader" /></marc:leader>
      <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="concat($record/marc:controlfield[@tag = '001'], '-0', $pos_offset)" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="005"><xsl:value-of select="$record/marc:controlfield[@tag = '005']" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="008"><xsl:value-of select="$record/marc:controlfield[@tag = '008']" /></marc:controlfield>
      <xsl:apply-templates select="$record/marc:datafield[@tag = '040']" />
      <marc:datafield tag="245" ind1="0" ind2="0">
        <marc:subfield code="a">
          <xsl:call-template name="getTitleStr">
            <xsl:with-param name="df300" select="." />
            <xsl:with-param name="cf007" select="''" />
          </xsl:call-template>
        </marc:subfield>
      </marc:datafield>
      <xsl:copy-of select="../marc:datafield" />
      <xsl:if test="not(../marc:datafield[@tag='337'])">
        <xsl:apply-templates select="." mode="add337" />
      </xsl:if>
      <marc:datafield tag="758" ind1=" " ind2=" ">
        <marc:subfield code="4">http://id.loc.gov/ontologies/bibframe/instanceOf</marc:subfield>
        <marc:subfield code="1"><xsl:value-of select="concat($base_recordid, '#Work')" /></marc:subfield>
      </marc:datafield>
    </marc:record>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag = '856' or @tag = '859']" mode="split">
    <xsl:param name="base_recordid" />
    <xsl:param name="pos" />
    <xsl:param name="record" />
    <xsl:variable name="pos_offset" select="concat('85X-', $pos)"/>
    <xsl:variable name="cf007">
      <xsl:choose>
        <xsl:when test="$record/marc:controlfield[@tag='007' and substring(.,1,1) = 'c']">
          <marc:controlfield xml:space="preserve" tag="007"><xsl:value-of select="$record/marc:controlfield[@tag='007' and substring(.,1,1) = 'c'][1]" /></marc:controlfield>
        </xsl:when>
        <xsl:otherwise>
          <marc:controlfield xml:space="preserve" tag="007">cr |||||||||||</marc:controlfield>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <marc:record>
      <marc:leader xml:space="preserve"><xsl:value-of select="$record/marc:leader" /></marc:leader>
      <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="concat($record/marc:controlfield[@tag = '001'], '-', $pos_offset)" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="005"><xsl:value-of select="$record/marc:controlfield[@tag = '005']" /></marc:controlfield>
      <xsl:copy-of select="$cf007" />
      <marc:controlfield xml:space="preserve" tag="008"><xsl:value-of select="$record/marc:controlfield[@tag = '008']" /></marc:controlfield>
      <xsl:apply-templates select="$record/marc:datafield[@tag = '040']" />
      <marc:datafield tag="245" ind1="0" ind2="0">
        <marc:subfield code="a">
          <xsl:call-template name="getTitleStr">
            <xsl:with-param name="df856sf3"><xsl:value-of select="marc:subfield[@code = '3']" /></xsl:with-param>
            <xsl:with-param name="df300"><marc:datafield /></xsl:with-param>
            <xsl:with-param name="cf007" select="'c'" />
          </xsl:call-template>
        </marc:subfield>
      </marc:datafield>
      <xsl:apply-templates select="." />
      <marc:datafield tag="758" ind1=" " ind2=" ">
        <marc:subfield code="4">http://id.loc.gov/ontologies/bibframe/instanceOf</marc:subfield>
        <marc:subfield code="1"><xsl:value-of select="concat($base_recordid, '#Work')" /></marc:subfield>
      </marc:datafield>
    </marc:record>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='300']" mode="add337">
    <marc:datafield tag="337">
      <xsl:choose>
        <xsl:when test="contains(marc:subfield[@code='3'], 'audio') or 
                        contains(marc:subfield[@code='3'], 'sound') or 
                        (marc:subfield[@code='3']='all' and contains(marc:subfield[@code='a'], 'audio')) or
                        (marc:subfield[@code='3']='all' and contains(marc:subfield[@code='a'], 'sound'))
          ">
          <marc:subfield code='a'>audio</marc:subfield>
          <marc:subfield code='b'>s</marc:subfield>
        </xsl:when>
        <xsl:when test="contains(marc:subfield[@code='3'], 'moving') or 
                        (marc:subfield[@code='3']='all' and (
                          contains(marc:subfield[@code='a'], 'moving') or 
                          contains(marc:subfield[@code='a'], 'film') or 
                          contains(marc:subfield[@code='a'], 'DVD') or 
                          contains(marc:subfield[@code='a'], 'Blu')
                        ))
         ">
          <marc:subfield code='a'>projected</marc:subfield>
          <marc:subfield code='b'>g</marc:subfield>
        </xsl:when>
        <xsl:when test="contains(marc:subfield[@code='3'], 'video') or 
                        (marc:subfield[@code='3']='all' and contains(marc:subfield[@code='a'], 'video'))">
          <marc:subfield code='a'>video</marc:subfield>
          <marc:subfield code='b'>v</marc:subfield>
        </xsl:when>
        <xsl:otherwise>
          <marc:subfield code='a'>unmediated</marc:subfield>
          <marc:subfield code='b'>n</marc:subfield>
        </xsl:otherwise>
      </xsl:choose>
    </marc:datafield>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='300']" mode="groupify">
    <xsl:param name="pcountOrig300" />
    <marc:datafield>
      <xsl:attribute name="tag"><xsl:value-of select="@tag"/></xsl:attribute>
      <xsl:attribute name="ind1"><xsl:value-of select="@ind1"/></xsl:attribute>
      <xsl:attribute name="ind2"><xsl:value-of select="@ind2"/></xsl:attribute>
      <xsl:choose>
        <xsl:when test="marc:subfield[@code='3']">
          <xsl:for-each select="marc:subfield[@code='3']">
            <marc:subfield>
              <xsl:attribute name="code">3</xsl:attribute>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="addSF3">
            <xsl:with-param name="theA" select="marc:subfield[@code='a'][1]" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$pcountOrig300=1">
          <xsl:apply-templates select="marc:subfield[@code != '3' and @code != 'e']" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="marc:subfield[@code != '3']" />
        </xsl:otherwise>
      </xsl:choose>
    </marc:datafield>  
    <xsl:if test="$pcountOrig300=1 and marc:subfield[@code = 'e']">
      <xsl:call-template name="parseE">
        <xsl:with-param name="theE" select="marc:subfield[@code ='e']" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="getTitleStr">
    <xsl:param name="df856sf3" />
    <xsl:param name="df300" />
    <xsl:param name="cf007" />
    <xsl:choose>
      <xsl:when test="$df856sf3 != ''">
        <xsl:value-of select="$df856sf3"/>
      </xsl:when>
      <xsl:when test="$df300/marc:subfield[@code='3'] and $df300/marc:subfield[@code='3'] != 'all'">
        <xsl:value-of select="concat('[', $df300/marc:subfield[@code='3'][1], ']')"/>
      </xsl:when>
      <xsl:when test="$df300/marc:subfield[@code='3'] = 'all'">
        <xsl:value-of select="concat('[', $df300/marc:subfield[@code='a'][1], ']')"/>
      </xsl:when>
      <xsl:when test="$cf007 != ''">
        <xsl:variable name="cf007pos1" select="substring($cf007, 1, 1)"/>
        <xsl:variable name="cf007pos1and2" select="substring($cf007, 1, 2)"/>
        <xsl:choose>
          <xsl:when test="$cf007pos1and2 = 'ad'">[Atlas]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'ag'">[Graph]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'aj'">[Map]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'ak'">[Cartographic material]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'aq'">[Model (Representation)]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'ar'">[Remote-sensing image]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'as'">[Geological cross-section]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'ay'">[View]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'da'">[Celestial globe]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kc'">[Collage]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kd'">[Drawing]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'ke'">[Painting]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kf'">[Photomechanical print]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kg'">[Negative (Photograph)]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kh'">[Photographic print]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'ki'">[Picture]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kj'">[Print]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kk'">[Poster]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kl'">[Scientific illustration]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kn'">[Wall chart]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kp'">[Postcard]</xsl:when>
          <xsl:when test="$cf007pos1and2 = 'kv'">[Photograph]</xsl:when>
          <xsl:when test="$cf007pos1 = 'a'">[Map]</xsl:when>
          <xsl:when test="$cf007pos1 = 'c'">[Electronic resource]</xsl:when>
          <xsl:when test="$cf007pos1 = 'd'">[Globe]</xsl:when>
          <xsl:when test="$cf007pos1 = 'f'">[Tactile resource]</xsl:when>
          <xsl:when test="$cf007pos1 = 'g'">[Project graphic]</xsl:when>
          <xsl:when test="$cf007pos1 = 'h'">[Microform]</xsl:when>
          <xsl:when test="$cf007pos1 = 'k'">[Non-projected graphic]</xsl:when>
          <xsl:when test="$cf007pos1 = 'm'">[Motion picture]</xsl:when>
          <xsl:when test="$cf007pos1 = 'o'">[Kit]</xsl:when>
          <xsl:when test="$cf007pos1 = 'q'">[Notated music]</xsl:when>
          <xsl:when test="$cf007pos1 = 'r'">[Remote sensing image]</xsl:when>
          <xsl:when test="$cf007pos1 = 's'">[Sound recording]</xsl:when>
          <xsl:when test="$cf007pos1 = 't'">[Text]</xsl:when>
          <xsl:when test="$cf007pos1 = 'v'">[Videorecording]</xsl:when>
          <xsl:otherwise>[Unknown]</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>[Unknown]</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="addSF3">
    <xsl:param name="theA" />
    <xsl:choose>
      <xsl:when test="contains($theA, 'audio disc')">
        <marc:subfield code='3'>audio disc</marc:subfield>
        <marc:subfield code='3'>CD</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'sound disc')">
        <marc:subfield code='3'>audio disc</marc:subfield>
        <marc:subfield code='3'>CD</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'audiocassette')">
        <marc:subfield code='3'>audiocassette</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'audio file')">
        <marc:subfield code='3'>audio file</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'video file')">
        <marc:subfield code='3'>video file</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'videodisc')">
        <marc:subfield code='3'>videodisc</marc:subfield>
        <marc:subfield code='3'>DVD</marc:subfield>
        <marc:subfield code='3'>BluRay</marc:subfield>
        <marc:subfield code='3'>Blu-ray disc</marc:subfield>
        <marc:subfield code='3'>moving image</marc:subfield>
        <marc:subfield code='3'>video</marc:subfield>
        <marc:subfield code='3'>two-dimensional moving image</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'DVD video')">
        <marc:subfield code='3'>videodisc</marc:subfield>
        <marc:subfield code='3'>DVD</marc:subfield>
        <marc:subfield code='3'>moving image</marc:subfield>
        <marc:subfield code='3'>two-dimensional moving image</marc:subfield>
        <marc:subfield code='3'>video</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'book')">
        <marc:subfield code='3'>book</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'score')">
        <marc:subfield code='3'>score</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'folio')">
        <marc:subfield code='3'>folio</marc:subfield>
      </xsl:when>
      <xsl:when test="contains($theA, 'lesson guide')">
        <marc:subfield code='3'>lesson guide</marc:subfield>
      </xsl:when>
      <xsl:otherwise>
        <marc:subfield code='3'>all</marc:subfield>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="parseE">
    <xsl:param name="theE"/>
    <xsl:choose>
      <xsl:when test="contains($theE, '+')">
        <xsl:call-template name="create300">
          <xsl:with-param name="theE" select="$theE" />
        </xsl:call-template>
        <!-- recursive call -->
        <xsl:call-template name="parseE">
          <xsl:with-param name="theE" select="substring-after($theE, '+')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create300">
          <xsl:with-param name="theE" select="$theE" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="create300">
    <xsl:param name="theE" />
    <xsl:variable name="eSlice">
      <xsl:choose>
        <xsl:when test="contains($theE, '+')">
          <xsl:value-of select="substring-before($theE, '+')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$theE"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="aTxt">
      <xsl:choose>
        <xsl:when test="contains($eSlice, ':')">
          <xsl:value-of select="concat(substring-before($eSlice, ':'), ')')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$eSlice"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="bTxt">
      <xsl:choose>
        <xsl:when test="contains($eSlice, ':')">
          <xsl:value-of select="substring-before(substring-after($eSlice, ':'), ';')"/>
        </xsl:when>
        <xsl:when test="contains($eSlice, '(')">
          <xsl:value-of select="substring-before(substring-after($eSlice, '('), ';')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="cTxt" select="substring-after($eSlice, ';')"/>
    <xsl:variable name="sf3">
      <xsl:call-template name="addSF3">
        <xsl:with-param name="theA" select="$aTxt" />
      </xsl:call-template>
    </xsl:variable>
    <marc:datafield tag="300" ind1=" " ind2=" ">
      <xsl:copy-of select="$sf3" />
      <xsl:if test="$aTxt != ''">
        <marc:subfield code='a'><xsl:value-of select="$aTxt"/></marc:subfield>
      </xsl:if>
      <xsl:if test="$bTxt != ''">
        <marc:subfield code='b'><xsl:value-of select="$bTxt"/></marc:subfield>
      </xsl:if>
      <xsl:if test="$cTxt != ''">
        <marc:subfield code='c'><xsl:value-of select="$cTxt"/></marc:subfield>
      </xsl:if>
    </marc:datafield>
  </xsl:template>

  <xsl:template match="marc:controlfield">
    <marc:controlfield>
      <xsl:attribute name="tag"><xsl:value-of select="@tag"/></xsl:attribute>
      <xsl:attribute name="xml:space">preserve</xsl:attribute>
      <xsl:value-of select="."/>
    </marc:controlfield>  
  </xsl:template>

  <xsl:template match="marc:datafield">
    <xsl:param name="genId">0</xsl:param>
    <marc:datafield>
      <xsl:attribute name="tag"><xsl:value-of select="@tag"/></xsl:attribute>
      <xsl:attribute name="ind1"><xsl:value-of select="@ind1"/></xsl:attribute>
      <xsl:attribute name="ind2"><xsl:value-of select="@ind2"/></xsl:attribute>
      <xsl:if test="$genId='1'">
        <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="marc:subfield" />
    </marc:datafield>  
  </xsl:template>
  
  <xsl:template match="marc:subfield">
    <marc:subfield>
      <xsl:attribute name="code"><xsl:value-of select="@code"/></xsl:attribute>
      <xsl:value-of select="."/>
    </marc:subfield>
  </xsl:template>
</xsl:stylesheet>
