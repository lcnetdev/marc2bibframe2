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
      Conversion specs for 001-007
  -->

  <xsl:template match="marc:controlfield[@tag='001']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:identifiedBy>
          <bf:Local>
            <rdf:value><xsl:value-of select="."/></rdf:value>
          </bf:Local>
        </bf:identifiedBy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='003']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:source>
          <bf:Source>
            <bf:code><xsl:value-of select="."/></bf:code>
          </bf:Source>
        </bf:source>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='005']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="changeDate" select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2),'T',substring(.,9,2),':',substring(.,11,2),':',substring(.,13,2))"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:changeDate>
          <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>dateTime</xsl:attribute>
          <xsl:value-of select="$changeDate"/>
        </bf:changeDate>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='007']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="workType">
      <xsl:choose>
        <xsl:when test="substring(.,1,1) = 'a'">Cartography</xsl:when>
        <xsl:when test="substring(.,1,1) = 'd'">Cartography</xsl:when>
        <xsl:when test="substring(.,1,1) = 'g'">StillImage</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- map -->
      <xsl:when test="substring(.,1,1) = 'a'">
        <xsl:variable name="genreForm">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'">atlas</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">diagram</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">map</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">profile</xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'">model</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">remote-sensing image</xsl:when>
            <xsl:when test="substring(.,2,1) = 's'">map section</xsl:when>
            <xsl:when test="substring(.,2,1) = 'y'">map view</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($marcgt,'atl')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($marcgt,'map')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'"><xsl:value-of select="concat($marcgt,'mod')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($marcgt,'rem')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">multicolored</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
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
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mmatrial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmatrial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mmatrial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmatrial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmatrial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mmatrial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mmatrial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mmatrial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mmatrial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'"><xsl:value-of select="concat($mmatrial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'"><xsl:value-of select="concat($mmatrial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mmatrial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mmatrial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'"><xsl:value-of select="concat($mmatrial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="substring(../marc:leader,7,1) != 'e' and substring(../marc:leader,7,1) != 'f'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$workType)"/></xsl:attribute>
              </rdf:type>
            </xsl:if>
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
      <!-- electronic resource -->
      <xsl:when test="substring(.,1,1) = 'c'">
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'">black and white</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">multicolored</xsl:when>
            <xsl:when test="substring(.,4,1) = 'g'">gray scale</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed</xsl:when>
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
      <!-- globe -->
      <xsl:when test="substring(.,1,1) = 'd'">
        <xsl:variable name="genreForm">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'a'">celestial globe</xsl:when>
            <xsl:when test="substring(.,2,1) = 'b'">planetary or lunar globe</xsl:when>
            <xsl:when test="substring(.,2,1) = 'c'">terrestrial globe</xsl:when>
            <xsl:when test="substring(.,2,1) = 'e'">earth moon globe</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">multicolored</xsl:when>
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
            <xsl:if test="substring(../marc:leader,7,1) != 'e' and substring(../marc:leader,7,1) != 'f'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$workType)"/></xsl:attribute>
              </rdf:type>
            </xsl:if>
            <bf:genreForm>
              <bf:GenreForm>
                <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcgt,'glo')"/></xsl:attribute>
                <rdfs:label>globe</rdfs:label>
              </bf:GenreForm>
            </bf:genreForm>
            <xsl:if test="$genreForm != ''">
              <bf:genreForm>
                <bf:GenreForm>
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
            <xsl:when test="substring(.,4,1) = 'c'">multicolored</xsl:when>
            <xsl:when test="substring(.,4,1) = 'h'">hand colored</xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'">mixed</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'b'"><xsl:value-of select="concat($mcolor,'blw')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'g'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'm'"><xsl:value-of select="concat($mcolor,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="substring(../marc:leader,7,1) != 'k'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$workType)"/></xsl:attribute>
              </rdf:type>
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
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='007']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <!-- map -->
      <xsl:when test="substring(.,1,1) = 'a'">
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'">facsimile</xsl:when>
            <xsl:when test="substring(.,6,1) = 'z'">other type of reproduction</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation2">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">photocopy, blueline print</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">photocopy</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">pre-production</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">film</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarity">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'">positive</xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'">negative</xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'">mixed polarity</xsl:when>
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
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$generation2 != ''">
              <bf:generation>
                <bf:Generation>
                  <rdfs:label><xsl:value-of select="$generation2"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
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
            <xsl:when test="substring(.,2,1) = 'j'">computer disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">computer card</xsl:when>
            <xsl:when test="substring(.,2,1) = 'm'">computer disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'o'">computer disc</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">online resource</xsl:when>
            <xsl:when test="substring(.,2,1) = 'z'">other electronic carrier</xsl:when>
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
            <xsl:when test="substring(.,5,1) = 'g'">4 3/4 in. or 12 cm.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">1 1/8 x 2 3/8 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">3 7/8 x 2 1/2 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">5 1/4 in.</xsl:when>
            <xsl:when test="substring(.,5,1) = 'u'">unknown</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">8 in.</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContent">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '">silent</xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'">sound on medium</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="imageBitDepth">
          <xsl:choose>
            <xsl:when test="substring(.,7,3) = 'mmm'">multiple</xsl:when>
            <xsl:when test="substring(.,7,3) = 'nnn'"/>
            <xsl:when test="substring(.,7,3) = '---'"/>
            <xsl:when test="substring(.,7,3) = '|||'"/>
            <xsl:otherwise><xsl:value-of select="substring(.,7,3)"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="encodingFormat">
          <xsl:choose>
            <xsl:when test="substring(.,10,1) = 'a'">one file format</xsl:when>
            <xsl:when test="substring(.,10,1) = 'm'">multiple file formats</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="substring(../marc:leader,7,1) != 'm'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Electronic')"/></xsl:attribute>
              </rdf:type>
            </xsl:if>
            <xsl:if test="count(../marc:datafield[@tag='337']) = 0">
              <bf:media>
                <bf:Media>
                  <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mediaTypes/c</xsl:attribute>
                </bf:Media>
              </bf:media>
            </xsl:if>
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
            <xsl:if test="$dimensions != ''">
              <bf:dimensions><xsl:value-of select="$dimensions"/></bf:dimensions>
            </xsl:if>
            <xsl:if test="$soundContent != ''">
              <bf:soundContent>
                <bf:SoundContent>
                  <rdfs:label><xsl:value-of select="$soundContent"/></rdfs:label>
                </bf:SoundContent>
              </bf:soundContent>
            </xsl:if>
            <xsl:if test="$imageBitDepth != ''">
              <bf:digitalCharacteristic>
                <bf:DigitalCharacteristic>
                  <rdf:type>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bflc,'ImageBitDepth')"/></xsl:attribute>
                  </rdf:type>
                  <rdfs:label><xsl:value-of select="$imageBitDepth"/></rdfs:label>
                </bf:DigitalCharacteristic>
              </bf:digitalCharacteristic>
            </xsl:if>
            <xsl:if test="$encodingFormat != ''">
              <bf:digitalCharacteristic>
                <bf:DigitalCharacteristic>
                  <rdf:type>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'EncodingFormat')"/></xsl:attribute>
                  </rdf:type>
                  <rdfs:label><xsl:value-of select="$encodingFormat"/></rdfs:label>
                </bf:DigitalCharacteristic>
              </bf:digitalCharacteristic>
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
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mmatrial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmatrial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mmatrial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmatrial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmatrial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mmatrial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mmatrial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mmatrial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mmatrial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'"><xsl:value-of select="concat($mmatrial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'"><xsl:value-of select="concat($mmatrial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mmatrial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mmatrial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'"><xsl:value-of select="concat($mmatrial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'">facsimile</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
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
            <xsl:when test="substring(.,5,1) = 'j'">safety film</xsl:when>
            <xsl:when test="substring(.,5,1) = 'k'">film base (not safety)</xsl:when>
            <xsl:when test="substring(.,5,1) = 'm'">mixed collection</xsl:when>
            <xsl:when test="substring(.,5,1) = 'o'">paper</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="soundContent">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = ' '">silent</xsl:when>
            <xsl:when test="substring(.,6,1) = 'a'">sound on medium</xsl:when>
            <xsl:when test="substring(.,6,1) = 'b'">sound separate from medium</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordingMedium">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">optical sound track on motion picture film</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">magnetic sound track on motion picture film</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">magnetic audio tape in cartridge</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">sound disc</xsl:when>
            <xsl:when test="substring(.,7,1) = 'e'">magnetic audio tape on reel</xsl:when>
            <xsl:when test="substring(.,7,1) = 'f'">magnetic audio tape in cassette</xsl:when>
            <xsl:when test="substring(.,7,1) = 'g'">optical and magnetic sound track on motion picture film</xsl:when>
            <xsl:when test="substring(.,7,1) = 'h'">videotape</xsl:when>
            <xsl:when test="substring(.,7,1) = 'i'">videodisc</xsl:when>
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
            <xsl:when test="substring(.,9,1) = 'm'">mixed collection</xsl:when>
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
            <xsl:when test="substring(.,9,1) = 'c'"><xsl:value-of select="concat($mmatrial,'crd')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'd'"><xsl:value-of select="concat($mmatrial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'e'"><xsl:value-of select="concat($mmatrial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'h'"><xsl:value-of select="concat($mmatrial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'j'"><xsl:value-of select="concat($mmatrial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'k'"><xsl:value-of select="concat($mmatrial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'm'"><xsl:value-of select="concat($mmatrial,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mountUri2">
          <xsl:choose>
            <xsl:when test="substring(.,9,1) = 'j'"><xsl:value-of select="concat($mmatrial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,9,1) = 'k'"><xsl:value-of select="concat($mmatrial,'gls')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="count(../marc:datafield[@tag='337']) = 0">
              <bf:media>
                <bf:Media>
                  <xsl:attribute name="rdf:about">http://id.loc.gov/vocabulary/mediaTypes/g</xsl:attribute>
                </bf:Media>
              </bf:media>
            </xsl:if>
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
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
            <xsl:if test="$soundContent != ''">
              <bf:soundContent>
                <bf:SoundContent>
                  <rdfs:label><xsl:value-of select="$soundContent"/></rdfs:label>
                </bf:SoundContent>
              </bf:soundContent>
            </xsl:if>
            <xsl:if test="$recordingMedium != ''">
              <bf:soundCharacteristic>
                <bf:RecordingMedium>
                  <rdfs:label><xsl:value-of select="$recordingMedium"/></rdfs:label>
                </bf:RecordingMedium>
              </bf:soundCharacteristic>
            </xsl:if>
            <xsl:if test="$dimensions != ''">
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
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
