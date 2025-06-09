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
      Conversion specs for 760-788
  -->

  
  <xsl:template match="marc:datafield[@tag='760' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='760') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='762' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='762') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='765' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='765') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='767' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='767') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='770' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='770') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='772' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='772') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='773' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='773') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='774' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='774') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='775' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='775') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='776' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='776') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='777' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='777') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[
                          (@tag='780' and @ind2='4' and not(preceding-sibling::marc:datafield[1][@tag='780' and @ind2='4'])) or
                          (@tag='780' and @ind2!='4') or 
                          (@tag='880' and substring(marc:subfield[@code='6'],1,3)='780') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[
                          (@tag='785' and @ind2='6' and not(preceding-sibling::marc:datafield[1][@tag='785' and @ind2='6'])) or
                          (@tag='785' and @ind2='7' and not(preceding-sibling::marc:datafield[1][@tag='785' and @ind2='7'])) or
                          (@tag='785' and @ind2!='6' and @ind2!='7') or
                          (@tag='880' and substring(marc:subfield[@code='6'],1,3)='785') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='786' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='786') and contains(marc:subfield[@code='6'], '-00')] |
                       marc:datafield[@tag='787' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='787') and contains(marc:subfield[@code='6'], '-00')]"
                mode="work">
    <xsl:param name="recordid"/>
    <xsl:param name="pPosition" select="position()"/>
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vWorkUri"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:variable>
    <xsl:variable name="vInstanceUri"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition"/></xsl:variable>
    <xsl:variable name="vTag">
      <xsl:choose>
        <xsl:when test="@tag='880'"><xsl:value-of select="substring(marc:subfield[@code='6'],1,3)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="v76X78Xcount" select="count(
                            ../marc:datafield[@tag='770' or @tag='772' or @tag='773' or 
                                              @tag='774' or @tag='775' or @tag='777' or 
                                              @tag='780' or @tag='785'] 
                            )" />
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="$vTag='760'">http://id.loc.gov/vocabulary/relationship/series</xsl:when>
        <xsl:when test="$vTag='762'">http://id.loc.gov/vocabulary/relationship/subseries</xsl:when>
        <xsl:when test="$vTag='765'">http://id.loc.gov/vocabulary/relationship/translationof</xsl:when>
        <xsl:when test="$vTag='767'">http://id.loc.gov/vocabulary/relationship/translatedas</xsl:when>
        <xsl:when test="$vTag='770'">http://id.loc.gov/vocabulary/relationship/supplement</xsl:when>
        <xsl:when test="$vTag='772'">http://id.loc.gov/vocabulary/relationship/supplementto</xsl:when>
        <xsl:when test="$vTag='773'">http://id.loc.gov/vocabulary/relationship/partof</xsl:when>
        <xsl:when test="$vTag='774'">http://id.loc.gov/vocabulary/relationship/part</xsl:when>
        <xsl:when test="$vTag='775'">http://id.loc.gov/vocabulary/relationship/otheredition</xsl:when>
        <xsl:when test="$vTag='776'">http://id.loc.gov/vocabulary/relationship/otherphysicalformat</xsl:when>
        <xsl:when test="$vTag='777'">http://id.loc.gov/vocabulary/relationship/issuedwith</xsl:when>
        <xsl:when test="$vTag='780'">
          <xsl:choose>
            <xsl:when test="@ind2='0'">http://id.loc.gov/vocabulary/relationship/continuationof</xsl:when>
            <xsl:when test="@ind2='1'">http://id.loc.gov/vocabulary/relationship/continuedinpart</xsl:when>
            <xsl:when test="@ind2='4'">http://id.loc.gov/vocabulary/relationship/mergerof</xsl:when>
            <xsl:when test="@ind2='5' or @ind2='6'">http://id.loc.gov/vocabulary/relationship/absorptionof</xsl:when>
            <xsl:when test="@ind2='7'">http://id.loc.gov/vocabulary/relationship/separatedfrom</xsl:when>
            <xsl:otherwise>http://id.loc.gov/vocabulary/relationship/precededby</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='785'">
          <xsl:choose>
            <xsl:when test="@ind2='0' or @ind2='8'">http://id.loc.gov/vocabulary/relationship/continuedby</xsl:when>
            <xsl:when test="@ind2='1'">http://id.loc.gov/vocabulary/relationship/continuedinpartby</xsl:when>
            <xsl:when test="@ind2='4' or @ind2='5'">http://id.loc.gov/vocabulary/relationship/absorbedby</xsl:when>
            <xsl:when test="@ind2='6'">http://id.loc.gov/vocabulary/relationship/splitinto</xsl:when>
            <xsl:when test="@ind2='7'">http://id.loc.gov/vocabulary/relationship/mergedtoform</xsl:when>
            <xsl:otherwise>http://id.loc.gov/vocabulary/relationship/succeededby</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$vTag='786'">http://id.loc.gov/vocabulary/relationship/datasource</xsl:when>
        <xsl:when test="$vTag='787'">http://id.loc.gov/vocabulary/relationship/relatedwork</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="vElement">bf:Work</xsl:variable>
    <xsl:variable name="vElementUri"><xsl:value-of select="$vWorkUri"/></xsl:variable>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    
    <xsl:variable name="vOccurrence">
      <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
        <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vRelated880" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" />
    <xsl:variable name="v880XmlLang"><xsl:apply-templates select="$vRelated880" mode="xmllang"/></xsl:variable>
    <!--
       if http://id.loc.gov/vocabulary/relationship/mergedtoform
        then we need to test if there is a second 785 ind2=7.
          If there is,
            then the first 785 is the "mergedWith" relation and the second is the resource both were merged into.
          if there isn't,
            then guess we'll just treat this as the resource the 245 was merged into.  
    -->
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:relation>
          <bf:Relation>
            <xsl:if test="../marc:datafield[@tag='580']">
              <xsl:choose>
                <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/mergedtoform' and
                                count(preceding-sibling::marc:datafield[@tag='785']) = 0">
                  <xsl:apply-templates select="../marc:datafield[@tag='580'][1]" mode="relNote" />
                </xsl:when>
                <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/mergedtoform' and
                                count(preceding-sibling::marc:datafield[@tag='785']) = 2">
                  <xsl:apply-templates select="../marc:datafield[@tag='580'][2]" mode="relNote" />
                </xsl:when>
                <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/mergerof' and
                                count(preceding-sibling::marc:datafield[@tag='780']) = 0">
                  <xsl:apply-templates select="../marc:datafield[@tag='580'][1]" mode="relNote" />
                </xsl:when>
                <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/mergerof' and
                                count(preceding-sibling::marc:datafield[@tag='780']) = 2">
                  <xsl:apply-templates select="../marc:datafield[@tag='580'][2]" mode="relNote" />
                </xsl:when>
                <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/splitinto' and
                                count(preceding-sibling::marc:datafield[@tag='785']) = 0">
                  <xsl:apply-templates select="../marc:datafield[@tag='580'][1]" mode="relNote" />
                </xsl:when>
                <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/absorbedby' and
                                contains(../marc:datafield[@tag='580']/marc:subfield[@code='a'], 'bsorbed by')">
                  <xsl:apply-templates select="../marc:datafield[@tag='580' and contains(marc:subfield[@code='a'], 'bsorbed by')][1]" mode="relNote" />
                </xsl:when>
                <xsl:when test="(
                                  $vTag = '770' or 
                                  $vTag = '772' or 
                                  $vTag = '773' or 
                                  $vTag = '774' or 
                                  $vTag = '775' or 
                                  $vTag = '777' or 
                                  $vTag = '780' or
                                  $vTag = '785'
                                 ) and 
                                    count(../marc:datafield[@tag='580']) = 1 and
                                    $v76X78Xcount = 1
                          ">
                  <xsl:apply-templates select="../marc:datafield[@tag='580']" mode="relNote" />
                </xsl:when>
              </xsl:choose>  
            </xsl:if>
            <bf:relationship>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$vProperty"/></xsl:attribute>
            </bf:relationship>
          <xsl:for-each select="marc:subfield[@code='i']">
            <bf:relationship>
                  <bf:Relationship>
                    <rdfs:label>
                      <xsl:if test="$vXmlLang != ''">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                      </xsl:if>
                      <xsl:call-template name="tChopPunct">
                        <xsl:with-param name="pString" select="."/>
                      </xsl:call-template>
                    </rdfs:label>
                  </bf:Relationship>
                </bf:relationship>
          </xsl:for-each>
          <xsl:choose>
            <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/mergedtoform' and 
                            following-sibling::marc:datafield[1][@tag='785' and @ind2='7']">
              <bf:mergedWith>
                <xsl:apply-templates select="." mode="link7XXwork">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pTitleType" select="'work'"/>
                  <xsl:with-param name="pTag" select="$vTag" />
                  <xsl:with-param name="pWorkUri" select="$vWorkUri" />
                  <xsl:with-param name="pInstanceUri" select="$vInstanceUri" />
                  <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                  <xsl:with-param name="pRelated880" select="$vRelated880" />
                  <xsl:with-param name="p880XmlLang" select="$v880XmlLang" />
                </xsl:apply-templates>
              </bf:mergedWith>
              <bf:associatedResource>
                <xsl:variable name="vWorkUri2"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition + 1"/></xsl:variable>
                <xsl:variable name="vInstanceUri2"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition  + 1"/></xsl:variable>
                <xsl:variable name="vOccurrence2">
                  <xsl:if test="following-sibling::marc:datafield[1][@tag='785' and @ind2='7']/marc:subfield[@code='6'] and not(contains(following-sibling::marc:datafield[1][@tag='785' and @ind2='7']/marc:subfield[@code='6'], '-00'))">
                    <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
                  </xsl:if>
                </xsl:variable>
                <xsl:variable name="vRelated8802" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence2]" />
                <xsl:variable name="v880XmlLang2"><xsl:apply-templates select="$vRelated8802" mode="xmllang"/></xsl:variable>
                
                <xsl:apply-templates select="following-sibling::marc:datafield[1][@tag='785' and @ind2='7']" mode="link7XXwork">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pTitleType" select="'work'"/>
                  <xsl:with-param name="pTag" select="$vTag" />
                  <xsl:with-param name="pWorkUri" select="$vWorkUri2" />
                  <xsl:with-param name="pInstanceUri" select="$vInstanceUri2" />
                  <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                  <xsl:with-param name="pRelated880" select="$vRelated8802" />
                  <xsl:with-param name="p880XmlLang" select="$v880XmlLang2" />
                </xsl:apply-templates>
              </bf:associatedResource>
            </xsl:when>
            <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/mergerof' and 
              following-sibling::marc:datafield[1][@tag='780' and @ind2='4']">
              <bf:associatedResource>
                <xsl:apply-templates select="." mode="link7XXwork">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pTitleType" select="'work'"/>
                  <xsl:with-param name="pTag" select="$vTag" />
                  <xsl:with-param name="pWorkUri" select="$vWorkUri" />
                  <xsl:with-param name="pInstanceUri" select="$vInstanceUri" />
                  <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                  <xsl:with-param name="pRelated880" select="$vRelated880" />
                  <xsl:with-param name="p880XmlLang" select="$v880XmlLang" />
                </xsl:apply-templates>
              </bf:associatedResource>
              <bf:associatedResource>
                <xsl:variable name="vWorkUri2"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition + 1"/></xsl:variable>
                <xsl:variable name="vInstanceUri2"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition  + 1"/></xsl:variable>
                <xsl:variable name="vOccurrence2">
                  <xsl:if test="following-sibling::marc:datafield[1][@tag='780' and @ind2='4']/marc:subfield[@code='6'] and not(contains(following-sibling::marc:datafield[1][@tag='785' and @ind2='7']/marc:subfield[@code='6'], '-00'))">
                    <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
                  </xsl:if>
                </xsl:variable>
                <xsl:variable name="vRelated8802" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence2]" />
                <xsl:variable name="v880XmlLang2"><xsl:apply-templates select="$vRelated8802" mode="xmllang"/></xsl:variable>
                
                <xsl:apply-templates select="following-sibling::marc:datafield[1][@tag='780' and @ind2='4']" mode="link7XXwork">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pTitleType" select="'work'"/>
                  <xsl:with-param name="pTag" select="$vTag" />
                  <xsl:with-param name="pWorkUri" select="$vWorkUri2" />
                  <xsl:with-param name="pInstanceUri" select="$vInstanceUri2" />
                  <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                  <xsl:with-param name="pRelated880" select="$vRelated8802" />
                  <xsl:with-param name="p880XmlLang" select="$v880XmlLang2" />
                </xsl:apply-templates>
              </bf:associatedResource>
            </xsl:when>
            <xsl:when test="$vProperty = 'http://id.loc.gov/vocabulary/relationship/splitinto' and 
                            following-sibling::marc:datafield[1][@tag='785' and @ind2='6']">
              <bf:associatedResource>
                <xsl:apply-templates select="." mode="link7XXwork">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pTitleType" select="'work'"/>
                  <xsl:with-param name="pTag" select="$vTag" />
                  <xsl:with-param name="pWorkUri" select="$vWorkUri" />
                  <xsl:with-param name="pInstanceUri" select="$vInstanceUri" />
                  <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                  <xsl:with-param name="pRelated880" select="$vRelated880" />
                  <xsl:with-param name="p880XmlLang" select="$v880XmlLang" />
                </xsl:apply-templates>
              </bf:associatedResource>
              <xsl:for-each select="following-sibling::marc:datafield[@tag='785' and @ind2='6']">
                <bf:associatedResource>
                  <xsl:variable name="vWorkUriN"><xsl:value-of select="$recordid"/>#Work<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition + position()"/></xsl:variable>
                  <xsl:variable name="vInstanceUriN"><xsl:value-of select="$recordid"/>#Instance<xsl:value-of select="@tag"/>-<xsl:value-of select="$pPosition  + position()"/></xsl:variable>
                  <xsl:variable name="vOccurrenceN">
                    <xsl:if test="following-sibling::marc:datafield[1][@tag='785' and @ind2='6']/marc:subfield[@code='6'] and not(contains(following-sibling::marc:datafield[1][@tag='785' and @ind2='6']/marc:subfield[@code='6'], '-00'))">
                      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
                    </xsl:if>
                  </xsl:variable>
                  <xsl:variable name="vRelated880N" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$vTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrenceN]" />
                  <xsl:variable name="v880XmlLangN"><xsl:apply-templates select="$vRelated880N" mode="xmllang"/></xsl:variable>
                  
                  <xsl:apply-templates select="." mode="link7XXwork">
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pTitleType" select="'work'"/>
                    <xsl:with-param name="pTag" select="$vTag" />
                    <xsl:with-param name="pWorkUri" select="$vWorkUriN" />
                    <xsl:with-param name="pInstanceUri" select="$vInstanceUriN" />
                    <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                    <xsl:with-param name="pRelated880" select="$vRelated880N" />
                    <xsl:with-param name="p880XmlLang" select="$v880XmlLangN" />
                  </xsl:apply-templates>
                </bf:associatedResource>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <bf:associatedResource>
                <xsl:apply-templates select="." mode="link7XXwork">
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pTitleType" select="'work'"/>
                  <xsl:with-param name="pTag" select="$vTag" />
                  <xsl:with-param name="pWorkUri" select="$vWorkUri" />
                  <xsl:with-param name="pInstanceUri" select="$vInstanceUri" />
                  <xsl:with-param name="pXmlLang" select="$vXmlLang" />
                  <xsl:with-param name="pRelated880" select="$vRelated880" />
                  <xsl:with-param name="p880XmlLang" select="$v880XmlLang" />
                </xsl:apply-templates>
              </bf:associatedResource>
            </xsl:otherwise>
          </xsl:choose>
          </bf:Relation>
        </bf:relation>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="marc:datafield" mode="link7XXwork">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pWorkUri"/>
    <xsl:param name="pInstanceUri"/>
    <xsl:param name="pXmlLang"/>
    <xsl:param name="pRelated880"/>
    <xsl:param name="p880XmlLang"/>
    <xsl:param name="pTag"/>
    <bf:Work>
      <xsl:attribute name="rdf:about"><xsl:value-of select="$pWorkUri"/></xsl:attribute>
      <xsl:apply-templates select="." mode="tLink7XXTitle">
        <xsl:with-param name="serialization" select="$serialization"/>
        <xsl:with-param name="pTitleType" select="'work'"/>
        <xsl:with-param name="pTag" select="$pTag" />
      </xsl:apply-templates>
      <xsl:for-each select="marc:subfield[@code='a']">
        <bf:contribution>
          <bf:PrimaryContribution>
            <bf:agent>
              <bf:Agent>
                <rdfs:label>
                  <xsl:if test="$pXmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                  </xsl:call-template>
                </rdfs:label>
                <xsl:if test="$pRelated880/marc:subfield[@code='a'][position()]">
                  <rdfs:label>
                    <xsl:if test="$p880XmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$p880XmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="$pRelated880/marc:subfield[@code='a'][position()]"/>
                    </xsl:call-template>
                  </rdfs:label>
                </xsl:if>
              </bf:Agent>
            </bf:agent>
          </bf:PrimaryContribution>
        </bf:contribution>
      </xsl:for-each>
      <xsl:for-each select="marc:subfield[@code='e']">
        <xsl:variable name="encoded">
          <xsl:call-template name="url-encode">
            <xsl:with-param name="str" select="normalize-space(.)"/>
          </xsl:call-template>
        </xsl:variable>
        <bf:language>
          <bf:Language>
            <xsl:attribute name="rdf:about"><xsl:value-of select="concat($languages,$encoded)"/></xsl:attribute>
          </bf:Language>
        </bf:language>
      </xsl:for-each>
      <xsl:for-each select="marc:subfield[@code='p']">
        <bf:title>
          <bf:AbbreviatedTitle>
            <bf:mainTitle>
              <xsl:if test="$pXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="."/>
            </bf:mainTitle>
            <xsl:if test="$pRelated880/marc:subfield[@code='p'][position()]">
              <bf:mainTitle>
                <xsl:if test="$p880XmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$p880XmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="$pRelated880/marc:subfield[@code='p'][position()]"/>
                </xsl:call-template>
              </bf:mainTitle>
            </xsl:if>
          </bf:AbbreviatedTitle>
        </bf:title>
      </xsl:for-each>
      <xsl:for-each select="marc:subfield[@code='v']">
        <bf:note>
          <bf:Note>
            <rdfs:label>
              <xsl:if test="$pXmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$pXmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="."/>
              </xsl:call-template>
            </rdfs:label>
          </bf:Note>
        </bf:note>
      </xsl:for-each>
      <xsl:for-each select="marc:subfield[@code='x']">
        <bf:identifiedBy>
          <bf:Issn>
            <rdf:value>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="."/>
              </xsl:call-template>
            </rdf:value>
          </bf:Issn>
        </bf:identifiedBy>
      </xsl:for-each>
      <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="marc:subfield[@code='4']" mode="subfield4">
        <xsl:with-param name="serialization" select="$serialization"/>
      </xsl:apply-templates>
      <bf:hasInstance>
        <bf:Instance>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$pInstanceUri"/></xsl:attribute>
          <xsl:apply-templates select="." mode="link7XXinstance">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pWorkUri" select="$pWorkUri"/>
            <xsl:with-param name="pTag" select="$pTag"/>
          </xsl:apply-templates>
        </bf:Instance>
      </bf:hasInstance>
    </bf:Work>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="link7XXinstance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pWorkUri"/>
    <xsl:param name="pTag"/>
    
    <xsl:variable name="vOccurrence">
      <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
        <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vRelated880" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$pTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" />
    <xsl:variable name="v880XmlLang"><xsl:apply-templates select="$vRelated880" mode="xmllang"/></xsl:variable>
    
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:apply-templates select="." mode="tLink7XXTitle">
          <xsl:with-param name="serialization" select="$serialization"/>
          <xsl:with-param name="pTitleType" select="'instance'"/>
          <xsl:with-param name="pTag" select="$pTag"/>
        </xsl:apply-templates>
        <xsl:for-each select="marc:subfield[@code='b']">
          <bf:editionStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:editionStatement>
          <xsl:if test="$vRelated880/marc:subfield[@code='b'][position()]">
            <bf:editionStatement>
              <xsl:if test="$v880XmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="$vRelated880/marc:subfield[@code='b'][position()]"/>
              </xsl:call-template>
            </bf:editionStatement>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='d']">
          <bf:provisionActivityStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:provisionActivityStatement>
          <xsl:if test="$vRelated880/marc:subfield[@code='d'][position()]">
            <bf:provisionActivityStatement>
              <xsl:if test="$v880XmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="$vRelated880/marc:subfield[@code='d'][position()]"/>
              </xsl:call-template>
            </bf:provisionActivityStatement>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='f']">
          <xsl:variable name="encoded">
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:variable>
          <bf:provisionActivity>
            <bf:ProvisionActivity>
              <bf:place>
                <bf:Place>
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($countries,$encoded)"/></xsl:attribute>
                </bf:Place>
              </bf:place>
            </bf:ProvisionActivity>
          </bf:provisionActivity>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='g']">
          <bf:part>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:part>
          <xsl:if test="$vRelated880/marc:subfield[@code='g'][position()]">
            <bf:part>
              <xsl:if test="$v880XmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="$vRelated880/marc:subfield[@code='g'][position()]"/>
              </xsl:call-template>
            </bf:part>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='h']">
          <bf:extent>
            <bf:Extent>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdfs:label>
              <xsl:if test="$vRelated880/marc:subfield[@code='h'][position()]">
                <rdfs:label>
                  <xsl:if test="$v880XmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="$vRelated880/marc:subfield[@code='h'][position()]"/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:if>
            </bf:Extent>
          </bf:extent>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='j' or @code='m' or @code='n' or @code='q']">
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
              <xsl:variable name="tCode" select="@code"/>
              <xsl:if test="$vRelated880/marc:subfield[@code=$tCode][position()]">
                <rdfs:label>
                  <xsl:if test="$v880XmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="$vRelated880/marc:subfield[@code=$tCode][position()]"/>
                  </xsl:call-template>
                </rdfs:label>
              </xsl:if>
            </bf:Note>
          </bf:note>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='k']">
          <bf:seriesStatement>
            <xsl:if test="$vXmlLang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
            </xsl:call-template>
          </bf:seriesStatement>
          <xsl:if test="$vRelated880/marc:subfield[@code='k'][position()]">
            <bf:seriesStatement>
              <xsl:if test="$v880XmlLang != ''">
                <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
              </xsl:if>
              <xsl:call-template name="tChopPunct">
                <xsl:with-param name="pString" select="$vRelated880/marc:subfield[@code='k'][position()]"/>
              </xsl:call-template>
            </bf:seriesStatement>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='o']">
          <bf:identifiedBy>
            <bf:Local>
              <rdf:value>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdf:value>
            </bf:Local>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='r']">
          <bf:identifiedBy>
            <bf:ReportNumber>
              <rdf:value>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdf:value>
            </bf:ReportNumber>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='u' or @code='y' or @code='z']">
          <xsl:variable name="vIdentifier">
            <xsl:choose>
              <xsl:when test="@code='u'">bf:Strn</xsl:when>
              <xsl:when test="@code='y'">bf:Coden</xsl:when>
              <xsl:when test="@code='z'">bf:Isbn</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <bf:identifiedBy>
            <xsl:element name="{$vIdentifier}">
              <rdf:value>
                <xsl:call-template name="tChopPunct">
                  <xsl:with-param name="pString" select="."/>
                </xsl:call-template>
              </rdf:value>
            </xsl:element>
          </bf:identifiedBy>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='w']">
          <xsl:variable name="vIdClass">
            <xsl:choose>
              <xsl:when test="starts-with(.,'(DLC)')">bf:Lccn</xsl:when>
              <xsl:otherwise>bf:Identifier</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:apply-templates mode="subfield0orw" select=".">
            <xsl:with-param name="serialization" select="$serialization"/>
            <xsl:with-param name="pIdClass" select="$vIdClass"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:apply-templates select="marc:subfield[@code='3']" mode="subfield3">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="marc:subfield[@code='4']" mode="subfield4">
          <xsl:with-param name="serialization" select="$serialization"/>
        </xsl:apply-templates>
        <bf:instanceOf>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$pWorkUri"/></xsl:attribute>
        </bf:instanceOf>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield" mode="tLink7XXTitle">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pTitleType"/>
    <xsl:param name="pTag" />
    
    <xsl:variable name="vOccurrence">
      <xsl:if test="marc:subfield[@code='6'] and not(contains(marc:subfield[@code='6'], '-00'))">
        <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="vRelated880" select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)=$pTag and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]" />
    <xsl:variable name="v880XmlLang"><xsl:apply-templates select="$vRelated880" mode="xmllang"/></xsl:variable>

    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vMainTitle">
      <xsl:call-template name="tChopPunct">
        <xsl:with-param name="pString">
          <xsl:choose>
            <xsl:when test="$pTitleType='work' and marc:subfield[@code='s']">
              <xsl:value-of select="marc:subfield[@code='s']"/>
            </xsl:when>
            <xsl:when test="marc:subfield[@code='t']">
              <xsl:value-of select="marc:subfield[@code='t']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="concat-nodes-space" select="../marc:datafield[@tag='245']/marc:subfield[@code='a' or @code='b']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vMainTitle880">
      <xsl:if test="$vRelated880/marc:subfield[@code='s' or @code='t' or @code='a']">
        <xsl:call-template name="tChopPunct">
          <xsl:with-param name="pString">
            <xsl:choose>
              <xsl:when test="$pTitleType='work' and $vRelated880/marc:subfield[@code='s']">
                <xsl:value-of select="marc:subfield[@code='s']"/>
              </xsl:when>
              <xsl:when test="$vRelated880/marc:subfield[@code='t']">
                <xsl:value-of select="$vRelated880/marc:subfield[@code='t']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="concat-nodes-space" select="../marc:datafield[@tag='245']/marc:subfield[@code='a' or @code='b']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <xsl:if test="$vMainTitle != ''">
      <xsl:choose>
        <xsl:when test="$serialization='rdfxml'">
          <bf:title>
            <bf:Title>
              <bf:mainTitle>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$vMainTitle"/>
              </bf:mainTitle>
              <xsl:if test="$vMainTitle880 != ''">
                <bf:mainTitle>
                  <xsl:if test="$v880XmlLang != ''">
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$vMainTitle880"/>
                </bf:mainTitle>
              </xsl:if>
              <xsl:if test="$pTitleType='work'">
                <xsl:for-each select="marc:subfield[@code='c']">
                  <bf:qualifier>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                      <xsl:with-param name="pChopParens" select="true()"/>
                    </xsl:call-template>
                  </bf:qualifier>
                </xsl:for-each>
                <xsl:for-each select="$vRelated880/marc:subfield[@code='c']">
                  <bf:qualifier>
                    <xsl:if test="$v880XmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$v880XmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                      <xsl:with-param name="pChopParens" select="true()"/>
                    </xsl:call-template>
                  </bf:qualifier>
                </xsl:for-each>
              </xsl:if>
            </bf:Title>
          </bf:title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
