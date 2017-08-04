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

  <!-- Utility templates -->

  <!--
      Determine the xml:lang code from $6
  -->

  <xsl:template match="marc:datafield" mode="xmllang">
    <xsl:if test="marc:subfield[@code='6'] and ../marc:controlfield[@tag='008']">
      <xsl:variable name="vLang008"><xsl:value-of select="substring(../marc:controlfield[@tag='008'],36,3)"/></xsl:variable>
      <xsl:variable name="vScript6"><xsl:value-of select="substring-after(marc:subfield[@code='6'],'/')"/></xsl:variable>
      <xsl:variable name="vScript6simple">
        <xsl:choose>
          <xsl:when test="contains(vScript6,'/')"><xsl:value-of select="substring-before($vScript6,'/')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$vScript6"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vLang"><xsl:value-of select="$languageMap/xml-langs/language/iso6392[text()=$vLang008]/parent::*/@xmllang"/></xsl:variable>
      <xsl:variable name="vScript">
        <xsl:choose>
          <xsl:when test="$vScript6simple='(3'">arab</xsl:when>
          <xsl:when test="$vScript6simple='(B'">latn</xsl:when>
          <xsl:when test="$vScript6simple='$1' and $vLang008='kor'">hang</xsl:when>
          <xsl:when test="$vScript6simple='$1' and $vLang008='chi'">hani</xsl:when>
          <xsl:when test="$vScript6simple='$1' and $vLang008='jpn'">jpan</xsl:when>
          <xsl:when test="$vScript6simple='(N'">cyrl</xsl:when>
          <xsl:when test="$vScript6simple='(S'">grek</xsl:when>
          <xsl:when test="$vScript6simple='(2'">hebr</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$vLang != '' and $vScript != ''"><xsl:value-of select="concat($vLang,'-',$vScript)"/></xsl:if>
    </xsl:if>
  </xsl:template>
        
  <!--
      rudimentary LCC validation
      returns "true" if valid, "" if not valid
  -->
  <xsl:template name="validateLCC">
    <xsl:param name="pCall"/>
    <xsl:variable name="vAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="vNumber">0123456789</xsl:variable>
    <xsl:if test="string-length(translate(substring($pCall,1,1),$vAlpha,''))=0">
      <xsl:choose>
        <xsl:when test="string-length(translate(substring($pCall,2,1),$vAlpha,''))=0">
          <xsl:choose>
            <xsl:when test="string-length(translate(substring($pCall,3,1),$vAlpha,''))=0">
              <xsl:if test="string-length(translate(substring($pCall,4,1),$vNumber,''))=0">true</xsl:if>
            </xsl:when>
            <xsl:when test="string-length(translate(substring($pCall,3,1),$vNumber,''))=0">true</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="string-length(translate(substring($pCall,2,1),$vNumber,''))=0">true</xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!--
      Chop [ ] from beginning and end of a string
  -->
  <xsl:template name="chopBrackets">
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
      <xsl:when test="substring($string,1,1)='['">
        <xsl:call-template name="chopBrackets">
          <xsl:with-param name="chopString" select="substring-after($string,'[')"/>
          <xsl:with-param name="punctuation" select="$punctuation"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($string,string-length($string),1) = ']'">
        <xsl:call-template name="chopBrackets">
          <xsl:with-param name="chopString" select="substring($string,1,string-length($string)-1)"/>
          <xsl:with-param name="punctuation" select="$punctuation"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
    </xsl:choose>
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
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="marc:controlfield[@tag=$tag]"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="count(marc:datafield[@tag=$tag]/marc:subfield[@code=$subfield]) = 1">
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="normalize-space(marc:datafield[@tag=$tag]/marc:subfield[@code=$subfield])"/>
            </xsl:call-template>
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
      convert a date string as from the 033/263 to an EDTF date
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
        <xsl:variable name="vDatePart">
          <xsl:choose>
            <xsl:when test="substring($pDateString,7,2) != ''">
              <xsl:value-of select="concat(substring($pDateString,1,4),'-',substring($pDateString,5,2),'-',substring($pDateString,7,2))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(substring($pDateString,1,4),'-',substring($pDateString,5,2))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
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

  <!--
      generate a property with a blank node Resource, and an rdfs:label
      process $3 and $2, if necessary
      Inspired by processing 340, may be useful elsewhere
  -->

  <xsl:template match="marc:subfield" mode="generateProperty">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pProp"/>
    <xsl:param name="pResource"/>
    <xsl:param name="pProcess"/>
    <xsl:param name="pPunctuation">
      <xsl:text>.:,;/ </xsl:text>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$pProp}">
          <xsl:element name="{$pResource}">
            <rdfs:label>
              <xsl:choose>
                <xsl:when test="$pProcess='chopPunctuation'">
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                    <xsl:with-param name="punctuation" select="$pPunctuation"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$pProcess='chopParens'">
                  <xsl:call-template name="chopParens">
                    <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                    <xsl:with-param name="punctuation" select="$pPunctuation"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$pProcess='chopBrackets'">
                  <xsl:call-template name="chopBrackets">
                    <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                    <xsl:with-param name="punctuation" select="$pPunctuation"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
              </xsl:choose>
            </rdfs:label>
            <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- get the tag ord of a datafield within a marc:record -->
  <xsl:template match="marc:datafield" mode="tagord">
    <xsl:variable name="vId" select="generate-id(.)"/>
    <xsl:for-each select="../marc:leader | ../marc:controlfield | ../marc:datafield">
      <xsl:if test="generate-id(.)=$vId"><xsl:value-of select="position()"/></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--
      URL encode a string, ASCII only
      based on https://skew.org/xml/stylesheets/url-encode/url-encode.xsl
  -->
  <xsl:template name="url-encode">
    <xsl:param name="str"/>   
    <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
    <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>
    <xsl:variable name="hex" >0123456789ABCDEF</xsl:variable>
    <xsl:if test="$str">
      <xsl:variable name="first-char" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$first-char)">
          <xsl:value-of select="$first-char"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="codepoint">
            <xsl:choose>
              <xsl:when test="contains($ascii,$first-char)">
                <xsl:value-of select="string-length(substring-before($ascii,$first-char)) + 32"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="no">Warning: string contains a character that is out of range! Substituting "?".</xsl:message>
                <xsl:text>63</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <xsl:variable name="hex-digit1" select="substring($hex,floor($codepoint div 16) + 1,1)"/>
        <xsl:variable name="hex-digit2" select="substring($hex,$codepoint mod 16 + 1,1)"/>
        <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) &gt; 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
