<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
  xmlns:marc="http://www.loc.gov/MARC21/slim"
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
    <xsl:variable name="count300" select="count(marc:controlfield[@tag='300'])"/>
    <xsl:variable name="countViable856s" select="count(marc:datafield[
                                                          @tag='856' and 
                                                          (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and 
                                                          ( 
                                                            contains(marc:subfield[@code='u'], '.loc.gov') or 
                                                            contains(marc:subfield[@code='u'], '.fdlp.gov') or 
                                                            contains(marc:subfield[@code='u'], '.gpo.gov') or 
                                                            contains(marc:subfield[@code='u'], '.congress.gov') or 
                                                            contains(marc:subfield[@code='u'], '.hathitrust.org')
                                                          )
                                                 ])" />

    <!-- Going to want to check if this record is already a 'split' record and, if so, just return it. -->
    <!-- But until then.... -->
    
    <xsl:choose>
      <xsl:when test="$count007 &lt; 2 and $countViable856s = 0">
        <marc:record>
          <marc:leader xml:space="preserve"><xsl:value-of select="marc:leader" /></marc:leader>
          <xsl:apply-templates select="marc:controlfield" />
          <xsl:apply-templates select="marc:datafield" />
        </marc:record>
      </xsl:when>
      <xsl:when test="$count007 &lt; 2 and $countViable856s &gt; 0">
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
                                                contains(marc:subfield[@code='u'], '.loc.gov') or 
                                                contains(marc:subfield[@code='u'], '.fdlp.gov') or 
                                                contains(marc:subfield[@code='u'], '.gpo.gov') or 
                                                contains(marc:subfield[@code='u'], '.congress.gov') or 
                                                contains(marc:subfield[@code='u'], '.hathitrust.org')
                                               )
                                             ]">
          <xsl:apply-templates select="." mode="split">
            <xsl:with-param name="base_recordid" select="$recordid" />
            <xsl:with-param name="pos" select="position()" />
          </xsl:apply-templates>
        </xsl:for-each>

      </xsl:when>
      <xsl:otherwise>
        <marc:record>
          <marc:leader xml:space="preserve"><xsl:value-of select="marc:leader" /></marc:leader>
          <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="marc:controlfield[@tag = '001']" /></marc:controlfield>
          <xsl:for-each select="marc:controlfield[@tag != preceding-sibling::marc:controlfield[1]/@tag]">
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
          <xsl:apply-templates select="marc:datafield[@tag = '300'][1]" />
          <xsl:for-each select="marc:datafield[@tag &gt; 300 and @tag != '856']">
            <xsl:sort select="@tag"/>
            <xsl:apply-templates select="." />            
          </xsl:for-each>
        </marc:record>
        
        <xsl:for-each select="marc:controlfield[@tag='007' and substring(.,1,1) != 'c']">
          <xsl:if test="position() &gt; 1">
            <xsl:apply-templates select="." mode="split">
              <xsl:with-param name="base_recordid" select="$recordid" />
              <xsl:with-param name="pos" select="position()" />
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='856' and (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and marc:subfield/@code='u']">
          <xsl:apply-templates select="." mode="split">
            <xsl:with-param name="base_recordid" select="$recordid" />
            <xsl:with-param name="pos" select="position()" />
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:controlfield[@tag = '007']" mode="split">
    <xsl:param name="base_recordid" />
    <xsl:param name="pos" />
    <xsl:variable name="cf007-01" select="substring(.,1,1)"/>
    <marc:record>
      <marc:leader xml:space="preserve"><xsl:value-of select="../marc:leader" /></marc:leader>
      <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="concat(../marc:controlfield[@tag = '001'], '-0', $pos)" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="005"><xsl:value-of select="../marc:controlfield[@tag = '005']" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="007"><xsl:value-of select="." /></marc:controlfield>
      <xsl:apply-templates select="../marc:datafield[@tag = '040']" />
      <xsl:if test="../marc:datafield[@tag = '300'][$pos]">
        <xsl:apply-templates select="../marc:datafield[@tag = '300'][$pos]" />
      </xsl:if>    
      <marc:datafield tag="758" ind1=" " ind2=" ">
        <marc:subfield code="4">http://id.loc.gov/ontologies/bibframe/instanceOf</marc:subfield>
        <marc:subfield code="1"><xsl:value-of select="concat($base_recordid, '#Work')" /></marc:subfield>
      </marc:datafield>
    </marc:record>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag = '856']" mode="split">
    <xsl:param name="base_recordid" />
    <xsl:param name="pos" />
    <xsl:variable name="pos_offset" select="count(../marc:controlfield[@tag='007' and substring(.,1,1) != 'c']) + $pos"/>
    <xsl:variable name="cf007">
      <xsl:choose>
        <xsl:when test="../marc:controlfield[@tag='007' and substring(.,1,1) = 'c']">
          <marc:controlfield xml:space="preserve" tag="007"><xsl:value-of select="../marc:controlfield[@tag='007' and substring(.,1,1) = 'c'][1]" /></marc:controlfield>
        </xsl:when>
        <xsl:otherwise>
          <marc:controlfield xml:space="preserve" tag="007">cr |||||||||||</marc:controlfield>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <marc:record>
      <marc:leader xml:space="preserve"><xsl:value-of select="../marc:leader" /></marc:leader>
      <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="concat(../marc:controlfield[@tag = '001'], '-0', $pos_offset)" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="005"><xsl:value-of select="../marc:controlfield[@tag = '005']" /></marc:controlfield>
      <xsl:copy-of select="$cf007" />
      <xsl:apply-templates select="../marc:datafield[@tag = '040']" />
      <xsl:apply-templates select="." />
      <marc:datafield tag="758" ind1=" " ind2=" ">
        <marc:subfield code="4">http://id.loc.gov/ontologies/bibframe/instanceOf</marc:subfield>
        <marc:subfield code="1"><xsl:value-of select="concat($base_recordid, '#Work')" /></marc:subfield>
      </marc:datafield>
    </marc:record>
  </xsl:template>

  <xsl:template match="marc:controlfield">
    <marc:controlfield>
      <xsl:attribute name="tag"><xsl:value-of select="@tag"/></xsl:attribute>
      <xsl:attribute name="xml:space">preserve</xsl:attribute>
      <xsl:value-of select="."/>
    </marc:controlfield>  
  </xsl:template>

  <xsl:template match="marc:datafield">
    <marc:datafield>
      <xsl:attribute name="tag"><xsl:value-of select="@tag"/></xsl:attribute>
      <xsl:attribute name="ind1"><xsl:value-of select="@ind1"/></xsl:attribute>
      <xsl:attribute name="ind2"><xsl:value-of select="@ind2"/></xsl:attribute>
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
