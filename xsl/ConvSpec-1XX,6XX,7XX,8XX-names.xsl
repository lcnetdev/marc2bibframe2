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
      Conversion specs for names from 1XX, 6XX, 7XX, and 8XX fields
  -->

  <!-- bf:Work properties from name fields -->
  <xsl:template match="marc:datafield[@tag='100' or @tag='110' or @tag='111']" mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="agentiri"><xsl:value-of select="$recordid"/>#Agent<xsl:value-of select="@tag"/>-<xsl:value-of select="position()"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="marc:subfield[@code='e' or @code='j' or @code='4']">
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <bf:contribution>
              <bf:Contribution>
                <xsl:apply-templates mode="agentContribution" select=".">
                  <xsl:with-param name="agentiri" select="$agentiri"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </bf:Contribution>
            </bf:contribution>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <bf:contributor>
              <xsl:apply-templates mode="agent" select=".">
                <xsl:with-param name="agentiri" select="$agentiri"/>
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </bf:contributor>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- bf:Contribution properties from name fields -->
  <xsl:template match="marc:datafield" mode="agentContribution">
    <xsl:param name="agentiri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="tag">
      <xsl:choose>
        <xsl:when test="@tag=880">
          <xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:agent>
          <xsl:apply-templates mode="agent" select=".">
            <xsl:with-param name="agentiri" select="$agentiri"/>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:agent>
        <xsl:choose>
          <xsl:when test="substring($tag,2,2)='11'">
            <xsl:apply-templates select="marc:subfield[@code='j']" mode="contributionRole">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="marc:subfield[@code='4']">
          <bf:role>
            <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/relators/<xsl:value-of select="."/></xsl:attribute>
          </bf:role>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='u']">
          <bflc:affiliation>
            <madsrdf:Affiliation>
              <rdfs:label>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
              </rdfs:label>
            </madsrdf:Affiliation>
          </bflc:affiliation>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- build bf:role properties -->
  <xsl:template match="marc:subfield" mode="contributionRole">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:call-template name="splitRole">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="roleString" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- recursive template to split bf:role properties out of a $e or $j -->
  <xsl:template name="splitRole">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="roleString"/>
    <xsl:choose>
      <xsl:when test="contains($roleString,',')">
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <bf:role>
              <bf:Role>
                <rdfs:label>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="substring-before($roleString,',')"/>
                  </xsl:call-template>
                </rdfs:label>
              </bf:Role>
            </bf:role>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="splitRole">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="roleString" select="substring-after($roleString,',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($roleString,' and')">
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <bf:role>
              <bf:Role>
                <rdfs:label>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="substring-before($roleString,' and')"/>
                  </xsl:call-template>
                </rdfs:label>
              </bf:Role>
            </bf:role>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="splitRole">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="roleString" select="substring-after($roleString,' and')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($roleString,'&amp;')">
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <bf:role>
              <bf:Role>
                <rdfs:label>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="substring-before($roleString,'&amp;')"/>
                  </xsl:call-template>
                </rdfs:label>
              </bf:Role>
            </bf:role>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="splitRole">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="roleString" select="substring-after($roleString,'&amp;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$serialization='rdfxml'">
            <bf:role>
              <bf:Role>
                <rdfs:label>
                  <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$roleString"/>
                  </xsl:call-template>
                </rdfs:label>
              </bf:Role>
            </bf:role>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- build a bf:Agent entity -->
  <xsl:template match="marc:datafield" mode="agent">
    <xsl:param name="agentiri"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="tag">
      <xsl:choose>
        <xsl:when test="@tag=880">
          <xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="label">
      <xsl:choose>
        <xsl:when test="substring($tag,2,2)='00'">
          <xsl:apply-templates mode="concat-nodes-space"
                               select="marc:subfield[@code='a' or
                                       @code='b' or 
                                       @code='c' or
                                       @code='d' or
                                       @code='j' or
                                       @code='q']"/>
        </xsl:when>
        <xsl:when test="substring($tag,2,2)='10'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']">
              <xsl:apply-templates mode="concat-nodes-space"
                                   select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='a' or
                                           @code='b' or 
                                           @code='c' or
                                           @code='d' or
                                           @code='n' or
                                           @code='g']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="concat-nodes-space"
                                   select="marc:subfield[@code='a' or
                                           @code='b' or 
                                           @code='c' or
                                           @code='d' or
                                           @code='n' or
                                           @code='g']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="substring($tag,2,2)='11'">
          <xsl:choose>
            <xsl:when test="marc:subfield[@code='t']">
              <xsl:apply-templates mode="concat-nodes-space"
                                   select="marc:subfield[@code='t']/preceding-sibling::marc:subfield[@code='a' or
                                           @code='c' or
                                           @code='d' or
                                           @code='e' or
                                           @code='n' or
                                           @code='g' or
                                           @code='q']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="concat-nodes-space"
                                   select="marc:subfield[@code='a' or
                                           @code='c' or
                                           @code='d' or
                                           @code='e' or
                                           @code='n' or
                                           @code='g' or
                                           @code='q']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="marckey">
      <xsl:apply-templates mode="marcKey"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:Agent>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$agentiri"/></xsl:attribute>
          <rdf:type>
            <xsl:choose>
              <xsl:when test="substring($tag,2,2)='00'">
                <xsl:choose>
                  <xsl:when test="@ind1='3'">bf:Family</xsl:when>
                  <xsl:otherwise>bf:Person</xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="substring($tag,2,2)='10'">
                <xsl:choose>
                  <xsl:when test="@ind1='1'">bf:Jurisdiction</xsl:when>
                  <xsl:otherwise>bf:Organization</xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="substring($tag,2,2)='11'">bf:Meeting</xsl:when>
            </xsl:choose>
          </rdf:type>
          <xsl:choose>
            <xsl:when test="substring($tag,2,2)='00'">
              <xsl:if test="$label != ''">
                <bflc:name00MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:name00MatchKey>
              </xsl:if>
              <bflc:name00MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name00MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='10'">
              <xsl:if test="$label != ''">
                <bflc:name10MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:name10MatchKey>
              </xsl:if>
              <bflc:name10MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name10MarcKey>
            </xsl:when>
            <xsl:when test="substring($tag,2,2)='11'">
              <xsl:if test="$label != ''">
                <bflc:name11MatchKey><xsl:value-of select="normalize-space($label)"/></bflc:name11MatchKey>
              </xsl:if>
              <bflc:name11MarcKey><xsl:value-of select="concat(@tag,@ind1,@ind2,normalize-space($marckey))"/></bflc:name11MarcKey>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="normalize-space($label)"/></rdfs:label>
          </xsl:if>
          <xsl:if test="not(marc:subfield[@code='t'])">
            <xsl:apply-templates mode="subfield0orw" select="marc:subfield[@code='0']">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </xsl:if>
        </bf:Agent>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
