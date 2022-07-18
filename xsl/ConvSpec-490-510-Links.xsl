<?xml version='1.0' encoding="UTF8"?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 490, and 510 - Other linking entries -->
  <!--can't have 2 490 work transforms; this is about the 8xx -->

  
  <!--uses wayne's code START HERE -->
  <!--or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='490')-->
  <xsl:template match="marc:datafield[@tag='490' ]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="hasParallel">
      <xsl:choose>
        <xsl:when test="count(marc:subfield[@code='a']) &gt; 1 and
          (substring(marc:subfield[@code='a'][1],string-length(marc:subfield[@code='a'][1])) = '=' or
          substring(marc:subfield[@code='v'][1],string-length(marc:subfield[@code='v'][1])) = '=')"><xsl:value-of select="true()"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="true()"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--for 880 pairing-->
    <xsl:variable name="vOccurrence">
      <xsl:value-of select="substring(substring-after(marc:subfield[@code='6'],'-'),1,2)"/>
    </xsl:variable>
    <xsl:variable name="v880Title">
      <xsl:if test="marc:subfield[@code='6']">            
        <xsl:for-each select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='490' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
          <xsl:variable name="v880Lang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
          <bf:mainTitle>       
            <xsl:if test="$v880Lang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$v880Lang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="marc:subfield[@code='a']"/>
            </xsl:call-template>
          </bf:mainTitle>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="v880Enumeration">
      <xsl:if test="marc:subfield[@code='6']">            
        <xsl:for-each select="../marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='490' and substring(substring-after(marc:subfield[@code='6'],'-'),1,2)=$vOccurrence]">
          <xsl:variable name="v880Lang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
          <bf:mainTitle>       
            <xsl:if test="$v880Lang != ''">
              <xsl:attribute name="xml:lang"><xsl:value-of select="$v880Lang"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="marc:subfield[@code='v']"/>
            </xsl:call-template>
          </bf:mainTitle>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>
    <xsl:for-each select="marc:subfield[@code='a']">
      <xsl:choose>
        <!--skip secondary subfield a's if hasparallel; don't build a new one-->
        <xsl:when test="preceding-sibling::subfield[@code='a'] and $hasParallel">
          <xsl:message >skipping bulding series because this is a jus parallel title</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
          <xsl:variable name="vTitle">
            <xsl:call-template name="tChopPunct">
              <xsl:with-param name="pString" select="."/>
              <xsl:with-param name="pEndPunct">
                <xsl:choose>
                  <xsl:when test="$hasParallel">                
                    <xsl:value-of select="'='"/>
                  </xsl:when>
                <xsl:otherwise>                
                  <xsl:value-of select="';,'"/>           
               </xsl:otherwise>
                </xsl:choose>            
              </xsl:with-param>
            </xsl:call-template>
           </xsl:variable> 
          
          <xsl:variable name="vParallelTitle">
             <xsl:for-each select="following-sibling::marc:subfield[@code='a'][text()]">
                <xsl:variable name="vParallelNode" select="generate-id(.)"/>                                        
                <xsl:variable name="vParallelEnumeration">
                  <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='v' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vParallelNode])"/>
                </xsl:variable>            
              <bf:title>
                <bf:ParallelTitle>
                <bf:mainTitle>    
                  <xsl:call-template name="tChopPunct">
                    <xsl:with-param name="pString" select="."/>
                    <xsl:with-param name="pEndPunct" select="';,'"/>
                  </xsl:call-template>
                </bf:mainTitle>
                <!--<xsl:if test="$vParallelEnumeration !=''">
                  <bf:partName><xsl:value-of select="$vParallelEnumeration"/></bf:partName>                 
                </xsl:if>-->
              </bf:ParallelTitle>
             </bf:title>
          </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="vLcc">
            <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='l' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode])"/>
          </xsl:variable>
          <xsl:variable name="vXIssn">            
            <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='x' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode])"/>
          </xsl:variable>
          <xsl:variable name="vEnumeration">
            <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='v' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode])"/>
          </xsl:variable>
          <xsl:variable name="vYIssn">
            <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='y' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode])"/>
          </xsl:variable>
          <xsl:variable name="vZIssn">
            <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='z' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode])"/>
          </xsl:variable>
          <xsl:variable name="vAppliesTo"><xsl:value-of select="preceding-sibling::marc:subfield[1][@code='3']"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bflc:relationship>
                <bflc:Relationship>
                  <bflc:relation>
                    <bflc:Relation rdf:about="http://id.loc.gov/ontologies/bibframe/hasSeries">
                      <rdfs:label>Has Series</rdfs:label>
                    </bflc:Relation>
                  </bflc:relation>
                  <bf:relatedTo>
                    <bf:Hub>
                      <rdf:type rdf:resource="http://id.loc.gov/ontologies/bibframe/Series"/>
                      <rdf:type rdf:resource="http://id.loc.gov/ontologies/bflc/Uncontrolled"/>
                      <bf:title>
                        <bf:Title>
                          <bf:mainTitle><xsl:value-of select="$vTitle"/></bf:mainTitle>
                           <xsl:if test="$v880Title !='' ">
                             <xsl:copy-of select="$v880Title"/>
                          </xsl:if>                        
                        </bf:Title>
                      </bf:title>
                      <xsl:if test="$vParallelTitle!='' ">
                        <xsl:copy-of select="$vParallelTitle"/>
                      </xsl:if>
                                          
                        <xsl:if test = "$vXIssn!=''">
                          <bf:identifiedBy>
                            <bf:Issn><rdf:value><xsl:value-of select="$vXIssn"/></rdf:value></bf:Issn>
                          </bf:identifiedBy>                      
                        </xsl:if>
                        
                        <xsl:if test="$vYIssn!=''">
                          <bf:identifiedBy>
                            <bf:Issn><rdf:value><xsl:value-of select="$vYIssn"/></rdf:value></bf:Issn>
                            <bf:status><bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/incorrect">
                              <rdfs:label>incorrect</rdfs:label></bf:Status>
                            </bf:status>
                          </bf:identifiedBy>                      
                        </xsl:if>
                      <xsl:if test="$vZIssn!=''">
                          <identifiedBy>
                            <Issn><rdf:value><xsl:value-of select="$vZIssn"/></rdf:value></Issn>
                            <bf:status><bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/cancinv">
                              <rdfs:label>canceled</rdfs:label></bf:Status>
                            </bf:status>
                          </identifiedBy>                      
                        </xsl:if>
                      <xsl:if test="$vLcc!=''">
                          <bf:classification><bf:ClassificationLcc>
                            <bf:assigner>
                              <bf:Agent rdf:about="http://id.loc.gov/vocabulary/organizations/dlc"/>
                            </bf:assigner>
                            <bf:classificationPortion><xsl:value-of select="$vLcc"/></bf:classificationPortion>
                          </bf:ClassificationLcc>
                          </bf:classification>
                          
                        </xsl:if>
                      <xsl:if test="$vAppliesTo !='' ">
                          <bflc:appliesTo>
                            <bflc:AppliesTo><xsl:value-of select="$vAppliesTo"/></bflc:AppliesTo>                        
                          </bflc:appliesTo>
                          
                        </xsl:if>
                       
                    </bf:Hub>
                  </bf:relatedTo>              
                  <xsl:if test="$vEnumeration !='' ">
                    <bf:seriesEnumeration><xsl:value-of select="$vEnumeration"/></bf:seriesEnumeration>
                  </xsl:if>
                  <xsl:if test="$v880Enumeration !='' and not($vEnumeration=$v880Enumeration) ">
                    <bf:seriesEnumeration><xsl:value-of select="$v880Enumeration"/></bf:seriesEnumeration>
                  </xsl:if>
                </bflc:Relationship>                         
                
              </bflc:relationship>
           
            </xsl:when>
          </xsl:choose>
        
   <!--end building a series  -->
          </xsl:otherwise>
         </xsl:choose>
        </xsl:for-each>
       
  </xsl:template>
  <xsl:template match="marc:datafield[@tag='510' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='510')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="@ind1='0' or @ind1='1' or @ind1='2'">bflc:indexedIn</xsl:when>
        <xsl:otherwise>bf:references</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vProperty}">
          <bf:Work>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:title>
                <bf:Title>
                  <bf:mainTitle>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="tChopPunct">
                      <xsl:with-param name="pString" select="."/>
                    </xsl:call-template>
                  </bf:mainTitle>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b' or @code='c']">
              <bf:note>
                <bf:Note>
                  <xsl:choose>
                    <xsl:when test="@code='b'">
                      <rdf:type>
                        <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/coverage</xsl:attribute>
                      </rdf:type>
                    </xsl:when>
                    <xsl:when test="@code='c'">
                      <rdf:type>
                        <xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/mnotetype/loc</xsl:attribute>
                      </rdf:type>
                    </xsl:when>
                  </xsl:choose>
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
          </bf:Work>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
