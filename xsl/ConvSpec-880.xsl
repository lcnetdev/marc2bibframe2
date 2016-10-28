<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for handling 880 fields
  -->

  <xsl:template match="marc:datafield[@tag='880']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:variable name="tag"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$tag='100' or $tag='110' or $tag='111'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="workName" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='130' or $tag='240'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="workUnifTitle" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='243'">
        <xsl:apply-templates mode="work243" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='245'">
        <xsl:if test="@ind1 = 1 and not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
          <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
          <xsl:apply-templates mode="work245" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$tag='700' or $tag='710' or $tag='711'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work7XX" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='730'">
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work730" select=".">
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='800' or $tag='810' or $tag='811'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work8XX" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>        
      <xsl:when test="$tag='830'">
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work830" select=".">
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>        
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='880']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="tag"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$tag='210'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance210" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='222'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>      
        <xsl:apply-templates mode="instance222" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='242'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>      
        <xsl:apply-templates mode="instance242" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='245'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance245" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='246'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance246" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='247'">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance247" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
