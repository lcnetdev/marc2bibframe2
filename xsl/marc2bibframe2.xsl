<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:lclocal="http://id.loc.gov/ontologies/lclocal/"
                extension-element-prefixes="date"
                exclude-result-prefixes="xsl marc">

  <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- stylesheet parameters -->

  <!-- base for minting URIs -->
  <xsl:param name="baseuri" select="'http://example.org/'"/>

  <!--
      MARC field in which to find the record ID
      Defaults to subfield $a, to use a different subfield,
      add to the end of the tag (e.g. "035a")
  -->
  <xsl:param name="idfield" select="'001'"/>

  <!--
      URI for record source, default none,
      e.g. http://id.loc.gov/vocabulary/organizations/dlc
      To run test of idsource, comment out next line, uncomment
      following line, and uncomment the test in
      test/ConvSpec-001-007.xspec
  -->
  <xsl:param name="idsource"/>
  <!-- <xsl:param name="idsource" select="'http://id.loc.gov/vocabulary/organizations/dlc'"/> -->

  <!--
      Use field conversion for locally defined fields.
      Some fields in the conversion (e.g. 859) are locally defined by
      LoC for conversion. By default these fields will not be
      converted unless this parameter evaluates to true()
  -->
  <xsl:param name="localfields" select="true()"/>
  
  <!--
      datestamp for generationProcess property of Work adminMetadata
      Useful to override if date:date-time() extension is not
      available
  -->
  <xsl:param name="pGenerationDatestamp">
    <xsl:choose>
      
      <xsl:when test="function-available('date:date-time')">
        <xsl:value-of select="date:date-time()"/>
      </xsl:when>
      <xsl:when test="function-available('current-dateTime')">
        <xsl:value-of select="current-dateTime()"/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  
  <!-- Output serialization. Currently only "rdfxml" is supported -->
  <xsl:param name="serialization" select="'rdfxml'"/>
  <!-- suppression is a local param -->
  <xsl:param name="suppressed"></xsl:param> 
  
  <xsl:include href="variables.xsl"/>
  <xsl:include href="utils.xsl"/>
  <xsl:include href="ConvSpec-ControlSubfields.xsl"/>
  <xsl:include href="ConvSpec-LDR.xsl"/>
  <xsl:include href="ConvSpec-001-007.xsl"/>
  <xsl:include href="ConvSpec-006,008.xsl"/>
  <xsl:include href="ConvSpec-010-048.xsl"/>
  <xsl:include href="ConvSpec-050-088.xsl"/>
  <xsl:include href="ConvSpec-1XX,7XX,8XX-names.xsl"/>
  <xsl:include href="ConvSpec-200-247not240-Titles.xsl"/>
  <xsl:include href="ConvSpec-240andX30-UnifTitle.xsl"/>
  <xsl:include href="ConvSpec-250-270.xsl"/>
  <xsl:include href="ConvSpec-3XX.xsl"/>
  <!-- Commenting out for now. Need to revist these. Tests commented out too. -->
  <!-- <xsl:include href="ConvSpec-460-468-SeriesTreat.xsl"/> -->
  <xsl:include href="ConvSpec-490-510-Links.xsl"/>
  <xsl:include href="ConvSpec-5XX.xsl"/>
  <xsl:include href="ConvSpec-600-662.xsl"/>
  <xsl:include href="ConvSpec-720+740to755.xsl"/>
  <xsl:include href="ConvSpec-758.xsl"/>
  <xsl:include href="ConvSpec-760-788-Links.xsl"/>
  <xsl:include href="ConvSpec-841-887.xsl"/>
  <xsl:include href="ConvSpec-880.xsl"/>
  <xsl:include href="ConvSpec-Process6-Series.xsl"/>
  <xsl:include href="ConvSpec-Process8-ProvAct.xsl"/>
  <xsl:include href="lc-local-fields.xsl"/>

  <xsl:template match="/">

    <!-- RDF/XML document frame -->
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                 xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                 xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#">

          <xsl:apply-templates>
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
          
        </rdf:RDF>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="marc:collection">
    <xsl:param name="serialization"/>

    <!-- pass marc:record nodes on down -->
    <xsl:apply-templates>
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="marc:record[@type='Bibliographic' or not(@type)]">
    <xsl:param name="serialization"/>

    <xsl:variable name="recordno"><xsl:value-of select="position()"/></xsl:variable>

    <xsl:variable name="recordid">
      <xsl:apply-templates mode="recordid" select=".">
        <xsl:with-param name="baseuri" select="$baseuri"/>
        <xsl:with-param name="idfield" select="$idfield"/>
        <xsl:with-param name="recordno" select="$recordno"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="vInstanceType">
      <xsl:apply-templates mode="instanceType" select="marc:leader">
        <xsl:with-param name="pBaseUri" select="$baseuri"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="vCount880"><xsl:value-of select="count(marc:datafield[@tag='880'])"/></xsl:variable>
    
    <xsl:variable name="rAdminMetadata">
      <!-- Small admin metadata for when it was new. -->
      <bf:adminMetadata>
        <bf:AdminMetadata>
          <bf:status>
            <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/n">
              <rdfs:label>new</rdfs:label>
            </bf:Status>
          </bf:status>
          
          <xsl:variable name="cf008date" select="marc:controlfield[@tag='008']"/>
          <xsl:variable name="marcYear" select="substring($cf008date,1,2)"/>
          <xsl:variable name="creationYear">
            <xsl:choose>
              <xsl:when test="$marcYear &lt; 65"><xsl:value-of select="concat('20',$marcYear)"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="concat('19',$marcYear)"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="cDate" select="concat($creationYear,'-',substring($cf008date,3,2),'-',substring($cf008date,5,2))" />
          <xsl:variable name="cDateInt" select="10000 * $creationYear + 100 * substring($cf008date,3,2) + substring($cf008date,5,2)"/>
          
          <xsl:variable name="cf005date" select="marc:controlfield[@tag='005']" />
          <xsl:variable name="mDateInt" select="10000 * substring($cf005date,1,4) + 100 * substring($cf005date,5,2) + substring($cf005date,7,2)"/>
          <xsl:variable name="mDate" select="concat(substring($cf005date,1,4),'-',substring($cf005date,5,2),'-',substring($cf005date,7,2))"/>
          <bf:date>
            <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>date</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$cDateInt &gt; $mDateInt">
                <xsl:value-of select="$mDate" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$cDate" />
              </xsl:otherwise>
            </xsl:choose>
          </bf:date>
          
          <xsl:if test="marc:datafield[@tag='040']/marc:subfield[@code='a']">
            <xsl:variable name="sfA" select="marc:datafield[@tag='040']/marc:subfield[@code='a']/text()" />
            <bf:agent>
              <bf:Agent>
                <xsl:if test="$sfA = 'DLC'">
                  <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                </xsl:if>
                <bf:code><xsl:value-of select="$sfA"/></bf:code>
              </bf:Agent>
            </bf:agent>
          </xsl:if>
        </bf:AdminMetadata>
      </bf:adminMetadata>
      
      <!-- Small admin metadata capturing last modification of MARC. -->
      <xsl:variable name="vStatus" select="substring(marc:leader,6,1)"/>
      <xsl:if test="$vStatus!='n'">
        <bf:adminMetadata>
          <bf:AdminMetadata>
            <xsl:choose>
              <xsl:when test="$vStatus!=''">
                <xsl:for-each select="$codeMaps/maps/mstatus/*[name() = $vStatus]">
                  <xsl:choose>
                    <xsl:when test="$serialization = 'rdfxml'">
                      <bf:status>
                        <bf:Status>
                          <xsl:attribute name="rdf:about"><xsl:value-of select="@href"/></xsl:attribute>
                          <rdfs:label><xsl:value-of select="."/></rdfs:label>
                        </bf:Status>
                      </bf:status>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <bf:status>
                  <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/c">
                    <rdfs:label>changed</rdfs:label>
                  </bf:Status>
                </bf:status>
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:variable name="cf005date" select="marc:controlfield[@tag='005']" />
            <xsl:variable name="changeDate" select="concat(substring($cf005date,1,4),'-',substring($cf005date,5,2),'-',substring($cf005date,7,2),'T',substring($cf005date,9,2),':',substring($cf005date,11,2),':',substring($cf005date,13,2))" /> 
            <xsl:if test="marc:controlfield[@tag='005'] and not(starts-with($changeDate, '0000'))">
              <bf:date>
                <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>dateTime</xsl:attribute>
                <xsl:value-of select="$changeDate"/>
              </bf:date>
            </xsl:if>
            
            <xsl:choose>
              <xsl:when test="marc:datafield[@tag='040']/marc:subfield[@code='d']">
                <xsl:variable name="sfA" select="marc:datafield[@tag='040']/marc:subfield[@code='d'][last()]/text()" />
                <bf:descriptionModifier>
                  <bf:Agent>
                    <xsl:if test="$sfA = 'DLC'">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                    </xsl:if>
                    <bf:code><xsl:value-of select="$sfA"/></bf:code>
                  </bf:Agent>
                </bf:descriptionModifier>
              </xsl:when>
              <xsl:when test="marc:datafield[@tag='040']/marc:subfield[@code='a']">
                <xsl:variable name="sfA" select="marc:datafield[@tag='040']/marc:subfield[@code='a']/text()" />
                <bf:agent>
                  <bf:Agent>
                    <xsl:if test="$sfA = 'DLC'">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                    </xsl:if>
                    <bf:code><xsl:value-of select="$sfA"/></bf:code>
                  </bf:Agent>
                </bf:agent>
              </xsl:when>
            </xsl:choose>
          </bf:AdminMetadata>
        </bf:adminMetadata>
      </xsl:if>
      
      <xsl:for-each select="marc:datafield[@tag='884' and contains(marc:subfield[@code='a'], 'DLC bibframe2marc')]">
        <bf:adminMetadata>
          <bf:AdminMetadata>
            <bf:status>
              <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/c">
                <rdfs:label>changed</rdfs:label>
              </bf:Status>
            </bf:status>
            
            <xsl:variable name="cf005date" select="marc:subfield[@code='g']" />
            <xsl:variable name="changeDate" select="concat(substring($cf005date,1,4),'-',substring($cf005date,5,2),'-',substring($cf005date,7,2),'T',substring($cf005date,9,2),':',substring($cf005date,11,2),':',substring($cf005date,13,2))"/>
            <xsl:if test="not (starts-with($changeDate, '0000'))">
              <bf:date>
                <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>dateTime</xsl:attribute>
                <xsl:value-of select="$changeDate"/>
              </bf:date>
            </xsl:if>
            
            <xsl:choose>
              <xsl:when test="marc:subfield[@code='q']">
                <xsl:variable name="sfA" select="marc:subfield[@code='q']" />
                <bf:agent>
                  <bf:Agent>
                    <xsl:if test="$sfA = 'DLC'">
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                    </xsl:if>
                    <bf:code><xsl:value-of select="$sfA"/></bf:code>
                  </bf:Agent>
                </bf:agent>
              </xsl:when>
            </xsl:choose>
            
            <bf:generationProcess>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="marc:subfield[@code='u']"/></xsl:attribute>
            </bf:generationProcess>
          </bf:AdminMetadata>
        </bf:adminMetadata>
      </xsl:for-each>
      
      <!-- Small admin metadata when converted. -->
      <bf:adminMetadata>
        <bf:AdminMetadata>
          <bf:status>
            <bf:Status rdf:about="http://id.loc.gov/vocabulary/mstatus/c">
              <rdfs:label>changed</rdfs:label>
            </bf:Status>
          </bf:status>
          <xsl:choose>
            <xsl:when test="$idsource != ''">
              <bf:agent>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$idsource"/></xsl:attribute>
              </bf:agent>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>No 'idsource' runtime value provided. No agent identified as the actor converting the record.</xsl:message>
            </xsl:otherwise>
          </xsl:choose>
          <bf:generationProcess>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$vConvVersionURI"/></xsl:attribute>
          </bf:generationProcess>
          <bf:date>
            <xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xs,'dateTime')"/></xsl:attribute>
            <xsl:value-of select="$pGenerationDatestamp"/>
          </bf:date>
        </bf:AdminMetadata>
      </bf:adminMetadata>
      
      <bf:adminMetadata>
        <bf:AdminMetadata>
          <bf:descriptionLevel>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$vOntoVersionURI"/></xsl:attribute>
          </bf:descriptionLevel>
          <!-- pass fields through conversion specs for AdminMetadata properties -->
          <xsl:choose>
            <xsl:when test="$vCount880 = 0">
              <xsl:apply-templates mode="adminmetadata">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="mProcessAdminMetadata880">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </bf:AdminMetadata>
      </bf:adminMetadata>
    </xsl:variable>
    
    <!-- generate main Work entity -->
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml' and $vInstanceType != 'SecondaryInstance'">
        <bf:Work>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
          <xsl:copy-of select="$rAdminMetadata" />
          <!-- pass fields through conversion specs for Work properties -->
          <xsl:choose>
            <xsl:when test="$vCount880 = 0">
              <xsl:apply-templates mode="work">
                <xsl:with-param name="recordid" select="$recordid"/>
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="mProcessWork880">
                <xsl:with-param name="recordid" select="$recordid"/>
                <xsl:with-param name="serialization" select="$serialization"/>
                <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
          <!-- for MTA Hub records, put Instance properties on the Work, do not generate Instance -->
          <xsl:choose>
            <xsl:when test="$vInstanceType = 'Hub'">
              <xsl:choose>
                <xsl:when test="$vCount880 = 0">
                  <xsl:apply-templates mode="instance">
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="mProcessInstance880">
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <bf:hasInstance>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
              </bf:hasInstance>
            </xsl:otherwise>
          </xsl:choose>
        </bf:Work>
      </xsl:when>
    </xsl:choose>
    
    <!-- generate main Instance entity (except for MTA Hub records) -->
    <xsl:if test="$vInstanceType != 'Hub'">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Instance>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
            <!-- pass fields through conversion specs for Instance properties -->
            <xsl:choose>
              <xsl:when test="$vCount880 = 0">
                <xsl:apply-templates mode="instance">
                  <xsl:with-param name="recordid" select="$recordid"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="mProcessInstance880">
                  <xsl:with-param name="recordid" select="$recordid"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                  <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="marc:datafield[
                                @tag='758' and 
                                marc:subfield[@code='4']='http://id.loc.gov/ontologies/bibframe/instanceOf' and
                                contains(marc:subfield[@code='1'], $baseuri)
                              ]">
                <bf:instanceOf>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="marc:datafield[@tag='758']/marc:subfield[@code='1']"/></xsl:attribute>
                </bf:instanceOf>
              </xsl:when>
              <xsl:otherwise>
                <bf:instanceOf>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                </bf:instanceOf>
              </xsl:otherwise>
            </xsl:choose>
            <!-- generate hasItem properties -->
            <xsl:if test="marc:datafield[@tag='051'] or
                          marc:datafield[@tag='541'] or
                          marc:datafield[@tag='880' and substring(marc:subfield[@code='6'],1,3)='541'] or 
                          ($localfields and marc:datafield[marc:subfield[@code='5']='DLC'])">
                <bf:hasItem>
                    <bf:Item>
                      <xsl:attribute name="rdf:about">
                        <xsl:value-of select="concat($recordid,'#Item')"/>
                      </xsl:attribute>
                      <bf:heldBy>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                      </bf:heldBy>
                      <xsl:choose>
                        <xsl:when test="$vCount880 = 0">
                          <xsl:apply-templates select="marc:datafield[marc:subfield[@code='5']='DLC']" mode="work">
                            <xsl:with-param name="recordid" select="$recordid"/>
                            <xsl:with-param name="serialization" select="$serialization"/>
                            <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                            <xsl:with-param name="pHasItem" select="true()"/>
                          </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="marc:datafield[marc:subfield[@code='5']='DLC']" mode="mProcessWork880">
                            <xsl:with-param name="recordid" select="$recordid"/>
                            <xsl:with-param name="serialization" select="$serialization"/>
                            <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                            <xsl:with-param name="pHasItem" select="true()"/>
                          </xsl:apply-templates>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                          <xsl:when test="$vCount880 = 0">
                            <xsl:apply-templates select="marc:datafield[marc:subfield[@code='5']='DLC']" mode="instance">
                              <xsl:with-param name="recordid" select="$recordid"/>
                              <xsl:with-param name="serialization" select="$serialization"/>
                              <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                              <xsl:with-param name="pHasItem" select="true()"/>
                            </xsl:apply-templates>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:apply-templates select="marc:datafield[marc:subfield[@code='5']='DLC']" mode="mProcessInstance880">
                              <xsl:with-param name="recordid" select="$recordid"/>
                              <xsl:with-param name="serialization" select="$serialization"/>
                              <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                              <xsl:with-param name="pHasItem" select="true()"/>
                            </xsl:apply-templates>
                          </xsl:otherwise>
                      </xsl:choose>
                      <xsl:apply-templates select="marc:datafield" mode="item">
                        <xsl:with-param name="recordid" select="$recordid"/>
                        <xsl:with-param name="serialization" select="$serialization"/>
                        <xsl:with-param name="pInstanceType" select="$vInstanceType"/>
                        <xsl:with-param name="pHasItem" select="true()"/>
                      </xsl:apply-templates>
                      <bf:itemOf>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Instance</xsl:attribute>
                      </bf:itemOf>
                    </bf:Item>
                </bf:hasItem>
            </xsl:if>
            
            <xsl:choose>
              <xsl:when test="$vCount880 = 0">
                <xsl:apply-templates mode="hasItem">
                  <xsl:with-param name="recordid" select="$recordid"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="mProcessItem880">
                  <xsl:with-param name="recordid" select="$recordid"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
            
            <!--
            <xsl:choose>
              <xsl:when test="$vCount880 = 0">
                <xsl:apply-templates mode="hasItem">
                  <xsl:with-param name="recordid" select="$recordid"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="mProcessItem880">
                  <xsl:with-param name="recordid" select="$recordid"/>
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
            <!-\- special LoC processing for $5 -\->
            <!-\- link all properties from fields with $5=DLC to a single Item -\->
            <xsl:if test="$localfields and
                          not(marc:datafield[@tag='051']) and
                          marc:datafield[marc:subfield[@code='5']='DLC']">
              <bf:hasItem>
                <bf:Item>
                  <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat($recordid,'#Item-DLC')"/>
                  </xsl:attribute>
                  <bf:heldBy>
                    <bf:Agent>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($organizations,'dlc')"/></xsl:attribute>
                      <bf:code>DLC</bf:code>
                    </bf:Agent>
                  </bf:heldBy>
                  <xsl:apply-templates select="marc:datafield[marc:subfield[@code='5']='DLC']" mode="work">
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pHasItem" select="true()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="marc:datafield[marc:subfield[@code='5']='DLC']" mode="instance">
                    <xsl:with-param name="recordid" select="$recordid"/>
                    <xsl:with-param name="serialization" select="$serialization"/>
                    <xsl:with-param name="pHasItem" select="true()"/>
                  </xsl:apply-templates>
                  <!-\- generate Item properties from 541/561/563/583 -\->
                  <xsl:apply-templates select="marc:datafield[(((@tag='541' or @tag='561' or @tag='563' or @tag='583') and not(marc:subfield[@code='6'])) or (@tag='880' and (substring(marc:subfield[@code='6'],1,3)='541' or substring(marc:subfield[@code='6'],1,3)='561' or substring(marc:subfield[@code='6'],1,3)='563' or substring(marc:subfield[@code='6'],1,3)='583'))) and (marc:subfield[@code='5']='DLC' or not(marc:subfield[@code='5']))]" mode="item5XX">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </bf:Item>
              </bf:hasItem>
            </xsl:if>
            -->
          </bf:Instance>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="adminmetadata"/>
  <xsl:template match="text()" mode="work"/>
  <xsl:template match="text()" mode="instance"/>
  <xsl:template match="text()" mode="item"/>
  <xsl:template match="text()" mode="hasItem"/>

  <!-- warn about other elements -->
  <xsl:template match="*">

    <xsl:message terminate="no">
      <xsl:text>WARNING: Unmatched element: </xsl:text><xsl:value-of select="name()"/>
    </xsl:message>

    <xsl:apply-templates/>

  </xsl:template>

</xsl:stylesheet>
