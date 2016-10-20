<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:naco="https://www.loc.gov/aba/pcc/naco/"
                exclude-result-prefixes="xsl naco">

  <!--
      an implementation of NACO normalization
      (https://www.loc.gov/aba/pcc/naco/normrule-2.html)
      This will not work for precomposed characters -
      could add manual translations
      First comma rule not implemented
      Returns lower-case (upper-case hurts the eyes)
  -->

  <!-- Lookup tables -->

  <!-- deletes -->
  <naco:translate char="'"/>
  <naco:translate char="["/>
  <naco:translate char="]"/>
  <naco:translate char="&#x02BC;"/> <!-- Spacing apostrophe (Alif) -->
  <naco:translate char="&#x02BE;"/> <!-- Spacing right half ring (Alif) -->
  <naco:translate char="&#x02BF;"/> <!-- Spacing left half ring (Ayn) -->
  <naco:translate char="&#x044A;"/> <!-- small letter hard sign -->
  <naco:translate char="&#x042A;"/> <!-- capital letter hard sign -->
  <naco:translate char="&#x044C;"/> <!-- small letter soft sign -->
  <naco:translate char="&#x042C;"/> <!-- capital letter soft sign -->

  <!-- modifying diacritics -->
  <naco:translate char="&#x0301;"/> <!-- combining acute -->
  <naco:translate char="&#x0306;"/> <!-- combining breve -->
  <naco:translate char="&#x0310;"/> <!-- combining candrabindu -->
  <naco:translate char="&#x0327;"/> <!-- combining cedilla -->
  <naco:translate char="&#x030A;"/> <!-- combining ring above -->
  <naco:translate char="&#x0325;"/> <!-- combining ring below -->
  <naco:translate char="&#x0302;"/> <!-- combining circumflex -->
  <naco:translate char="&#x0323;"/> <!-- combining dot below -->
  <naco:translate char="&#x0360;"/> <!-- combining double tilde -->
  <naco:translate char="&#xFE22;"/> <!-- combining double tilde left half -->
  <naco:translate char="&#xFE23;"/> <!-- combining double tilde right half -->
  <naco:translate char="&#x0333;"/> <!-- combining double low line -->
  <naco:translate char="&#x0300;"/> <!-- combining grave -->
  <naco:translate char="&#x030C;"/> <!-- combining caron (hacek) -->
  <naco:translate char="&#x0313;"/> <!-- combining comma above -->
  <naco:translate char="&#x0315;"/> <!-- combining comma above right -->
  <naco:translate char="&#x0326;"/> <!-- combining comma below -->
  <naco:translate char="&#x0361;"/> <!-- combining double inverted breve -->
  <naco:translate char="&#x0304;"/> <!-- combining macron -->
  <naco:translate char="&#x0309;"/> <!-- combining hook above -->
  <naco:translate char="&#x031C;"/> <!-- combining left half ring below -->
  <naco:translate char="&#x0328;"/> <!-- combining ogonek -->
  <naco:translate char="&#x0307;"/> <!-- combining dot above -->
  <naco:translate char="&#x0303;"/> <!-- combining tilde -->
  <naco:translate char="&#x0308;"/> <!-- combining diaeresis (umlaut) -->
  <naco:translate char="&#x0332;"/> <!-- combining low line -->
  <naco:translate char="&#x032E;"/> <!-- combining breve below (upadhmaniya) -->

  <!-- blanks -->
  <naco:translate char="!"> </naco:translate>
  <naco:translate char='"'> </naco:translate>
  <naco:translate char="("> </naco:translate>
  <naco:translate char=")"> </naco:translate>
  <naco:translate char="-"> </naco:translate>
  <naco:translate char="{"> </naco:translate>
  <naco:translate char="}"> </naco:translate>
  <naco:translate char="&lt;"> </naco:translate>
  <naco:translate char="&gt;"> </naco:translate>
  <naco:translate char=";"> </naco:translate>
  <naco:translate char=":"> </naco:translate>
  <naco:translate char="."> </naco:translate>
  <naco:translate char="?"> </naco:translate>
  <naco:translate char="&#x00BF;"> </naco:translate> <!-- inverted question mark -->
  <naco:translate char="&#x00A1;"> </naco:translate> <!-- inverted exclamation mark -->
  <naco:translate char=","> </naco:translate>
  <naco:translate char="/"> </naco:translate>
  <naco:translate char="\"> </naco:translate>
  <naco:translate char="*"> </naco:translate>
  <naco:translate char="|"> </naco:translate>
  <naco:translate char="%"> </naco:translate>
  <naco:translate char="="> </naco:translate>
  <naco:translate char="&#x00B1;"> </naco:translate> <!-- plus or minus -->
  <naco:translate char="&#x2213;"> </naco:translate> <!-- minus or plus -->
  <naco:translate char="&#x207A;"> </naco:translate> <!-- superscript plus -->
  <naco:translate char="&#x207B;"> </naco:translate> <!-- superscript minus -->
  <naco:translate char="&#x00AE;"> </naco:translate> <!-- patent mark -->
  <naco:translate char="&#x00A9;"> </naco:translate> <!-- copyright -->
  <naco:translate char="&#x00B0;"> </naco:translate> <!-- degree sign -->
  <naco:translate char="^"> </naco:translate>
  <naco:translate char="_"> </naco:translate>
  <naco:translate char="`"> </naco:translate>
  <naco:translate char="~"> </naco:translate>
  <naco:translate char="&#x00B7;"> </naco:translate> <!-- middle dot -->
  
  <!-- superscript numbers -->
  <naco:translate char="&#x2070;">0</naco:translate>
  <naco:translate char="&#x00B9;">1</naco:translate>
  <naco:translate char="&#x00B2;">2</naco:translate>
  <naco:translate char="&#x00B3;">3</naco:translate>
  <naco:translate char="&#x2074;">4</naco:translate>
  <naco:translate char="&#x2075;">5</naco:translate>
  <naco:translate char="&#x2076;">6</naco:translate>
  <naco:translate char="&#x2077;">7</naco:translate>
  <naco:translate char="&#x2078;">8</naco:translate>
  <naco:translate char="&#x2079;">9</naco:translate>
  <!-- subscript numbers -->
  <naco:translate char="&#x2080;">0</naco:translate>
  <naco:translate char="&#x2081;">1</naco:translate>
  <naco:translate char="&#x2082;">2</naco:translate>
  <naco:translate char="&#x2083;">3</naco:translate>
  <naco:translate char="&#x2084;">4</naco:translate>
  <naco:translate char="&#x2085;">5</naco:translate>
  <naco:translate char="&#x2086;">6</naco:translate>
  <naco:translate char="&#x2087;">7</naco:translate>
  <naco:translate char="&#x2088;">8</naco:translate>
  <naco:translate char="&#x2089;">9</naco:translate>

  <naco:translate char="&#x00C6;">AE</naco:translate> <!-- capital letter AE -->
  <naco:translate char="&#x00E6;">ae</naco:translate> <!-- small letter ae -->
  <naco:translate char="&#x0152;">OE</naco:translate> <!-- capital ligature oe -->
  <naco:translate char="&#x0153;">oe</naco:translate> <!-- small ligature oe -->
  <naco:translate char="&#x0110;">D</naco:translate> <!-- capital letter D with stroke -->
  <naco:translate char="&#x0111;">d</naco:translate> <!-- small letter D with stroke -->
  <naco:translate char="&#x00D0;">D</naco:translate> <!-- capital letter eth -->
  <naco:translate char="&#x00F0;">d</naco:translate> <!-- small letter eth -->
  <naco:translate char="&#x0130;">I</naco:translate> <!-- capital letter dotted i -->
  <naco:translate char="&#x0131;">i</naco:translate> <!-- small letter dotless i -->
  <naco:translate char="&#x0141;">L</naco:translate> <!-- capital letter L with stroke -->
  <naco:translate char="&#x0142;">l</naco:translate> <!-- small letter l with stroke -->
  <naco:translate char="&#x2113;">l</naco:translate> <!-- script small l -->
  <naco:translate char="&#x01A0;">O</naco:translate> <!-- capital letter O with horn (O-hook) -->
  <naco:translate char="&#x01A1;">o</naco:translate> <!-- small letter o with horn (o-hook) -->
  <naco:translate char="&#x01AF;">U</naco:translate> <!-- capital letter U with horn (U-hook) -->
  <naco:translate char="&#x01B0;">u</naco:translate> <!-- small letter u with horn (u-hook) -->
  <naco:translate char="&#x00D8;">O</naco:translate> <!-- capital letter O with stroke -->
  <naco:translate char="&#x00F8;">o</naco:translate> <!-- small letter o with stroke -->
  <naco:translate char="&#x00DE;">TH</naco:translate> <!-- capital letter thorn -->
  <naco:translate char="&#x00FE;">th</naco:translate> <!-- small letter thorn -->
  <naco:translate char="&#x1E9E;">SS</naco:translate> <!-- capital letter sharp s -->
  <naco:translate char="&#x00DF;">ss</naco:translate> <!-- small letter sharp s -->

  <xsl:template name="naco-normalize-string">
    <xsl:param name="str"/>
    <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz&#x03B1;&#x03B2;&#x03B3;</xsl:variable>
    <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ&#x0391;&#x0392;&#x0393;</xsl:variable>
    <xsl:variable name="translated">
      <xsl:call-template name="_translate-chars">
        <xsl:with-param name="str" select="$str"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="normalize-space(translate($translated,$uc,$lc))"/>
  </xsl:template>

  <xsl:template name="_translate-chars">
    <xsl:param name="str"/>
    <xsl:param name="i" select="1"/>
    <xsl:choose>
      <xsl:when test="document('')/*/naco:translate[$i]/@char">
        <xsl:choose>
          <xsl:when test="contains($str,document('')/*/naco:translate[$i]/@char)">
            <xsl:variable name="translated">
              <xsl:call-template name="_translate-char">
                <xsl:with-param name="char" select="document('')/*/naco:translate[$i]/@char"/>
                <xsl:with-param name="replace" select="document('')/*/naco:translate[$i]/text()"/>
                <xsl:with-param name="str" select="$str"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="_translate-chars">
              <xsl:with-param name="str" select="$translated"/>
              <xsl:with-param name="i" select="$i+1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="document('')/*/naco:translate[$i+1]/@char">
                <xsl:call-template name="_translate-chars">
                  <xsl:with-param name="str" select="$str"/>
                  <xsl:with-param name="i" select="$i+1"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="_translate-char">
    <xsl:param name="char"/>
    <xsl:param name="replace"/>
    <xsl:param name="str"/>
    <xsl:choose>
      <xsl:when test="contains($str,$char)">
        <xsl:call-template name="_translate-char">
          <xsl:with-param name="char" select="$char"/>
          <xsl:with-param name="str" select="concat(substring-before($str,$char),$replace,substring-after($str,$char))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
