<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 490, 510, 530-535 - Other linking entries -->

  <xsl:template match="marc:datafield[@tag='490']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:seriesStatement>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:seriesStatement>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='v']">
          <bf:seriesEnumeration>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:seriesEnumeration>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='x']">
          <bf:hasSeries>
            <bf:Work>
              <bf:identifiedBy>
                <bf:Issn>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Issn>
              </bf:identifiedBy>
            </bf:Work>
          </bf:hasSeries>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='530']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance530-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="work530">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
      <xsl:with-param name="recordid" select="$recordid"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='530' or @tag='880']" mode="work530">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:param name="recordid"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:hasInstance>
          <bf:Instance>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
            <bf:instanceOf>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
            </bf:instanceOf>
            <bf:otherPhysicalFormat>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
            </bf:otherPhysicalFormat>
            <xsl:choose>
              <xsl:when test="../marc:datafield[@tag='130']">
                <xsl:apply-templates mode="titleUnifTitle" select="../marc:datafield[@tag='130']">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="label">
                    <xsl:apply-templates mode="concat-nodes-space"
                                         select="../marc:datafield[@tag='130']/marc:subfield[@code='a' or
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
                  </xsl:with-param>                    
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="../marc:datafield[@tag='240']">
                <xsl:apply-templates mode="titleUnifTitle" select="../marc:datafield[@tag='240']">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="label">
                    <xsl:apply-templates mode="concat-nodes-space"
                                         select="../marc:datafield[@tag='240']/marc:subfield[@code='a' or
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
                  </xsl:with-param>                    
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
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
              </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:note>
                <bf:Note>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:acquisitionSource>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:acquisitionSource>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:acquisitionTerms>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </bf:acquisitionTerms>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='d']">
              <bf:identifiedBy>
                <bf:StockNumber>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:StockNumber>
              </bf:identifiedBy>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='u']">
              <bf:hasItem>
                <bf:Item>
                  <bf:itemOf>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
                  </bf:itemOf>
                  <bf:electronicLocator>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
                  </bf:electronicLocator>
                </bf:Item>
              </bf:hasItem>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='3']">
              <xsl:apply-templates select="." mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </bf:Instance>
        </bf:hasInstance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='510']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance510">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='510' or @tag='880']" mode="instance510">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bflc:indexedIn>
          <bf:Work>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:title>
                <bf:Title>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b' or @code='c']">
              <bf:note>
                <bf:Note>
                  <bf:noteType>
                    <xsl:choose>
                      <xsl:when test="@code='b'">Coverage</xsl:when>
                      <xsl:when test="@code='c'">Location</xsl:when>
                    </xsl:choose>
                  </bf:noteType>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='x']">
              <bf:identifiedBy>
                <bf:Issn>
                  <rdfs:label>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Issn>
              </bf:identifiedBy>
            </xsl:for-each>
          </bf:Work>
        </bflc:indexedIn>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='530']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance530-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:apply-templates select="." mode="instance530">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pInstanceUri" select="$vInstanceUri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='530' or @tag='880']" mode="instance530">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:otherPhysicalFormat>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
        </bf:otherPhysicalFormat>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    
  
</xsl:stylesheet>
