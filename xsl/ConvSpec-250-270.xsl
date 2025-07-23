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

  <!-- Conversion specs for 250-270 -->

  <xsl:template match="marc:datafield[@tag='254' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='254')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:editionStatement>
          <xsl:if test="$vXmlLang != ''">
            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
          </xsl:if>
          <xsl:call-template name="tChopPunct">
            <xsl:with-param name="pString" select="marc:subfield[@code='a']"/>
           </xsl:call-template>
         </bf:editionStatement>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='255' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='255')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vCoordinates">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="marc:subfield[@code='c']"/>
        <xsl:with-param name="pChopParens" select="true()"/>
        <xsl:with-param name="pForceTerm" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vZone">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="marc:subfield[@code='d']"/>
        <xsl:with-param name="pChopParens" select="true()"/>
        <xsl:with-param name="pForceTerm" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vEquinox">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="marc:subfield[@code='e']"/>
        <xsl:with-param name="pChopParens" select="true()"/>
        <xsl:with-param name="pForceTerm" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:scale>
            <bf:Scale>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:Scale>
          </bf:scale>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code='b' or @code='c' or @code='d' or @code='f' or @code='g']">
          <bf:cartographicAttributes>
            <bf:Cartographic>
              <xsl:for-each select="marc:subfield[@code='b']">
                <bf:projection>
                  <bf:Projection>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Projection>
                </bf:projection>
              </xsl:for-each>
              <xsl:if test="$vCoordinates != ''">
                <bf:coordinates>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vCoordinates"/>
                </bf:coordinates>
              </xsl:if>
              <xsl:if test="$vZone != ''">
                <bf:ascensionAndDeclination>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vZone"/>
                </bf:ascensionAndDeclination>
              </xsl:if>
              <xsl:if test="$vEquinox != ''">
                <bf:equinox>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vEquinox"/>
                </bf:equinox>
              </xsl:if>
              <xsl:for-each select="marc:subfield[@code='f']">
                <bf:outerGRing>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:outerGRing>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='g']">
                <bf:exclusionGRing>
                  <xsl:if test="$vXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </bf:exclusionGRing>
              </xsl:for-each>
            </bf:Cartographic>
          </bf:cartographicAttributes>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='257' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='257')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:originPlace>
            <bf:Place>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Place>
          </bf:originPlace>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='250' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='250')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vEditionStatementRaw">
      <xsl:apply-templates select="marc:subfield[@code='a' or @code='b']" mode="concat-nodes-space"/>
    </xsl:variable>
    <xsl:variable name="vEditionStatement">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString" select="$vEditionStatementRaw"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:editionStatement>
          <xsl:if test="$vXmlLang != ''">
            <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$vEditionStatement"/>
        </bf:editionStatement>
      </xsl:when>
    </xsl:choose>
  </xsl:template>    
  
  <xsl:template match="marc:datafield[@tag='256' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='256')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <rdf:type>
              <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/computer</xsl:attribute>
            </rdf:type>
            <rdfs:label>
              <xsl:if test="$vXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="marc:subfield[@code='a']"/>
              </xsl:call-template>
            </rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='260']" mode="instance">
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="v880Occurrence">
      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
    </xsl:variable>
    <xsl:for-each select="marc:subfield[@code = 'd']">
      <xsl:variable name="vLinkedValue">
        <xsl:if test="$v880Occurrence and $v880Occurrence != '00'">
          <xsl:value-of
            select="../../marc:datafield[@tag = '880' and substring(marc:subfield[@code = '6'], 1, 3) = $vTag and substring(substring-after(marc:subfield[@code = '6'], '-'), 1, 2) = $v880Occurrence]/marc:subfield[@code = 'd'][position()]"
          />
        </xsl:if>
      </xsl:variable>
      <bf:identifiedBy>
        <bf:PublisherNumber>
          <rdf:value>
            <xsl:value-of select="."/>
          </rdf:value>
          <xsl:if test="$vLinkedValue != ''">
            <rdf:value>
              <xsl:value-of select="$vLinkedValue"/>
            </rdf:value>
          </xsl:if>
        </bf:PublisherNumber>
      </bf:identifiedBy>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='263' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='263')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bflc:projectedProvisionDate>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bflc:projectedProvisionDate>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='265' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='265')]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:acquisitionSource>
            <bf:AcquisitionSource>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </bf:AcquisitionSource>
          </bf:acquisitionSource>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
