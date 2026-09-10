<?xml version="1.0" encoding="UTF-8"?>
<!--
  Render a conversion result as one line per node, so that output from two
  XSLT processors can be compared without their serialization differences
  (indentation, attribute order, where namespace declarations land) showing up
  as false differences. Run it with the same processor over both files.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:param name="depth" select="0"/>
    <xsl:call-template name="indent">
      <xsl:with-param name="n" select="$depth"/>
    </xsl:call-template>
    <xsl:value-of select="name()"/>
    <xsl:for-each select="@*">
      <xsl:sort select="name()"/>
      <xsl:value-of select="concat(' ', name(), '=&quot;', normalize-space(.), '&quot;')"/>
    </xsl:for-each>
    <xsl:if test="normalize-space(text()) != ''">
      <xsl:value-of select="concat(' | ', normalize-space(text()))"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="*">
      <xsl:with-param name="depth" select="$depth + 1"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="indent">
    <xsl:param name="n"/>
    <xsl:if test="$n &gt; 0">
      <xsl:text>  </xsl:text>
      <xsl:call-template name="indent">
        <xsl:with-param name="n" select="$n - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
