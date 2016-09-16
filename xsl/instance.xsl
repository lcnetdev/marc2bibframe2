<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Templates for building a BIBFRAME 2.0 Instance Resource from MARCXML
      All templates should have the mode "instance"
  -->
  

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="instance"/>

</xsl:stylesheet>
