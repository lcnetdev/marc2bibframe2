<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="xsl marc exsl">

  <!--
      Conversion specs for bib title fields 210-247 (not 240)
  -->

  <!-- bf:Instance properties from MARC 210 -->
  <xsl:template match="marc:datafield[@tag='210' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='210')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="@ind2='0'">
      <xsl:apply-templates mode="title210" select=".">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- bf:Work properties from MARC 210 -->
  <xsl:template match="marc:datafield[@tag='210' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='210')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="@ind2=' '">
      <xsl:apply-templates mode="title210" select=".">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- bf:title property from MARC 210 -->
  <xsl:template match="marc:datafield[@tag='210' or @tag='880']" mode="title210">
    <xsl:param name="serialization"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:AbbreviatedTitle>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:mainTitle>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:qualifier>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:qualifier>
            </xsl:for-each>
            <xsl:choose>
              <xsl:when test="@ind2='0'">
                <xsl:for-each select="marc:subfield[@code='2']">
                  <bf:assigner>
                    <bf:Agent>
                      <bf:code><xsl:value-of select="."/></bf:code>
                    </bf:Agent>
                  </bf:assigner>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="@ind2=' '">
                <bf:assigner>
                  <bf:Agent>
                    <bf:code>issnkey</bf:code>
                  </bf:Agent>
                </bf:assigner>
              </xsl:when>
            </xsl:choose>
          </bf:AbbreviatedTitle>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <!-- bf:Work properties from MARC 222 -->
  <xsl:template match="marc:datafield[@tag='222' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='222')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:KeyTitle>
            <xsl:if test="@ind2 != '0' and @ind2 != ' '">
              <bflc:nonSortNum>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@ind2"/>
              </bflc:nonSortNum>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:mainTitle>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:qualifier>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </bf:qualifier>
            </xsl:for-each>
          </bf:KeyTitle>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <!-- bf:Instance properties from MARC 242 -->
  <xsl:template match="marc:datafield[@tag='242' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='242')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:VariantTitle>
            <rdf:type rdf:resource="{concat($varianttitle, 'tra')}" />
            <xsl:if test="@ind2 != '0' and @ind2 != ' '">
              <bflc:nonSortNum>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@ind2"/>
              </bflc:nonSortNum>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:mainTitle>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:subtitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:subtitle>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='n']">
              <bf:partNumber>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:partNumber>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='p']">
              <bf:partName>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:partName>
            </xsl:for-each>
          </bf:VariantTitle>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Work properties from MARC 243 -->
  <xsl:template match="marc:datafield[@tag='243' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='243')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:CollectiveTitle>
            <xsl:if test="@ind2 != '0' and @ind2 != ' '">
              <bflc:nonSortNum>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@ind2"/>
              </bflc:nonSortNum>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:mainTitle>
            </xsl:for-each>
          </bf:CollectiveTitle>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Work properties from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='245')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vOccurrence">
      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
    </xsl:variable>
    <xsl:variable name="label">
      <xsl:apply-templates mode="concat-nodes-space"
                           select="marc:subfield[@code='a' or
                                   @code='b' or
                                   @code='n' or
                                   @code='p']"/>
    </xsl:variable>
    <xsl:variable name="label-c">
      <xsl:apply-templates mode="concat-nodes-space"
                           select="marc:subfield[@code='a' or
                            @code='b' or
                            @code='n' or
                            @code='p' or
                            @code='c']"/>
    </xsl:variable>
    <xsl:variable name="vLinkedLabel">
      <xsl:if test="@tag='245' and marc:subfield[@code='6']">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='a' or
                                     @code='b' or
                                     @code='n' or
                                     @code='p']"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vLinkedLabel-c">
      <xsl:if test="@tag='245' and marc:subfield[@code='6']">
        <xsl:apply-templates mode="concat-nodes-space"
                                    select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='a' or
                                      @code='b' or
                                      @code='n' or
                                      @code='p' or
                                      @code='c']"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vXmlLang880">
      <xsl:if test="@tag='245' and marc:subfield[@code='6']">
        <xsl:apply-templates select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" mode="xmllang"/>
      </xsl:if>
    </xsl:variable>
    <!-- generate Work properties -->
    <xsl:apply-templates mode="work245" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
    <!-- generate Work properties from linked 880 -->
    <xsl:if test="@tag='245' and marc:subfield[@code='6']">
      <xsl:apply-templates mode="work245" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:choose>
          <xsl:when test="contains($label-c, ' =')">
            <xsl:variable name="label-cPreNS">
              <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="$label-c" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="label-cNS" select="exsl:node-set($label-cPreNS)" />

            <xsl:choose>
              <xsl:when test="count($label-cNS/item) &lt; 5">
                           
            <xsl:variable name="vLinkedLabel-cPreNS">
              <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="$vLinkedLabel-c" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="vLinkedLabel-cNS" select="exsl:node-set($vLinkedLabel-cPreNS)" />
            
            <xsl:variable name="df246s" select="ancestor::marc:record/marc:datafield[@tag = '246']" />
            
            <xsl:for-each select="$label-cNS/item">
              <xsl:variable name="lc" select="."/>
              <xsl:variable name="pos" select="position()"/>
              <xsl:if test="not($df246s/marc:subfield[@code = 'a' and contains($lc, .)])">
                  <!--
                  <xsl:if test="@ind2 != '0' and @ind2 != ' '">
                    <bflc:nonSortNum>
                      <xsl:if test="$vXmlLang880 != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang880"/></xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="@ind2" />
                    </bflc:nonSortNum>
                  </xsl:if>
                  -->
                  <xsl:variable name="t">
                    <xsl:choose>
                      <xsl:when test="contains(., ' /')">
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="substring-before(., ' /')"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="tChopPunct">
                          <xsl:with-param name="pString" select="."/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="tStartsUpper">
                    <xsl:call-template name="isUpper">
                      <xsl:with-param name="text" select="substring($t, 1, 1)" />
                    </xsl:call-template>
                  </xsl:variable>
                  
                  <xsl:variable name="vFinalT">
                    <xsl:choose>
                      <xsl:when test="$tStartsUpper = '0' and $pos != '1'">
                        <xsl:choose>
                          <xsl:when test="contains($label-cNS/item[1], ' :')">
                            <xsl:variable name="lIndex">
                              <xsl:call-template name="tLastIndex">
                                <xsl:with-param name="pString" select="$label-cNS/item[1]" />
                                <xsl:with-param name="pSearch" select="' : '"></xsl:with-param>
                              </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="concat(substring($label-cNS/item[1], 1, $lIndex), $t)"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="concat($label-cNS/item[1], ' : ', $t)"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$t"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  
                  <xsl:variable name="vFinal880T">
                    <xsl:if test="$vLinkedLabel-cPreNS != '' and $vLinkedLabel-cNS/item[$pos] != $lc">
                      <xsl:variable name="langt">
                        <xsl:choose>
                          <xsl:when test="contains($vLinkedLabel-cNS/item[$pos], ' /')">
                            <xsl:call-template name="tChopPunct">
                              <xsl:with-param name="pString" select="substring-before($vLinkedLabel-cNS/item[$pos], ' /')"/>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="tChopPunct">
                              <xsl:with-param name="pString" select="$vLinkedLabel-cNS/item[$pos]"/>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:variable name="langtStartsUpper">
                        <xsl:call-template name="isUpper">
                          <xsl:with-param name="text" select="substring($langt, 1, 1)" />
                        </xsl:call-template>
                      </xsl:variable>
                        <xsl:choose>
                          <xsl:when test="$langtStartsUpper = '0' and $pos != '1'">
                            <xsl:choose>
                              <xsl:when test="contains($vLinkedLabel-cNS/item[1], ' :')">
                                <xsl:variable name="ltIndex">
                                  <xsl:call-template name="tLastIndex">
                                    <xsl:with-param name="pString" select="$vLinkedLabel-cNS/item[1]" />
                                    <xsl:with-param name="pSearch" select="' : '"></xsl:with-param>
                                  </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of select="concat(substring($vLinkedLabel-cNS/item[1], 1, $ltIndex), $langt)"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="concat($vLinkedLabel-cNS/item[1], ' : ', $langt)"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$langt"/>
                          </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                  </xsl:variable>
                
                <xsl:call-template name="work-title-from-parts">
                  <xsl:with-param name="vLabel" select="$vFinalT" />
                  <!-- <xsl:with-param name="vNonSortNum" select="@ind2" /> -->
                  <xsl:with-param name="vXmlLang880" select="$vXmlLang880" />
                  <xsl:with-param name="vLinkedLabel" select="$vFinal880T" />
                  <xsl:with-param name="vTitleClass" select="'bf:ParallelTitle'" />
                </xsl:call-template>
                  
              </xsl:if>
            </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="work-title-from-parts">
                  <xsl:with-param name="vLabel" select="$label" />
                  <xsl:with-param name="vNonSortNum" select="@ind2" />
                  <xsl:with-param name="vXmlLang880" select="$vXmlLang880" />
                  <xsl:with-param name="vLinkedLabel" select="$vLinkedLabel" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="work-title-from-parts">
              <xsl:with-param name="vLabel" select="$label" />
              <xsl:with-param name="vNonSortNum" select="@ind2" />
              <xsl:with-param name="vXmlLang880" select="$vXmlLang880" />
              <xsl:with-param name="vLinkedLabel" select="$vLinkedLabel" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="work-title-from-parts">
    <xsl:param name="vNonSortNum" />
    <xsl:param name="vLabel" />
    <xsl:param name="vLinkedLabel" />
    <xsl:param name="vXmlLang880" />
    <xsl:param name="vTitleClass" select="'bf:Title'" />
    <bf:title>
      <xsl:element name="{$vTitleClass}">
        <xsl:if test="$vNonSortNum != '' and $vNonSortNum != '0' and $vNonSortNum != ' '">
          <bflc:nonSortNum>
            <xsl:if test="$vXmlLang880 != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang880"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@ind2" />
          </bflc:nonSortNum>
        </xsl:if>
        <bf:mainTitle>
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="$vLabel"/>
          </xsl:call-template>
        </bf:mainTitle>
        <xsl:if test="$vLinkedLabel != ''">
          <bf:mainTitle>
            <xsl:if test="$vXmlLang880 != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang880"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="$vLinkedLabel"/>
            </xsl:call-template>
          </bf:mainTitle>
        </xsl:if>
      </xsl:element>
    </bf:title>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245' or @tag='880']" mode="work245">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="not(../marc:datafield[@tag='046']/marc:subfield[@code='k'])">
          <xsl:for-each select="marc:subfield[@code='f']">
            <bf:originDate>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="."/>
                <xsl:with-param name="pForceTerm" select="true()"/>
              </xsl:call-template>
            </bf:originDate>
          </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='g']">
          <bf:originDate>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
              <xsl:with-param name="pForceTerm" select="true()"/>
            </xsl:call-template>
          </bf:originDate>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='s']">
          <bf:version>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:version>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- bf:Instance properties from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='245')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceType" />
    <xsl:variable name="output245">
      <xsl:choose>
        <xsl:when test="$pInstanceType = 'SecondaryInstance' and ../marc:datafield[@tag='856' or @tag='859']">SKIP</xsl:when>
        <xsl:when test="$pInstanceType != 'SecondaryInstance'">TRUE</xsl:when>
        <xsl:otherwise>TRUE</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$output245!='SKIP'">
      <xsl:variable name="vOccurrence">
      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
    </xsl:variable>
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
    <xsl:variable name="vLinkedLabel">
      <xsl:if test="@tag='245' and marc:subfield[@code='6']">
        <xsl:apply-templates mode="concat-nodes-space"
                             select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]/marc:subfield[@code='a' or
                                     @code='b' or
                                     @code='f' or 
                                     @code='g' or
                                     @code='k' or
                                     @code='n' or
                                     @code='p' or
                                     @code='s']"/>
      </xsl:if>
    </xsl:variable>
    <xsl:apply-templates mode="instance245" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="label" select="$label"/>
    </xsl:apply-templates>
    <!-- generate Instance properties from linked 880 -->
    <xsl:if test="@tag='245' and marc:subfield[@code='6']">
      <xsl:apply-templates mode="instance245" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="label" select="$vLinkedLabel"/>
      </xsl:apply-templates>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
                <bf:title>
                  <bf:Title>
                <xsl:apply-templates mode="title245" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="label" select="$label"/>
                </xsl:apply-templates>
                <!-- generate Title properties from linked 880 -->
                <xsl:if test="@tag='245' and marc:subfield[@code='6']">
                  <xsl:apply-templates mode="title245" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="label" select="$vLinkedLabel"/>
                  </xsl:apply-templates>
                </xsl:if>
                  </bf:Title>
                </bf:title>
      </xsl:when>
    </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245' or @tag='880']" mode="instance245">
    <xsl:param name="serialization"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:responsibilityStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:responsibilityStatement>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245' or @tag='880']" mode="title245">
    <xsl:param name="label"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pSubtitle" select="true()"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:if test="@ind2 != '0' and @ind2 != ' '">
          <bflc:nonSortNum>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@ind2" />
          </bflc:nonSortNum>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:mainTitle>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:variable name="vEndsWIthEqualSign">
              <xsl:call-template name="ends-with">
                <xsl:with-param name="haystack" select="." />
                <xsl:with-param name="needle" select="'='" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$vEndsWIthEqualSign = '1'">
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pEndPunct" select="'.:;,/'"/>
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </bf:mainTitle>
        </xsl:for-each>
        <!-- No subtitle in Work title object -->
        <xsl:choose>
          <xsl:when test="$pSubtitle">
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:subtitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </bf:subtitle>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
        <xsl:for-each select="marc:subfield[@code='n']">
          <bf:partNumber>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:partNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='p']">
          <bf:partName>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:partName>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Work properties from MARC 246 -->
  <xsl:template match="marc:datafield[@tag='246' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='246')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:if test="translate(@ind2,' 0123567','') = ''">
        <xsl:apply-templates select="." mode="title246">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- bf:Instance properties from MARC 246 -->
  <xsl:template match="marc:datafield[@tag='246' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='246')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pHasItem" select="false()"/>
    <!-- note special $5 processing for LoC below -->
    <xsl:if test="$pHasItem or not($localfields and marc:subfield[@code='5'])">
      <xsl:if test="translate(@ind2,'48','') = ''">
        <xsl:apply-templates select="." mode="title246">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- title processing for MARC 246 -->
  <xsl:template match="marc:datafield[@tag='246' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='246')]" mode="title246">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vTitleClass">
      <xsl:choose>
        <xsl:when test="@ind2 = '1'">bf:ParallelTitle</xsl:when>
        <xsl:otherwise>bf:VariantTitle</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:element name="{$vTitleClass}">
            <xsl:choose>
              <xsl:when test="@ind2 = '0'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/por" />
              </xsl:when>
              <xsl:when test="@ind2 = '2'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/dis" />
              </xsl:when>
              <xsl:when test="@ind2 = '4'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/cov" />
              </xsl:when>
              <xsl:when test="@ind2 = '5'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/atp" />
              </xsl:when>
              <xsl:when test="@ind2 = '6'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/cap" />
              </xsl:when>
              <xsl:when test="@ind2 = '7'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/run" />
              </xsl:when>
              <xsl:when test="@ind2 = '8'">
                <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/spi" />
              </xsl:when>
            </xsl:choose>
            <xsl:apply-templates mode="t246Props" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <!-- generate Title properties from linked 880 -->
            <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
              <xsl:variable name="vOccurrence">
                <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
              </xsl:variable>
              <xsl:apply-templates mode="t246Props" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='246' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:if>
            <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:element>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="marc:datafield[@tag='246' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='246')]" mode="t246Props">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='i']">
      <bf:note>
        <bf:Note>
          <rdfs:label>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </rdfs:label>
        </bf:Note>
      </bf:note>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='a']">
      <bf:mainTitle>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:mainTitle>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='b']">
      <bf:subtitle>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:subtitle>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='f']">
      <bf:date>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
          <xsl:with-param name="pForceTerm" select="true()"/>
        </xsl:call-template>
      </bf:date>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='n']">
      <bf:partNumber>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:partNumber>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='p']">
      <bf:partName>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:partName>
    </xsl:for-each>
  </xsl:template>

  <!-- bf:Work properties from MARC 247 -->
  <xsl:template match="marc:datafield[@tag='247' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='247')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:VariantTitle>
            <rdf:type rdf:resource="http://id.loc.gov/vocabulary/vartitletype/for" />
            <xsl:apply-templates mode="t247Props" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <!-- generate Title properties from linked 880 -->
            <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
              <xsl:variable name="vOccurrence">
                <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
              </xsl:variable>
              <xsl:apply-templates mode="t247Props" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='247' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:if>
            <xsl:variable name="vPos" select="count(preceding-sibling::marc:datafield[@tag='247']) + 1" />
            <xsl:if test="../marc:datafield[@tag='547'][$vPos]">
              <bf:note>
                <bf:Note>
                  <xsl:apply-templates select="../marc:datafield[@tag='547'][$vPos]" mode="instanceNote5XXLabel" />
                </bf:Note>
              </bf:note>
            </xsl:if>
          </bf:VariantTitle>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='247' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='247')]" mode="t247Props">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a']">
      <bf:mainTitle>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:mainTitle>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='b']">
      <bf:subtitle>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:subtitle>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='f']">
      <bf:date>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
          <xsl:with-param name="pForceTerm" select="true()"/>
        </xsl:call-template>
      </bf:date>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='g']">
      <bf:qualifier>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
          <xsl:with-param name="pChopParens" select="true()"/>
        </xsl:call-template>
      </bf:qualifier>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='n']">
      <bf:partNumber>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:partNumber>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='p']">
      <bf:partName>
        <xsl:if test="$vXmlLang != ''">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString" select="."/>
        </xsl:call-template>
      </bf:partName>
    </xsl:for-each>
    <xsl:for-each select="marc:subfield[@code='x']">
      <bf:identifiedBy>
        <bf:Issn>
          <rdf:value>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </rdf:value>
        </bf:Issn>
      </bf:identifiedBy>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
