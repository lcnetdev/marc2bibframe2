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
      Conversion specs for 841-887
  -->

  <xsl:template match="marc:datafield[@tag='856']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="marc:subfield[@code='u'] and
                  (@ind2='1' or
                  (@ind2 != '0' and @ind2 != '2' and
                  substring(../marc:leader,7,1) != 'm' and
                  substring(../marc:controlfield[@tag='007'],1,1) != 'c' and
                  substring(../marc:controlfield[@tag='008'],24,1) != 'q' and
                  substring(../marc:controlfield[@tag='008'],24,1) != 's'))">
      <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
      <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:hasInstance>
            <bf:Instance>
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vInstanceUri"/></xsl:attribute>
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Electronic')"/></xsl:attribute>
              </rdf:type>
              <xsl:if test="../marc:datafield[@tag='245']">
                <bf:title>
                  <xsl:apply-templates mode="title245" select="../marc:datafield[@tag='245']">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="label">
                      <xsl:apply-templates mode="concat-nodes-space"
                                           select="../marc:datafield[@tag='245']/marc:subfield[@code='a' or
                                                   @code='b' or
                                                   @code='f' or 
                                                   @code='g' or
                                                   @code='k' or
                                                   @code='n' or
                                                   @code='p' or
                                                   @code='s']"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                </bf:title>
              </xsl:if>
              <bf:hasItem>
                <bf:Item>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="$vItemUri"/></xsl:attribute>
                  <xsl:apply-templates select="." mode="locator856">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pProp">bf:electronicLocator</xsl:with-param>
                  </xsl:apply-templates>
                  <bf:itemOf>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$vInstanceUri"/></xsl:attribute>
                  </bf:itemOf>
                </bf:Item>
              </bf:hasItem>
              <bf:instanceOf>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
              </bf:instanceOf>
            </bf:Instance>
          </bf:hasInstance>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='856']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="marc:subfield[@code='u'] and @ind2='2'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <xsl:apply-templates select="." mode="locator856">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pProp">bf:supplementaryContent</xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
          
  <xsl:template match="marc:datafield[@tag='850' or @tag='852']" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="vAddress">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='e' or @code='n']">
            <xsl:value-of select="concat(.,', ')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:hasItem>
            <bf:Item>
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vItemUri"/></xsl:attribute>
              <bf:heldBy>
                <bf:Agent>
                  <xsl:choose>
                    <xsl:when test="string-length(.) &lt; 10">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,.)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <rdfs:label><xsl:value-of select="."/></rdfs:label>
                    </xsl:otherwise>
                  </xsl:choose>
                </bf:Agent>
              </bf:heldBy>
              <xsl:if test="../@tag='852'">
                <xsl:for-each select="../marc:subfield[@code='b']">
                  <bf:subLocation>
                    <bf:SubLocation>
                      <rdfs:label><xsl:value-of select="."/></rdfs:label>
                    </bf:SubLocation>
                  </bf:subLocation>
                </xsl:for-each>
                <xsl:if test="$vAddress != ''">
                  <bf:subLocation>
                    <bf:SubLocation>
                      <rdfs:label><xsl:value-of select="$vAddress"/></rdfs:label>
                    </bf:SubLocation>
                  </bf:subLocation>
                </xsl:if>
                <xsl:for-each select="../marc:subfield[@code='u']">
                  <bf:electronicLocator>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                  </bf:electronicLocator>
                </xsl:for-each>
                <xsl:for-each select="../marc:subfield[@code='x' or @code='z']">
                  <bf:note>
                    <bf:Note>
                      <rdfs:label><xsl:value-of select="."/></rdfs:label>
                    </bf:Note>
                  </bf:note>
                </xsl:for-each>
              </xsl:if>
              <bf:itemOf>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
              </bf:itemOf>
            </bf:Item>
          </bf:hasItem>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='856']" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="marc:subfield[@code='u'] and
                  (@ind2='0' or
                  substring(../marc:leader,7,1)='m' or
                  substring(../marc:controlfield[@tag='007'],1,1)='c' or
                  substring(../marc:controlfield[@tag='008'],24,1)='q' or
                  substring(../marc:controlfield[@tag='008'],24,1)='s')">
      <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:hasItem>
            <bf:Item>
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vItemUri"/></xsl:attribute>
              <xsl:apply-templates select="." mode="locator856">
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pProp">bf:electronicLocator</xsl:with-param>
              </xsl:apply-templates>
              <bf:itemOf>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
              </bf:itemOf>
            </bf:Item>
          </bf:hasItem>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='856']" mode="locator856">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pProp"/>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='u']">
          <xsl:element name="{$pProp}">
            <xsl:choose>
              <xsl:when test="../marc:subfield[@code='z' or @code='y' or @code='3']">
                <rdfs:Resource>
                  <bflc:locator>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                  </bflc:locator>
                  <xsl:for-each select="../marc:subfield[@code='z' or @code='y' or @code='3']">
                    <bf:note>
                      <bf:Note>
                        <rdfs:label><xsl:value-of select="."/></rdfs:label>
                      </bf:Note>
                    </bf:note>
                  </xsl:for-each>
                </rdfs:Resource>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>
