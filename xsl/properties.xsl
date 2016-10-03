<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Templates to build BIBFRAME 2.0 properties for entities -->

  <!-- bf:Title properties from MARC 210 -->
  <xsl:template match="marc:datafield[@tag='210']" mode="title210">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
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
          <bf:qualifier><xsl:value-of select="."/></bf:qualifier>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='2']">
          <bf:source>
            <bf:Source>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:Source>
          </bf:source>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <!-- bf:Title properties from MARC 222 -->
  <xsl:template match="marc:datafield[@tag='222']" mode="title222">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
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
          <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:qualifier><xsl:value-of select="."/></bf:qualifier>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    

  <!-- bf:Title properties from MARC 242 -->
  <xsl:template match="marc:datafield[@tag='242']" mode="title242">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <rdf:type>bf:VariantTitle</rdf:type>
        <bf:variantType>translated</bf:variantType>
        <xsl:variable name="label">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='n' or @code='p']"/>
        </xsl:variable>
        <xsl:if test="$label != ''">
          <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
          <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:subtitle><xsl:value-of select="."/></bf:subtitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='n']">
          <bf:partNumber><xsl:value-of select="."/></bf:partNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='p']">
          <bf:partName><xsl:value-of select="."/></bf:partName>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='y']">
          <bf:language>
            <bf:Language>
              <bf:code><xsl:value-of select="."/></bf:code>
            </bf:Language>
          </bf:language>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title properties from MARC 243 -->
  <xsl:template match="marc:datafield[@tag='243']" mode="title243">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
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
          <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title properties from MARC 245 -->
  <xsl:template match="marc:datafield[@tag='245']" mode="title245">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <rdf:type>bf:InstanceTitle</rdf:type>
        <xsl:variable name="label">
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='n' or @code='p']"/>
        </xsl:variable>
        <xsl:if test="$label != ''">
          <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
          <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:subtitle><xsl:value-of select="."/></bf:subtitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='n']">
          <bf:partNumber><xsl:value-of select="."/></bf:partNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='p']">
          <bf:partName><xsl:value-of select="."/></bf:partName>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Title properties from MARC 246 -->
  <xsl:template match="marc:datafield[@tag='246']" mode="title246">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
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
          <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='n' or @code='p']"/>
        </xsl:variable>
        <xsl:if test="$label != ''">
          <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
          <bflc:titleSortKey><xsl:value-of select="substring($label,1,string-length($label)-1)"/></bflc:titleSortKey>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:subtitle><xsl:value-of select="."/></bf:subtitle>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='f']">
          <bf:date><xsl:value-of select="."/></bf:date>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='n']">
          <bf:partNumber><xsl:value-of select="."/></bf:partNumber>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='p']">
          <bf:partName><xsl:value-of select="."/></bf:partName>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
