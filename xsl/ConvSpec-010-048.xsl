<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:local="local:"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc local">

  <!--
      Conversion specs for 010-048
  -->

  <xsl:template match="marc:datafield[@tag='010']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Lccn>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
            </bf:Lccn>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='015']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Nbn>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
              <xsl:if test="following-sibling::marc:subfield[position() = 1][@code = 'q']">
                <bf:qualifier><xsl:value-of select="following-sibling::marc:subfield[position() = 1][@code = 'q']"/></bf:qualifier>
              </xsl:if>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Nbn>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='016']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Nban>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="../@ind1 = ' '">
                  <bf:source>
                    <bf:Source>
                      <rdfs:label>Library and Archives Canada</rdfs:label>
                    </bf:Source>
                  </bf:source>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </bf:Nban>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='017']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="date"><xsl:value-of select="marc:subfield[@code='d'][1]"/></xsl:variable>
    <xsl:variable name="dateformatted"><xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2))"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:CopyrightNumber>
              <rdf:value><xsl:value-of select="."/></rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='b']">
                <bf:source>
                  <bf:Source>
                    <rdfs:label><xsl:value-of select="normalize-space(.)"/></rdfs:label>
                  </bf:Source>
                </bf:source>
              </xsl:for-each>
              <xsl:if test="$date != ''">
                <bf:date>
                  <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>date</xsl:attribute>
                  <xsl:value-of select="$dateformatted"/>
                </bf:date>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='i']">
                <bf:note>
                  <bf:Note>
                    <rdfs:label>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                        <xsl:with-param name="chopString">
                          <xsl:value-of select="."/>
                        </xsl:with-param>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Note>
                </bf:note>
              </xsl:for-each>
            </bf:CopyrightNumber>
          </bf:identifiedBy>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Only match the first 020, for subsequent 020s create new instance -->
  <xsl:template match="marc:datafield[@tag='020'][not(preceding-sibling::marc:datafield[@tag='020'])]" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance020">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--
      generate new Instances from multiple 020s
  -->
  <xsl:template match="marc:datafield[@tag='020'][preceding-sibling::marc:datafield[@tag='020']]" mode="newInstance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="instanceiri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Instance>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$instanceiri"/></xsl:attribute>
          <xsl:apply-templates select="." mode="instance020">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          <bf:instanceOf>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          </bf:instanceOf>
        </bf:Instance>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instance020">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='z']">
          <bf:identifiedBy>
            <bf:Isbn>
              <rdf:value>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
              </rdf:value>
              <xsl:if test="@code = 'z'">
                <rdfs:label>invalid</rdfs:label>
              </xsl:if>
              <xsl:for-each select="../marc:subfield[@code='q']">
                <bf:qualifier>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
                    <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                  </xsl:call-template>
                </bf:qualifier>
              </xsl:for-each>
            </bf:Isbn>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
          <bf:acquisitionTerms>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
              <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
            </xsl:call-template>
          </bf:acquisitionTerms>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
