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

  <xsl:template match="marc:controlfield[@tag='006']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <!-- continuing resources -->
    <xsl:if test="substring(.,1,1) = 's'">
      <xsl:if test="substring(.,18,1) != '|'">
        <xsl:call-template name="entryConvention008">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="code" select="substring(.,18,1)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:controlfield[@tag='008']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
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
              <bf:noteType>metadata entry convention</bf:noteType>
              <rdfs:label><xsl:value-of select="$convention"/></rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='006']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <!-- select call appropriate 008 template based on pos 0 -->
    <xsl:choose>
      <!-- books -->
      <xsl:when test="substring(.,1,1) = 'a' or
                      substring(.,1,1) = 't'">
        <xsl:call-template name="work008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:call-template name="work008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="substring(.,1,1) = 'e' or
                      substring(.,1,1) = 'f'">
        <xsl:call-template name="work008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- music -->
      <xsl:when test="substring(.,1,1) = 'c' or
                      substring(.,1,1) = 'd' or
                      substring(.,1,1) = 'i' or
                      substring(.,1,1) = 'j'">
        <xsl:call-template name="work008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="substring(.,1,1) = 's'">
        <xsl:call-template name="work008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- visual materials -->
      <xsl:when test="substring(.,1,1) = 'g' or
                      substring(.,1,1) = 'k' or
                      substring(.,1,1) = 'o' or
                      substring(.,1,1) = 'r'">
        <xsl:call-template name="work008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

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
            <bf:Language>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($languages,$language)"/></xsl:attribute>
            </bf:Language>
          </bf:language>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <!-- books -->
      <xsl:when test="(substring(../marc:leader,7,1) = 'a' or substring(../marc:leader,7,1 = 't')) and
                      (substring(../marc:leader,8,1) = 'a' or substring(../marc:leader,8,1) = 'c' or substring(../marc:leader,8,1) = 'd' or substring(../marc:leader,8,1) = 'm')">
        <xsl:call-template name="work008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="substring(../marc:leader,7,1) = 'm'">
        <xsl:call-template name="work008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="substring(../marc:leader,7,1) = 'e' or substring(../marc:leader,7,1) = 'f'">
        <xsl:call-template name="work008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- music -->
      <xsl:when test="substring(../marc:leader,7,1) = 'c' or
                      substring(../marc:leader,7,1) = 'd' or
                      substring(../marc:leader,7,1) = 'i' or
                      substring(../marc:leader,7,1) = 'j'">
        <xsl:call-template name="work008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="substring(../marc:leader,7,1) = 'a' and
                      (substring(../marc:leader,8,1) = 'b' or
                        substring(../marc:leader,8,1) = 'i' or
                        substring(../marc:leader,8,1) = 's')">
        <xsl:call-template name="work008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- visual materials -->
      <xsl:when test="substring(../marc:leader,7,1) = 'g' or
                      substring(../marc:leader,7,1) = 'k' or
                      substring(../marc:leader,7,1) = 'o' or
                      substring(../marc:leader,7,1) = 'r'">
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
    <xsl:call-template name="illustrativeContent008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="illustrations" select="substring($dataElements,1,4)"/>
    </xsl:call-template>
    <xsl:call-template name="intendedAudience008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,5,1)"/>
    </xsl:call-template>
    <xsl:call-template name="supplementaryContent008">
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
              <rdfs:label>festschrift</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="index008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,14,1)"/>
    </xsl:call-template>
    <xsl:for-each select="$codeMaps/maps/litform/*[name() = substring($dataElements,16,1)] |
                          $codeMaps/maps/litform/*[name() = concat('x',substring($dataElements,16,1))]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
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
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
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
    <xsl:for-each select="$codeMaps/maps/carttype/*[name() = substring($dataElements,8,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:if test="@prop = 'genreForm'">
            <bf:genreForm>
              <bf:GenreForm>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:GenreForm>
            </bf:genreForm>
          </xsl:if>
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
    <xsl:call-template name="supplementaryContent008">
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
    <xsl:variable name="duration">
      <xsl:choose>
        <xsl:when test="substring($dataElements,1,3) = '000'">more than 999 minutes</xsl:when>
        <xsl:when test="substring($dataElements,1,3) = '---'"/>
        <xsl:when test="substring($dataElements,1,3) = 'nnn'"/>
        <xsl:when test="substring($dataElements,1,3) = '|||'"/>
        <xsl:when test="starts-with(substring($dataElements,1,3),'0')">
          <xsl:call-template name="chopLeadingPadding">
            <xsl:with-param name="chopString" select="substring($dataElements,1,3)"/>
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
    <xsl:for-each select="$codeMaps/maps/visualtype/*[name() = substring($dataElements,16,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
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
  <xsl:template name="supplementaryContent008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="contents"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:for-each select="$codeMaps/maps/marcgt/*[name() = substring($contents,$i,1)] |
                            $codeMaps/maps/marcgt/*[name() = concat('x',substring($contents,$i,1))]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:supplementaryContent>
              <bf:SupplementaryContent>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:SupplementaryContent>
            </bf:supplementaryContent>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:call-template name="supplementaryContent008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="contents" select="$contents"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- create genreForm property for a gov doc -->
  <xsl:template name="govdoc008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:variable name="govdoc">
      <xsl:choose>
        <xsl:when test="$code = 'a'">autonomous or semi-autonomous government publication</xsl:when>
        <xsl:when test="$code = 'c'">multilocal government publication</xsl:when>
        <xsl:when test="$code = 'f'">federal or national government publication</xsl:when>
        <xsl:when test="$code = 'i'">international intergovernmental government publication</xsl:when>
        <xsl:when test="$code = 'l'">local government publication</xsl:when>
        <xsl:when test="$code = 'm'">multistate government publication</xsl:when>
        <xsl:when test="$code = 'o'">government publication</xsl:when>
        <xsl:when test="$code = 's'">state, provincial, territorial, dependant government publication</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$govdoc != ''">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcgt,'gov')"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="$govdoc"/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
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
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($genreForms,'gf2014026068')"/></xsl:attribute>
              <rdfs:label>conference papers and proceedings</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
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
      <xsl:for-each select="$codeMaps/maps/mapform/*[name() = substring($form,$i,1)]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
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
    <xsl:for-each select="$codeMaps/maps/musicCompForm/*[name() = $code]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
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
    <xsl:for-each select="$codeMaps/maps/musicFormat/*[name() = $code]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
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
    <xsl:if test="$i &lt; 7">
      <xsl:for-each select="$codeMaps/maps/musicSuppContent/*[name() = substring($accomp,$i,1)]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
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
      <xsl:for-each select="$codeMaps/maps/musicTextForm/*[name() = substring($litform,$i,1)]">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
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

  <xsl:template match="marc:controlfield[@tag='006']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType"/>
    <!-- select call appropriate 008 template based on pos 0 -->
    <xsl:choose>
      <!-- books -->
      <xsl:when test="substring(.,1,1) = 'a' or
                      substring(.,1,1) = 't'">
        <xsl:call-template name="instance008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:call-template name="instance008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="substring(.,1,1) = 'e' or
                      substring(.,1,1) = 'f'">
        <xsl:call-template name="instance008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- mixed materials -->
      <xsl:when test="substring(.,1,1) = 'p'">
        <xsl:call-template name="instance008mixed">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- music -->
      <xsl:when test="substring(.,1,1) = 'c' or
                      substring(.,1,1) = 'd' or
                      substring(.,1,1) = 'i' or
                      substring(.,1,1) = 'j'">
        <xsl:call-template name="instance008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="substring(.,1,1) = 's'">
        <xsl:call-template name="instance008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- visual materials -->
      <xsl:when test="substring(.,1,1) = 'g' or
                      substring(.,1,1) = 'k' or
                      substring(.,1,1) = 'o' or
                      substring(.,1,1) = 'r'">
        <xsl:call-template name="instance008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='008']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType"/>
    <xsl:variable name="vDate1">
      <xsl:choose>
        <xsl:when test="substring(.,8,4) = '    '"/>
        <xsl:when test="substring(.,8,4) = '||||'"/>
        <xsl:otherwise>
          <xsl:value-of select="substring(.,8.4)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vDate2">
      <xsl:choose>
        <xsl:when test="substring(.,12,4) = '    '"/>
        <xsl:when test="substring(.,12,4) = '||||'"/>
        <xsl:otherwise>
          <xsl:value-of select="substring(.,12,4)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="provisionDate">
      <xsl:choose>
        <xsl:when test="substring(.,7,1) = 'c'">
          <xsl:call-template name="u2x">
            <xsl:with-param name="dateString" select="concat(substring(.,8,4),'/..')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="substring(.,7,1) = 'd' or
                        substring(.,7,1) = 'i' or
                        substring(.,7,1) = 'k' or
                        substring(.,7,1) = 'm' or
                        substring(.,7,1) = 'q' or
                        substring(.,7,1) = 'u' or
                        (substring(.,7,1) = '|' and $vDate1 != '' and $vDate2 != '')">
          <xsl:call-template name="u2x">
            <xsl:with-param name="dateString" select="concat(substring(.,8,4),'/',substring(.,12,4))"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="substring(.,7,1) = 'e' or
                       (substring(.,7,1) = '|' and $vDate1 != '' and $vDate2 != '')">
          <xsl:choose>
            <xsl:when test="substring(.,14,2) = '  '">
              <xsl:call-template name="u2x">
                <xsl:with-param name="dateString" select="concat(substring(.,8,4),'-',substring(.,12,2))"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="u2x">
                <xsl:with-param name="dateString" select="concat(substring(.,8,4),'-',substring(.,12,2),'-',substring(.,14,2))"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="substring(.,7,1) = 'p' or
                        substring(.,7,1) = 'r' or
                        substring(.,7,1) = 's' or
                        substring(.,7,1) = 't' or
                       (substring(.,7,1) = '|' and $vDate1 != '')">
          <xsl:call-template name="u2x">
            <xsl:with-param name="dateString" select="substring(.,8,4)"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pubPlace">
      <xsl:choose>
        <xsl:when test="substring(.,18,1) = ' '"><xsl:value-of select="substring(.,16,2)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="substring(.,16,3)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="$provisionDate != ''">
            <bf:provisionActivity>
              <bf:ProvisionActivity>
                <xsl:choose>
                  <xsl:when test="substring(.,7,1) = 'c' or
                                  substring(.,7,1) = 'd' or
                                  substring(.,7,1) = 'e' or
                                  substring(.,7,1) = 'm' or
                                  substring(.,7,1) = 'q' or
                                  substring(.,7,1) = 'r' or
                                  substring(.,7,1) = 's' or
                                  substring(.,7,1) = 't' or
                                  substring(.,7,1) = 'u' or
                                  substring(.,7,1) = '|'">
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Publication')"/></xsl:attribute>
                    </rdf:type>
                  </xsl:when>
                  <xsl:when test="substring(.,7,1) = 'i' or
                                  substring(.,7,1) = 'k'">
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Production')"/></xsl:attribute>
                    </rdf:type>
                    <bf:note>
                      <bf:Note>
                        <xsl:choose>
                          <xsl:when test="substring(.,7,1) = 'i'">
                            <rdfs:label>inclusive collection dates</rdfs:label>
                          </xsl:when>
                          <xsl:otherwise>
                            <rdfs:label>bulk collection dates</rdfs:label>
                          </xsl:otherwise>
                        </xsl:choose>
                      </bf:Note>
                    </bf:note>
                  </xsl:when>
                  <xsl:when test="substring(.,7,1) = 'p'">
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Distribution')"/></xsl:attribute>
                    </rdf:type>
                  </xsl:when>
                </xsl:choose>
                <bf:date>
                  <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($edtf,'edtf')"/></xsl:attribute>
                  <xsl:value-of select="$provisionDate"/>
                </bf:date>
                <xsl:if test="$pubPlace != '' and $pubPlace != '|||'">
                  <xsl:variable name="pubPlaceEncoded">
                    <xsl:call-template name="url-encode">
                      <xsl:with-param name="str" select="normalize-space($pubPlace)"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <bf:place>
                    <bf:Place>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,$pubPlaceEncoded)"/></xsl:attribute>
                    </bf:Place>
                  </bf:place>
                </xsl:if>
              </bf:ProvisionActivity>
            </bf:provisionActivity>
            <xsl:choose>
              <xsl:when test="substring(.,7,1) = 'c'">
                <bf:note>
                  <bf:Note>
                    <rdfs:label>Currently published</rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:when>
              <xsl:when test="substring(.,7,1) = 'd'">
                <bf:note>
                  <bf:Note>
                    <rdfs:label>Ceased publication</rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:when>
              <xsl:when test="substring(.,7,1) = 'p'">
                <bf:provisionActivity>
                  <bf:ProvisionActivity>
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Production')"/></xsl:attribute>
                    </rdf:type>
                    <bf:date>
                      <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($edtf,'edtf')"/></xsl:attribute>
                      <xsl:call-template name="u2x">
                        <xsl:with-param name="dateString" select="substring(.,12,4)"/>
                      </xsl:call-template>
                    </bf:date>
                  </bf:ProvisionActivity>
                </bf:provisionActivity>
              </xsl:when>
              <xsl:when test="substring(.,7,1) = 't'">
                <bf:copyrightDate>
                  <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($edtf,'edtf')"/></xsl:attribute>
                  <xsl:call-template name="u2x">
                    <xsl:with-param name="dateString" select="substring(.,12,4)"/>
                  </xsl:call-template>
                </bf:copyrightDate>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$pubPlace != '' and $pubPlace != '|||'">
              <xsl:variable name="pubPlaceEncoded">
                <xsl:call-template name="url-encode">
                  <xsl:with-param name="str" select="normalize-space($pubPlace)"/>
                </xsl:call-template>
              </xsl:variable>
              <bf:provisionActivity>
                <bf:ProvisionActivity>
                  <rdf:type>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Publication')"/></xsl:attribute>
                  </rdf:type>
                  <bf:place>
                    <bf:Place>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,$pubPlaceEncoded)"/></xsl:attribute>
                    </bf:Place>
                  </bf:place>
                </bf:ProvisionActivity>
              </bf:provisionActivity>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <!-- books -->
      <xsl:when test="(substring(../marc:leader,7,1) = 'a' or substring(../marc:leader,7,1 = 't')) and
                      (substring(../marc:leader,8,1) = 'a' or substring(../marc:leader,8,1) = 'c' or substring(../marc:leader,8,1) = 'd' or substring(../marc:leader,8,1) = 'm')">
        <xsl:call-template name="instance008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="leader" select="../marc:leader"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="substring(../marc:leader,7,1) = 'm'">
        <xsl:call-template name="instance008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="substring(../marc:leader,7,1) = 'e' or substring(../marc:leader,7,1) = 'f'">
        <xsl:call-template name="instance008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- music -->
      <xsl:when test="substring(../marc:leader,7,1) = 'c' or
                      substring(../marc:leader,7,1) = 'd' or
                      substring(../marc:leader,7,1) = 'i' or
                      substring(../marc:leader,7,1) = 'j'">
        <xsl:call-template name="instance008music">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="substring(../marc:leader,7,1) = 'a' and
                      (substring(../marc:leader,8,1) = 'b' or
                        substring(../marc:leader,8,1) = 'i' or
                        substring(../marc:leader,8,1) = 's')">
        <xsl:call-template name="instance008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- visual materials -->
      <xsl:when test="substring(../marc:leader,7,1) = 'g' or
                      substring(../marc:leader,7,1) = 'k' or
                      substring(../marc:leader,7,1) = 'o' or
                      substring(../marc:leader,7,1) = 'r'">
        <xsl:call-template name="instance008visual">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
          <xsl:with-param name="pInstanceType" select="$pInstanceType"/>
        </xsl:call-template>
      </xsl:when>
      <!-- mixed materials -->
      <xsl:when test="substring(../marc:leader,7,1) = 'p'">
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
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
    </xsl:call-template>
    <xsl:variable name="vAddInstanceType">
      <xsl:choose>
        <xsl:when test="substring($dataElements,6,1) = 'o' or substring($dataElements,6,1) = 's'">
          <xsl:if test="$pInstanceType != 'Electronic'">Electronic</xsl:if>
        </xsl:when>
        <xsl:when test="substring($dataElements,6,1) = 'r'">
          <xsl:if test="$pInstanceType != 'Print'">Print</xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
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
                <rdfs:label>braille</rdfs:label>
              </bf:TactileNotation>
            </bf:notation>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="$vAddInstanceType != ''">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$vAddInstanceType)"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- dataElements for computer files -->
  <xsl:template name="instance008computerfiles">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:if test="substring($dataElements,6,1) = 'o' or substring($dataElements,6,1) = 'q'">
      <xsl:call-template name="carrier008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>  

  <!-- data elements for maps -->
  <xsl:template name="instance008maps">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:for-each select="$codeMaps/maps/carttype/*[name() = substring($dataElements,8,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:if test="@prop = 'issuance'">
            <bf:issuance>
              <bf:Issuance>
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:Issuance>
            </bf:issuance>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,12,1)"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- data elements for music -->
  <xsl:template name="instance008music">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- data elements for continuing resources -->
  <xsl:template name="instance008cr">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
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
    <xsl:for-each select="$codeMaps/maps/crtype/*[name() = substring($dataElements,4,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="$codeMaps/maps/carrier/*[name() = substring($dataElements,5,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:note>
            <bf:Note>
              <xsl:if test="@href">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <bf:noteType>form of original item</bf:noteType>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- data elements for visual materials -->
  <xsl:template name="instance008visual">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,12,1)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="substring($dataElements,17,1) = '|'">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:note>
              <bf:Note>
                <bf:noteType>technique</bf:noteType>
                <rdfs:label>no attempt to code</rdfs:label>
              </bf:Note>
            </bf:note>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$codeMaps/maps/technique/*[name() = substring($dataElements,17,1)]">
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bf:note>
                <bf:Note>
                  <xsl:if test="@href != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                  </xsl:if>
                  <bf:noteType>technique</bf:noteType>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- data elements for mixed materials -->
  <xsl:template name="instance008mixed">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
    </xsl:call-template>
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
    <xsl:for-each select="$codeMaps/maps/carrier/*[name() = $code]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:carrier>
            <bf:Carrier>
              <xsl:if test="@href">
                <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:if>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Carrier>
          </bf:carrier>
        </xsl:when>
      </xsl:choose>
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
                <bflc:relief>
                  <bflc:Relief>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                    <rdfs:label><xsl:value-of select="."/></rdfs:label>
                  </bflc:Relief>
                </bflc:relief>
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
    <xsl:if test="$code = '1'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:supplementaryContent>
            <bf:SupplementaryContent rdf:about="http://id.loc.gov/vocabulary/msupplcont/index">
              <rdfs:label>Index present</rdfs:label>
            </bf:SupplementaryContent>
          </bf:supplementaryContent>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
