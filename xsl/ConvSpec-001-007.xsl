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
      Conversion specs for 001-007
  -->

  <xsl:template match="marc:controlfield[@tag='001']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:identifiedBy>
          <bf:Local>
            <rdf:value><xsl:value-of select="."/></rdf:value>
            <bf:assigner>
              <bf:Agent>
                <xsl:choose>
                  <xsl:when test="../marc:controlfield[@tag='003'] = 'DLC' or ../marc:controlfield[@tag='003'] = ''">
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/organizations/dlc</xsl:attribute>
                    <bf:code>DLC</bf:code>
                  </xsl:when>
                  <xsl:when test="not(../marc:controlfield[@tag='003'])">
                    <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/organizations/dlc</xsl:attribute>
                    <bf:code>DLC</bf:code>
                  </xsl:when>
                  <xsl:otherwise>
                    <bf:code><xsl:value-of select="../marc:controlfield[@tag='003']" /></bf:code>
                  </xsl:otherwise>
                </xsl:choose>
              </bf:Agent>
            </bf:assigner>
          </bf:Local>
        </bf:identifiedBy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:controlfield[@tag='005']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="changeDate" select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2),'T',substring(.,9,2),':',substring(.,11,2),':',substring(.,13,2))"/>
    <xsl:if test="not (starts-with($changeDate, '0000'))">
      <xsl:choose>
        <xsl:when test="$serialization= 'rdfxml'">
          <bf:changeDate>
            <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>dateTime</xsl:attribute>
            <xsl:value-of select="$changeDate"/>
          </bf:changeDate>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='007']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vNodeId" select="generate-id(.)"/>
    <xsl:variable name="workType">
      <xsl:choose>
        <xsl:when test="contains('ad',substring(.,1,1)) and
                        substring(../marc:leader,7,1) != 'e' and
                        substring(../marc:leader,7,1) != 'f'">Cartography</xsl:when>
        <xsl:when test="substring(.,1,1) = 'c' and
                        substring(../marc:leader,7,1) != 'm'">Multimedia</xsl:when>
        <xsl:when test="contains('gk',substring(.,1,1)) and
                        substring(../marc:leader,7,1) != 'k'">StillImage</xsl:when>
        <xsl:when test="substring(.,1,1) = 'h' and
                        substring(../marc:leader,7,1) != 'a' and
                        substring(../marc:leader,7,1) != 't'">Text</xsl:when>
        <xsl:when test="contains('mv',substring(.,1,1)) and
                        substring(../marc:leader,7,1) != 'g'">MovingImage</xsl:when>
        <xsl:when test="substring(.,1,1) = 's' and
                        substring(../marc:leader,7,1) != 'i' and
                        substring(../marc:leader,7,1) != 'j'">Audio</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$workType != ''">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$workType)"/></xsl:attribute>
          </rdf:type>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:variable name="vContentType">
      <xsl:choose>
        <xsl:when test="substring(.,1,1) = 'a'">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'q'">crf</xsl:when>
            <xsl:when test="contains('dgjkrsy',substring(.,2,1)) and
                            substring(../marc:leader,7,1) != 'e' and
                            substring(../marc:leader,7,1) != 'f'">cri</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="substring(.,1,1) = 'd'">crf</xsl:when>
        <xsl:when test="contains('gk',substring(.,1,1)) and
                        substring(../marc:leader,7,1) != 'k'">sti</xsl:when>
        <xsl:when test="contains('mv',substring(.,1,1)) and
                        substring(../marc:leader,7,1) != 'g'">tdi</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$vContentType != '' and
                  not(../marc:datafield[@tag='336'])">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:content>
            <bf:Content>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($contentType,$vContentType)"/></xsl:attribute>
              <rdfs:label>
                <xsl:choose>
                  <xsl:when test="$vContentType='crf'">cartographic three-dimensional form</xsl:when>
                  <xsl:when test="$vContentType='cri'">cartographic image</xsl:when>
                  <xsl:when test="$vContentType='tdi'">two-dimensional moving image</xsl:when>
                  <xsl:when test="$vContentType='sti'">still image</xsl:when>
                </xsl:choose>
              </rdfs:label>
            </bf:Content>
          </bf:content>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:choose>
      <!-- map -->
      <xsl:when test="substring(.,1,1) = 'a'">
        <xsl:variable name="genreForm">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'">atlases</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">graphs</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">maps</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">cartographic materials</xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'">models (representations)</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">remote-sensing images</xsl:when>
            <xsl:when test="substring(.,2,1) = 's'">geological cross-sections</xsl:when>
            <xsl:when test="substring(.,2,1) = 'y'">views</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($genreForms,'gf2011026058')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'"><xsl:value-of select="concat($genreForms,'gf2014026061')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($genreForms,'gf2011026387')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'"><xsl:value-of select="concat($genreForms,'gf2011026113')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'"><xsl:value-of select="concat($genreForms,'gf2017027245')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($genreForms,'gf2011026530')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 's'"><xsl:value-of select="concat($genreForms,'gf2011026295')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'y'"><xsl:value-of select="concat($genreForms,'gf2018026045')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$genreForm != ''">
              <bf:genreForm>
                <bf:GenreForm>
                  <xsl:if test="$genreUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$genreUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$genreForm"/></rdfs:label>
                </bf:GenreForm>
                </bf:genreForm>
            </xsl:if>
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- electronic resource -->
      <xsl:when test="substring(.,1,1) = 'c'">
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'g'">gray scale</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'g'"><xsl:value-of select="concat($mcolor,'gry')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContent">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '">silent</xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'">sound</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContentURI">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '"><xsl:value-of select="concat($msoundcontent,'silent')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
            <xsl:if test="$soundContent != ''">
              <bf:soundContent>
                <bf:SoundContent>
                  <xsl:if test="$soundContentURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$soundContentURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$soundContent"/></rdfs:label>
                </bf:SoundContent>
              </bf:soundContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- globe -->
      <xsl:when test="substring(.,1,1) = 'd'">
        <xsl:variable name="genreForm">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'">celestial globes</xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'">globes</xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'">globes</xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'">globes</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreFormURI">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'"><xsl:value-of select="concat($genreForms,'gf2011026117')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'"><xsl:value-of select="concat($genreForms,'gf2011026300')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($genreForms,'gf2011026300')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'"><xsl:value-of select="concat($genreForms,'gf2011026300')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$genreForm != ''">
              <bf:genreForm>
                <bf:GenreForm>
                  <xsl:if test="$genreFormURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$genreFormURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$genreForm"/></rdfs:label>
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:if>
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- projected graphic -->
      <xsl:when test="substring(.,1,1) = 'g'">
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'h'">hand colored</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'g'"><xsl:value-of select="concat($mcolor,'hnd')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContent">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '">silent</xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'">sound</xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'">sound</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContentURI">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '"><xsl:value-of select="concat($msoundcontent,'silent')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
            <xsl:if test="$soundContent != ''">
              <bf:soundContent>
                <bf:SoundContent>
                  <xsl:if test="$soundContentURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$soundContentURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$soundContent"/></rdfs:label>
                </bf:SoundContent>
              </bf:soundContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- microform -->
      <xsl:when test="substring(.,1,1) = 'h'">
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,10,1) = 'c'">color</xsl:when>
            <xsl:when test="substring(.,10,1) = 'm'">mixed color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- nonprojected graphic -->
      <xsl:when test="substring(.,1,1) = 'k'">
        <xsl:variable name="genreForm">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'">collages</xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'">drawing</xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'">paintings</xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'">photomechanical print</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">negatives (photographs)</xsl:when>
            <xsl:when test="substring(.,2,1) = 'h'">photographic prints</xsl:when>
            <xsl:when test="substring(.,2,1) = 'i'">picture</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">prints</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">posters</xsl:when>
            <xsl:when test="substring(.,2,1) = 'l'">scientific illustrations</xsl:when>
            <xsl:when test="substring(.,2,1) = 'n'">wall charts</xsl:when>
            <xsl:when test="substring(.,2,1) = 'p'">postcards</xsl:when>
            <xsl:when test="substring(.,2,1) = 'v'">photographs</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreFormUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($genreForms,'gf2017027227')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($graphicMaterials,'tgm003277')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'"><xsl:value-of select="concat($genreForms,'gf2017027246')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'"><xsl:value-of select="concat($graphicMaterials,'tgm007730')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'"><xsl:value-of select="concat($genreForms,'gf2019026026')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'h'"><xsl:value-of select="concat($graphicMaterials,'tgm007718')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'i'"><xsl:value-of select="concat($genreForms,'gf2017027251')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($genreForms,'gf2017027255')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'"><xsl:value-of select="concat($genreForms,'gf2014026152')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'l'"><xsl:value-of select="concat($graphicMaterials,'tgm009250')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'n'"><xsl:value-of select="concat($genreForms,'gf2016026011')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'p'"><xsl:value-of select="concat($genreForms,'gf2014026151')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'v'"><xsl:value-of select="concat($genreForms,'gf2017027249')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'h'">hand colored</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'h'"><xsl:value-of select="concat($mcolor,'hnd')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$genreForm != ''">
              <bf:genreForm>
                <bf:GenreForm>
                  <xsl:if test="$genreFormUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$genreFormUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$genreForm"/></rdfs:label>
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:if>
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- motion picture -->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'h'">hand colored</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'h'"><xsl:value-of select="concat($mcolor,'hnd')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vAspectRatioURI">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmaspect,'nonana')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmaspect,'ana')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmaspect,'wide')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vAspectRatioLabel">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'b'">non-anamorphic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">anamorphic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">wide-screen</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vAspectRatioURI2">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmaspect,'wide')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmaspect,'wide')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vAspectRatioLabel2">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'b'">wide-screen</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">wide-screen</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vAspectRatioNote">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'b'">non-anamorphic (wide-screen)</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">anamorphic (wide-screen)</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContent">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '">silent</xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'">sound</xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'">sound</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContentURI">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '"><xsl:value-of select="concat($msoundcontent,'silent')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreForm2">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'c'">outtakes</xsl:when>
            <xsl:when test="substring(.,10,1) = 'd'">rushes</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreForm2Uri">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'c'"><xsl:value-of select="concat($genreForms,'gf2011026435')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 'd'"><xsl:value-of select="concat($genreForms,'gf2011026551')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
            <xsl:if test="$vAspectRatioURI != ''">
              <bf:aspectRatio>
                <bf:AspectRatio>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vAspectRatioURI"/></xsl:attribute>
                    <xsl:if test="$vAspectRatioLabel != ''">
                        <rdfs:label><xsl:value-of select="$vAspectRatioLabel"/></rdfs:label>
                    </xsl:if>
                </bf:AspectRatio>
              </bf:aspectRatio>
            </xsl:if>
            <xsl:if test="$vAspectRatioURI2 != ''">
              <bf:aspectRatio>
                <bf:AspectRatio>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vAspectRatioURI2"/></xsl:attribute>
                    <xsl:if test="$vAspectRatioLabel2 != ''">
                        <rdfs:label><xsl:value-of select="$vAspectRatioLabel2"/></rdfs:label>
                    </xsl:if>
                </bf:AspectRatio>
              </bf:aspectRatio>
            </xsl:if>
            <xsl:if test="$vAspectRatioNote != ''">
              <bf:aspectRatio>
                <bf:AspectRatio>
                  <bf:note>
                    <bf:Note>
                      <rdfs:label><xsl:value-of select="$vAspectRatioNote"/></rdfs:label>
                    </bf:Note>
                  </bf:note>
                </bf:AspectRatio>
              </bf:aspectRatio>
            </xsl:if>
            <xsl:if test="$soundContent != ''">
              <bf:soundContent>
                <bf:SoundContent>
                  <xsl:if test="$soundContentURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$soundContentURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$soundContent"/></rdfs:label>
                </bf:SoundContent>
              </bf:soundContent>
            </xsl:if>
            <xsl:if test="$genreForm2 != ''">
              <bf:genreForm>
                <bf:GenreForm>
                  <xsl:if test="$genreForm2Uri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$genreForm2Uri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$genreForm2"/></rdfs:label>
                </bf:GenreForm>
              </bf:genreForm>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- no Work properties for sound recording other than rdf:type -->
      <!-- videorecording -->
      <xsl:when test="substring(.,1,1) = 'v'">
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed color</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContent">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '">silent</xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'">sound</xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'">sound</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContentURI">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '"><xsl:value-of select="concat($msoundcontent,'silent')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'"><xsl:value-of select="concat($msoundcontent,'sound')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
            <xsl:if test="$soundContent != ''">
              <bf:soundContent>
                <bf:SoundContent>
                  <xsl:if test="$soundContentURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$soundContentURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$soundContent"/></rdfs:label>
                </bf:SoundContent>
              </bf:soundContent>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='007']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vMediaTypeLabel">
      <xsl:choose>
        <xsl:when test="substring(.,1,1) = 'a'">unmediated</xsl:when>
        <xsl:when test="substring(.,1,1) = 'c'">computer</xsl:when>
        <xsl:when test="substring(.,1,1) = 'g'">projected</xsl:when>
        <xsl:when test="substring(.,1,1) = 'h'">microform</xsl:when>
        <xsl:when test="substring(.,1,1) = 'k'">unmediated</xsl:when>
        <xsl:when test="substring(.,1,1) = 'm'">projected</xsl:when>
        <xsl:when test="substring(.,1,1) = 's'">audio</xsl:when>
        <xsl:when test="substring(.,1,1) = 'v'">video</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vMediaTypeCode">
      <xsl:choose>
        <xsl:when test="substring(.,1,1) = 'a'">n</xsl:when>
        <xsl:when test="substring(.,1,1) = 'c'">c</xsl:when>
        <xsl:when test="substring(.,1,1) = 'g'">g</xsl:when>
        <xsl:when test="substring(.,1,1) = 'h'">h</xsl:when>
        <xsl:when test="substring(.,1,1) = 'k'">n</xsl:when>
        <xsl:when test="substring(.,1,1) = 'm'">g</xsl:when>
        <xsl:when test="substring(.,1,1) = 's'">s</xsl:when>
        <xsl:when test="substring(.,1,1) = 'v'">v</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$vMediaTypeLabel != '' and not(../marc:datafield[@tag='337'])">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:media>
            <bf:Media>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($mediaType,$vMediaTypeCode)"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="$vMediaTypeLabel"/></rdfs:label>
            </bf:Media>
          </bf:media>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:choose>
      <!-- map -->
      <xsl:when test="substring(.,1,1) = 'a'">
        <xsl:variable name="vCarrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($carriers,'nc')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'"><xsl:value-of select="concat($carriers,'nb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($carriers,'nb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'"><xsl:value-of select="concat($carriers,'nb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'"><xsl:value-of select="concat($carriers,'nr')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($carriers,'nb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 's'"><xsl:value-of select="concat($carriers,'nb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'y'"><xsl:value-of select="concat($carriers,'nb')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vCarrierLabel">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'">volume</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">sheet</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">sheet</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">sheet</xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'">object</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">sheet</xsl:when>
            <xsl:when test="substring(.,2,1) = 's'">sheet</xsl:when>
            <xsl:when test="substring(.,2,1) = 'y'">sheet</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">paper</xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'">wood</xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'">stone</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">metal</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">skin</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">textile</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">plastic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">glass</xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'">vinyl</xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'">vellum</xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'">plaster</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">leather</xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'">parchment</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mmaterial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmaterial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mmaterial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mmaterial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mmaterial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mmaterial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mmaterial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'"><xsl:value-of select="concat($mmaterial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'"><xsl:value-of select="concat($mmaterial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mmaterial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mmaterial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'"><xsl:value-of select="concat($mmaterial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'">facsimile</xsl:when>
            <xsl:when test="substring(.,6,1) = 'z'">mixed generation</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generationURI">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'"><xsl:value-of select="concat($mgeneration,'facsimile')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'z'"><xsl:value-of select="concat($mgeneration,'mixedgen')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="productionMethod">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">blueline process</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">photocopying</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="productionMethodURI">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'"><xsl:value-of select="concat($mproduction,'blueline')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'"><xsl:value-of select="concat($mproduction,'photocopy')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarity">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'">positive</xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'">negative</xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'">mixed</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarityUri">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'"><xsl:value-of select="concat($mpolarity,'pos')"/></xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'"><xsl:value-of select="concat($mpolarity,'neg')"/></xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'"><xsl:value-of select="concat($mpolarity,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$vCarrierLabel != '' and not(../marc:datafield[@tag='338'])">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:if test="$vCarrierUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vCarrierUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$vCarrierLabel"/></rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <xsl:if test="$generationURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$generationURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$productionMethod != ''">
              <bf:productionMethod>
                <bf:ProductionMethod>
                  <xsl:if test="$productionMethodURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$productionMethodURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$productionMethod"/></rdfs:label>
                </bf:ProductionMethod>
              </bf:productionMethod>
            </xsl:if>
            <xsl:if test="$polarity != ''">
              <bf:polarity>
                <bf:Polarity>
                  <xsl:if test="$polarityUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$polarityUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$polarity"/></rdfs:label>
                </bf:Polarity>
              </bf:polarity>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- electronic resource -->
      <xsl:when test="substring(.,1,1) = 'c'">
        <xsl:variable name="carrier">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'">computer tape cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'">computer chip cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'">computer disc cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'">computer disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'">computer disc cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'">computer tape cassette</xsl:when>
            <xsl:when test="substring(.,2,1) = 'h'">computer tape reel</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">computer disc cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">computer card</xsl:when>
            <xsl:when test="substring(.,2,1) = 'm'">computer disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'">computer disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">online resource</xsl:when>
            <xsl:when test="substring(.,2,1) = 'z'">other computer carrier</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="carrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'"><xsl:value-of select="concat($carriers,'ca')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'"><xsl:value-of select="concat($carriers,'cb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($carriers,'ce')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($carriers,'cd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'"><xsl:value-of select="concat($carriers,'ce')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'"><xsl:value-of select="concat($carriers,'cf')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'h'"><xsl:value-of select="concat($carriers,'ch')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($carriers,'ce')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'"><xsl:value-of select="concat($carriers,'ck')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'm'"><xsl:value-of select="concat($carriers,'cd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'"><xsl:value-of select="concat($carriers,'cd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($carriers,'cr')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'z'"><xsl:value-of select="concat($carriers,'cz')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimensions">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">3 1/2 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">12 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">4 3/4 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">1 1/8 x 2 3/8 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">3 7/8 x 2 1/2 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">5 1/4 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'u'">unknown</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">8 in.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="substring(../marc:leader,7,1) != 'm'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Electronic')"/></xsl:attribute>
              </rdf:type>
            </xsl:if>
            <xsl:if test="$carrier != '' and not(../marc:datafield[@tag='338'])">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:if test="$carrierUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$carrierUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$carrier"/></rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$dimensions != '' and not(../marc:datafield[@tag='300']/marc:subfield[@code='c'])">
              <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- globe -->
      <xsl:when test="substring(.,1,1) = 'd'">
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">paper</xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'">wood</xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'">stone</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">metal</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">skin</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">textile</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">plastic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">glass</xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'">vinyl</xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'">vellum</xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'">plaster</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">leather</xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'">parchment</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mmaterial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmaterial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mmaterial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mmaterial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mmaterial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mmaterial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mmaterial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'"><xsl:value-of select="concat($mmaterial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'"><xsl:value-of select="concat($mmaterial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mmaterial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mmaterial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'"><xsl:value-of select="concat($mmaterial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'">facsimile</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generationUri">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'"><xsl:value-of select="concat($mgeneration,'facsimile')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="not(../marc:datafield[@tag='337'])">
              <bf:media>
                <bf:Media>
                  <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mediaTypes/n</xsl:attribute>
                  <rdfs:label>unmediated</rdfs:label>
                </bf:Media>
              </bf:media>
            </xsl:if>
            <xsl:if test="not(../marc:datafield[@tag='338'])">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/carriers/nr</xsl:attribute>
                  <rdfs:label>object</rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <xsl:if test="$generationUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$generationUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- projected graphic -->
      <xsl:when test="substring(.,1,1) = 'g'">
        <xsl:variable name="carrier">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'">filmstrip cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'">filmslip</xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'">filmstrip</xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'">film roll</xsl:when>
            <xsl:when test="substring(.,2,1) = 's'">slide</xsl:when>
            <xsl:when test="substring(.,2,1) = 't'">overhead transparency</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="carrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($carriers,'gc')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($carriers,'gd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'"><xsl:value-of select="concat($carriers,'gf')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'"><xsl:value-of select="concat($carriers,'mo')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 's'"><xsl:value-of select="concat($carriers,'gs')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 't'"><xsl:value-of select="concat($carriers,'gt')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'd'">glass</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">safety base</xsl:when>
            <xsl:when test="substring(.,5,1) = 'k'">non-safety base</xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'">mixed material</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">paper</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmaterial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'k'"><xsl:value-of select="concat($mmaterial,'nsf')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'"><xsl:value-of select="concat($mmaterial,'pap')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMedium">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">magneto-optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'">magneto-optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'">optical</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMediumURI">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'"><xsl:value-of select="concat($mrecmedium,'opt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'"><xsl:value-of select="concat($mrecmedium,'magopt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'"><xsl:value-of select="concat($mrecmedium,'magopt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'"><xsl:value-of select="concat($mrecmedium,'opt')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimensions">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'">standard 8 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'">super 8 mm., single 8 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'c'">9.5 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'd'">16 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'e'">28 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'f'">35 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'g'">70 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'j'">2x2 in. or 5x5 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'k'">2 1/4 in. x 2 1/4 in. or 6x6 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 's'">4x5 in. or 10x13 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 't'">15x7 in. or 13x18 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'v'">18x10 in. or 21x26 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'w'">9x9 in. or 23x23 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'x'">10x10 in. or 26x26 cm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'y'">17x7 in. or 18x18 cm.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mount">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'c'">cardboard</xsl:when>
            <xsl:when test="substring(.,9,1) = 'd'">glass</xsl:when>
            <xsl:when test="substring(.,9,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,9,1) = 'h'">metal</xsl:when>
            <xsl:when test="substring(.,9,1) = 'j'">metal</xsl:when>
            <xsl:when test="substring(.,9,1) = 'k'">synthetic</xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'">mixed material</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mount2">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'j'">glass</xsl:when>
            <xsl:when test="substring(.,9,1) = 'k'">glass</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mountUri">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'c'"><xsl:value-of select="concat($mmaterial,'crd')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'd'"><xsl:value-of select="concat($mmaterial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'e'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'h'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'j'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'k'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mountUri2">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'j'"><xsl:value-of select="concat($mmaterial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'k'"><xsl:value-of select="concat($mmaterial,'gls')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$carrier != '' and not(../marc:datafield[@tag='338'])">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:if test="$carrierUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$carrierUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$carrier"/></rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$recordingMedium != ''">
              <bf:soundCharacteristic>
                <bf:RecordingMedium>
                  <xsl:if test="$recordingMediumURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$recordingMediumURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$recordingMedium"/></rdfs:label>
                </bf:RecordingMedium>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$dimensions != '' and not(../marc:datafield[@tag='300']/marc:subfield[@code='c'])">
              <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
            </xsl:if>
            <xsl:if test="$mount != ''">
              <bf:mount>
                <bf:Mount>
                  <xsl:if test="$mountUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$mountUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$mount"/></rdfs:label>
                </bf:Mount>
              </bf:mount>
            </xsl:if>
            <xsl:if test="$mount2 != ''">
              <bf:mount>
                <bf:Mount>
                  <xsl:if test="$mountUri2 != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$mountUri2"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$mount2"/></rdfs:label>
                </bf:Mount>
              </bf:mount>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- microform -->
      <xsl:when test="substring(.,1,1) = 'h'">
        <xsl:variable name="vCarrier">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'">aperture card</xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'">microfilm cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'">microfilm cassette</xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'">microfilm reel</xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'">microfiche</xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'">microfiche cassette</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">microopaque</xsl:when>
            <xsl:when test="substring(.,2,1) = 'h'">microfilm slip</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">microfilm roll</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="carrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'"><xsl:value-of select="concat($carriers,'ha')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'"><xsl:value-of select="concat($carriers,'hb')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($carriers,'hc')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($carriers,'hd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'"><xsl:value-of select="concat($carriers,'he')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'"><xsl:value-of select="concat($carriers,'hf')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'"><xsl:value-of select="concat($carriers,'hg')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'h'"><xsl:value-of select="concat($carriers,'hh')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($carriers,'hj')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarity">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">positive</xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'">negative</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed polarity</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarityUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mpolarity,'pos')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mpolarity,'neg')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mpolarity,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimensions">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">8 mm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">16 mm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">35 mm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">70 mm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'h'">105 mm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'">13x5 in. or 8x13 cm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'">4x6 in. or 11x15 cm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">6x9 in. or 16x23 cm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'">3 1/4 x 7 3/8 in. or 9x19 cm.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="reductionRatioRangeValue"><xsl:value-of select="substring(.,6,1)" /></xsl:variable>
        <xsl:variable name="reductionRatioRange">
          <xsl:value-of select="$codeMaps/maps/reductionRatioRange/*[name() = $reductionRatioRangeValue]" />
        </xsl:variable>
        <xsl:variable name="reductionRatioRangeUri">
          <xsl:value-of select="$codeMaps/maps/reductionRatioRange/*[name() = $reductionRatioRangeValue]/@href" />
        </xsl:variable>
        <xsl:variable name="reductionRatio">
          <xsl:choose>
            <xsl:when test="substring(.,7,3) = '|||'"/>
            <xsl:when test="substring(.,7,3) = '---'"/>
            <xsl:otherwise><xsl:value-of select="substring(.,7,3)"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="emulsion">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'a'">silver halide emulsion</xsl:when>
            <xsl:when test="substring(.,11,1) = 'b'">diazo emulsion</xsl:when>
            <xsl:when test="substring(.,11,1) = 'c'">vesicular emulsion</xsl:when>
            <xsl:when test="substring(.,11,1) = 'm'">mixed material</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="emulsionUri">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'a'"><xsl:value-of select="concat($mmaterial,'slh')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'b'"><xsl:value-of select="concat($mmaterial,'dia')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'c'"><xsl:value-of select="concat($mmaterial,'ves')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,12,1) = 'a'">first generation</xsl:when>
            <xsl:when test="substring(.,12,1) = 'b'">printing master</xsl:when>
            <xsl:when test="substring(.,12,1) = 'c'">service copy</xsl:when>
            <xsl:when test="substring(.,12,1) = 'm'">mixed generation</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generationURI">
          <xsl:choose>
            <xsl:when test="substring(.,12,1) = 'a'"><xsl:value-of select="concat($mgeneration,'firstgen')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'b'"><xsl:value-of select="concat($mgeneration,'printmaster')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'c'"><xsl:value-of select="concat($mgeneration,'servcopy')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'm'"><xsl:value-of select="concat($mgeneration,'mixedgen')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'a'">safety base</xsl:when>
            <xsl:when test="substring(.,13,1) = 'c'">acetate</xsl:when>
            <xsl:when test="substring(.,13,1) = 'd'">safety base</xsl:when>
            <xsl:when test="substring(.,13,1) = 'p'">polyester</xsl:when>
            <xsl:when test="substring(.,13,1) = 'r'">safety base, mixed</xsl:when>
            <xsl:when test="substring(.,13,1) = 't'">triacetate</xsl:when>
            <xsl:when test="substring(.,13,1) = 'i'">nitrate</xsl:when>
            <xsl:when test="substring(.,13,1) = 'm'">mixed material</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'a'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'c'"><xsl:value-of select="concat($mmaterial,'ace')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'd'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'p'"><xsl:value-of select="concat($mmaterial,'pol')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'r'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 't'"><xsl:value-of select="concat($mmaterial,'tri')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'i'"><xsl:value-of select="concat($mmaterial,'nit')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="count(../marc:datafield[@tag='338']) = 0 and $vCarrier != ''">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$carrierUri"/></xsl:attribute>
                  <rdfs:label><xsl:value-of select="$vCarrier"/></rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$polarity != ''">
              <bf:polarity>
                <bf:Polarity>
                  <xsl:if test="$polarityUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$polarityUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$polarity"/></rdfs:label>
                </bf:Polarity>
              </bf:polarity>
            </xsl:if>
            <xsl:if test="count(../marc:datafield[@tag='300']/marc:subfield[@code='c']) = 0 and $dimensions != ''">
              <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
            </xsl:if>
            <xsl:if test="$reductionRatioRange != ''">
              <bf:reductionRatio>
                <bf:ReductionRatio>
                  <xsl:if test="$reductionRatioRangeUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$reductionRatioRangeUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$reductionRatioRange"/></rdfs:label>
                </bf:ReductionRatio>
              </bf:reductionRatio>
            </xsl:if>
            <xsl:if test="$reductionRatio != ''">
              <bf:reductionRatio>
                <bf:ReductionRatio>
                    <rdfs:label><xsl:value-of select="$reductionRatio"/></rdfs:label>
                </bf:ReductionRatio>
              </bf:reductionRatio>
            </xsl:if>
            <xsl:if test="$emulsion != ''">
              <bf:emulsion>
                <bf:Emulsion>
                  <xsl:if test="$emulsionUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$emulsionUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$emulsion"/></rdfs:label>
                </bf:Emulsion>
              </bf:emulsion>
            </xsl:if>
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <xsl:if test="$generationURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$generationURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- nonprojected graphic -->
      <xsl:when test="substring(.,1,1) = 'k'">
        <xsl:variable name="vCarrier">
          <xsl:choose>
            <xsl:when test="contains('acdfghijklcopv',substring(.,1,1))">sheet</xsl:when>
            <xsl:when test="substring(.,1,1) = 'e'">object</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vCarrierUri">
          <xsl:choose>
            <xsl:when test="contains('acdfghijklcopv',substring(.,1,1))">http://id.loc.gov/vocabulary/carriers/nb</xsl:when>
            <xsl:when test="substring(.,1,1) = 'e'">http://id.loc.gov/vocabulary/carriers/nr</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">canvas</xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'">bristol board</xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'">cardboard</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">glass</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">skin</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">textile</xsl:when>
            <xsl:when test="substring(.,5,1) = 'h'">metal</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">plastic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'">vinyl</xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'">mixed material</xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'">vellum</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">paper</xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'">plaster</xsl:when>
            <xsl:when test="substring(.,5,1) = 'q'">hardboard</xsl:when>
            <xsl:when test="substring(.,5,1) = 'r'">porcelain</xsl:when>
            <xsl:when test="substring(.,5,1) = 's'">stone</xsl:when>
            <xsl:when test="substring(.,5,1) = 't'">wood</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">leather</xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'">parchment</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mmaterial,'can')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmaterial,'brb')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mmaterial,'crd')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmaterial,'gla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mmaterial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mmaterial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'h'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mmaterial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'"><xsl:value-of select="concat($mmaterial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'"><xsl:value-of select="concat($mmaterial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'"><xsl:value-of select="concat($mmaterial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mmaterial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'q'"><xsl:value-of select="concat($mmaterial,'hdb')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'r'"><xsl:value-of select="concat($mmaterial,'por')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 's'"><xsl:value-of select="concat($mmaterial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 't'"><xsl:value-of select="concat($mmaterial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mmaterial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'"><xsl:value-of select="concat($mmaterial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mount">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'a'">canvas</xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'">bristol board</xsl:when>
            <xsl:when test="substring(.,6,1) = 'c'">cardboard</xsl:when>
            <xsl:when test="substring(.,6,1) = 'd'">glass</xsl:when>
            <xsl:when test="substring(.,6,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,6,1) = 'f'">skin</xsl:when>
            <xsl:when test="substring(.,6,1) = 'g'">textile</xsl:when>
            <xsl:when test="substring(.,6,1) = 'h'">metal</xsl:when>
            <xsl:when test="substring(.,6,1) = 'i'">plastic</xsl:when>
            <xsl:when test="substring(.,6,1) = 'l'">vinyl</xsl:when>
            <xsl:when test="substring(.,6,1) = 'm'">mixed collection</xsl:when>
            <xsl:when test="substring(.,6,1) = 'n'">vellum</xsl:when>
            <xsl:when test="substring(.,6,1) = 'o'">paper</xsl:when>
            <xsl:when test="substring(.,6,1) = 'p'">plaster</xsl:when>
            <xsl:when test="substring(.,6,1) = 'q'">hardboard</xsl:when>
            <xsl:when test="substring(.,6,1) = 'r'">porcelain</xsl:when>
            <xsl:when test="substring(.,6,1) = 's'">stone</xsl:when>
            <xsl:when test="substring(.,6,1) = 't'">wood</xsl:when>
            <xsl:when test="substring(.,6,1) = 'v'">leather</xsl:when>
            <xsl:when test="substring(.,6,1) = 'w'">parchment</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mountUri">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'a'"><xsl:value-of select="concat($mmaterial,'can')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'"><xsl:value-of select="concat($mmaterial,'brb')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'c'"><xsl:value-of select="concat($mmaterial,'crd')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'd'"><xsl:value-of select="concat($mmaterial,'gla')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'e'"><xsl:value-of select="concat($mmaterial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'f'"><xsl:value-of select="concat($mmaterial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'g'"><xsl:value-of select="concat($mmaterial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'h'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'i'"><xsl:value-of select="concat($mmaterial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'l'"><xsl:value-of select="concat($mmaterial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'n'"><xsl:value-of select="concat($mmaterial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'o'"><xsl:value-of select="concat($mmaterial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'p'"><xsl:value-of select="concat($mmaterial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'q'"><xsl:value-of select="concat($mmaterial,'hdb')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'r'"><xsl:value-of select="concat($mmaterial,'por')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 's'"><xsl:value-of select="concat($mmaterial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 't'"><xsl:value-of select="concat($mmaterial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'v'"><xsl:value-of select="concat($mmaterial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,6,1) = 'w'"><xsl:value-of select="concat($mmaterial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="count(../marc:datafield[@tag='338']) = 0 and $vCarrier != ''">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$vCarrierUri"/></xsl:attribute>
                  <rdfs:label><xsl:value-of select="$vCarrier"/></rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$mount != ''">
              <bf:mount>
                <bf:Mount>
                  <xsl:if test="$mountUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$mountUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$mount"/></rdfs:label>
                </bf:Mount>
              </bf:mount>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- motion picture -->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:variable name="carrier">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'">film cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'">film cassette</xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'">film roll</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">film reel</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="carrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($carriers,'mc')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'"><xsl:value-of select="concat($carriers,'mf')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'"><xsl:value-of select="concat($carriers,'mo')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($carriers,'mr')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vPresentationFormat">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">standard sound aperture</xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'">3D</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">standard silent aperture</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vPresentationFormatURI">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mpresformat,'sound')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mpresformat,'3d')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mpresformat,'silent')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMedium">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">magneto-optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'">magneto-optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'">optical</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMediumURI">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'"><xsl:value-of select="concat($mrecmedium,'opt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'"><xsl:value-of select="concat($mrecmedium,'magopt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'"><xsl:value-of select="concat($mrecmedium,'magopt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'"><xsl:value-of select="concat($mrecmedium,'opt')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimensions">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'">8 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'">super 8 mm., single 8 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'c'">9.5 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'd'">16 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'e'">28 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'f'">35 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'g'">70 mm.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackChannels">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'k'">mixed</xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'">mono</xsl:when>
            <xsl:when test="substring(.,9,1) = 'q'">surround</xsl:when>
            <xsl:when test="substring(.,9,1) = 's'">stereo</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackUri">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'k'"><xsl:value-of select="concat($mplayback,'mix')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'"><xsl:value-of select="concat($mplayback,'mon')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'q'"><xsl:value-of select="concat($mplayback,'mul')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 's'"><xsl:value-of select="concat($mplayback,'ste')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarity">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'a'">positive</xsl:when>
            <xsl:when test="substring(.,11,1) = 'b'">negative</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarityUri">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'a'"><xsl:value-of select="concat($mpolarity,'pos')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'b'"><xsl:value-of select="concat($mpolarity,'neg')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,12,1) = 'd'">duplicate</xsl:when>
            <xsl:when test="substring(.,12,1) = 'e'">master</xsl:when>
            <xsl:when test="substring(.,12,1) = 'o'">original</xsl:when>
            <xsl:when test="substring(.,12,1) = 'r'">viewing copy</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generationURI">
          <xsl:choose>
            <xsl:when test="substring(.,12,1) = 'd'"><xsl:value-of select="concat($mgeneration,'dupe')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'e'"><xsl:value-of select="concat($mgeneration,'master')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'o'"><xsl:value-of select="concat($mgeneration,'original')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'r'"><xsl:value-of select="concat($mgeneration,'viewcopy')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'a'">safety base</xsl:when>
            <xsl:when test="substring(.,13,1) = 'c'">acetate</xsl:when>
            <xsl:when test="substring(.,13,1) = 'd'">safety base</xsl:when>
            <xsl:when test="substring(.,13,1) = 'p'">polyester</xsl:when>
            <xsl:when test="substring(.,13,1) = 'r'">safety base</xsl:when>
            <xsl:when test="substring(.,13,1) = 't'">triacetate</xsl:when>
            <xsl:when test="substring(.,13,1) = 'i'">nitrate base</xsl:when>
            <xsl:when test="substring(.,13,1) = 'm'">mixed material</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'a'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'c'"><xsl:value-of select="concat($mmaterial,'ace')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'd'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'p'"><xsl:value-of select="concat($mmaterial,'pol')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'r'"><xsl:value-of select="concat($mmaterial,'saf')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 't'"><xsl:value-of select="concat($mmaterial,'tri')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'i'"><xsl:value-of select="concat($mmaterial,'nit')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="count(../marc:datafield[@tag='338']) = 0 and $carrier != ''">
              <bf:carrier>
                <bf:Carrier>
                  <xsl:if test="$carrierUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$carrierUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$carrier"/></rdfs:label>
                </bf:Carrier>
              </bf:carrier>
            </xsl:if>
            <xsl:if test="$vPresentationFormat != '' and count(../marc:datafield[@tag='345']/marc:subfield[. = $vPresentationFormat]) = 0">
              <bf:projectionCharacteristic>
                <bf:PresentationFormat>
                  <xsl:if test="$vPresentationFormatURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vPresentationFormatURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$vPresentationFormat"/></rdfs:label>
                </bf:PresentationFormat>
              </bf:projectionCharacteristic>
            </xsl:if>
            <xsl:if test="$recordingMedium != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $recordingMedium]) = 0">
              <bf:soundCharacteristic>
                <bf:RecordingMedium>
                  <xsl:if test="$recordingMediumURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$recordingMediumURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$recordingMedium"/></rdfs:label>
                </bf:RecordingMedium>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="count(../marc:datafield[@tag='300']/marc:subfield[@code='c']) = 0 and $dimensions != ''">
              <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
            </xsl:if>
            <xsl:if test="$playbackChannels != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $playbackChannels]) = 0">
              <bf:soundCharacteristic>
                <bf:PlaybackChannels>
                  <xsl:if test="$playbackUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$playbackUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$playbackChannels"/></rdfs:label>
                </bf:PlaybackChannels>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$polarity != ''">
              <bf:polarity>
                <bf:Polarity>
                  <xsl:if test="$polarityUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$polarityUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$polarity"/></rdfs:label>
                </bf:Polarity>
              </bf:polarity>
            </xsl:if>
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <xsl:if test="$generationURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$generationURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- sound recording -->
      <xsl:when test="substring(.,1,1) = 's'">
        <xsl:variable name="carrier">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'">audio disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'">audio cylinder</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">audio cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'i'">sound track film</xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'">audio roll</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">online resource</xsl:when>
            <xsl:when test="substring(.,2,1) = 's'">audiocassette</xsl:when>
            <xsl:when test="substring(.,2,1) = 't'">audiotape reel</xsl:when>
            <xsl:when test="substring(.,2,1) = 'w'">audio wire reel</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="carrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($carriers,'sd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'"><xsl:value-of select="concat($carriers,'se')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'"><xsl:value-of select="concat($carriers,'sg')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'i'"><xsl:value-of select="concat($carriers,'si')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'"><xsl:value-of select="concat($carriers,'sq')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($carriers,'cr')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 's'"><xsl:value-of select="concat($carriers,'sg')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 't'"><xsl:value-of select="concat($carriers,'st')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'w'"><xsl:value-of select="concat($carriers,'sw')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="playingSpeedValue"><xsl:value-of select="substring(.,4,1)" /></xsl:variable>
        <xsl:variable name="playingSpeed">
          <xsl:value-of select="$codeMaps/maps/playbackSpeed/*[name() = $playingSpeedValue]" />
        </xsl:variable>
        <xsl:variable name="playingSpeedUri">
            <xsl:value-of select="$codeMaps/maps/playbackSpeed/*[name() = $playingSpeedValue]/@href" />
        </xsl:variable>

        <xsl:variable name="playbackChannels">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'm'">mono</xsl:when>
            <xsl:when test="substring(.,5,1) = 'q'">surround</xsl:when>
            <xsl:when test="substring(.,5,1) = 's'">stereo</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'm'"><xsl:value-of select="concat($mplayback,'mon')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'q'"><xsl:value-of select="concat($mplayback,'mul')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 's'"><xsl:value-of select="concat($mplayback,'ste')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="grooveCharacteristic">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'm'">
              <xsl:choose>
                <xsl:when test="contains('abce', substring(.,4,1))">microgroove</xsl:when>
                <xsl:when test="substring(.,4,1) = 'i'">fine pitch</xsl:when>
                <xsl:otherwise>microgroove</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="substring(.,6,1) = 's'">
              <xsl:choose>
                <xsl:when test="substring(.,4,1) = 'd'">coarse groove</xsl:when>
                <xsl:when test="substring(.,4,1) = 'h'">standard pitch</xsl:when>
                <xsl:otherwise>coarse groove</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="grooveCharacteristicURI">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'm'">
              <xsl:choose>
                <xsl:when test="contains('abce', substring(.,4,1))"><xsl:value-of select="concat($mgroove,'micro')"/></xsl:when>
                <xsl:when test="substring(.,4,1) = 'i'"><xsl:value-of select="concat($mgroove,'finepitch')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat($mgroove,'micro')"/></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="substring(.,6,1) = 's'">
              <xsl:choose>
                <xsl:when test="substring(.,4,1) = 'd'"><xsl:value-of select="concat($mgroove,'coarse')"/></xsl:when>
                <xsl:when test="substring(.,4,1) = 'h'"><xsl:value-of select="concat($mgroove,'stanpitch')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat($mgroove,'coarse')"/></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimensions">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">3 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">5 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">7 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">10 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'">12 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">16 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'">4 3/4 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'j'">3 7/8 x 2 1/2 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 'o'">5 1/4 x 3 7/8 in.</xsl:when>
            <xsl:when test="substring(.,7,1) = 's'">2 3/4 x 4 in.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="tapeWidth">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'l'">1/8 in. tape width</xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'">1/4 in. tape width</xsl:when>
            <xsl:when test="substring(.,8,1) = 'o'">1/2 in. tape width</xsl:when>
            <xsl:when test="substring(.,8,1) = 'p'">1 in. tape width</xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="tapeConfigValue"><xsl:value-of select="substring(.,9,1)" /></xsl:variable>
        <xsl:variable name="tapeConfig">
          <xsl:value-of select="$codeMaps/maps/tapeConfig/*[name() = $tapeConfigValue]" />
        </xsl:variable>
        <xsl:variable name="tapeConfigUri">
            <xsl:value-of select="$codeMaps/maps/tapeConfig/*[name() = $tapeConfigValue]/@href" />
        </xsl:variable>

        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'a'">master tape</xsl:when>
            <xsl:when test="substring(.,10,1) = 'b'">tape duplication master</xsl:when>
            <xsl:when test="substring(.,10,1) = 'd'">disc master</xsl:when>
            <xsl:when test="substring(.,10,1) = 'r'">mother</xsl:when>
            <xsl:when test="substring(.,10,1) = 's'">stamper</xsl:when>
            <xsl:when test="substring(.,10,1) = 't'">test pressing</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generationURI">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'a'"><xsl:value-of select="concat($mgeneration,'master')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 'b'"><xsl:value-of select="concat($mgeneration,'tapedupe')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 'd'"><xsl:value-of select="concat($mgeneration,'discmaster')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 'r'"><xsl:value-of select="concat($mgeneration,'mother')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 's'"><xsl:value-of select="concat($mgeneration,'stamper')"/></xsl:when>
            <xsl:when test="substring(.,10,1) = 't'"><xsl:value-of select="concat($mgeneration,'testpress')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'a'">lacquer</xsl:when>
            <xsl:when test="substring(.,11,1) = 'b'">nitrate</xsl:when>
            <xsl:when test="substring(.,11,1) = 'c'">acetate</xsl:when>
            <xsl:when test="substring(.,11,1) = 'g'">glass</xsl:when>
            <xsl:when test="substring(.,11,1) = 'i'">aluminum</xsl:when>
            <xsl:when test="substring(.,11,1) = 'r'">paper</xsl:when>
            <xsl:when test="substring(.,11,1) = 'l'">metal</xsl:when>
            <xsl:when test="substring(.,11,1) = 'm'">plastic</xsl:when>
            <xsl:when test="substring(.,11,1) = 'p'">plastic</xsl:when>
            <xsl:when test="substring(.,11,1) = 's'">shellac</xsl:when>
            <xsl:when test="substring(.,11,1) = 'w'">wax</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'a'"><xsl:value-of select="concat($mmaterial,'lac')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'b'"><xsl:value-of select="concat($mmaterial,'nit')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'c'"><xsl:value-of select="concat($mmaterial,'ace')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'g'"><xsl:value-of select="concat($mmaterial,'gla')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'i'"><xsl:value-of select="concat($mmaterial,'alu')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'r'"><xsl:value-of select="concat($mmaterial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'l'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'm'"><xsl:value-of select="concat($mmaterial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'p'"><xsl:value-of select="concat($mmaterial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 's'"><xsl:value-of select="concat($mmaterial,'she')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'w'"><xsl:value-of select="concat($mmaterial,'wax')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vBaseMaterial2">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'c'">magnetic particles</xsl:when>
            <xsl:when test="substring(.,11,1) = 'g'">lacquer</xsl:when>
            <xsl:when test="substring(.,11,1) = 'i'">lacquer</xsl:when>
            <xsl:when test="substring(.,11,1) = 'm'">metal</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vBaseMaterialUri2">
          <xsl:choose>
            <xsl:when test="substring(.,11,1) = 'c'"><xsl:value-of select="concat($mmaterial,'fer')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'g'"><xsl:value-of select="concat($mmaterial,'lac')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'i'"><xsl:value-of select="concat($mmaterial,'lac')"/></xsl:when>
            <xsl:when test="substring(.,11,1) = 'm'"><xsl:value-of select="concat($mmaterial,'mtl')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cutting">
          <xsl:choose>
            <xsl:when test="substring(.,12,1) = 'h'">vertical cutting</xsl:when>
            <xsl:when test="substring(.,12,1) = 'l'">lateral or combined cutting</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cuttingURI">
          <xsl:choose>
            <xsl:when test="substring(.,12,1) = 'h'"><xsl:value-of select="concat($mgroove,'vertical')"/></xsl:when>
            <xsl:when test="substring(.,12,1) = 'l'"><xsl:value-of select="concat($mgroove,'lateral')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackCharacteristic">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'a'">NAB standard</xsl:when>
            <xsl:when test="substring(.,13,1) = 'b'">CCIR encoded</xsl:when>
            <xsl:when test="substring(.,13,1) = 'c'">Dolby-B encoded</xsl:when>
            <xsl:when test="substring(.,13,1) = 'd'">dbx encoded</xsl:when>
            <xsl:when test="substring(.,13,1) = 'f'">Dolby-A encoded</xsl:when>
            <xsl:when test="substring(.,13,1) = 'g'">Dolby-C encoded</xsl:when>
            <xsl:when test="substring(.,13,1) = 'h'">CX encoded</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackCharacteristicURI">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'a'"><xsl:value-of select="concat($mspecplayback,'nab')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'b'"><xsl:value-of select="concat($mspecplayback,'ccir')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'c'"><xsl:value-of select="concat($mspecplayback,'dolbyb')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'd'"><xsl:value-of select="concat($mspecplayback,'dbx')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'f'"><xsl:value-of select="concat($mspecplayback,'dolbya')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'g'"><xsl:value-of select="concat($mspecplayback,'dolbyc')"/></xsl:when>
            <xsl:when test="substring(.,13,1) = 'h'"><xsl:value-of select="concat($mspecplayback,'cx')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMethod">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'e'">digital</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMethodURI">
          <xsl:choose>
            <xsl:when test="substring(.,13,1) = 'e'"><xsl:value-of select="concat($mrectype,'digital')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="captureStorageValue"><xsl:value-of select="substring(.,14,1)" /></xsl:variable>
        <xsl:variable name="captureStorage">
          <xsl:value-of select="$codeMaps/maps/captureStorage/*[name() = $captureStorageValue]" />
        </xsl:variable>
        <xsl:variable name="captureStorageUri">
            <xsl:value-of select="$codeMaps/maps/captureStorage/*[name() = $captureStorageValue]/@href" />
        </xsl:variable>
        
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="count(../marc:datafield[@tag='338']) = 0">
              <xsl:if test="$carrier != ''">
                <bf:carrier>
                  <bf:Carrier>
                    <xsl:if test="$carrierUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$carrierUri"/></xsl:attribute>
                    </xsl:if>
                    <rdfs:label><xsl:value-of select="$carrier"/></rdfs:label>
                  </bf:Carrier>
                </bf:carrier>
              </xsl:if>
            </xsl:if>
            <xsl:if test="$playingSpeed != ''">
              <bf:soundCharacteristic>
                <bf:PlayingSpeed>
                  <xsl:if test="$playingSpeedUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$playingSpeedUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$playingSpeed"/></rdfs:label>
                </bf:PlayingSpeed>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$playbackChannels != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $playbackChannels]) = 0">  
              <bf:soundCharacteristic>
                <bf:PlaybackChannels>
                  <xsl:if test="$playbackUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$playbackUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$playbackChannels"/></rdfs:label>
                </bf:PlaybackChannels>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$grooveCharacteristic != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $grooveCharacteristic]) =0">
              <bf:soundCharacteristic>
                <bf:GrooveCharacteristic>
                  <xsl:if test="$grooveCharacteristicURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$grooveCharacteristicURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$grooveCharacteristic"/></rdfs:label>
                </bf:GrooveCharacteristic>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="count(../marc:datafield[@tag='300']/marc:subfield[@code='c']) = 0 and $dimensions != ''">
              <xsl:if test="$dimensions != ''">
                <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
              </xsl:if>
              <xsl:if test="$tapeWidth != ''">
                <bf:dimensions><xsl:value-of select="$tapeWidth"/></bf:dimensions>
              </xsl:if>
            </xsl:if>
            <xsl:if test="$tapeConfig != ''">
              <bf:soundCharacteristic>
                <bf:TapeConfig>
                  <xsl:if test="$tapeConfigUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$tapeConfigUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$tapeConfig"/></rdfs:label>
                </bf:TapeConfig>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <xsl:if test="$generationURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$generationURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$vBaseMaterial2 != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$vBaseMaterialUri2 != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vBaseMaterialUri2"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$vBaseMaterial2"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$cutting != ''">
              <bf:soundCharacteristic>
                <bf:GrooveCharacteristic>
                  <xsl:if test="$cuttingURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$cuttingURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$cutting"/></rdfs:label>
                </bf:GrooveCharacteristic>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$playbackCharacteristic != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $playbackCharacteristic]) = 0">
              <bf:soundCharacteristic>
                <bf:PlaybackCharacteristic>
                  <xsl:if test="$playbackCharacteristicURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$playbackCharacteristicURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$playbackCharacteristic"/></rdfs:label>
                </bf:PlaybackCharacteristic>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$recordingMethod != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $recordingMethod]) = 0">
              <bf:soundCharacteristic>
                <bf:RecordingMethod>
                  <xsl:if test="$recordingMethodURI != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$recordingMethodURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$recordingMethod"/></rdfs:label>
                </bf:RecordingMethod>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$captureStorage != ''">
              <bf:soundCharacteristic>
                <bflc:CaptureStorage>
                  <xsl:if test="$captureStorageUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$captureStorageUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$captureStorage"/></rdfs:label>
                </bflc:CaptureStorage>
              </bf:soundCharacteristic>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- videorecording -->
      <xsl:when test="substring(.,1,1) = 'v'">
        <xsl:variable name="carrier">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'">video cartridge</xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'">videodisc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'">videocassette</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">videotape reel</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="carrierUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'c'"><xsl:value-of select="concat($carriers,'vc')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($carriers,'vd')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'f'"><xsl:value-of select="concat($carriers,'vf')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($carriers,'vr')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="videoFormat">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">Betamax</xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'">VHS</xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'">U-matic)</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">EIAJ</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">Type C</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">Quadruplex</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">laser optical</xsl:when>
            <xsl:when test="substring(.,5,1) = 'h'">CED</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">Betacam</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">Betacam SP</xsl:when>
            <xsl:when test="substring(.,5,1) = 'k'">Super-VHS</xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'">M-II</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">D-2</xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'">8mm</xsl:when>
            <xsl:when test="substring(.,5,1) = 'q'">Hi-8mm</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="videoFormatURI">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mvidformat,'betamax')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mvidformat,'vhs')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mvidformat,'umatic')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mvidformat,'eiaj')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mvidformat,'typec')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mvidformat,'quad')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mvidformat,'laser')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'h'"><xsl:value-of select="concat($mvidformat,'ced')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mvidformat,'betacam')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mvidformat,'betasp')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'k'"><xsl:value-of select="concat($mvidformat,'svhs')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'"><xsl:value-of select="concat($mvidformat,'mii')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'"><xsl:value-of select="concat($mvidformat,'d2')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mvidformat,'8mm')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'q'"><xsl:value-of select="concat($mvidformat,'hi8mm')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vEncodingFormat">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 's'">Blu-Ray video</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">DVD video</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vEncodingFormatUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 's'"><xsl:value-of select="concat($mencformat,'bluray')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mencformat,'dvdv')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMedium">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">magneto-optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'">magneto-optical</xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'">magnetic</xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'">optical</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMediumURI">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'"><xsl:value-of select="concat($mrecmedium,'opt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'"><xsl:value-of select="concat($mrecmedium,'magopt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'"><xsl:value-of select="concat($mrecmedium,'magopt')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'"><xsl:value-of select="concat($mrecmedium,'mag')"/></xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'"><xsl:value-of select="concat($mrecmedium,'opt')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimensions">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'">8 mm.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'">1/4 in.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'o'">1/2 in.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'p'">1 in.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'q'">2 in.</xsl:when>
            <xsl:when test="substring(.,8,1) = 'r'">3/4 in.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackChannels">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'k'">mixed</xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'">mono</xsl:when>
            <xsl:when test="substring(.,9,1) = 'q'">surround</xsl:when>
            <xsl:when test="substring(.,9,1) = 's'">stereo</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="playbackUri">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'k'"><xsl:value-of select="concat($mplayback,'mix')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'"><xsl:value-of select="concat($mplayback,'mon')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'q'"><xsl:value-of select="concat($mplayback,'mul')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 's'"><xsl:value-of select="concat($mplayback,'ste')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="count(../marc:datafield[@tag='338']) = 0">
              <xsl:if test="$carrier != ''">
                <bf:carrier>
                  <bf:Carrier>
                    <xsl:if test="$carrierUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$carrierUri"/></xsl:attribute>
                    </xsl:if>
                    <rdfs:label><xsl:value-of select="$carrier"/></rdfs:label>
                  </bf:Carrier>
                </bf:carrier>
              </xsl:if>
            </xsl:if>
            <xsl:if test="$videoFormat != '' and count(../marc:datafield[@tag='346']/marc:subfield[. = $videoFormat]) = 0">
              <bf:videoCharacteristic>
                <bf:VideoFormat>
                  <xsl:if test="$videoFormatURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$videoFormatURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$videoFormat"/></rdfs:label>
                </bf:VideoFormat>
              </bf:videoCharacteristic>
            </xsl:if>
            <xsl:if test="$vEncodingFormat != '' and count(../marc:datafield[@tag='347']/marc:subfield[. = $vEncodingFormat]) = 0">
              <bf:digitalCharacteristic>
                <bf:EncodingFormat>
                  <xsl:if test="$vEncodingFormatUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vEncodingFormatUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$vEncodingFormat"/></rdfs:label>
                </bf:EncodingFormat>
              </bf:digitalCharacteristic>
            </xsl:if>
            <xsl:if test="$recordingMedium != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $recordingMedium]) = 0">
              <bf:soundCharacteristic>
                <bf:RecordingMedium>
                  <xsl:if test="$recordingMediumURI != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$recordingMediumURI"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$recordingMedium"/></rdfs:label>
                </bf:RecordingMedium>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="count(../marc:datafield[@tag='300']/marc:subfield[@code='c']) = 0">
                <xsl:if test="$dimensions != ''">
                    <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$playbackChannels != '' and count(../marc:datafield[@tag='344']/marc:subfield[. = $playbackChannels]) = 0">
              <bf:soundCharacteristic>
                <bf:PlaybackChannels>
                  <xsl:if test="$playbackUri != ''">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="$playbackUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$playbackChannels"/></rdfs:label>
                </bf:PlaybackChannels>
              </bf:soundCharacteristic>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
