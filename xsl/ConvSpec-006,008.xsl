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
  -->

  <!-- Lookup tables -->
  <local:millus>
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
  </local:millus>

  <local:maudience>
    <a href="http://id.loc.gov/vocabulary/maudience/pre">preschool</a>
    <b href="http://id.loc.gov/vocabulary/maudience/pri">primary</b>
    <c href="http://id.loc.gov/vocabulary/maudience/pad">pre-adolescent</c>
    <d href="http://id.loc.gov/vocabulary/maudience/ado">adolescent</d>
    <e href="http://id.loc.gov/vocabulary/maudience/adu">adult</e>
    <f href="http://id.loc.gov/vocabulary/maudience/spe">specialized</f>
    <g href="http://id.loc.gov/vocabulary/maudience/gen">general</g>
    <j href="http://id.loc.gov/vocabulary/maudience/juv">juvenile</j>
  </local:maudience>

  <local:carrier>
    <a href="http://id.loc.gov/vocabulary/mediaTypes/h">microfilm</a>
    <b href="http://id.loc.gov/vocabulary/carriers/he">microfiche</b>
    <c href="http://id.loc.gov/vocabulary/carriers/hg">microopaque</c>
    <o href="http://id.loc.gov/vocabulary/carriers/cr">online resource</o>
    <q>direct electronic</q>
    <r>regular print reproduction</r>
    <s>electronic</s>
  </local:carrier>

  <local:marcgt>
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
  </local:marcgt>

  <local:litform>
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
  </local:litform>

  <local:bioform>
    <a href="http://id.loc.gov/vocabulary/marcgt/aut">autobiography</a>
    <b href="http://id.loc.gov/vocabulary/marcgt/bio">individual biography</b>
    <c href="http://id.loc.gov/vocabulary/marcgt/bio">collective biography</c>
    <d href="http://id.loc.gov/vocabulary/marcgt/bio">contains biographical information</d>
  </local:bioform>

  <local:computerFileType>
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
  </local:computerFileType>

  <local:carttype>
    <a prop="issuance">single map</a>
    <b prop="issuance">map series</b>
    <c prop="issuance">map serial</c>
    <d prop="genreForm" href="http://id.loc.gov/vocabulary/marcgt/glo">globe</d>
    <e prop="genreForm" href="http://id.loc.gov/vocabulary/marcgt/atl">atlas</e>
    <f prop="issuance">map supplement to another work</f>
    <g prop="issuance">map bound as part of another work</g>
  </local:carttype>

  <local:mapform>
    <e href="http://id.loc.gov/vocabulary/marcgt/man">manuscript</e>
    <j href="http://id.loc.gov/vocabulary/marcgt/pos">picture card, post card</j>
    <k href="http://id.loc.gov/vocabulary/marcgt/cal">calendar</k>
    <l href="http://id.loc.gov/vocabulary/marcgt/puz">puzzle</l>
    <n href="http://id.loc.gov/vocabulary/marcgt/gam">game</n>
    <o href="http://id.loc.gov/vocabulary/marcgt/wal">wall map</o>
    <p href="http://id.loc.gov/vocabulary/marcgt/pla">playing cards</p>
    <r href="http://id.loc.gov/vocabulary/marcgt/loo">loose-leaf</r>
  </local:mapform>

  <local:musicTextForm>
    <a href="http://id.loc.gov/vocabulary/marcgt/aut">autobiography</a>
    <b href="http://id.loc.gov/vocabulary/marcgt/bio">biography</b>
    <c href="http://id.loc.gov/vocabulary/marcgt/cpl">conference proceedings</c>
    <d href="http://id.loc.gov/vocabulary/marcgt/dra">drama</d>
    <e href="http://id.loc.gov/vocabulary/marcgt/ess">essays</e>
    <f href="http://id.loc.gov/vocabulary/marcgt/fic">fiction</f>
    <g href="http://id.loc.gov/vocabulary/marcgt/rpt">reporting</g>
    <h href="http://id.loc.gov/vocabulary/marcgt/his">history</h>
    <i href="http://id.loc.gov/vocabulary/marcgt/ins">instruction</i>
    <j href="http://id.loc.gov/vocabulary/marcgt/lan">language instruction</j>
    <k href="http://id.loc.gov/vocabulary/marcgt/cod">comedy</k>
    <l href="http://id.loc.gov/vocabulary/marcgt/spe">lectures, speeches</l>
    <m href="http://id.loc.gov/vocabulary/marcgt/mem">memoirs</m>
    <o href="http://id.loc.gov/vocabulary/marcgt/fol">folktales</o>
    <p href="http://id.loc.gov/vocabulary/marcgt/poe">poetry</p>
    <r href="http://id.loc.gov/vocabulary/marcgt/reh">rehearsals</r>
    <s href="http://id.loc.gov/vocabulary/marcgt/sou">sounds</s>
    <t href="http://id.loc.gov/vocabulary/marcgt/int">interviews</t>
  </local:musicTextForm>

  <local:frequency>
    <a href="http://id.loc.gov/vocabulary/frequencies/ann">annual</a>
    <b href="http://id.loc.gov/vocabulary/frequencies/bmn">bimonthly</b>
    <c href="http://id.loc.gov/vocabulary/frequencies/swk">semiweekly</c>
    <d href="http://id.loc.gov/vocabulary/frequencies/dyl">daily</d>
    <e href="http://id.loc.gov/vocabulary/frequencies/bwk">biweekly</e>
    <f href="http://id.loc.gov/vocabulary/frequencies/san">semiannual</f>
    <g href="http://id.loc.gov/vocabulary/frequencies/bin">biennial</g>
    <h href="http://id.loc.gov/vocabulary/frequencies/ten">triennial</h>
    <i href="http://id.loc.gov/vocabulary/frequencies/ttw">three times a week</i>
    <j href="http://id.loc.gov/vocabulary/frequencies/ttm">three times a month</j>
    <k href="http://id.loc.gov/vocabulary/frequencies/con">continuously updated</k>
    <m href="http://id.loc.gov/vocabulary/frequencies/mon">monthly</m>
    <q href="http://id.loc.gov/vocabulary/frequencies/grt">quarterly</q>
    <s href="http://id.loc.gov/vocabulary/frequencies/smn">semimonthly</s>
    <t href="http://id.loc.gov/vocabulary/frequencies/tty">three times a year</t>
    <w href="http://id.loc.gov/vocabulary/frequencies/wkl">weekly</w>
  </local:frequency>

  <local:crtype>
    <d href="http://id.loc.gov/vocabulary/marcgt/dtd">updating database</d>
    <l href="http://id.loc.gov/vocabulary/marcgt/loo">updating loose-leaf</l>
    <m href="http://id.loc.gov/vocabulary/marcgt/ser">monographic series</m>
    <n href="http://id.loc.gov/vocabulary/marcgt/new">newspaper</n>
    <p href="http://id.loc.gov/vocabulary/marcgt/per">periodical</p>
    <w href="http://id.loc.gov/vocabulary/marcgt/web">updating web site</w>
  </local:crtype>

  <local:visualtype>
    <a href="http://id.loc.gov/vocabulary/marcgt/aro">art original</a>
    <b href="http://id.loc.gov/vocabulary/marcgt/kit">kit</b>
    <c href="http://id.loc.gov/vocabulary/marcgt/art">art reproduction</c>
    <d href="http://id.loc.gov/vocabulary/marcgt/dio">diorama</d>
    <f href="http://id.loc.gov/vocabulary/marcgt/fls">filmstrip</f>
    <g href="http://id.loc.gov/vocabulary/marcgt/gam">game</g>
    <i href="http://id.loc.gov/vocabulary/marcgt/pic">picture</i>
    <k href="http://id.loc.gov/vocabulary/marcgt/gra">graphic</k>
    <l href="http://id.loc.gov/vocabulary/marcgt/ted">technical drawing</l>
    <m href="http://id.loc.gov/vocabulary/marcgt/mot">motion picture</m>
    <n href="http://id.loc.gov/vocabulary/marcgt/cha">chart</n>
    <o href="http://id.loc.gov/vocabulary/marcgt/fla">flash card</o>
    <p href="http://id.loc.gov/vocabulary/marcgt/mic">microscope slide</p>
    <q href="http://id.loc.gov/vocabulary/marcgt/mod">model</q>
    <r href="http://id.loc.gov/vocabulary/marcgt/rea">realia</r>
    <s href="http://id.loc.gov/vocabulary/marcgt/sli">slide</s>
    <t href="http://id.loc.gov/vocabulary/marcgt/tra">transparency</t>
    <v href="http://id.loc.gov/vocabulary/marcgt/vid">videorecording</v>
    <w href="http://id.loc.gov/vocabulary/marcgt/toy">toy</w>
  </local:visualtype>

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
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcgt,'fes')"/></xsl:attribute>
              <rdfs:label>festschrift</rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:for-each select="document('')/*/local:litform/*[name() = substring($dataElements,16,1)] |
                          document('')/*/local:litform/*[name() = concat('x',substring($dataElements,16,1))]">
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
    <xsl:for-each select="document('')/*/local:bioform/*[name() = substring($dataElements,17,1)]">
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
    <xsl:for-each select="document('')/*/local:computerFileType/*[name() = substring($dataElements,9,1)]">
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
    <xsl:call-template name="govdoc008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,11,1)"/>
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
    <xsl:variable name="compform">
      <xsl:choose>
        <xsl:when test="substring($dataElements,1,2) = 'an'">anthems</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'bd'">ballads</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'bg'">bluegrass music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'bl'">blues</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'bt'">ballets</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ca'">chaconnes</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cb'">chants, other religions</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cc'">chant, Christian</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cg'">concerti grossi</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ch'">chorales</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cl'">chorale preludes</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cn'">canons and rounds</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cp'">chansons, polyphonic</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cr'">carols</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cs'">chance compositions</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ct'">cantatas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cy'">country music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'cz'">canzonas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'df'">dance forms</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'dv'">divertimentos, serenades, cassations, divertissements, notturni</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'fg'">fugues</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'fl'">flamenco</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'fm'">folk music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ft'">fantasias</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'gm'">gospel music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'hy'">hymns</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'jz'">jazz</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mc'">musical revues and comedies</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'md'">madrigals</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mi'">minuets</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mo'">motets</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mp'">motion picture music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mr'">marches</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ms'">masses</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mu'">multiple forms</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'mz'">mazurkas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'nc'">nocturnes</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'op'">operas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'or'">oratorios</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ov'">overtures</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'pg'">program music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'pm'">passion music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'po'">polonaises</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'pp'">popular music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'pr'">preludes</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ps'">passacaglias</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'pt'">part-songs</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'pv'">pavans</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'rc'">rock music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'rd'">rondos</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'rg'">ragtime music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ri'">ricercars</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'rp'">rhapsodies</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'rq'">requiems</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'sd'">square dance music</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'sg'">songs</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'sn'">sonatas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'sp'">symphonic poems</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'st'">studies and exercises</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'su'">suites</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'sy'">symphonies</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'tc'">toccatas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'tl'">teatro lirico</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'ts'">trio-sonatas</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'vi'">villancicos</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'vr'">variations</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'wz'">waltzes</xsl:when>
        <xsl:when test="substring($dataElements,1,2) = 'za'">arzuelas</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="musicformat">
      <xsl:choose>
        <xsl:when test="substring($dataElements,3,1) = 'a'">full score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'b'">full score, miniature or study size</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'c'">accompaniment reduced for keyboard</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'd'">voice score with accompaniment omitted</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'e'">condensed score or piano-conductor score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'g'">close score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'h'">chorus score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'i'">condensed score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'j'">performer-conducter part</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'k'">vocal score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'l'">score</xsl:when>
        <xsl:when test="substring($dataElements,3,1) = 'm'">multiple score formats</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="intendedAudience008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,5,1)"/>
    </xsl:call-template>
    <xsl:call-template name="suppContentMusic008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="accomp" select="substring($dataElements,7,6)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$compform != ''">
          <bf:genreForm>
            <bf:GenreForm>
              <bf:code><xsl:value-of select="substring($dataElements,1,2)"/></bf:code>
              <rdfs:label><xsl:value-of select="$compform"/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:if>
        <xsl:if test="$musicformat != ''">
          <bf:musicFormat>
            <bf:MusicFormat>
              <bf:code><xsl:value-of select="substring($dataElements,3,1)"/></bf:code>
              <rdfs:label><xsl:value-of select="$musicformat"/></rdfs:label>
            </bf:MusicFormat>
          </bf:musicFormat>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="musicTextForm008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="litform" select="substring($dataElements,13,2)"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- data elements for continuing resources -->
  <xsl:template name="work008cr">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:variable name="script">
      <xsl:choose>
        <xsl:when test="substring($dataElements,16,1) = 'a'">basic roman</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'b'">extended roman</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'c'">cyrillic</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'd'">japanese</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'e'">chinese</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'f'">arabic</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'g'">greek</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'h'">hebrew</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'i'">thai</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'j'">devanagari</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'k'">korean</xsl:when>
        <xsl:when test="substring($dataElements,16,1) = 'l'">tamil</xsl:when>
      </xsl:choose>
    </xsl:variable>
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
        <xsl:if test="$script != ''">
          <bf:notation>
            <bf:Script>
              <bf:code><xsl:value-of select="substring($dataElements,16,1)"/></bf:code>
              <rdfs:label><xsl:value-of select="$script"/></rdfs:label>
            </bf:Script>
          </bf:notation>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
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
    <xsl:for-each select="document('')/*/local:visualtype/*[name() = substring($dataElements,16,1)]">
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
              <xsl:when test="substring($dataElements,1,3) != '000'">
                <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'duration')"/></xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <xsl:value-of select="$duration"/>
          </bf:duration>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- create Work intendedAudience properties from 008 -->
  <xsl:template name="intendedAudience008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:for-each select="document('')/*/local:maudience/*[name() = $code]">
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

  <!-- create Work genreForm properties from 008 -->
  <!-- loop 4 times -->
  <xsl:template name="genreForm008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="contents"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 5">
      <xsl:for-each select="document('')/*/local:marcgt/*[name() = substring($contents,$i,1)] |
                            document('')/*/local:marcgt/*[name() = concat('x',substring($contents,$i,1))]">
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

  <!-- create genreForm property for a conference publication -->
  <xsl:template name="conference008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:if test="$code = '1'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:genreForm>
            <bf:GenreForm>
              <xsl:attribute name="rdf:about"><xsl:value-of select="concat($marcgt,'cpb')"/></xsl:attribute>
              <rdfs:label>conference publication</rdfs:label>
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
      <xsl:for-each select="document('')/*/local:mapform/*[name() = substring($form,$i,1)]">
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

  <!-- supplementaryContent properties for music - loop 6 times -->
  <xsl:template name="suppContentMusic008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="accomp"/>
    <xsl:param name="i" select="1"/>
    <xsl:if test="$i &lt; 7">
      <xsl:variable name="supp">
        <xsl:choose>
          <xsl:when test="substring($accomp,$i,1) = 'a'">discography</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'b'">bibliography</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'c'">thematic index</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'd'">libretto or text</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'e'">biography of composer or author</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'f'">biography of performer or history of ensemble</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'g'">technical and/or historical information on instruments</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'h'">technical information on music</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'i'">historical information</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'k'">ethnological information</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 'r'">instructional materials</xsl:when>
          <xsl:when test="substring($accomp,$i,1) = 's'">music</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$supp != ''">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:supplementaryContent>
              <bf:SupplementaryContent>
                <bf:code><xsl:value-of select="substring($accomp,$i,1)"/></bf:code>
                <rdfs:label><xsl:value-of select="$supp"/></rdfs:label>
              </bf:SupplementaryContent>
            </bf:supplementaryContent>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
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
      <xsl:for-each select="document('')/*/local:musicTextForm/*[name() = substring($litform,$i,1)]">
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
    <!-- select call appropriate 008 template based on pos 0 -->
    <xsl:choose>
      <!-- books -->
      <xsl:when test="substring(.,1,1) = 'a' or
                      substring(.,1,1) = 't'">
        <xsl:call-template name="instance008books">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- computer files -->
      <xsl:when test="substring(.,1,1) = 'm'">
        <xsl:call-template name="instance008computerfiles">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- maps -->
      <xsl:when test="substring(.,1,1) = 'e' or
                      substring(.,1,1) = 'f'">
        <xsl:call-template name="instance008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- mixed materials -->
      <xsl:when test="substring(.,1,1) = 'p'">
        <xsl:call-template name="instance008mixed">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
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
        </xsl:call-template>
      </xsl:when>
      <!-- continuing resources -->
      <xsl:when test="substring(.,1,1) = 's'">
        <xsl:call-template name="instance008cr">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,2,17)"/>
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
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='008']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
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
            <xsl:if test="$pubPlace != '' and $pubPlace != '|||'">
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
      <!-- maps -->
      <xsl:when test="substring(../marc:leader,7,1) = 'e' or substring(../marc:leader,7,1) = 'f'">
        <xsl:call-template name="instance008maps">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="dataElements" select="substring(.,19,17)"/>
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
        </xsl:call-template>
      </xsl:when>
      <!-- mixed materials -->
      <xsl:when test="substring(../marc:leader,7,1) = 'p'">
        <xsl:call-template name="instance008mixed">
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
    <xsl:call-template name="supplementaryContent008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,14,1)"/>
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
    <xsl:variable name="projection">
      <xsl:choose>
        <xsl:when test="substring($dataElements,5,2) = 'aa'">Aitoff</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ab'">Gnomic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ac'">Lambert's azimuthal equal area</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ad'">Orthographic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ae'">Azimuthal equidistant</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'af'">Stereographic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ag'">General vertical near-sided</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'am'">Modified stereographic for Alaska</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'an'">Chamberlin trimetric</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ap'">polar stereographic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'au'">Azimuthal, specific type unknown</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'az'">Azimuthal, other</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ba'">Gali</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bb'">Goode's homiographic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bc'">Lambert's cylindrical equal area</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bd'">Mercator</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'be'">Miller</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bf'">Mollweide</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bg'">Sinusoidal</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bh'">Transverse Mercator</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bi'">Gauss-Kruger</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bj'">Equirectangular</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bk'">Krovak</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bl'">Cassini-Soldner</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bo'">Oblique Mercator</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'br'">Robinson</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bs'">Space oblique Mercator</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bu'">Cylindrical, specific type unknown</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'bz'">Cylindrical, other</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ca'">Alber's equal area</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'cb'">Bonne</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'cc'">Lambert's conformal conic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'ce'">Equidistant conic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'cp'">Polyconic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'cu'">Conic, specific type unknown</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'cz'">Conic, other</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'da'">Armadillo</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'db'">Butterfly</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'dc'">Eckert</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'dd'">Goode's homolosine</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'de'">Miller's bipolar oblique conformal conic</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'df'">Van Der Grinten</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'dg'">Dimaxion</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'dh'">Cordiform</xsl:when>
        <xsl:when test="substring($dataElements,5,2) = 'dl'">Lambert conformal</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="cartographicAttributes008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="relief" select="substring($dataElements,1,4)"/>
    </xsl:call-template>
    <xsl:call-template name="supplementaryContent008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,14,1)"/>
    </xsl:call-template>
    <xsl:for-each select="document('')/*/local:carttype/*[name() = substring($dataElements,8,1)]">
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
          <xsl:if test="@prop = 'issuance'">
            <bf:issuance>
              <bf:Issuance>
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
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$projection != ''">
          <bf:projection>
            <bf:Cartographic>
              <bf:code><xsl:value-of select="substring($dataElements,5,2)"/></bf:code>
              <rdfs:label><xsl:value-of select="$projection"/></rdfs:label>
            </bf:Cartographic>
          </bf:projection>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
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
      <xsl:choose>
        <xsl:when test="substring($dataElements,2,1) = 'n'">normalized irregular</xsl:when>
        <xsl:when test="substring($dataElements,2,1) = 'r'">regular</xsl:when>
        <xsl:when test="substring($dataElements,2,1) = 'x'">completely irregular</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="document('')/*/local:frequency/*[name() = substring($dataElements,1,1)]">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:frequency>
            <bf:Frequency>
              <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Frequency>
          </bf:frequency>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="document('')/*/local:crtype/*[name() = substring($dataElements,4,1)]">
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
    <xsl:for-each select="document('')/*/local:carrier/*[name() = substring($dataElements,5,1)]">
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
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$regularity != ''">
          <bf:frequency>
            <bf:Frequency>
              <rdfs:label><xsl:value-of select="$regularity"/></rdfs:label>
            </bf:Frequency>
          </bf:frequency>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- data elements for visual materials -->
  <xsl:template name="instance008visual">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="dataElements"/>
    <xsl:variable name="technique">
      <xsl:choose>
        <xsl:when test="substring($dataElements,17,1) = 'a'">animation</xsl:when>
        <xsl:when test="substring($dataElements,17,1) = 'c'">animation and live action</xsl:when>
        <xsl:when test="substring($dataElements,17,1) = 'l'">live action</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="carrier008">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="code" select="substring($dataElements,12,1)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="$technique != ''">
          <bf:note>
            <bf:Note>
              <bf:noteType>technique</bf:noteType>
              <rdfs:label><xsl:value-of select="$technique"/></rdfs:label>
            </bf:Note>
          </bf:note>
        </xsl:if>
      </xsl:when>
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
      <xsl:for-each select="document('')/*/local:millus/*[name() = substring($illustrations,$i,1)]">
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
    <xsl:for-each select="document('')/*/local:carrier/*[name() = $code]">
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
      <xsl:variable name="note">
        <xsl:choose>
          <xsl:when test="substring($relief,$i,1) = 'a'">contours</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'b'">shading</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'c'">gradient and bathymetric tints</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'd'">hachures</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'e'">bathymetry/soundings</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'f'">form lines</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'g'">spot heights</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'i'">pictorially</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'j'">land forms</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'k'">bathymetry/isolines</xsl:when>
          <xsl:when test="substring($relief,$i,1) = 'm'">rock drawings</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$note != ''">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:cartographicAttributes>
              <bf:Cartographic>
                <bf:note>
                  <bf:Note>
                    <bf:noteType>relief</bf:noteType>
                    <rdfs:label><xsl:value-of select="$note"/></rdfs:label>
                  </bf:Note>
                </bf:note>
              </bf:Cartographic>
            </bf:cartographicAttributes>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:call-template name="cartographicAttributes008">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="relief" select="$relief"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="supplementaryContent008">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="code"/>
    <xsl:if test="$code = '1'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:supplementaryContent>
            <bf:SupplementaryContent>
              <rdfs:label>Index present</rdfs:label>
            </bf:SupplementaryContent>
          </bf:supplementaryContent>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
