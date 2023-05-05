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

    <!-- Going to want to check if this record is already a 'split' record and, if so, just return it. -->
    <!-- But until then.... -->
    
    <xsl:choose>
      <xsl:when test="$count007 = 1">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="marc:controlfield[@tag='007']">
          <xsl:if test="position() &gt; 1">
            <xsl:apply-templates select=".">
              <xsl:with-param name="base_recordid" select="$recordid" />
              <xsl:with-param name="pos" select="position()" />
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:controlfield[@tag = '007']">
    <xsl:param name="base_recordid" />
    <xsl:param name="pos" />
    <xsl:variable name="cf007-01" select="substring(.,1,1)"/>
    <marc:record>
      <marc:leader xml:space="preserve"><xsl:value-of select="../marc:leader" /></marc:leader>
      <marc:datafield tag="758" ind1=" " ind2=" ">
        <marc:subfield code="4">http://id.loc.gov/ontologies/bibframe/instanceOf</marc:subfield>
        <marc:subfield code="1"><xsl:value-of select="concat($base_recordid, '#Work')" /></marc:subfield>
      </marc:datafield>
      <marc:controlfield xml:space="preserve" tag="001"><xsl:value-of select="concat(../marc:controlfield[@tag = '001'], '-0', $pos)" /></marc:controlfield>
      <marc:controlfield xml:space="preserve" tag="007"><xsl:value-of select="." /></marc:controlfield>
      <xsl:if test="../marc:datafield[@tag = '300'][$pos]">
        <marc:datafield tag="300" ind1="../marc:datafield[@tag = '300'][$pos]/@ind1" ind2="../marc:datafield[@tag = '300'][$pos]/@ind2">
          <xsl:for-each select="../marc:datafield[@tag = '300'][$pos]/marc:subfield">
            <marc:subfield>
              <xsl:attribute name="code"><xsl:value-of select="@code"/></xsl:attribute>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
        </marc:datafield>
      </xsl:if>
      <xsl:if test="$cf007-01 = 'c' and ../marc:datafield[@tag = '856'][$pos - 1]">
        <xsl:variable name="df856" select="../marc:datafield[@tag = '856'][$pos - 1]" />
        <!-- Electronic -->
        <marc:datafield tag="856" ind1="../marc:datafield[@tag = '856'][$pos]/@ind1" ind2="../marc:datafield[@tag = '856'][$pos]/@ind2">
          <xsl:attribute name="ind1"><xsl:value-of select="$df856/@ind1"/></xsl:attribute>
          <xsl:attribute name="ind2"><xsl:value-of select="$df856/@ind2"/></xsl:attribute>
          <xsl:for-each select="$df856/marc:subfield">
            <marc:subfield>
              <xsl:attribute name="code"><xsl:value-of select="@code"/></xsl:attribute>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
        </marc:datafield>
      </xsl:if>
    </marc:record>
  </xsl:template>
</xsl:stylesheet>
