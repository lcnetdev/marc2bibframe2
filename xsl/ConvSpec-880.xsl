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

  <xsl:template match="marc:datafield[@tag='880']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:variable name="tag"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:variable>
    <xsl:choose>
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
      <xsl:when test="$tag='255'">
        <xsl:apply-templates mode="work255" select=".">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='336'">
        <xsl:apply-templates select="." mode="rdaResource">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pProp">bf:content</xsl:with-param>
          <xsl:with-param name="pResource">bf:Content</xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='351'">
        <xsl:apply-templates select="." mode="work351">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='380'">
        <xsl:apply-templates select="." mode="work380">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='382'">
        <xsl:apply-templates select="." mode="work382">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='383'">
        <xsl:apply-templates select="." mode="work383">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='385' or $tag='386'">
        <xsl:apply-templates select="." mode="work385or386">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='502'">
        <xsl:apply-templates select="." mode="work502">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='508' or $tag='511'">
        <xsl:apply-templates select="." mode="workCreditsNote">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='518'">
        <xsl:apply-templates select="." mode="work518">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='520'">
        <xsl:apply-templates select="." mode="work520">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='522'">
        <xsl:apply-templates select="." mode="work522">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='530' or $tag='533' or $tag='534'">
        <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates select="." mode="hasInstance5XX">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
          <xsl:with-param name="recordid" select="$recordid"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='546'">
        <xsl:apply-templates select="." mode="work546">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='580'">
        <xsl:apply-templates select="." mode="work580">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='600' or $tag='610' or $tag='611'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work6XXName" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="recordid" select="$recordid"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='630'">
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work630" select=".">
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="recordid" select="$recordid"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="($tag='648' or $tag='650' or $tag='651') or ($tag='655' and @ind1=' ')">
        <xsl:variable name="vTopicUri">
          <xsl:choose>
            <xsl:when test="$tag='655'">
              <xsl:value-of select="$recordid"/>#GenreForm880-<xsl:value-of select="position()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$recordid"/>#Topic880-<xsl:value-of select="position()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates select="." mode="work6XXAuth">
          <xsl:with-param name="pTopicUri" select="$vTopicUri"/>
          <xsl:with-param name="recordid" select="$recordid"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='653'">
        <xsl:apply-templates select="." mode="work653">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='656'">
        <xsl:apply-templates select="." mode="work656">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='662'">
        <xsl:apply-templates select="." mode="work662">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='700' or $tag='710' or $tag='711' or $tag='720'">
        <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work7XX" select=".">
          <xsl:with-param name="agentiri" select="$agentiri"/>
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='730' or $tag='740'">
        <xsl:variable name="workiri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="work730" select=".">
          <xsl:with-param name="workiri" select="$workiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='752'">
        <xsl:apply-templates select="." mode="work752">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="recordid" select="$recordid"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='765' or $tag='767' or $tag='770' or $tag='772' or $tag='773' or $tag='774' or $tag='775' or $tag='780' or $tag='785' or $tag='786' or $tag='787'">
        <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates select="." mode="work7XXLinks">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
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
      <xsl:when test="$tag='350'">
        <xsl:apply-templates select="." mode="instance350">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='352'">
        <xsl:apply-templates select="." mode="instance352">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='362'">
        <xsl:apply-templates select="." mode="instance362">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='500' or $tag='501' or $tag='504' or
                      $tag='513' or $tag='515' or $tag='516' or
                      $tag='536' or $tag='544' or $tag='545' or
                      $tag='547' or $tag='550' or $tag='555' or
                      $tag='556' or $tag='581' or $tag='585' or
                      $tag='586' or $tag='588'">
        <xsl:apply-templates select="." mode="instanceNote5XX">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='505'">
        <xsl:apply-templates select="." mode="instance505">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='506'">
        <xsl:apply-templates select="." mode="instance506">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='507'">
        <xsl:apply-templates select="." mode="instance507">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='510'">
        <xsl:apply-templates select="." mode="instance510">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='521'">
        <xsl:apply-templates select="." mode="instance521">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='525'">
        <xsl:apply-templates select="." mode="instance525">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='530'">
        <xsl:apply-templates select="." mode="instance530">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='533'">
        <xsl:apply-templates select="." mode="instance533">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='534'">
        <xsl:apply-templates select="." mode="instance534">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='538'">
        <xsl:apply-templates select="." mode="instance538">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='540'">
        <xsl:apply-templates select="." mode="instance540">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='760' or $tag='762'">
        <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates select="." mode="instance7XXLinks">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$tag='766'">
        <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work</xsl:variable>
        <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates select="." mode="instance776">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pWorkUri" select="$vWorkUri"/>
          <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>  
