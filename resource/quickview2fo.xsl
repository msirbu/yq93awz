<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="firstpage"
            margin-right="0.3in"
            margin-left="0.3in"
            margin-bottom="0.5in"
            margin-top="0.4in"
            page-height="11in" page-width="8.5in">
          <fo:region-body margin-top="0.1in" margin-bottom="0.1in"/>
          <fo:region-before extent="0.1in"/>
          <fo:region-after extent="0.1in"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="otherpages"
            margin-right="0.3in"
            margin-left="0.3in"
            margin-bottom="0.5in"
            margin-top="0.4in"
            page-height="11in" page-width="8.5in">
          <fo:region-body margin-top="1.5in" margin-bottom="0.0in"/>
          <fo:region-before extent="1.5in"/>
          <fo:region-after extent="0.0in"/>
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="my-sequence">
            <fo:single-page-master-reference master-reference="firstpage"/>
            <fo:repeatable-page-master-reference master-reference="otherpages"/>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="my-sequence">


        <fo:flow flow-name="xsl-region-body">

        <fo:block-container  font-family="sans-serif" font-size="12pt">
            <fo:block>
                Total remainder <xsl:value-of select="stmt/Chart"/>: 
                <xsl:value-of select="stmt/total"/>  
            </fo:block>
        </fo:block-container>
    
        <xsl:choose>
            <xsl:when test="stmt/summary">
                <fo:block-container width="7.9in" left="0.00in" >
                    <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
                </fo:block-container>
            </xsl:when>

            <xsl:otherwise>
                <fo:block> </fo:block>
            </xsl:otherwise>
        </xsl:choose>

        <!--   ============================ done summary & separator ================================= -->

        <!--   ======================== Previously billed transactions =============================== -->

        <xsl:choose>
            <xsl:when test="stmt/prev_stmt">
                <fo:block font-size="10pt" >Previously billed transactions:</fo:block>


                    <xsl:for-each select="stmt/prev_stmt">

                        <fo:block-container width="7.0in" top="0.30in" left="0.0in" >
                            <fo:block text-align="start" line-height="12pt" font-family="sans-serif" 
                                font-size="10pt" margin-top="5mm" >
                                Chart: <fo:inline font-weight="bold" font-size="11pt"> 
                                        <xsl:value-of select="Chart"/></fo:inline>
                                    <fo:inline color="#ffffff"> _ _ _ _ _  </fo:inline>
                                Patient: <fo:inline font-weight="bold" font-size="11pt"> 
                                        <xsl:value-of select="name"/></fo:inline>
                            </fo:block>
                        </fo:block-container>

                        <xsl:for-each select="case">

                            <fo:block-container width="7.0in" margin-top="0.10in" left="0.0in" >
                                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="10pt">
                                    Case: [<xsl:value-of select="id"/>] <xsl:value-of select="case_name"/>
                                    
                                    <xsl:if test="facility = 'MHC01'">
                                        <fo:inline color="#ffffff"> _ _ _ _ _ _ _ _  </fo:inline>
                                        Office: Silver Spring
                                    </xsl:if>
                                    <xsl:if test="facility = 'MHC02'">
                                        <fo:inline color="#ffffff"> _ _ _ _ _ _ _ _  </fo:inline>
                                        Office: Rockville
                                    </xsl:if>
                                </fo:block>

                            </fo:block-container>

                            <fo:table font-size="10pt" margin-top="4mm" table-layout="fixed"  width="7.9in" >

                            <fo:table-header text-align="center" >
                              <fo:table-row height="10mm" >
                                <fo:table-cell width="0.60in" >
                                  <fo:block>Dates</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Procedure</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Charge</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Paid by Insurance 1</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Paid by Insurance 2</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block><fo:inline color="#ffffff">Deductible</fo:inline></fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Paid by Guarantor</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Adjustments</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>Remainder Balance</fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                            </fo:table-header>

                            <fo:table-body>

                                  <xsl:for-each select="trans">
                                         <fo:table-row>
                                            <fo:table-cell>
                                              <fo:block> <xsl:value-of select="date" /> </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                              <fo:block text-align="center"> <xsl:value-of select="proc" /> </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="charge" /> </fo:block>
                                            </fo:table-cell>

                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="Ins1" /> </fo:block>
                                            </fo:table-cell>

                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="Ins2" /> </fo:block>
                                            </fo:table-cell>

                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="deductible" /> </fo:block>
                                            </fo:table-cell>

                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="guarantor" /> </fo:block>
                                            </fo:table-cell>

                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="adjust" /> </fo:block>
                                            </fo:table-cell>

                                            <fo:table-cell>
                                              <fo:block text-align="right" margin-right="4mm"> 
                                                    <xsl:value-of select="remainder" /> </fo:block>
                                            </fo:table-cell>
                                          </fo:table-row>
                                  </xsl:for-each>

                             </fo:table-body>
                            </fo:table>


                        </xsl:for-each>  <!-- case -->

                        <fo:block-container height="0.5cm" width="7.9in" left="0.00in" margin-top="3mm" >
                           <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
                        </fo:block-container>

                  </xsl:for-each>    <!-- patient -->

                  <!-- ============================= print header for new transactions =================== -->

                    <xsl:choose>
                        <xsl:when test="stmt/patient">
                            <fo:block font-size="10pt" keep-with-next.within-page="always">
                                New transactions:</fo:block>
                        </xsl:when>

                        <xsl:otherwise>
                            <fo:block  font-size="10pt"> No new transactions.</fo:block>
                        </xsl:otherwise>
                    </xsl:choose>

            </xsl:when>   <!-- ============================= end of previously billed transactions === -->

            <xsl:otherwise>
                <fo:block font-size="2pt" line-height="2pt"> </fo:block>
            </xsl:otherwise>
        </xsl:choose>

        <!--   ============================= Current transactions ==================================== -->


        <xsl:for-each select="stmt/patient">

            <fo:block-container width="7.0in" left="0.0in" >
                <fo:block text-align="start" line-height="11pt" font-family="sans-serif" 
                    font-size="10pt" margin-top="1mm" >
                        Chart: <fo:inline font-weight="bold" font-size="11pt"> 
                                <xsl:value-of select="Chart"/></fo:inline>
                            <fo:inline color="#ffffff"> _ _ _ _ _  </fo:inline>
                        Patient: <fo:inline font-weight="bold" font-size="11pt"> 
                                <xsl:value-of select="name"/></fo:inline>
                </fo:block>
            </fo:block-container>

            <xsl:for-each select="case">

                <fo:block-container width="7.0in" margin-top="2mm" left="0.0in" >
                    <fo:block text-align="start" font-family="sans-serif" font-size="10pt">
                        Case: [<xsl:value-of select="id"/>] <xsl:value-of select="case_name"/>
                                    
                        <xsl:if test="facility = 'MHC01'">
                            <fo:inline color="#ffffff"> _ _ _ _ _ _ _ _  </fo:inline>
                            Office: Silver Spring
                        </xsl:if>
                        <xsl:if test="facility = 'MHC02'">
                            <fo:inline color="#ffffff"> _ _ _ _ _ _ _ _  </fo:inline>
                            Office: Rockville
                        </xsl:if>
                    </fo:block>
                </fo:block-container>

                <fo:table font-size="10pt" margin-top="1mm" table-layout="fixed"  width="7.9in" >

                <fo:table-header text-align="center" >
                  <fo:table-row height="10mm" >
                    <fo:table-cell width="0.60in" >
                      <fo:block>Dates</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Procedure</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Charge</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Paid by Insurance 1</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Paid by Insurance 2</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block><fo:inline color="#ffffff">Deductible</fo:inline></fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Paid by Guarantor</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Adjustments</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block>Remainder Balance</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-header>

                <fo:table-body>
 
                      <xsl:for-each select="trans">
                             <fo:table-row>
                                <fo:table-cell>
                                  <fo:block> <xsl:value-of select="date" /> </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block text-align="center"> <xsl:value-of select="proc" /> </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="charge" /> </fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="Ins1" /> </fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="Ins2" /> </fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="deductible" /> </fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="guarantor" /> </fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="adjust" /> </fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                  <fo:block text-align="right" margin-right="4mm"> 
                                        <xsl:value-of select="remainder" /> </fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                      </xsl:for-each>

                 </fo:table-body>
                </fo:table>


            </xsl:for-each>  <!-- case -->
 
            <fo:block-container height="0.5cm" width="7.9in" left="0.00in" margin-top="2mm" >
               <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
            </fo:block-container>

      </xsl:for-each>    <!-- patient -->

            <fo:block-container width="7.9in" margin-top="2mm"  >
                <fo:block  font-family="sans-serif" 
                    font-size="10pt" margin-top="5mm" text-align="right" margin-right="4mm">
                   Total due:  <fo:inline color="#ffffff"> ..... </fo:inline>
                            <xsl:value-of select="stmt/total"/>
                </fo:block>
            </fo:block-container>
 
 
            <fo:block-container width="7.9in" >
               <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
            </fo:block-container>

<!--            <fo:block-container height="1cm" width="7.9in" left="0.00in" font-family="sans-serif" 
                margin-top="3mm" font-size="10pt" >
               <fo:block>Billing questions:  <fo:inline font-weight="bold" font-size="11pt"> 
                            301-251-9800</fo:inline>
                </fo:block>
            </fo:block-container>


            <fo:block-container width="5.00in" 
             border-style="solid" border-after-width="1pt">
                <fo:block text-align="center" line-height="10pt" font-family="sans-serif" 
                 font-weight="bold" font-size="10pt" padding="2mm">
                    To pay by credit card call us during business hours at 301-251-9800. 
                </fo:block>
            </fo:block-container>

            <fo:block-container width="7.5in" margin-top="6mm" >
                <fo:block text-align="start" font-family="sans-serif" font-size="10pt">
                    Please make check payable to 
                    <fo:inline font-weight="bold">Montgomery Health Center</fo:inline>
                    and write the chart and statement numbers on the check.
                </fo:block>
            </fo:block-container>
-->
        </fo:flow>

      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
