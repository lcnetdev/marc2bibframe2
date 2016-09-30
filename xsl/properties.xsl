<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Templates to build BIBFRAME 2.0 properties for entities -->

  <!-- build the properties of a bf:Title from a 210 field -->
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

  <!-- build the properties of a bf:Title from a 222 field -->
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

  <!-- build the properties of a bf:Title from a 245 field -->
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

  <!-- build the properties of a bf:Work from a 245 field -->
  <xsl:template match="marc:datafield[@tag='245']" mode="work245">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='f' or @code='g']">
          <bf:originDate><xsl:value-of select="."/></bf:originDate>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:genreForm>
            <bf:GenreForm>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='s']">
          <bf:version><xsl:value-of select="."/></bf:version>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
