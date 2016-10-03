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
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>instance</xsl:attribute>
          <xsl:apply-templates mode="instance">
            <xsl:with-param name="recordid" select="$recordid"/>
            <xsl:with-param name="serialization" select="'rdfxml'"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>work</xsl:attribute>
          </bf:instanceOf>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='210']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="@ind1 = 1">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title210-<xsl:value-of select="position()"/></xsl:attribute>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <bf:Title>
                <xsl:apply-templates mode="title210" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Title>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='222']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:title>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title222-<xsl:value-of select="position()"/></xsl:attribute>
        </bf:title>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='242']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="@ind1 = 1">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title242-<xsl:value-of select="position()"/></xsl:attribute>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <bf:Title>
                <xsl:apply-templates mode="title242" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Title>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='245']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="@ind1 = 1">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title245</xsl:attribute>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <bf:Title>
                <xsl:apply-templates mode="title245" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Title>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>      
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:responsibilityStatement><xsl:value-of select="."/></bf:responsibilityStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:genreForm>
            <bf:GenreForm>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </bf:GenreForm>
          </bf:genreForm>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='246']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="(@ind1 = 1) or (@ind1 = 3)">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>title246-<xsl:value-of select="position()"/></xsl:attribute>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:title>
              <bf:Title>
                <xsl:apply-templates mode="title246" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Title>
            </bf:title>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>      
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <!-- <xsl:for-each select="marc:subfield[@code='c']"> -->
        <!--   <bf:responsibilityStatement><xsl:value-of select="."/></bf:responsibilityStatement> -->
        <!-- </xsl:for-each> -->
        <!-- <xsl:for-each select="marc:subfield[@code='h']"> -->
        <!--   <bf:genreForm> -->
        <!--     <bf:GenreForm> -->
        <!--       <rdfs:label><xsl:value-of select="."/></rdfs:label> -->
        <!--     </bf:GenreForm> -->
        <!--   </bf:genreForm> -->
        <!-- </xsl:for-each> -->
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="instance"/>

</xsl:stylesheet>
