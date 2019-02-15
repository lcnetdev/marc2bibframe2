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
    <xsl:apply-templates select="." mode="work856">
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTagOrd" select="position()"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- 859 is a local field at LoC -->
  <xsl:template match="marc:datafield[@tag='859']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="$localfields">
      <xsl:apply-templates select="." mode="work856">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pTagOrd" select="position()"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work856">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTagOrd" select="position()"/>
    <!-- If ind2 is #, 0, 1, or 8 and the Instance does not have the class of Electronic, create a new Instance -->
    <xsl:if test="marc:subfield[@code='u'] and
                  (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and
                  (substring(../marc:leader,7,1) != 'm' and
                  substring(../marc:controlfield[@tag='008'],24,1) != 'o' and
                  substring(../marc:controlfield[@tag='008'],24,1) != 's')">
      <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="$pTagOrd"/></xsl:variable>
      <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="$pTagOrd"/></xsl:variable>
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
    <xsl:apply-templates select="." mode="instance856">
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- 859 is a local field at LoC -->
  <xsl:template match="marc:datafield[@tag='859']" mode="instance">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="$localfields">
      <xsl:apply-templates select="." mode="instance856">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instance856">
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
          
  <xsl:template match="marc:datafield[@tag='856']" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="hasItem856">
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTagOrd" select="position()"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- 859 is a local field at LoC -->
  <xsl:template match="marc:datafield[@tag='859']" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="$localfields">
      <xsl:apply-templates select="." mode="hasItem856">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pTagOrd" select="position()"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="hasItem856">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTagOrd" select="position()"/>
    <!-- If ind2 is #, 0, 1, or 8 and the Instance has the class of Electronic, add an Item to the Instance -->
    <xsl:if test="marc:subfield[@code='u'] and
                  (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and
                  (substring(../marc:leader,7,1) = 'm' or
                  substring(../marc:controlfield[@tag='008'],24,1) = 'o' or
                  substring(../marc:controlfield[@tag='008'],24,1) = 's')">
      <xsl:variable name="vItemUri"><xsl:value-of select="$recordid"/>#Item<xsl:value-of select="@tag"/>-<xsl:value-of select="$pTagOrd"/></xsl:variable>
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

  <xsl:template match="marc:datafield" mode="locator856">
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
