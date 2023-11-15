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

  <xsl:template match="marc:datafield[@tag='856' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='856')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work856">
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTagOrd" select="$pPosition"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- 859 is a local field at LoC -->
  <xsl:template match="marc:datafield[@tag='859' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='859')]" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="$localfields">
      <xsl:apply-templates select="." mode="work856">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pTagOrd" select="$pPosition"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="work856">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTagOrd" select="position()"/>
    <!-- only process if there is $u -->
    <xsl:if test="marc:subfield[@code='u'] and not(../marc:datafield[@tag='758'])">
      <!-- lower case for comparison -->
      <xsl:variable name="vSubfieldA" select="translate(normalize-space(marc:subfield[@code='a'][1]),$upper,$lower)"/>
      <xsl:variable name="vSubfield3" select="translate(normalize-space(marc:subfield[@code='3'][1]),$upper,$lower)"/>
      <xsl:choose>
        <xsl:when test="contains($vSubfieldA, 'table of contents') or contains($vSubfield3, 'table of contents')">
          <xsl:choose>
            <xsl:when test="$serialization='rdfxml'">
              <xsl:for-each select="marc:subfield[@code='u']">
                <bf:tableOfContents>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                </bf:tableOfContents>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <!-- If ind2 is #, 0, 1, or 8 and the Instance does not have the class of Electronic, create a new Instance -->
        <xsl:when test="(@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and
                        (substring(../marc:leader,7,1) != 'm' and
                        substring(../marc:controlfield[@tag='008'],24,1) != 'o' and
                        substring(../marc:controlfield[@tag='008'],24,1) != 's')">
            <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="$pTagOrd"/></xsl:variable>
            <xsl:choose>
              <xsl:when test="$serialization = 'rdfxml'">
                <bf:hasInstance>
                  <bf:Instance>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$vInstanceUri"/></xsl:attribute>
                    <rdf:type>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,'Electronic')"/></xsl:attribute>
                    </rdf:type>
                    <xsl:choose>
                      <xsl:when test="marc:subfield[@code='3']">
                        <bf:title>
                          <bf:Title>
                            <bf:mainTitle><xsl:value-of select="marc:subfield[@code='3']"/></bf:mainTitle>
                          </bf:Title>
                        </bf:title>
                      </xsl:when>
                      <xsl:when test="../marc:datafield[@tag='245']">
                      <bf:title>
                        <bf:Title>
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
                        </bf:Title>
                      </bf:title>
                    </xsl:when>
                    </xsl:choose>

                    <xsl:apply-templates select="." mode="locator856">
                      <xsl:with-param name="serialization" select="$serialization"/>
                      <xsl:with-param name="pProp">bf:electronicLocator</xsl:with-param>
                    </xsl:apply-templates>
                    <bf:instanceOf>
                      <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                    </bf:instanceOf>
                  </bf:Instance>
                </bf:hasInstance>
              </xsl:when>
            </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='856' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='856')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance856">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- 859 is a local field at LoC -->
  <xsl:template match="marc:datafield[@tag='859' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='859')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="$localfields">
      <xsl:apply-templates select="." mode="instance856">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instance856">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vSubfieldA" select="translate(normalize-space(marc:subfield[@code='a'][1]),$upper,$lower)"/>
    <xsl:variable name="vSubfield3" select="translate(normalize-space(marc:subfield[@code='3'][1]),$upper,$lower)"/>
    <xsl:if test="$serialization = 'rdfxml' and marc:subfield[@code='u']">
        <xsl:choose>
          <!-- If ind2 is #, 0, 1, or 8 and the Instance does not have the class of Electronic, create a new Instance -->
          <xsl:when test="../marc:datafield[@tag='758'] and 
            (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8')">
              <xsl:choose>
                <xsl:when test="marc:subfield[@code='3']">
                  <bf:title>
                    <bf:Title>
                      <bf:mainTitle><xsl:value-of select="marc:subfield[@code='3']"/></bf:mainTitle>
                    </bf:Title>
                  </bf:title>
                </xsl:when>
                <xsl:when test="../marc:datafield[@tag='245']">
                  <bf:title>
                    <bf:Title>
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
                    </bf:Title>
                  </bf:title>
                </xsl:when>
              </xsl:choose>
              <xsl:apply-templates select="." mode="locator856" />
          </xsl:when>
          <xsl:when test="@ind2='2' and not(contains($vSubfieldA, 'table of contents')) and not(contains($vSubfield3, 'table of contents'))">
            <xsl:apply-templates select="." mode="locator856">
              <xsl:with-param name="serialization" select="$serialization"/>
              <xsl:with-param name="pProp">bf:supplementaryContent</xsl:with-param>
              <xsl:with-param name="pObject">bf:SupplementaryContent</xsl:with-param>
            </xsl:apply-templates>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
  </xsl:template>
          
  <xsl:template match="marc:datafield[@tag='856' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='856')]" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="hasItem856">
      <xsl:with-param name="recordid" select="$recordid"/>
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pTagOrd" select="$pPosition"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- 859 is a local field at LoC -->
  <xsl:template match="marc:datafield[@tag='859' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='859')]" mode="hasItem">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:if test="$localfields">
      <xsl:apply-templates select="." mode="hasItem856">
        <xsl:with-param name="recordid" select="$recordid"/>
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pTagOrd" select="$pPosition"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="hasItem856">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTagOrd" select="position()"/>
    <xsl:variable name="vSubfieldA" select="translate(normalize-space(marc:subfield[@code='a'][1]),$upper,$lower)"/>
    <xsl:variable name="vSubfield3" select="translate(normalize-space(marc:subfield[@code='3'][1]),$upper,$lower)"/>
      <!-- If ind2 is #, 0, 1, or 8, the Instance has the class of Electronic, and $3 != 'Table of Contents', add an Item to the Instance -->
      <xsl:if test="not(../marc:datafield[@tag='758']) and 
                    marc:subfield[@code='u'] and
                    (@ind2=' ' or @ind2='0' or @ind2='1' or @ind2='8') and
                    (substring(../marc:leader,7,1) = 'm' or
                    substring(../marc:controlfield[@tag='008'],24,1) = 'o' or
                    substring(../marc:controlfield[@tag='008'],24,1) = 's') and
                    not(contains($vSubfieldA, 'table of contents')) and 
                    not(contains($vSubfield3, 'table of contents'))">
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
    <xsl:param name="pProp" select="'bf:electronicLocator'"/>
    <xsl:param name="pObject" select="'rdfs:Resource'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='u']">
          <xsl:choose>
            <xsl:when test="$pProp = 'bf:electronicLocator'">
              <xsl:element name="{$pProp}">
                <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
              </xsl:element>
              <xsl:for-each select="../marc:subfield[@code='z' or @code='y']">
                <bf:note>
                  <bf:Note>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="{$pProp}">
                <xsl:element name="{$pObject}">
                  <bf:electronicLocator>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                  </bf:electronicLocator>
                  <xsl:for-each select="../marc:subfield[@code='3' or @code='z' or @code='y']">
                    <bf:note>
                      <bf:Note>
                        <rdfs:label>
                          <xsl:if test="$vXmlLang != ''">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                          </xsl:if>
                          <xsl:call-template name="tChopPunct">
                            <xsl:with-param name="pString" select="."/>
                          </xsl:call-template>
                        </rdfs:label>
                      </bf:Note>
                    </bf:note>
                  </xsl:for-each>
                </xsl:element>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
