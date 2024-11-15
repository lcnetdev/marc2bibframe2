<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:local="local:"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc local">

  <!--
      Conversion specs for 006,008
      See lookup tables in conf/codeMaps.xml for code conversions
  -->

  <!--<xsl:template match="marc:controlfield[@tag='006']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <!-\- continuing resources -\->
    <xsl:if test="substring(.,1,1) = 's'">
      <xsl:if test="substring(.,18,1) != '|'">
        <xsl:call-template name="entryConvention008">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="code" select="substring(.,18,1)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>-->

  <!-- return the material type for the 008 from the leader -->
  <xsl:template match="marc:leader" mode="mMaterialType008">
    <xsl:choose>
      <xsl:when test="(substring(.,7,1) = 'a' or substring(.,7,1 = 't')) and
                      (substring(.,8,1) = 'a' or substring(.,8,1) = 'c' or substring(.,8,1) = 'd' or substring(.,8,1) = 'm')">BK</xsl:when>
      <xsl:when test="substring(.,7,1) = 'm'">CF</xsl:when>
      <xsl:when test="substring(.,7,1) = 'e' or substring(.,7,1) = 'f'">MP</xsl:when>
      <xsl:when test="substring(.,7,1) = 'c' or
                      substring(.,7,1) = 'd' or
                      substring(.,7,1) = 'i' or
                      substring(.,7,1) = 'j'">MU</xsl:when>
      <xsl:when test="substring(.,7,1) = 'a' and
                      (substring(.,8,1) = 'b' or
                       substring(.,8,1) = 'i' or
                       substring(.,8,1) = 's')">CR</xsl:when>
      <xsl:when test="substring(.,7,1) = 'g' or
                      substring(.,7,1) = 'k' or
                      substring(.,7,1) = 'o' or
                      substring(.,7,1) = 'r'">VM</xsl:when>
      <xsl:when test="substring(.,7,1) = 'p'">MX</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- return the carrier URI from the 008 -->
  <xsl:template match="marc:record" mode="mCarrier008URI">
    <xsl:variable name="vMaterialType">
      <xsl:apply-templates select="marc:leader" mode="mMaterialType008"/>
    </xsl:variable>
    <xsl:variable name="vCode">
      <xsl:choose>
        <xsl:when test="contains('BK CF MU CR MX',$vMaterialType)">
          <xsl:value-of select="substring(marc:controlfield[@tag='008'],24,1)"/>
        </xsl:when>
        <xsl:when test="contains('MP VM',$vMaterialType)">
          <xsl:value-of select="substring(marc:controlfield[@tag='008'],30,1)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vCodeLookup">
      <xsl:choose>
        <xsl:when test="$vMaterialType='CF' and ($vCode='o' or $vCode='q')">
          <xsl:value-of select="$vCode"/>
        </xsl:when>
        <xsl:when test="$vMaterialType != 'CF' and $vCode=' '">r</xsl:when>
        <xsl:otherwise><xsl:value-of select="$vCode"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="$codeMaps/maps/carrier/*[name() = $vCodeLookup]">
      <xsl:value-of select="@href"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="marc:controlfield[@tag='008']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <!--
    <xsl:variable name="marcYear" select="substring(.,1,2)"/>
    <xsl:variable name="creationYear">
      <xsl:choose>
        <xsl:when test="$marcYear &lt; 50"><xsl:value-of select="concat('20',$marcYear)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="concat('19',$marcYear)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:creationDate>
          <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>date</xsl:attribute>
          <xsl:value-of select="concat($creationYear,'-',substring(.,3,2),'-',substring(.,5,2))"/>
        </bf:creationDate>
      </xsl:when>
    </xsl:choose>
    -->
    <!-- continuing resources -->
    <xsl:if test="substring(../marc:leader,7,1) = 'a' and
                  (substring(../marc:leader,8,1) = 'b' or
                   substring(../marc:leader,8,1) = 'i' or
                   substring(../marc:leader,8,1) = 's')">
      <xsl:if test="substring(.,35,1) != '|'">
        <xsl:call-template name="entryConvention008">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="code" select="substring(.,35,1)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- create entry convention note from pos 34 of 008/continuing resources -->
  <xsl:template name="entryConvention008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="convention">
      <xsl:choose>
        <xsl:when test="$code='0'">0 - successive</xsl:when>
        <xsl:when test="$code='1'">1 - latest</xsl:when>
        <xsl:when test="$code='2'">2 - integrated</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$convention != ''">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:note>
            <bf:Note>
              <rdf:type>
                <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/metaentry</xsl:attribute>
              </rdf:type>
              <rdfs:label><xsl:value-of select="$convention"/></rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!--<xsl:template match="marc:controlfield[@tag='006']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <!-\- select call appropriate 008 template based on pos 0 -\->
    <xsl:choose>
      <!-\- books -\->
      <xsl:when test="substring(.,1,1) = 'a' or
                      substring(.,1,1) = 't'">
        <xsl:call-template name="work008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- computer files -\->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:call-template name="work008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- maps -\->
      <xsl:when test="substring(.,1,1) = 'e' or
                      substring(.,1,1) = 'f'">
        <xsl:call-template name="work008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- music -\->
      <xsl:when test="substring(.,1,1) = 'c' or
                      substring(.,1,1) = 'd' or
                      substring(.,1,1) = 'i' or
                      substring(.,1,1) = 'j'">
        <xsl:call-template name="work008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- continuing resources -\->
      <xsl:when test="substring(.,1,1) = 's'">
        <xsl:call-template name="work008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- visual materials -\->
      <xsl:when test="substring(.,1,1) = 'g' or
                      substring(.,1,1) = 'k' or
                      substring(.,1,1) = 'o' or
                      substring(.,1,1) = 'r'">
        <xsl:call-template name="work008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>-->

  <xsl:template match="marc:controlfield[@tag='008']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="language">
      <xsl:choose>
        <xsl:when test="substring(.,36,3) = '   '"/>
        <xsl:when test="substring(.,36,3) = '|||'"/>
        <xsl:otherwise>
          <xsl:call-template name="url-encode">
            <xsl:with-param name="str" select="normalize-space(substring(.,36,3))"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$language != ''">
          <bf:language>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($languages,$language)"/></xsl:attribute>
          </bf:language>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:variable name="vMaterialType">
      <xsl:apply-templates select="../marc:leader" mode="mMaterialType008"/>
    </xsl:variable>
    <xsl:choose>
      <!-- books -->
      <xsl:when test="$vMaterialType='BK'">
        <xsl:call-template name="work008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="$vMaterialType='CF'">
        <xsl:call-template name="work008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="$vMaterialType='MP'">
        <xsl:call-template name="work008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- music -->
      <xsl:when test="$vMaterialType='MU'">
        <xsl:call-template name="work008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="$vMaterialType='CR'">
        <xsl:call-template name="work008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- visual materials -->
      <xsl:when test="$vMaterialType='VM'">
        <xsl:call-template name="work008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- data elements for books -->
  <xsl:template name="work008books">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:call-template name="illustrativeContent008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="illustrations" select="substring($dataElements,1,4)"/>
    </xsl:call-template>
    <xsl:call-template name="intendedAudience008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,5,1)"/>
    </xsl:call-template>
    <xsl:call-template name="genreForm008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="contents" select="substring($dataElements,7,4)"/>
    </xsl:call-template>
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
    </xsl:call-template>
    <xsl:call-template name="conference008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,12,1)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="substring($dataElements,13,1) = '1'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($genreForms,'gf2016026082')"/></xsl:attribute>
              <rdfs:label>Festschriften</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="index008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,14,1)"/>
    </xsl:call-template>
    <xsl:variable name="v655" select="../marc:datafield[@tag='655' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
    <xsl:for-each select="$codeMaps/maps/litform/*[name() = substring($dataElements,16,1)] |
                          $codeMaps/maps/litform/*[name() = concat('x',substring($dataElements,16,1))]">
      <xsl:variable name="vLitformTxt" select="." />
      <xsl:choose>
        <xsl:when test="not($v655[.=$vLitformTxt]) and not($v655[.=concat($vLitformTxt, '.')]) and $serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="$codeMaps/maps/bioform/*[name() = substring($dataElements,17,1)]">
      <xsl:variable name="vBioformText" select="." />
      <xsl:choose>
        <xsl:when test="not($v655[.=$vBioformText]) and not($v655[.=concat($vBioformText, '.')]) and $serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- data elements for computer files -->
  <xsl:template name="work008computerfiles">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:call-template name="intendedAudience008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,5,1)"/>
    </xsl:call-template>
    <xsl:for-each select="$codeMaps/maps/computerFileType/*[name() = substring($dataElements,9,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:if test="@href">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
    </xsl:call-template>
  </xsl:template>

  <!-- data elements for maps -->
  <xsl:template name="work008maps">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:call-template name="cartographicAttributes008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="relief" select="substring($dataElements,1,4)"/>
    </xsl:call-template>
    <xsl:for-each select="$codeMaps/maps/projection/*[name() = substring($dataElements,5,2)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:cartographicAttributes>
            <bf:Cartographic>
              <bf:projection>
                <bf:Projection>
                  <xsl:if test="@href">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Projection>
              </bf:projection>
            </bf:Cartographic>
          </bf:cartographicAttributes>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
    </xsl:call-template>
    <xsl:call-template name="index008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,14,1)"/>
    </xsl:call-template>
    <xsl:call-template name="mapform008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="form" select="substring($dataElements,16,2)"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- data elements for music -->
  <xsl:template name="work008music">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:call-template name="intendedAudience008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,5,1)"/>
    </xsl:call-template>
    <xsl:call-template name="suppContentMusic008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="accomp" select="substring($dataElements,7,6)"/>
    </xsl:call-template>
    <xsl:call-template name="compForm008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,1,2)"/>
    </xsl:call-template>
    <xsl:call-template name="musicFormat008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,3,1)"/>
    </xsl:call-template>
    <xsl:call-template name="musicTextForm008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="litform" select="substring($dataElements,13,2)"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- data elements for continuing resources -->
  <xsl:template name="work008cr">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:for-each select="$codeMaps/maps/crtype/*[name() = substring($dataElements,4,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bflc:serialPubType>
            <bflc:SerialPubType>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bflc:SerialPubType>
          </bflc:serialPubType>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:call-template name="genreForm008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="contents" select="substring($dataElements,7,4)"/>
    </xsl:call-template>
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
    </xsl:call-template>
    <xsl:call-template name="conference008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,12,1)"/>
    </xsl:call-template>
    <xsl:for-each select="$codeMaps/maps/crscript/*[name() = substring($dataElements,16,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:notation>
            <bf:Script>
              <xsl:if test="@href">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Script>
          </bf:notation>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- data elements for visual materials -->
  <xsl:template name="work008visual">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="duration">
      <xsl:choose>
        <xsl:when test="substring($dataElements,1,3) = '000'">more than 999 minutes</xsl:when>
        <xsl:when test="substring($dataElements,1,3) = '---'"/>
        <xsl:when test="substring($dataElements,1,3) = 'nnn'"/>
        <xsl:when test="substring($dataElements,1,3) = '|||'"/>
        <xsl:when test="substring($dataElements,1,3) = '   '"/>
        <xsl:when test="starts-with(substring($dataElements,1,3),'0')">
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="substring($dataElements,1,3)"/>
            <xsl:with-param name="pEndPunct" select="' '"/>
            <xsl:with-param name="pLeadPunct" select="'0'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="substring($dataElements,1,3)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="intendedAudience008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,5,1)"/>
    </xsl:call-template>
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
    </xsl:call-template>
    <xsl:variable name="v655" select="../marc:datafield[@tag='655' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
    <xsl:variable name="v380" select="../marc:datafield[@tag='380' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
    <xsl:for-each select="$codeMaps/maps/visualtype/*[name() = substring($dataElements,16,1)]">
      <xsl:variable name="vCodemapTxt" select="." />
      <xsl:choose>
        <xsl:when test="
            not($v380[.=$vCodemapTxt]) and not($v380[.=concat($vCodemapTxt, '.')]) and 
            not($v655[.=$vCodemapTxt]) and not($v655[.=concat($vCodemapTxt, '.')]) and 
            $serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="$codeMaps/maps/technique/*[name() = substring($dataElements,17,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bflc:movingImageTechnique>
            <bflc:MovingImageTechnique>
              <xsl:if test="@href != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bflc:MovingImageTechnique>
          </bflc:movingImageTechnique>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$duration != ''">
          <bf:duration>
            <xsl:choose>
              <xsl:when test="substring($dataElements,1,3) = '000'">
                <xsl:value-of select="$duration"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'duration')"/></xsl:attribute>
                <xsl:value-of select="concat('PT',$duration,'M')"/>
              </xsl:otherwise>
            </xsl:choose>
          </bf:duration>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- create Work intendedAudience properties from 008 -->
  <xsl:template name="intendedAudience008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:for-each select="$codeMaps/maps/maudience/*[name() = $code]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:intendedAudience>
            <bf:IntendedAudience>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:IntendedAudience>
          </bf:intendedAudience>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- create Work supplementaryContent properties from 008 -->
  <!-- loop 4 times -->
  <xsl:template name="genreForm008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="contents"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:variable name="vProperty">
        <xsl:choose>
          <xsl:when test="contains('bkq',substring($contents,$i,1))">bf:supplementaryContent</xsl:when>
          <xsl:otherwise>bf:genreForm</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="vResource">
        <xsl:choose>
          <xsl:when test="contains('bkq',substring($contents,$i,1))">bf:SupplementaryContent</xsl:when>
          <xsl:otherwise>bf:GenreForm</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="v655" select="../marc:datafield[@tag='655' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
      <xsl:variable name="v353" select="../marc:datafield[@tag='353']/marc:subfield[@code='a']" />
      <xsl:for-each select="$codeMaps/maps/marcgt/*[name() = substring($contents,$i,1)] |
                            $codeMaps/maps/marcgt/*[name() = concat('x',substring($contents,$i,1))]">
        <xsl:variable name="vMarcgtText" select="." />
        <xsl:choose>
          <xsl:when test="
              (
                (
                    $vProperty='bf:supplementaryContent' and
                    not($v353[.=$vMarcgtText])
                ) or 
                (
                  $vProperty='bf:genreForm' and 
                  not($v655[.=$vMarcgtText]) and 
                  not($v655[.=concat($vMarcgtText, '.')])
                 )
               ) and 
              $serialization = 'rdfxml'">
            <xsl:element name="{$vProperty}">
              <xsl:element name="{$vResource}">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </xsl:element>
            </xsl:element>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="genreForm008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="contents" select="$contents"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- create bflc:governmentPubType property for a gov doc -->
  <xsl:template name="govdoc008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="govdoc">
      <xsl:choose>
        <xsl:when test="$code = 'a'">autonomous</xsl:when>
        <xsl:when test="$code = 'c'">multilocal</xsl:when>
        <xsl:when test="$code = 'f'">federal</xsl:when>
        <xsl:when test="$code = 'i'">international intergovernmental</xsl:when>
        <xsl:when test="$code = 'l'">local</xsl:when>
        <xsl:when test="$code = 'm'">multistate</xsl:when>
        <xsl:when test="$code = 'o'">government</xsl:when>
        <xsl:when test="$code = 's'">state</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$govdoc != ''">
          <bflc:governmentPubType>
            <bflc:GovernmentPubType>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($mgovtpubtype,$code)"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="$govdoc"/></rdfs:label>
            </bflc:GovernmentPubType>
          </bflc:governmentPubType>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- create genreForm property for a conference publication -->
  <xsl:template name="conference008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:if test="$code = '1'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:if test="$genreForms != '' and count(../marc:datafield[@tag='655']/marc:subfield[. = $genreForms]) = 0">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($genreForms,'gf2014026068')"/></xsl:attribute>
              <rdfs:label>Conference papers and proceedings</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- genreForm properties for maps - loop 2 times -->
  <xsl:template name="mapform008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="form"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 3">
      <xsl:variable name="v655" select="../marc:datafield[@tag='655' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
      <xsl:for-each select="$codeMaps/maps/mapform/*[name() = substring($form,$i,1)]">
        <xsl:variable name="vCodemapTxt" select="." />
        <xsl:choose>
          <xsl:when test="not($v655[.=$vCodemapTxt]) and not($v655[.=concat($vCodemapTxt, '.')]) and $serialization = 'rdfxml'">
            <bf:genreForm>
              <bf:GenreForm>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:GenreForm>
            </bf:genreForm>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="mapform008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="form" select="$form"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- compForm properties for music -->
  <xsl:template name="compForm008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="v655" select="../marc:datafield[@tag='655' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
    <xsl:for-each select="$codeMaps/maps/musicCompForm/*[name() = $code]">
      <xsl:variable name="vCodemapTxt" select="." />
      <xsl:choose>
        <xsl:when test="not($v655[.=$vCodemapTxt]) and not($v655[.=concat($vCodemapTxt, '.')]) and $serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:if test="@href != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- musicFormat properties for music -->
  <xsl:template name="musicFormat008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="df348-as" select="../marc:datafield[@tag = '348']/marc:subfield[@code = 'a']" />
    <xsl:for-each select="$codeMaps/maps/musicFormat/*[name() = $code]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml' and (count($df348-as)=0 or $df348-as[text() != .])">
          <bf:musicFormat>
            <bf:MusicFormat>
              <xsl:if test="@href != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:MusicFormat>
          </bf:musicFormat>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- supplementaryContent properties for music - loop 6 times -->
  <xsl:template name="suppContentMusic008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="accomp"/>
    <xsl:param name="i" select="1"/>
    <xsl:variable name="df353-bs" select="../marc:datafield[@tag = '348']/marc:subfield[@code = 'b']" />
    <xsl:variable name="df353-0s" select="../marc:datafield[@tag = '348']/marc:subfield[@code = '0']" />
    <xsl:if test="$i &lt; 7">
      <xsl:for-each select="$codeMaps/maps/musicSuppContent/*[name() = substring($accomp,$i,1)]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml' and (
                                                (count($df353-0s)=0 and count($df353-bs)=0) or 
                                                ($df353-0s[text() != @href] and not(contains(@href, $df353-bs/text())))
                                           )">
            <bf:supplementaryContent>
              <bf:SupplementaryContent>
                <xsl:if test="@href">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                </xsl:if>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:SupplementaryContent>
            </bf:supplementaryContent>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="suppContentMusic008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="accomp" select="$accomp"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- genreForm properties for text accompanying music - loop 2 times -->
  <xsl:template name="musicTextForm008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="litform"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 3">
      <xsl:variable name="v655" select="../marc:datafield[@tag='655' and marc:subfield[@code='2']='lcgft']/marc:subfield[@code='a']" />
      <xsl:for-each select="$codeMaps/maps/musicTextForm/*[name() = substring($litform,$i,1)]">
        <xsl:variable name="vCodemapTxt" select="." />
        <xsl:choose>
          <xsl:when test="not($v655[.=$vCodemapTxt]) and not($v655[.=concat($vCodemapTxt, '.')]) and $serialization = 'rdfxml'">
            <bf:genreForm>
              <bf:GenreForm>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:GenreForm>
            </bf:genreForm>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="musicTextForm008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="litform" select="$litform"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!--<xsl:template match="marc:controlfield[@tag='006']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType"/>
    <!-\- select call appropriate 008 template based on pos 0 -\->
    <xsl:choose>
      <!-\- books -\->
      <xsl:when test="substring(.,1,1) = 'a' or
                      substring(.,1,1) = 't'">
        <xsl:call-template name="instance008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- computer files -\->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:call-template name="instance008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- maps -\->
      <xsl:when test="substring(.,1,1) = 'e' or
                      substring(.,1,1) = 'f'">
        <xsl:call-template name="instance008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- mixed materials -\->
      <xsl:when test="substring(.,1,1) = 'p'">
        <xsl:call-template name="instance008mixed">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- music -\->
      <xsl:when test="substring(.,1,1) = 'c' or
                      substring(.,1,1) = 'd' or
                      substring(.,1,1) = 'i' or
                      substring(.,1,1) = 'j'">
        <xsl:call-template name="instance008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- continuing resources -\->
      <xsl:when test="substring(.,1,1) = 's'">
        <xsl:call-template name="instance008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
      <!-\- visual materials -\->
      <xsl:when test="substring(.,1,1) = 'g' or
                      substring(.,1,1) = 'k' or
                      substring(.,1,1) = 'o' or
                      substring(.,1,1) = 'r'">
        <xsl:call-template name="instance008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
          <xsl:with-param name="pTag" select="'006'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>-->

  <xsl:template match="marc:controlfield[@tag='008']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType"/>
    <!--
      008 date and place processing are part of process8.  See ConvSpec-Process8-ProvAct.xsl.
      But we will call the requisite template at this time.
    -->
    <xsl:if test="$pInstanceType != 'SecondaryInstance'">
      <xsl:call-template name="process8" />
    </xsl:if>
    <xsl:variable name="vMaterialType">
      <xsl:apply-templates select="../marc:leader" mode="mMaterialType008"/>
    </xsl:variable>
    <xsl:choose>
      <!-- books -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='BK'">
        <xsl:call-template name="instance008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="leader" select="../marc:leader"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='CF'">
        <xsl:call-template name="instance008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='MP'">
        <xsl:call-template name="instance008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- music -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='MU'">
        <xsl:call-template name="instance008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='CR'">
        <xsl:call-template name="instance008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- visual materials -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='VM'">
        <xsl:call-template name="instance008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- mixed materials -->
      <xsl:when test="$pInstanceType != 'SecondaryInstance' and $vMaterialType='MX'">
        <xsl:call-template name="instance008mixed">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- data elements for books -->
  <xsl:template name="instance008books">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pInstanceType"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="vPos23Code" select="substring($dataElements,6,1)" />
    <xsl:if test="$pTag='008' and $vPos23Code!=' '">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="$vPos23Code"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:variable name="vMediaType">
      <xsl:if test="not(../marc:datafield[@tag='337'])">
        <xsl:choose>
          <xsl:when test="substring($dataElements,6,1) = ' ' or
                          substring($dataElements,6,1) = 'd' or
                          substring($dataElements,6,1) = 'f' or
                          substring($dataElements,6,1) = 'r'">n</xsl:when>
          <xsl:when test="substring($dataElements,6,1) = 'o' or
                          substring($dataElements,6,1) = 'q' or
                          substring($dataElements,6,1) = 's'">c</xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$vMediaType != ''">
          <bf:media>
            <bf:Media>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($mediaType,$vMediaType)"/></xsl:attribute>
              <rdfs:label>
                <xsl:choose>
                  <xsl:when test="$vMediaType = 'n'">unmediated</xsl:when>
                  <xsl:when test="$vMediaType = 'c'">computer</xsl:when>
                </xsl:choose>
              </rdfs:label>
            </bf:Media>
          </bf:media>
        </xsl:if>
        <xsl:if test="$pTag='008'">
          <xsl:choose>
            <xsl:when test="substring($dataElements,6,1) = 'd'">
              <bf:fontSize>
                <bf:FontSize rdf:about="http://id.loc.gov/vocabulary/mfont/lp">
                  <rdfs:label>large print</rdfs:label>
                </bf:FontSize>
              </bf:fontSize>
            </xsl:when>
            <xsl:when test="substring($dataElements,6,1) = 'f'">
              <bf:notation>
                <bf:TactileNotation rdf:about="http://id.loc.gov/vocabulary/mtactile/brail">
                  <rdfs:label>braille code</rdfs:label>
                </bf:TactileNotation>
              </bf:notation>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- dataElements for computer files -->
  <xsl:template name="instance008computerfiles">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:if test="$pTag='008'">
      <xsl:if test="substring($dataElements,6,1) = 'o' or substring($dataElements,6,1) = 'q'">
        <xsl:call-template name="carrier008">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>  

  <!-- data elements for maps -->
  <xsl:template name="instance008maps">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="vPos23Code" select="substring($dataElements,12,1)" />
    <xsl:if test="$pTag='008' and $vPos23Code!=' '">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="$vPos23Code"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- data elements for music -->
  <xsl:template name="instance008music">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="vPos23Code" select="substring($dataElements,6,1)" />
    <xsl:if test="$pTag='008' and $vPos23Code!=' '">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="$vPos23Code"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- data elements for continuing resources -->
  <xsl:template name="instance008cr">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="regularity">
      <xsl:value-of select="substring($dataElements,2,1)"/>
    </xsl:variable>
    <xsl:for-each select="$codeMaps/maps/frequency/*[name() = substring($dataElements,1,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:frequency>
            <bf:Frequency>
              <xsl:if test="@href != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Frequency>
          </bf:frequency>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:if test="$regularity='n' or $regularity='x'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:frequency>
            <bf:Frequency>
              <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/frequencies/irr</xsl:attribute>
              <rdfs:label>irregular</rdfs:label>
            </bf:Frequency>
          </bf:frequency>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:variable name="vPos22Code">
      <xsl:choose>
        <xsl:when test="substring($dataElements,5,1) = ' '">skip</xsl:when>
        <xsl:otherwise><xsl:value-of select="substring($dataElements,5,1)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="$codeMaps/maps/crorigform/*[name() = $vPos22Code]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:note>
            <bf:Note>
              <rdf:type>
                <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/orig</xsl:attribute>
              </rdf:type>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:variable name="vPos23Code" select="substring($dataElements,6,1)" />
    <xsl:if test="$pTag='008' and $vPos23Code!=' '">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="$vPos23Code"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- data elements for visual materials -->
  <xsl:template name="instance008visual">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="vPos23Code" select="substring($dataElements,12,1)" />
    <xsl:if test="$pTag='008' and $vPos23Code!=' '">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="$vPos23Code"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- data elements for mixed materials -->
  <xsl:template name="instance008mixed">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="pTag" select="'008'"/>
    <xsl:variable name="vPos23Code" select="substring($dataElements,6,1)" />
    <xsl:if test="$pTag='008' and $vPos23Code!=' '">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="$vPos23Code"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- illustrativeContent - loop over 4 times -->
  <xsl:template name="illustrativeContent008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="illustrations"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:for-each select="$codeMaps/maps/millus/*[name() = substring($illustrations,$i,1)]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:illustrativeContent>
              <bf:Illustration>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:Illustration>
            </bf:illustrativeContent>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="illustrativeContent008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="illustrations" select="$illustrations"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="carrier008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="vCarrierUris">
      <xsl:apply-templates select="ancestor::marc:record" mode="mURI33X">
        <xsl:with-param name="pTag" select="'338'"/>
        <xsl:with-param name="pCode" select = "'b'"/>
        <xsl:with-param name="pStem" select="$carriers"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:for-each select="$codeMaps/maps/carrier/*[name() = $code]">
      <xsl:if test="not(contains($vCarrierUris,@href))">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:carrier>
              <bf:Carrier>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:Carrier>
            </bf:carrier>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- cartographicAttributes - loop over 4 characters -->
  <xsl:template name="cartographicAttributes008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="relief"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:for-each select="$codeMaps/maps/relief/*[name() = substring($relief,$i,1)]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:cartographicAttributes>
              <bf:Cartographic>
                <bf:relief>
                  <bf:Relief>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bf:Relief>
                </bf:relief>
              </bf:Cartographic>
            </bf:cartographicAttributes>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="cartographicAttributes008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="relief" select="$relief"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="index008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="v353" select="../marc:datafield[@tag='353']/marc:subfield[@code='a']" />
    <xsl:if test="$code = '1' and not($v353[.!='index'])">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:supplementaryContent>
            <bf:SupplementaryContent rdf:about="http://id.loc.gov/vocabulary/msupplcont/index">
              <rdfs:label>index</rdfs:label>
            </bf:SupplementaryContent>
          </bf:supplementaryContent>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
