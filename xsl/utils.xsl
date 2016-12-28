<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Utility templates -->

  <!--
      Chop [ ] from beginning and end of a string
      From MARC21slim2MODS.xsl
  -->
  <xsl:template name="chopBrackets">
    <xsl:param name="chopString"/>
    <xsl:variable name="string">
      <xsl:call-template name="chopPunctuation">
	<xsl:with-param name="chopString" select="$chopString"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="substring($string, 1,1)='['">
      <xsl:value-of select="substring($string,2, string-length($string)-2)"/>
    </xsl:if>
    <xsl:if test="substring($string, 1,1)!='['">
      <xsl:value-of select="$string"/>
    </xsl:if>
  </xsl:template>

  <!--
      Chop ( ) from beginning and end of a string
  -->
  <xsl:template name="chopParens">
    <xsl:param name="chopString"/>
    <xsl:param name="punctuation">
      <xsl:text>.:,;/ </xsl:text>
    </xsl:param>
    <xsl:variable name="string">
      <xsl:call-template name="chopPunctuation">
	<xsl:with-param name="chopString" select="$chopString"/>
        <xsl:with-param name="punctuation" select="$punctuation"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="substring($string,1,1)='('">
        <xsl:call-template name="chopParens">
          <xsl:with-param name="chopString" select="substring-after($string,'(')"/>
          <xsl:with-param name="punctuation" select="$punctuation"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($string,string-length($string),1) = ')'">
        <xsl:call-template name="chopParens">
          <xsl:with-param name="chopString" select="substring($string,1,string-length($string)-1)"/>
          <xsl:with-param name="punctuation" select="$punctuation"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Chop trailing punctuation
      .:,;/ and space
      From MARC21slimUtils.xsl
  -->
  <xsl:template name="chopPunctuation">
    <xsl:param name="chopString"/>
    <xsl:param name="punctuation">
      <xsl:text>.:,;/ </xsl:text>
    </xsl:param>
    <xsl:variable name="length" select="string-length($chopString)"/>
    <xsl:choose>
      <xsl:when test="$length=0"/>
      <xsl:when test="contains($punctuation, substring($chopString,$length,1))">
	<xsl:call-template name="chopPunctuation">
	  <xsl:with-param name="chopString" select="substring($chopString,1,$length - 1)"/>
	  <xsl:with-param name="punctuation" select="$punctuation"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not($chopString)"/>
      <xsl:otherwise>
	<xsl:value-of select="$chopString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      generate a recordid base from user config
  -->
  <xsl:template match="marc:record" mode="recordid">
    <xsl:param name="baseuri" select="'http://example.org/'"/>
    <xsl:param name="idfield" select="'001'"/>
    <xsl:param name="recordno"/>
    <xsl:variable name="tag" select="substring($idfield,1,3)"/>
    <xsl:variable name="subfield">
      <xsl:choose>
        <xsl:when test="substring($idfield,4,1)">
          <xsl:value-of select="substring($idfield,4,1)"/>
        </xsl:when>
        <xsl:otherwise>a</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="recordid">
      <xsl:choose>
        <xsl:when test="$tag &lt; 10">
          <xsl:if test="count(marc:controlfield[@tag=$tag]) = 1">
            <xsl:value-of select="marc:controlfield[@tag=$tag]"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="count(marc:datafield[@tag=$tag]/marc:subfield[@code=$subfield]) = 1">
            <xsl:value-of select="normalize-space(marc:datafield[@tag=$tag]/marc:subfield[@code=$subfield])"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$recordid != ''">
        <xsl:value-of select="$baseuri"/><xsl:value-of select="$recordid"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="no">
          <xsl:text>WARNING: Unable to determine record ID for record </xsl:text><xsl:value-of select="$recordno"/><xsl:text>. Using generated ID.</xsl:text>
        </xsl:message>
        <xsl:value-of select="$baseuri"/><xsl:value-of select="generate-id(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      create a space delimited label
      need to trim off the trailing space to use
  -->
  <xsl:template match="*" mode="concat-nodes-space">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>

  <!--
      generate a marcKey for the subfields of a marc:datafield
      of the form $[code][text]$[code][text] etc.
  -->
  <xsl:template match="marc:subfield" mode="marcKey">
    <xsl:text>$</xsl:text><xsl:value-of select="@code"/><xsl:value-of select="."/>
  </xsl:template>

  <!--
      convert "u" or "U" to "X" for dates
  -->
  <xsl:template name="u2x">
    <xsl:param name="dateString"/>
    <xsl:choose>
      <xsl:when test="contains($dateString,'u')">
        <xsl:call-template name="u2x">
          <xsl:with-param name="dateString" select="concat(substring-before($dateString,'u'),'X',substring-after($dateString,'u'))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($dateString,'U')">
        <xsl:call-template name="u2x">
          <xsl:with-param name="dateString" select="concat(substring-before($dateString,'U'),'X',substring-after($dateString,'U'))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$dateString"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      convert a date string as from the 033 to an EDTF date
      (https://www.loc.gov/standards/datetime/pre-submission.html)
      with one difference - use 'X' for unspecified digits
  -->
  <xsl:template name="edtfFormat">
    <xsl:param name="pDateString"/>
    <!-- convert '-' to 'X' -->
    <xsl:choose>
      <xsl:when test="contains(substring($pDateString,1,12),'-')">
        <xsl:call-template name="edtfFormat">
          <xsl:with-param name="pDateString" select="concat(substring-before($pDateString,'-'),'X',substring-after($pDateString,'-'))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>      
        <xsl:variable name="vDatePart" select="concat(substring($pDateString,1,4),'-',substring($pDateString,5,2),'-',substring($pDateString,7,2))"/>
        <xsl:variable name="vTimePart">
          <xsl:if test="substring($pDateString,9,4) != ''">
            <xsl:value-of select="concat('T',substring($pDateString,9,2),':',substring($pDateString,11,2),':00')"/>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="vTimeDiff">
          <xsl:if test="substring($pDateString,13,5) != ''">
            <xsl:value-of select="concat(substring($pDateString,13,3),':',substring($pDateString,16,2))"/>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="concat($vDatePart,$vTimePart,$vTimeDiff)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
