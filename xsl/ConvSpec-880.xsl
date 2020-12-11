<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for handling 880 fields
  -->

  <xsl:template match="*" mode="mProcessAdminMetadata880">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vProcess">
      <xsl:call-template name="tProcess"/>
    </xsl:variable>
    <xsl:if test="$vProcess='true'">
      <xsl:apply-templates select="." mode="adminmetadata">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="mProcessWork880">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:param name="pAgentIri"/>
    <xsl:variable name="vProcess">
      <xsl:call-template name="tProcess"/>
    </xsl:variable>
    <xsl:if test="$vProcess='true'">
      <xsl:apply-templates select="." mode="work">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="pPosition" select="position()"/>
        <xsl:with-param name="pAgentIri" select="$pAgentIri"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="mProcessInstance880">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:param name="pInstanceType"/>
    <xsl:variable name="vProcess">
      <xsl:call-template name="tProcess"/>
    </xsl:variable>
    <xsl:if test="$vProcess='true'">
      <xsl:apply-templates select="." mode="instance">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        <xsl:with-param name="pPosition" select="position()"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="mProcessItem880">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vProcess">
      <xsl:call-template name="tProcess"/>
    </xsl:variable>
    <xsl:if test="$vProcess='true'">
      <xsl:apply-templates select="." mode="hasItem">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pPosition" select="position()"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- return true() if field should be processed based on 880/$6 processing specs -->
  <!-- context is a leader, controlfield, or datafield node -->
  <xsl:template name="tProcess">
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'">
          <xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vOccurrence">
      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="name()='leader' or name()='controlfield'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="not(marc:subfield[@code='6'])">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="not($map880/datafields/datafield[@tag=$vTag])">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="@tag != '880' and not(../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence])">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="@tag='880' and not(../marc:datafield[@tag=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence])">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="@tag != '880' and $map880/datafields/datafield[@tag=$vTag]/@convertLinked='false'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="@tag='880' and $map880/datafields/datafield[@tag=$vTag]/@convertLinked='true'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
