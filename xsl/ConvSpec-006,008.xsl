<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:lcvocab="http://id.loc.gov/vocabulary/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc lcvocab">

  <!--
      Conversion specs for 006,008
  -->

  <!-- Lookup tables -->
  <lcvocab:millus>
    <a href="http://id.loc.gov/vocabulary/millus/ill">illustrations</a>
    <b href="http://id.loc.gov/vocabulary/millus/map">maps</b>
    <c href="http://id.loc.gov/vocabulary/millus/por">portraits</c>
    <d href="http://id.loc.gov/vocabulary/millus/chr">charts</d>
    <e href="http://id.loc.gov/vocabulary/millus/pln">plans</e>
    <f href="http://id.loc.gov/vocabulary/millus/plt">plates</f>
    <g href="http://id.loc.gov/vocabulary/millus/mus">music</g>
    <h href="http://id.loc.gov/vocabulary/millus/fac">facsimiles</h>
    <i href="http://id.loc.gov/vocabulary/millus/coa">coats of arms</i>
    <j href="http://id.loc.gov/vocabulary/millus/gnt">geneological tables</j>
    <k href="http://id.loc.gov/vocabulary/millus/for">forms</k>
    <l href="http://id.loc.gov/vocabulary/millus/sam">samples</l>
    <m href="http://id.loc.gov/vocabulary/millus/pho">phonodisc, phonowire</m>
    <o href="http://id.loc.gov/vocabulary/millus/pht">photographs</o>
    <p href="http://id.loc.gov/vocabulary/millus/ilm">illuminations</p>
  </lcvocab:millus>

  <lcvocab:maudience>
    <a href="http://id.loc.gov/vocabulary/maudience/pre">preschool</a>
    <b href="http://id.loc.gov/vocabulary/maudience/pri">primary</b>
    <c href="http://id.loc.gov/vocabulary/maudience/pad">pre-adolescent</c>
    <d href="http://id.loc.gov/vocabulary/maudience/ado">adolescent</d>
    <e href="http://id.loc.gov/vocabulary/maudience/adu">adult</e>
    <f href="http://id.loc.gov/vocabulary/maudience/spe">specialized</f>
    <g href="http://id.loc.gov/vocabulary/maudience/gen">general</g>
    <j href="http://id.loc.gov/vocabulary/maudience/juv">juvenile</j>
  </lcvocab:maudience>

  <lcvocab:carrier>
    <a href="http://id.loc.gov/vocabulary/mediaTypes/h">microfilm</a>
    <b href="http://id.loc.gov/vocabulary/carriers/he">microfiche</b>
    <c href="http://id.loc.gov/vocabulary/carriers/hg">microopaque</c>
    <o href="http://id.loc.gov/vocabulary/carriers/cr">online resource</o>
    <q>direct electronic</q>
    <r>regular print reproduction</r>
    <s>electronic</s>
  </lcvocab:carrier>

  <lcvocab:marcgt>
    <a href="http://id.loc.gov/vocabulary/marcgt/abs">abstract or summary</a>
    <b href="http://id.loc.gov/vocabulary/marcgt/bib">bibliography</b>
    <c href="http://id.loc.gov/vocabulary/marcgt/cat">catalog</c>
    <d href="http://id.loc.gov/vocabulary/marcgt/dic">dictionary</d>
    <e href="http://id.loc.gov/vocabulary/marcgt/enc">encyclopedia</e>
    <f href="http://id.loc.gov/vocabulary/marcgt/han">handbook</f>
    <g href="http://id.loc.gov/vocabulary/marcgt/lea">legal article</g>
    <h href="http://id.loc.gov/vocabulary/marcgt/bio">biography</h>
    <i href="http://id.loc.gov/vocabulary/marcgt/ind">index</i>
    <j href="http://id.loc.gov/vocabulary/marcgt/pat">patent</j>
    <k href="http://id.loc.gov/vocabulary/marcgt/dis">discography</k>
    <l href="http://id.loc.gov/vocabulary/marcgt/leg">legislation</l>
    <m href="http://id.loc.gov/vocabulary/marcgt/the">thesis</m>
    <n href="http://id.loc.gov/vocabulary/marcgt/sur">survey of literature</n>
    <o href="http://id.loc.gov/vocabulary/marcgt/rev">review</o>
    <p href="http://id.loc.gov/vocabulary/marcgt/pro">programmed text</p>
    <q href="http://id.loc.gov/vocabulary/marcgt/fil">filmography</q>
    <r href="http://id.loc.gov/vocabulary/marcgt/dir">directory</r>
    <s href="http://id.loc.gov/vocabulary/marcgt/sta">statistics</s>
    <t href="http://id.loc.gov/vocabulary/marcgt/ter">technical report</t>
    <u href="http://id.loc.gov/vocabulary/marcgt/stp">standard of specification</u>
    <v href="http://id.loc.gov/vocabulary/marcgt/lec">legal case and case notes</v>
    <w href="http://id.loc.gov/vocabulary/marcgt/law">law report or digest</w>
    <y href="http://id.loc.gov/vocabulary/marcgt/yea">yearbook</y>
    <z href="http://id.loc.gov/vocabulary/marcgt/tre">treaty</z>
    <x2 href="http://id.loc.gov/vocabulary/marcgt/off">offprint</x2>
    <x5 href="http://id.loc.gov/vocabulary/marcgt/cal">calendar</x5>
    <x6 href="http://id.loc.gov/vocabulary/marcgt/cgn">comic or graphic novel</x6>
  </lcvocab:marcgt>

  <lcvocab:litform>
    <x1 href="http://id.loc.gov/vocabulary/marcgt/fic">fiction</x1>
    <d href="http://id.loc.gov/vocabulary/marcgt/fic">drama</d>
    <e href="http://id.loc.gov/vocabulary/marcgt/fic">essay</e>
    <f href="http://id.loc.gov/vocabulary/marcgt/fic">novel</f>
    <h href="http://id.loc.gov/vocabulary/marcgt/fic">humor, satire</h>
    <i href="http://id.loc.gov/vocabulary/marcgt/fic">letter</i>
    <j href="http://id.loc.gov/vocabulary/marcgt/fic">short story</j>
    <m href="http://id.loc.gov/vocabulary/marcgt/fic">mixed fiction</m>
    <p href="http://id.loc.gov/vocabulary/marcgt/fic">poetry</p>
    <s href="http://id.loc.gov/vocabulary/marcgt/fic">speech</s>
  </lcvocab:litform>

  <lcvocab:bioform>
    <a href="http://id.loc.gov/vocabulary/marcgt/aut">autobiography</a>
    <b href="http://id.loc.gov/vocabulary/marcgt/bio">individual biography</b>
    <c href="http://id.loc.gov/vocabulary/marcgt/bio">collective biography</c>
    <d href="http://id.loc.gov/vocabulary/marcgt/bio">contains biographical information</d>
  </lcvocab:bioform>

  <lcvocab:computerFileType>
    <a href="http://id.loc.gov/vocabulary/marcgt/num">numeric data</a>
    <b href="http://id.loc.gov/vocabulary/marcgt/com">computer program</b>
    <c href="http://id.loc.gov/vocabulary/marcgt/rep">representational</c>
    <d href="http://id.loc.gov/vocabulary/marcgt/doc">document (computer)</d>
    <e href="http://id.loc.gov/vocabulary/marcgt/bda">bibliographic data</e>
    <f href="http://id.loc.gov/vocabulary/marcgt/fon">font</f>
    <g href="http://id.loc.gov/vocabulary/marcgt/gam">game</g>
    <h>sound</h>
    <i href="http://id.loc.gov/vocabulary/marcgt/inm">interactive multimedia</i>
    <j href="http://id.loc.gov/vocabulary/marcgt/ons">online system or service</j>
    <m>computer file combination</m>
  </lcvocab:computerFileType>    
  
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
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='008']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="language">
      <xsl:choose>
        <xsl:when test="substring(.,36,3) = '   '"/>
        <xsl:otherwise><xsl:value-of select="substring(.,36,3)"/></xsl:otherwise>
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
    </xsl:choose>
  </xsl:template>

  <!-- data elements for books -->
  <xsl:template name="work008books">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
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
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="substring($dataElements,12,1) = '1'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcgt,'cpb')"/></xsl:attribute>
              <rdfs:label>conference publication</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:if>
        <xsl:if test="substring($dataElements,13,1) = '1'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcgt,'fes')"/></xsl:attribute>
              <rdfs:label>festschrift</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:for-each select="document('')/*/lcvocab:litform/*">
      <xsl:if test="name() = substring($dataElements,16,1) or
                    name() = concat('x',substring($dataElements,16,1))">
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
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="document('')/*/lcvocab:bioform/*">
      <xsl:if test="name() = substring($dataElements,17,1)">
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
      </xsl:if>
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
    <xsl:for-each select="document('')/*/lcvocab:computerFileType/*">
      <xsl:if test="name() = substring($dataElements,9,1)">
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
      </xsl:if>
    </xsl:for-each>
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
    </xsl:call-template>
  </xsl:template>

  <!-- create Work intendedAudience properties from 008 -->
  <xsl:template name="intendedAudience008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:for-each select="document('')/*/lcvocab:maudience/*">
      <xsl:if test="name() = $code">
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
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- create Work genreForm properties from 008 -->
  <!-- loop 4 times -->
  <xsl:template name="genreForm008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="contents"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:for-each select="document('')/*/lcvocab:marcgt/*">
        <xsl:if test="name() = substring($contents,$i,1) or
                      name() = concat('x',substring($contents,$i,1))">
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
        </xsl:if>
      </xsl:for-each>
      <xsl:call-template name="genreForm008">
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

  <xsl:template match="marc:controlfield[@tag='008']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
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
                        substring(.,7,1) = 'u'">
          <xsl:call-template name="u2x">
            <xsl:with-param name="dateString" select="concat(substring(.,8,4),'/',substring(.,12,4))"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="substring(.,7,1) = 'e'">
          <xsl:choose>
            <xsl:when test="substring(.,14,2) = '  '">
              <xsl:call-template name="u2x">
                <xsl:with-param name="dateString" select="concat(substring(.,8,4),'-',substring(.,12,4))"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="u2x">
                <xsl:with-param name="dateString" select="concat(substring(.,8,4),'-',substring(.,12,4),'-',substring(.,14,2))"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="substring(.,7,1) = 'p' or
                        substring(.,7,1) = 'r' or
                        substring(.,7,1) = 's' or
                        substring(.,7,1) = 't'">
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
                                  substring(.,7,1) = 'u'">
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
                <xsl:if test="$pubPlace != ''">
                  <bf:place>
                    <bf:Place>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,$pubPlace)"/></xsl:attribute>
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
            <xsl:if test="$pubPlace != ''">
              <bf:provisionActivity>
                <bf:ProvisionActivity>
                  <rdf:type>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Publication')"/></xsl:attribute>
                  </rdf:type>
                  <bf:place>
                    <bf:Place>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,$pubPlace)"/></xsl:attribute>
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
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="substring(../marc:leader,7,1) = 'm'">
        <xsl:call-template name="instance008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- data elements for books -->
  <xsl:template name="instance008books">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:param name="leader"/>
    <xsl:call-template name="illustrativeContent008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="illustrations" select="substring($dataElements,1,4)"/>
    </xsl:call-template>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,6,1)"/>
    </xsl:call-template>
    <xsl:variable name="instanceType">
      <xsl:choose>
        <xsl:when test="substring($dataElements,6,1) = 'o' or substring($dataElements,6,1) = 's'">
          <xsl:if test="substring($leader,7,1) != 'm'"><xsl:value-of select="concat($bf,'Electronic')"/></xsl:if>
        </xsl:when>
        <xsl:when test="substring($dataElements,6,1) = 'r'"><xsl:value-of select="concat($bf,'Print')"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="substring($dataElements,6,1) = 'd'">
            <bf:fontSize>
              <bf:FontSize>
                <rdfs:label>large print</rdfs:label>
              </bf:FontSize>
            </bf:fontSize>
          </xsl:when>
          <xsl:when test="substring($dataElements,6,1) = 'f'">
            <bf:notation>
              <bf:TactileNotation>
                <rdfs:label>braille</rdfs:label>
              </bf:TactileNotation>
            </bf:notation>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="$instanceType != ''">
          <rdf:type>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$instanceType"/></xsl:attribute>
          </rdf:type>
        </xsl:if>
        <xsl:if test="substring($dataElements,14,1) = '1'">
          <bf:supplementaryContent>
            <bf:SupplementaryContent>
              <rdfs:label>Index present</rdfs:label>
            </bf:SupplementaryContent>
          </bf:supplementaryContent>
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

  <!-- illustrativeContent - loop over 4 times -->
  <xsl:template name="illustrativeContent008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="illustrations"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:for-each select="document('')/*/lcvocab:millus/*">
        <xsl:if test="name() = substring($illustrations,$i,1)">
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
        </xsl:if>
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
    <xsl:for-each select="document('')/*/lcvocab:carrier/*">
      <xsl:if test="name() = $code">
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
      </xsl:if>
    </xsl:for-each>
  </xsl:template>    

</xsl:stylesheet>
