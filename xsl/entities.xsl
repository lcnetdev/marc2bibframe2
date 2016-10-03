<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Templates for building a BIBFRAME 2.0 entities from MARCXML
      All templates should have the mode "entities"
      Parameter "recordid" used to generate id
  -->

  <xsl:template match="marc:datafield[@tag='210']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:if test="@ind1 = 1">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title210-<xsl:value-of select="position()"/></xsl:attribute>
            <xsl:apply-templates mode="title210" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
        
  <xsl:template match="marc:datafield[@tag='222']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title222-<xsl:value-of select="position()"/></xsl:attribute>
          <xsl:apply-templates mode="title222" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='242']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:if test="@ind1 = 1">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title242-<xsl:value-of select="position()"/></xsl:attribute>
            <xsl:apply-templates mode="title242" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:if test="@ind1 = 1">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title245</xsl:attribute>
            <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
              <rdf:type>bf:WorkTitle</rdf:type>
            </xsl:if>
            <xsl:apply-templates mode="title245" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='246']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:if test="(@ind1 = 1) or (@ind1 = 3)">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title246-<xsl:value-of select="position()"/></xsl:attribute>
            <xsl:apply-templates mode="title246" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='247']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:if test="@ind1 = 1">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title247-<xsl:value-of select="position()"/></xsl:attribute>
            <xsl:apply-templates mode="title247" select=".">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="entities"/>

</xsl:stylesheet>
