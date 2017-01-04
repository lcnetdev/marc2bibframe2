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
      <xsl:when test="$tag='050'">
        <xsl:apply-templates mode="work050" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='052'">
        <xsl:apply-templates mode="work052" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='055'">
        <xsl:apply-templates mode="work055" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='072'">
        <xsl:apply-templates mode="work072" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='082'">
        <xsl:apply-templates mode="work082" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='084'">
        <xsl:apply-templates mode="work084" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='100' or $tag='110' or $tag='111'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="workName" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='130' or $tag='240'">
        <xsl:apply-templates mode="workUnifTitle" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='243'">
        <xsl:apply-templates mode="work243" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='245'">
        <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
          <xsl:variable name="label">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='b' or
                                         @code='f' or 
                                         @code='g' or
                                         @code='k' or
                                         @code='n' or
                                         @code='p' or
                                         @code='s']"/>
          </xsl:variable>
          <xsl:apply-templates mode="work245" select=".">
            <xsl:with-param name="label" select="$label"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$tag='336'">
        <xsl:apply-templates select="." mode="rdaResource">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:content</xsl:with-param>
          <xsl:with-param name="pResource">bf:Content</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='700' or $tag='710' or $tag='711'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work7XX" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='730'">
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work730" select=".">
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='800' or $tag='810' or $tag='811'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work8XX" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>        
      <xsl:when test="$tag='830'">
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work830" select=".">
          <xsl:with-param name="workiri" select="$workiri"/>
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
      <xsl:when test="$tag='086'">
        <xsl:apply-templates mode="instance086" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='210'">
        <xsl:apply-templates mode="instance210" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='222'">
        <xsl:apply-templates mode="instance222" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='242'">
        <xsl:apply-templates mode="instance242" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='245'">
        <xsl:variable name="label">
          <xsl:apply-templates mode="concat-nodes-space"
                               select="marc:subfield[@code='a' or
                                       @code='b' or
                                       @code='f' or 
                                       @code='g' or
                                       @code='k' or
                                       @code='n' or
                                       @code='p' or
                                       @code='s']"/>
        </xsl:variable>
        <xsl:apply-templates mode="instance245" select=".">
          <xsl:with-param name="label" select="$label"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='246'">
        <xsl:apply-templates mode="instance246" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='247'">
        <xsl:apply-templates mode="instance247" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='250'">
        <xsl:apply-templates mode="instance250" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='254'">
        <xsl:apply-templates mode="instance254" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='255'">
        <xsl:apply-templates mode="instance255" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='256'">
        <xsl:apply-templates mode="instance256" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='257'">
        <xsl:apply-templates mode="instance257" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='260' or $tag='262' or $tag='264'">
        <xsl:apply-templates mode="instance260" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='261'">
        <xsl:apply-templates mode="instance261" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='263'">
        <xsl:apply-templates mode="instance263" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='300'">
        <xsl:apply-templates mode="instance300" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='306'">
        <xsl:apply-templates mode="instance306" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='310' or $tag='321'">
        <xsl:apply-templates mode="instance310" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='337'">
        <xsl:apply-templates select="." mode="rdaResource">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:media</xsl:with-param>
          <xsl:with-param name="pResource">bf:Media</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='338'">
        <xsl:apply-templates select="." mode="rdaResource">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:carrier</xsl:with-param>
          <xsl:with-param name="pResource">bf:Carrier</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='340'">
        <xsl:apply-templates select="." mode="instance340">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='344'">
        <xsl:apply-templates select="." mode="instance344">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='345'">
        <xsl:apply-templates select="." mode="instance345">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='346'">
        <xsl:apply-templates select="." mode="instance346">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='347'">
        <xsl:apply-templates select="." mode="instance347">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='348'">
        <xsl:apply-templates select="." mode="instance348">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='880']" mode="newItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="tag"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$tag='050'">
        <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="item050" select=".">
          <xsl:with-param name="pItemUri" select="$vItemUri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>  
