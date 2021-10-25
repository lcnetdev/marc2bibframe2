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
            <xsl:if test="@ind2 != '0'">
              <xsl:variable name="label">
                <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
              </xsl:variable>
              <bflc:titleSortKey>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space(substring($label,@ind2+1))"/>
              </bflc:titleSortKey>
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
            <bf:variantType>translated</bf:variantType>
            <xsl:if test="@ind2 != '0'">
              <xsl:variable name="label">
                <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or
                                                                       @code='b' or
                                                                       @code='c' or
                                                                       @code='h' or
                                                                       @code='n' or
                                                                       @code='p']"/>
              </xsl:variable>
              <bflc:titleSortKey>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="normalize-space(substring($label,@ind2+1))"/>
                </xsl:call-template>
              </bflc:titleSortKey>
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
            <xsl:if test="@ind2 != '0'">
              <xsl:variable name="label">
                <xsl:apply-templates mode="concat-nodes-space"
                                     select="marc:subfield[@code='a' or
                                             @code='d' or
                                             @code='f' or
                                             @code='g' or
                                             @code='k' or
                                             @code='l' or
                                             @code='m' or
                                             @code='n' or
                                             @code='o' or
                                             @code='p' or
                                             @code='r' or
                                             @code='s']"/>
              </xsl:variable>
              <bflc:titleSortKey>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="normalize-space(substring($label,@ind2+1))"/>
                </xsl:call-template>
              </bflc:titleSortKey>
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
        <bf:title>
          <bf:Title>
            <xsl:apply-templates mode="title245" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pSubtitle" select="false()"/>
              <xsl:with-param name="label" select="$label"/>
            </xsl:apply-templates>
            <!-- generate Title properties from linked 880 -->
            <xsl:if test="@tag='245' and marc:subfield[@code='6']">
              <xsl:apply-templates mode="title245" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='245' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pSubtitle" select="false()"/>
                <xsl:with-param name="label" select="$vLinkedLabel"/>
              </xsl:apply-templates>
            </xsl:if>
          </bf:Title>
        </bf:title>
      </xsl:when>
    </xsl:choose>
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
        <xsl:if test="@ind2 != '0'">
          <bflc:titleSortKey>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="normalize-space(substring($label,@ind2+1))"/>
            </xsl:call-template>
          </bflc:titleSortKey>
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
                <bf:variantType>portion</bf:variantType>
              </xsl:when>
              <xsl:when test="@ind2 = '2'">
                <bf:variantType>distinctive</bf:variantType>
              </xsl:when>
              <xsl:when test="@ind2 = '4'">
                <bf:variantType>cover</bf:variantType>
              </xsl:when>
              <xsl:when test="@ind2 = '5'">
                <bf:variantType>added title page</bf:variantType>
              </xsl:when>
              <xsl:when test="@ind2 = '6'">
                <bf:variantType>caption</bf:variantType>
              </xsl:when>
              <xsl:when test="@ind2 = '7'">
                <bf:variantType>running</bf:variantType>
              </xsl:when>
              <xsl:when test="@ind2 = '8'">
                <bf:variantType>spine</bf:variantType>
              </xsl:when>
            </xsl:choose>
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
            <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:element>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Work properties from MARC 247 -->
  <xsl:template match="marc:datafield[@tag='247' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='247')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <bf:VariantTitle>
            <bf:variantType>former</bf:variantType>
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
          </bf:VariantTitle>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
