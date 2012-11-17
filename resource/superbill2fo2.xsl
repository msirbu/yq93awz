<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="mypage"
            margin-right="0.3in"
            margin-left="1in"
            margin-bottom="0.5in"
            margin-top="0.4in"
            page-height="11in" page-width="8.5in">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="mypage">
        <fo:flow flow-name="xsl-region-body">

            <fo:block-container height="1cm" width="5cm" top="0.07in" left="0.40in" position="absolute">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="test/name"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.32in" left="0.40in" position="absolute">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="test/Ins1"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.57in" left="0.40in" position="absolute">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="test/Ins2"/>
                </fo:block>
            </fo:block-container>
     
            <fo:block-container height="1cm" width="5cm" top="0.22in" left="3.0in" position="absolute">
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="14pt">
                    <xsl:value-of select="test/Date"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.72in" left="3.0in" position="absolute">
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="14pt">
                    <xsl:value-of select="test/Chart"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.27in" left="4.15in" position="absolute">
                <fo:block text-align="start" line-height="18pt" font-family="sans-serif" font-size="18pt">
                    <xsl:value-of select="test/drinitials"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="1cm" top="0.85in" left="4.25in" position="absolute">
                <fo:block text-align="center" line-height="18pt" font-family="sans-serif" font-size="18pt">
                    <xsl:value-of select="test/locR"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="1cm" top="1.26in" left="4.25in" position="absolute">
                <fo:block text-align="center" line-height="18pt" font-family="sans-serif" font-size="18pt">
                    <xsl:value-of select="test/locS"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.06in" left="4.85in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    <xsl:value-of select="test/SNSX"/>
                </fo:block>
            </fo:block-container>

 
            <fo:block-container height="1cm" width="5cm" top="0.32in" left="4.85in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    <xsl:value-of select="test/SFX"/>
                </fo:block>
            </fo:block-container>

 
            <fo:block-container height="1cm" width="5cm" top="0.55in" left="4.85in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    <xsl:value-of select="test/MRX"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="1.09in" left="3.35in" position="absolute">
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="14pt">
                    <xsl:value-of select="test/copay"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.80in" left="0.40in" position="absolute">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="test/balance"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.80in" left="1.08in" position="absolute">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="test/remtext"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.85in" left="1.90in" position="absolute">
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="14pt">
                    <xsl:value-of select="test/reminder"/>
                </fo:block>
            </fo:block-container>


            <fo:block-container height="1cm" width="5cm" top="9.8in" left="4.25in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="11pt">
                <xsl:value-of select="test/doctorname"/>
                </fo:block>           
            </fo:block-container>

            <fo:block-container height="1cm" width="2.5cm" top="9.8in" left="6.25in" position="absolute">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                <xsl:value-of select="test/Date"/>
                </fo:block>           
            </fo:block-container>

            <!-- new page ==================================================== -->

            <!-- TODO:  
                - check for NP flag; mark items with ask 
            -->

            <fo:block-container height="10.1in">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                     
                </fo:block>
            </fo:block-container>

            <fo:block-container  font-family="sans-serif" font-size="10pt">
                <fo:block text-align="start" line-height="10pt" font-family="sans-serif" font-size="10pt">
                    Demographic information for 
                    <fo:inline font-weight="bold"><xsl:value-of select="test/patient/chart"/> </fo:inline> 
                    <fo:inline color="#ffffff">_ _ _ _ _ _ _ _</fo:inline> 
                    Date: <xsl:value-of select="test/Date"/>
                </fo:block>

                <fo:block text-align="start" font-family="sans-serif" 
                    font-size="10pt" margin-top="4mm" >
                    Patient: <xsl:value-of select="test/patient/name"/>
                    <fo:inline color="#ffffff"> ... </fo:inline> 
					(DOB:
                			<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
					<xsl:value-of select="test/patient/dob"/>)
                			<fo:inline color="#ffffff"> ... </fo:inline>
					Age:
                			<fo:inline color="#ffffff" font-size="5pt">.</fo:inline>
					<xsl:value-of select="test/patient/age"/>
                			<fo:inline color="#ffffff"> ... </fo:inline>
					Sex:
                			<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
					<xsl:value-of select="test/patient/sex"/>
                </fo:block>

                <fo:block text-align="start" margin-top="1mm">
                    Address: <xsl:value-of select="test/patient/adr1"/>
                    <fo:inline color="#ffffff"> . . . </fo:inline> 
                    <xsl:value-of select="test/patient/adr2"/>
                    <fo:inline color="#ffffff"> . . . </fo:inline> 
                    <xsl:value-of select="test/patient/adr3"/>
                 </fo:block>

                <fo:block text-align="start"  margin-top="1mm">
                    SSN: <xsl:value-of select="test/patient/ssn"/>
                    <fo:inline color="#ffffff"> - - - - - </fo:inline> 
                    Signature on file: <xsl:value-of select="test/patient/signature/on_file"/>
                    <fo:inline color="#ffffff">.</fo:inline> 
                    (sig. date: <fo:inline color="#ffffff">.</fo:inline> 
                    <xsl:value-of select="test/patient/signature/date"/> )
                 </fo:block>

                <fo:table font-size="9pt" table-layout="fixed" width="6.5in" margin-top="2mm"  line-height="11pt" >
                    <fo:table-column column-number="1" column-width="12%"/>
                    <fo:table-column column-number="2" column-width="88%"/>
                    <fo:table-body text-align="left" >

                        <fo:table-row text-align="left" >
                            <fo:table-cell>
                                <fo:block>e-mail</fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block><xsl:value-of select="test/patient/email"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
 
                        <xsl:for-each select="test/patient/phone">
                            <fo:table-row text-align="left" >
                                <fo:table-cell>
                                    <fo:block><xsl:value-of select="type"/></fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block><xsl:value-of select="number"/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>	

                    </fo:table-body>
                </fo:table>

                <fo:block><fo:leader leader-pattern="rule" leader-length="6.5in" /> </fo:block>

                <fo:block font-family="sans-serif" font-size="10pt">
                    Insurance information 
					<fo:inline color="#ffffff"> - - - - - - - - - - - </fo:inline>
					Case: <xsl:value-of select="test/patient/case/id"/>
					<fo:inline color="#ffffff"> ..... </fo:inline>
					<xsl:value-of select="test/patient/case/name"/>
                </fo:block>

                <xsl:if test="test/patient/case/ins1/code != ''"> <!-- do only if cell is not null -->
                    <fo:block start-indent=".5cm" end-indent=".5cm">
                        Ins1: <xsl:value-of select="test/patient/case/ins1/code"/>
                                <fo:inline color="#ffffff"> ... </fo:inline>
                                <xsl:value-of select="test/patient/case/ins1/name"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        ID: <xsl:value-of select="test/patient/case/ins1/id"/>
                        <fo:inline color="#ffffff"> - - - - - - - - - - - - - - </fo:inline>
                        Copay: $ <xsl:value-of select="test/patient/case/ins1/copay"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        Group: <xsl:value-of select="test/patient/case/ins1/group"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        Insured: <xsl:value-of select="test/patient/case/ins1/insured"/>
                        (<xsl:value-of select="test/patient/case/ins1/relationship"/> )
                        <fo:inline color="#ffffff"> ..... </fo:inline>
                        DOB:
                		<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
                        <xsl:value-of select="test/patient/case/ins1/insured_dob"/>
                    </fo:block> 

                </xsl:if>	

                <xsl:if test="test/patient/case/ins2/code != ''"> <!-- do only if cell is not null -->
                    <fo:block start-indent=".5cm" end-indent=".5cm">
                        Ins2: <xsl:value-of select="test/patient/case/ins2/code"/>
                                <fo:inline color="#ffffff"> ... </fo:inline>
                                <xsl:value-of select="test/patient/case/ins2/name"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        ID: <xsl:value-of select="test/patient/case/ins2/id"/>
                        <fo:inline color="#ffffff"> - - - - - - - - - - - - - - </fo:inline>
                        Copay: $ <xsl:value-of select="test/patient/case/ins2/copay"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        Group: <xsl:value-of select="test/patient/case/ins2/group"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        Insured: <xsl:value-of select="test/patient/case/ins2/insured"/>
                        (<xsl:value-of select="test/patient/case/ins2/relationship"/> )
                        <fo:inline color="#ffffff"> ..... </fo:inline>
                        DOB:
                		<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
                        <xsl:value-of select="test/patient/case/ins2/insured_dob"/>
                    </fo:block> 

                </xsl:if>	

                <xsl:if test="test/patient/case/ins3/code != ''"> <!-- do only if cell is not null -->
                    <fo:block start-indent=".5cm" end-indent=".5cm">
                        Ins3: <xsl:value-of select="test/patient/case/ins3/code"/>
                                <fo:inline color="#ffffff"> ... </fo:inline>
                                <xsl:value-of select="test/patient/case/ins3/name"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        ID: <xsl:value-of select="test/patient/case/ins3/id"/>
                        <fo:inline color="#ffffff"> - - - - - - - - - - - - - - </fo:inline>
                        Copay: $ <xsl:value-of select="test/patient/case/ins3/copay"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        Group: <xsl:value-of select="test/patient/case/ins3/group"/>
                    </fo:block> 

                    <fo:block start-indent="1.5cm" end-indent=".5cm">
                        Insured: <xsl:value-of select="test/patient/case/ins3/insured"/>
                        ( <xsl:value-of select="test/patient/case/ins3/relationship"/> )
                        <fo:inline color="#ffffff"> ..... </fo:inline>
                        DOB:
                		<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
                        <xsl:value-of select="test/patient/case/ins3/insured_dob"/>
                    </fo:block> 

                </xsl:if>	

                <fo:block margin-top="2mm"><fo:leader leader-pattern="rule" leader-length="6.5in" /> </fo:block>

                <fo:block> Last visit information </fo:block>

                <xsl:if test="test/patient/history/dx"> 
                    <fo:table font-size="9pt" table-layout="fixed" width="6.5in"  margin-top="2mm">
                        <fo:table-column column-number="1" column-width="20%"/>
                        <fo:table-column column-number="2" column-width="80%"/>
                        <fo:table-body >
                            <xsl:for-each select="test/patient/history/dx">
                                <fo:table-row text-align="left" >
                                    <fo:table-cell margin-left="17mm">
                                        <fo:block><xsl:value-of select="code"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="name"/></fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>	
                        </fo:table-body>
                    </fo:table>
                </xsl:if>	

                <xsl:if test="test/patient/history/visit/trans"> 
                    <fo:table font-size="9pt" table-layout="fixed" width="6.5in" line-height="12pt" margin-top="3mm">
                        <fo:table-column column-number="1" column-width="12%"/>
                        <fo:table-column column-number="2" column-width="7%"/>
                        <fo:table-column column-number="3" column-width="7%"/>
                        <fo:table-column column-number="4" column-width="7%"/>
                        <fo:table-column column-number="5" column-width="7%"/>
                        <fo:table-column column-number="6" column-width="2%"/>
                        <fo:table-column column-number="7" column-width="7%"/>
                        <fo:table-column column-number="8" column-width="5%"/>
                        <fo:table-column column-number="9" column-width="5%"/>
                        <fo:table-column column-number="10" column-width="41%"/>
                        <fo:table-body border-style="solid" >

                            <xsl:for-each select="test/patient/history/visit/trans">
                                <fo:table-row text-align="center" display-align="center" height="3mm" border-style="solid"  >
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="date"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="d1"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="d2"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="d3"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="d4"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block> </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="proc"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="m1"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" >
                                            <fo:block><xsl:value-of select="m2"/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border-style="solid" text-align="left">
                                            <fo:block margin-left="2mm"><xsl:value-of select="name"/></fo:block>
                                        </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>	

                        </fo:table-body>
                    </fo:table>
                </xsl:if>	
                

                <fo:block margin-top="2mm"><fo:leader leader-pattern="rule" leader-length="6.5in" /> </fo:block>

                <fo:block margin-top="2mm" margin-bottom="2mm"> Patient history </fo:block>

                <fo:block> 
                    Well visits: 
                    <xsl:for-each select="test/patient/history/well_visit"> 
                        <fo:inline color="#ffffff"> ... </fo:inline> 
                        <xsl:value-of select="date"/>  
                        (<xsl:value-of select="code"/>)
                    </xsl:for-each>
                </fo:block>

                <fo:block> 
                    
                    <xsl:choose>
                        <xsl:when test="test/patient/sex='Female'">
                            PAP tests: 
                            <xsl:for-each select="test/patient/history/pap_test"> 
                                <fo:inline color="#ffffff"> ... </fo:inline> 
                                <xsl:value-of select="date"/>  
                            </xsl:for-each>
                            
                        </xsl:when>
                        <xsl:otherwise>
                             <fo:inline color="#777777">PAP tests: not applicable (patient sex)</fo:inline> 
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>

                <fo:block> 
                    Flu shots: 
                    <xsl:for-each select="test/patient/history/flu_shot"> 
                        <fo:inline color="#ffffff"> ... </fo:inline> 
                        <xsl:value-of select="date"/>  
                    </xsl:for-each>
                </fo:block>

            </fo:block-container>


        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
