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
      Conversion specs for bib title fields 210-247 (not 240)
  -->

  <!-- bf:Instance properties from MARC 210 -->
  <xsl:template match="marc:datafield[@tag='210']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title210-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance210" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='210' or @tag='880']" mode="instance210">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title210" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 210 -->
  <xsl:template match="marc:datafield[@tag='210' or @tag='880']" mode="title210">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:if test="@ind1 = 1">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$titleiri"/></xsl:attribute>
          </xsl:if>
          <rdf:type>bf:VariantTitle</rdf:type>
          <rdf:type>bf:AbbreviatedTitle</rdf:type>
          <xsl:if test="@ind2 = ' '">
            <bf:source>
              <bf:Source>
                <rdf:value>issnkey</rdf:value>
              </bf:Source>
            </bf:source>
          </xsl:if>
          <xsl:variable name="label">
            <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
          </xsl:variable>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,1,string-length($label)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='b']">
            <bf:qualifier>
              <xsl:call-template name="chopParens">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:qualifier>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='2']">
            <bf:source>
              <bf:Source>
                <rdfs:label><xsl:value-of select="."/></rdfs:label>
              </bf:Source>
            </bf:source>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <!-- bf:Instance properties from MARC 222 -->
  <xsl:template match="marc:datafield[@tag='222']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title222-<xsl:value-of select="position()"/></xsl:variable>      
    <xsl:apply-templates mode="instance222" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='222' or @tag='880']" mode="instance222">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title222" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 222 -->
  <xsl:template match="marc:datafield[@tag='222' or @tag='880']" mode="title222">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$titleiri"/></xsl:attribute>
          <rdf:type>bf:VariantTitle</rdf:type>
          <rdf:type>bf:KeyTitle</rdf:type>
          <xsl:variable name="label">
            <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
          </xsl:variable>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:mainTitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='b']">
            <bf:qualifier>
              <xsl:call-template name="chopParens">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:qualifier>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <!-- bf:Instance properties from MARC 242 -->
  <xsl:template match="marc:datafield[@tag='242']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title242-<xsl:value-of select="position()"/></xsl:variable>      
    <xsl:apply-templates mode="instance242" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='242' or @tag='880']" mode="instance242">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title242" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 242 -->
  <xsl:template match="marc:datafield[@tag='242' or @tag='880']" mode="title242">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:if test="@ind1 = 1">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$titleiri"/></xsl:attribute>
          </xsl:if>
          <rdf:type>bf:VariantTitle</rdf:type>
          <bf:variantType>translated</bf:variantType>
          <xsl:variable name="label">
            <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or
                                                                   @code='b' or
                                                                   @code='c' or
                                                                   @code='h' or
                                                                   @code='n' or
                                                                   @code='p']"/>
          </xsl:variable>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:mainTitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='b']">
            <bf:subtitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:subtitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='n']">
            <bf:partNumber>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partNumber>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='p']">
            <bf:partName>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partName>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='y']">
            <bf:language>
              <bf:Language>
                <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/languages/<xsl:value-of select="."/></xsl:attribute>
              </bf:Language>
            </bf:language>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Work properties from MARC 243 -->
  <xsl:template match="marc:datafield[@tag='243']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates mode="work243" select=".">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='243' or @tag='880']" mode="work243">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title243" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 243 -->
  <xsl:template match="marc:datafield[@tag='243' or @tag='880']" mode="title243">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <rdf:type>bf:VariantTitle</rdf:type>
          <rdf:type>bf:CollectiveTitle</rdf:type>
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
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:mainTitle>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Work properties from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="@ind1 = 1 and not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
      <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title245-<xsl:value-of select="position()"/></xsl:variable>
      <xsl:apply-templates mode="work245" select=".">
        <xsl:with-param name="titleiri" select="$titleiri"/>
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245' or @tag='880']" mode="work245">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title245" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
        <xsl:for-each select="marc:subfield[@code='f' or @code='g']">
          <bf:originDate>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:value-of select="."/>
              </xsl:with-param>
            </xsl:call-template>
          </bf:originDate>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:genreForm>
            <bf:GenreForm>
              <rdfs:label>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="chopBrackets">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='s']">
          <bf:version>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:value-of select="."/>
              </xsl:with-param>
            </xsl:call-template>
          </bf:version>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- bf:Instance properties from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title245-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance245" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245' or @tag='880']" mode="instance245">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:choose>
            <xsl:when test="@ind1 = 1 and not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$titleiri"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="title245" select=".">
                <xsl:with-param name="titleiri" select="$titleiri"/>
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </bf:title>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:responsibilityStatement>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:value-of select="."/>
              </xsl:with-param>
            </xsl:call-template>
          </bf:responsibilityStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:genreForm>
            <bf:GenreForm>
              <rdfs:label>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString">
                    <xsl:call-template name="chopBrackets">
                      <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245' or @tag='880']" mode="title245">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:if test="@ind1 = 1">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$titleiri"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="@ind1 = 1 and not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
            <rdf:type>bf:WorkTitle</rdf:type>
          </xsl:if>
          <rdf:type>bf:InstanceTitle</rdf:type>
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
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:mainTitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='b']">
            <bf:subtitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:subtitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='n']">
            <bf:partNumber>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partNumber>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='p']">
            <bf:partName>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partName>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Instance properties from MARC 246 -->
  <xsl:template match="marc:datafield[@tag='246']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title246-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance246" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='246' or @tag='880']" mode="instance246">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title246" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 246 -->
  <xsl:template match="marc:datafield[@tag='246' or @tag='880']" mode="title246">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:if test="(@ind1 = 1) or (@ind1 = 3)">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$titleiri"/></xsl:attribute>
          </xsl:if>
          <rdf:type>bf:VariantTitle</rdf:type>
          <xsl:choose>
            <xsl:when test="@ind2 = '0'">
              <bf:variantType>portion</bf:variantType>
            </xsl:when>
            <xsl:when test="@ind2 = '1'">
              <rdf:type>bf:ParallelTitle</rdf:type>
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
          <xsl:variable name="label">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='b' or
                                         @code='g' or
                                         @code='n' or
                                         @code='p']"/>
          </xsl:variable>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,1,string-length($label)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:mainTitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='b']">
            <bf:subtitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:subtitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='f']">
            <bf:date>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:date>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='n']">
            <bf:partNumber>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partNumber>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='p']">
            <bf:partName>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partName>
          </xsl:for-each>
          <xsl:apply-templates mode="subfield5" select="marc:subfield[@code='5']">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Instance properties from MARC 247 -->
  <xsl:template match="marc:datafield[@tag='247']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title247-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance247" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='247' or @tag='880']" mode="instance247">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:apply-templates mode="title247" select=".">
            <xsl:with-param name="titleiri" select="$titleiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title from MARC 247 -->
  <xsl:template match="marc:datafield[@tag='247' or @tag='880']" mode="title247">
    <xsl:param name="titleiri"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:if test="@ind1 = 1">
            <xsl:attribute name="rdf:about"><xsl:value-of select="$titleiri"/></xsl:attribute>
          </xsl:if>
          <rdf:type>bf:VariantTitle</rdf:type>
          <bf:variantType>former</bf:variantType>
          <xsl:variable name="label">
            <xsl:apply-templates mode="concat-nodes-space"
                                 select="marc:subfield[@code='a' or
                                         @code='b' or
                                         @code='g' or
                                         @code='n' or
                                         @code='p']"/>
          </xsl:variable>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,1,string-length($label)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:for-each select="marc:subfield[@code='a']">
            <bf:mainTitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:mainTitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='b']">
            <bf:subtitle>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:subtitle>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='f']">
            <bf:date>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:date>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='g']">
            <bf:qualifier>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:call-template name="chopParens">
                    <xsl:with-param name="chopString">
                      <xsl:value-of select="."/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </bf:qualifier>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='n']">
            <bf:partNumber>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partNumber>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='p']">
            <bf:partName>
              <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </bf:partName>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='x']">
            <bf:identifiedBy>
              <bf:Issn>
                <rdf:value>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                      <xsl:value-of select="."/>
                    </xsl:with-param>
                  </xsl:call-template>
                </rdf:value>
              </bf:Issn>
            </bf:identifiedBy>
          </xsl:for-each>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
