<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Templates for building a BIBFRAME 2.0 Instance Resource from MARCXML
      All templates should have the mode "instance"
  -->
  

  <xsl:template match="marc:record" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Instance>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
          <xsl:apply-templates mode="instance">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          </bf:instanceOf>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:leader" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:choose>
          <xsl:when test="substring(.,7,1) = 'd'"><rdf:type>Manuscript</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'f'"><rdf:type>Manuscript</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 'm'"><rdf:type>Electronic</rdf:type></xsl:when>
          <xsl:when test="substring(.,7,1) = 't'"><rdf:type>Manuscript</rdf:type></xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="substring(.,8,1) = 'a'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>m</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'b'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>s</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'c'"><rdf:type>Collection</rdf:type></xsl:when>
          <xsl:when test="substring(.,8,1) = 'd'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>d</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'i'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>i</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 'm'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>m</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
          <xsl:when test="substring(.,8,1) = 's'">
            <bf:issuance>
              <bf:Issuance>
                <bf:code>s</bf:code>
              </bf:Issuance>
            </bf:issuance>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="substring(.,9,1) = 'a'"><rdf:type>Archival</rdf:type></xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='210']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title210-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance210" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='222']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title222-<xsl:value-of select="position()"/></xsl:variable>      
    <xsl:apply-templates mode="instance222" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='242']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title242-<xsl:value-of select="position()"/></xsl:variable>      
    <xsl:apply-templates mode="instance242" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title245-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance245" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='246']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title246-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance246" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='247']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title247-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates mode="instance247" select=".">
      <xsl:with-param name="titleiri" select="$titleiri"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='880']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'210')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance210" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'222')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>      
        <xsl:apply-templates mode="instance222" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'242')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>      
        <xsl:apply-templates mode="instance242" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'245')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance245" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'246')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance246" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with(marc:subfield[@code='6'],'247')">
        <xsl:variable name="titleiri"><xsl:value-of select="$recordid"/>#Title880-<xsl:value-of select="position()"/></xsl:variable>
        <xsl:apply-templates mode="instance247" select=".">
          <xsl:with-param name="titleiri" select="$titleiri"/>
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="instance"/>

</xsl:stylesheet>
