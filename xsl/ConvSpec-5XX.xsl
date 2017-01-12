<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 5XX fields -->

  <xsl:template match="marc:datafield[@tag='502']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work502">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='502' or @tag='880']" mode="work502">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:dissertation>
          <bf:Dissertation>
            <xsl:for-each select="marc:subfield[@code='a']">
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b']">
              <bf:degree><xsl:value-of select="."/></bf:degree>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='c']">
              <bf:grantingInstitution>
                <bf:Agent>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Agent>
              </bf:grantingInstitution>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='d']">
              <bf:date><xsl:value-of select="."/></bf:date>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='g']">
              <bf:note>
                <bf:Note>
                  <rdfs:label><xsl:value-of select="."/></rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='o']">
              <bf:identifiedBy>
                <bf:DissertationIdentifier>
                  <rdf:value><xsl:value-of select="."/></rdf:value>
                </bf:DissertationIdentifier>
              </bf:identifiedBy>
            </xsl:for-each>
          </bf:Dissertation>
        </bf:dissertation>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='508' or @tag='511']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="workCreditsNote">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='508' or @tag='511' or @tag='880']" mode="workCreditsNote">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vDisplayConst">
      <xsl:choose>
        <xsl:when test="$vTag='511' and @ind1='1'">Cast: </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:credits><xsl:value-of select="$vDisplayConst"/><xsl:value-of select="."/></bf:credits>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='500' or @tag='501' or @tag='504' or @tag='515']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instanceNote5XX">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pNoteType">
        <xsl:choose>
          <xsl:when test="@tag='501'">with</xsl:when>
          <xsl:when test="@tag='504'">bibliography</xsl:when>
          <xsl:when test="@tag='515'">issuance information</xsl:when>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='505']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance505">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='505' or @tag='880']" mode="instance505">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='g' or @code='r' or @code='t']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:tableOfContents>
          <bf:TableOfContents>
            <rdfs:label><xsl:value-of select="normalize-space($vLabel)"/></rdfs:label>
          </bf:TableOfContents>
        </bf:tableOfContents>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='506']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance506">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='506' or @tag='880']" mode="instance506">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='e' or @code='f']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:usageAndAccessPolicy>
          <bf:UsageAndAccessPolicy>
            <rdfs:label><xsl:value-of select="normalize-space($vLabel)"/></rdfs:label>
            <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='5']" mode="subfield5">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:UsageAndAccessPolicy>
        </bf:usageAndAccessPolicy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='507']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance507">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='507' or @tag='880']" mode="instance507">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:scale><xsl:value-of select="normalize-space($vLabel)"/></bf:scale>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='513']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance513">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='513' or @tag='880']" mode="instance513">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vLabel">
      <xsl:apply-templates mode="concat-nodes-space" select="marc:subfield[@code='a' or @code='b']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:note>
          <bf:Note>
            <bf:noteType>Report type</bf:noteType>
            <rdfs:label><xsl:value-of select="normalize-space($vLabel)"/></rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="instanceNote5XX">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pNoteType"/>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a']">
          <bf:note>
            <bf:Note>
              <rdfs:label><xsl:value-of select="."/></rdfs:label>
              <xsl:if test="$pNoteType != ''">
                <bf:noteType><xsl:value-of select="$pNoteType"/></bf:noteType>
              </xsl:if>
              <!-- special handling for other subfields -->
              <xsl:choose>
                <xsl:when test="$vTag='504'">
                  <xsl:for-each select="../marc:subfield[@code='b']">
                    <bf:count><xsl:value-of select="."/></bf:count>
                  </xsl:for-each>
                </xsl:when>
              </xsl:choose>
              <xsl:apply-templates select="../marc:subfield[@code='3']" mode="subfield3">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='5']" mode="subfield5">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
