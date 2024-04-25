<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for 758
  -->
  <xsl:template match="marc:datafield[
      @tag='758' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='758') and 
      not(marc:subfield[@code='4']='http://id.loc.gov/ontologies/bibframe/instanceOf')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel"><xsl:value-of select="marc:subfield[@code='a']" /></xsl:variable>
    
    <xsl:choose>
      <xsl:when test="not(marc:subfield[@code='i']) and not(marc:subfield[@code='4'])">
        <bflc:relationship>
          <bflc:Relationship>
            <bflc:relation rdf:resource="http://id.loc.gov/ontologies/bibframe/hasEquivalent" />
            <xsl:for-each select="marc:subfield[@code='0' or @code='1'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:apply-templates select="." mode="df758subfield0or1" />
            </xsl:for-each>
          </bflc:Relationship>
        </bflc:relationship>
      </xsl:when>
      <xsl:when test="marc:subfield[@code='4'] and not(contains(marc:subfield[@code='4'], 'rdaregistry'))">
        <bflc:relationship>
          <bflc:Relationship>
            <xsl:for-each select="marc:subfield[@code='4']">
              <xsl:choose>
                <xsl:when test="starts-with(text(),'http')">
                  <bflc:relation>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="text()"/></xsl:attribute>
                  </bflc:relation>
                </xsl:when>
                <xsl:otherwise>
                  <bflc:relation>
                    <bflc:Relation>
                      <rdfs:label><xsl:value-of select="text()" /></rdfs:label>
                    </bflc:Relation>
                  </bflc:relation>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='1'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:apply-templates select="." mode="df758subfield0or1" />
            </xsl:for-each>
          </bflc:Relationship>
        </bflc:relationship>
      </xsl:when>
      <xsl:when test="marc:subfield[@code='i']">
        <bflc:relationship>
          <bflc:Relationship>
            <xsl:for-each select="marc:subfield[@code='i']">
              <bflc:relation>
                <bflc:Relation>
                  <rdfs:label><xsl:value-of select="text()" /></rdfs:label>
                </bflc:Relation>
              </bflc:relation>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='1'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:apply-templates select="." mode="df758subfield0or1" />
            </xsl:for-each>
          </bflc:Relationship>
        </bflc:relationship>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!--
      create a bf:identifiedBy property from a subfield $0 or $w
  -->
  <xsl:template match="marc:subfield" mode="df758subfield0or1">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="relatedUri">
      <xsl:choose>
        <xsl:when test="starts-with(text(),'(uri)')"><xsl:value-of select="substring-after(text(),'(uri)')" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="text()" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <bf:relatedTo>
      <xsl:attribute name="rdf:resource"><xsl:value-of select="$relatedUri"/></xsl:attribute>
    </bf:relatedTo>
  </xsl:template>
</xsl:stylesheet>
