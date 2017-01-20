<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for 720, 740-754
  -->

  <!-- Processing of 720 is handled in ConvSpec-1XX,6XX,7XX,8XX-names.xsl -->

  <!-- Processing of 740 is handled in ConvSpec-X30and240-UnifTitle.xsl -->

  <xsl:template match="marc:datafield[@tag='752']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:apply-templates select="." mode="work752">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="recordid" select="$recordid"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work752">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:contribution>
          <bf:Contribution>
            <bf:place>
              <bf:Place>
                <rdf:type>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'HierarchicalGeographic')"/></xsl:attribute>
                </rdf:type>
                <rdfs:label><xsl:value-of select="$vLabel"/></rdfs:label>
                <madsrdf:componentList rdf:parseType="Collection">
                  <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
                    <xsl:variable name="vResource">
                      <xsl:choose>
                        <xsl:when test="@code='a'">madsrdf:Country</xsl:when>
                        <xsl:when test="@code='b'">madsrdf:County</xsl:when>
                        <xsl:when test="@code='c'">madsrdf:State</xsl:when>
                        <xsl:when test="@code='d'">madsrdf:City</xsl:when>
                        <xsl:otherwise>madsrdf:Geographic</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:element name="{$vResource}">
                      <rdfs:label>
                        <xsl:call-template name="chopPunctuation">
                          <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                      </rdfs:label>
                    </xsl:element>
                  </xsl:for-each>
                </madsrdf:componentList>
                <xsl:apply-templates select="marc:subfield[@code='0']" mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Place>
            </bf:place>
            <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
              <xsl:with-param name="pMode">relationship</xsl:with-param>
              <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:for-each select="marc:subfield[@code='4']">
              <bflc:relationship>
                <bflc:Relationship>
                  <bflc:relation>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($relators,substring(.,1,3))"/></xsl:attribute>
                  </bflc:relation>
                  <bf:relatedTo>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                  </bf:relatedTo>
                </bflc:Relationship>
              </bflc:relationship>
            </xsl:for-each>
          </bf:Contribution>
        </bf:contribution>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='753']" mode="instance">
    <xsl:param name="serialization" select="$serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c']">
          <xsl:variable name="vResource">
            <xsl:choose>
              <xsl:when test="@code='a'">bflc:MachineModel</xsl:when>
              <xsl:when test="@code='b'">bflc:ProgrammingLanguage</xsl:when>
              <xsl:when test="@code='c'">bflc:OperatingSystem</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <bf:systemRequirements>
            <xsl:element name="{$vResource}">
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
              <xsl:if test="following-sibling::marc:subfield[position()=1]/@code='0'">
                <xsl:apply-templates select="following-sibling::marc:subfield[position()=1]" mode="subfield0orw">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </bf:systemRequirements>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
