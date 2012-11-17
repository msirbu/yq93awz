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
            margin-left="0.3in"
            margin-bottom="0.5in"
            margin-top="0.4in"
            page-height="11in" page-width="8.5in">
          <fo:region-body margin-top="1.5in" margin-bottom="4.0in"/>
          <fo:region-before extent="1.5in"/>
          <fo:region-after extent="4.0in"/>
        </fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="mypage">

        <fo:static-content flow-name="xsl-region-before" border-style="solid" border-after-width="1pt" >
            <fo:block-container height="5cm" width="15cm" top="0.0in" left="0.00in" 
             position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                Montgomery Health Center 
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                14800 Physicians Ln, Suite 131 
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                Rockville, MD 20850
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                Ph: 301-251-9800    Fax: 301-251-9802  
                </fo:block>           
            </fo:block-container>

            <fo:block-container height="1.5cm" width="5in" top="0.0in" left="2.90in" 
             position="absolute" >
                <fo:block text-align="right" line-height="13pt" font-family="sans-serif" font-size="10pt">
                 
                Date: <xsl:value-of select="stmt/Date"/>
                <fo:inline color="#ffffff"> ... </fo:inline>
                Statement: <xsl:value-of select="stmt/Chart"/>-<xsl:value-of select="stmt/id"/>
                <fo:inline color="#ffffff"> ........ </fo:inline>
                Page  <fo:page-number /> 
                </fo:block>           
           </fo:block-container>

           <fo:block-container height="2.0cm" width="7.9in" top="0.80in" left="0.00in" 
             position="absolute" >
                <fo:block text-align="center" line-height="10pt" font-family="sans-serif" 
                    font-size="10pt"  margin-top="2mm"  >
                This is a statement for professional services renderd by physicians 
                of <fo:inline font-weight="bold">Montgomery Health Center, LLC </fo:inline>.
                </fo:block>           

                <fo:block text-align="center" line-height="13pt" font-family="sans-serif" 
                    font-size="10pt"  margin-top="2mm" >
                Simona N. Sirbu, M.D. 
                <fo:inline color="#ffffff"> ... </fo:inline>
                Socrates Fotiu, M.D. 
                <fo:inline color="#ffffff"> ... </fo:inline>
                Maritere Rochet, M.D.
                <fo:inline color="#ffffff"> ... </fo:inline>
                Waheed Malik, M.D.
                </fo:block>           
            </fo:block-container>

            <fo:block-container height="0.20in" width="7.9in" top="1.30in" left="0.00in" position="absolute">
               <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
            </fo:block-container>

        </fo:static-content>



        <fo:static-content flow-name="xsl-region-after" border-style="solid" border-after-width="1pt" >

            <fo:block-container height="3cm" width="15cm" top="1.7in" left="0.60in" 
             position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/name"/>
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/Adr1"/>
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/Adr2"/>
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/Adr3"/>
                </fo:block>           
             </fo:block-container>

            <fo:block-container height="2cm" width="15cm" top="3.2in" left="0.60in" 
             position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                MONTGOMERY HEALTH CENTER 
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                14800 PHYSICIANS LN, SUITE 131 
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                ROCKVILLE, MD 20850
                </fo:block>           
            </fo:block-container>

            <fo:block-container height="3cm" width="15cm" top="3.1in" left="4.75in" 
             position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/name"/>
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/Adr1"/>
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/Adr2"/>
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="10pt">
                    <xsl:value-of select="stmt/Adr3"/>
                </fo:block>           
             </fo:block-container>

            <fo:block-container height="1cm" width="7.5in" top="0.70in" left="0.2in" position="absolute" >
                <fo:block text-align="start" font-family="sans-serif" font-size="9pt">
                    Please detach and return with payment. 
                </fo:block>
            </fo:block-container>

            <fo:block-container height="0.20in" width="7.9in" top="0.75in" left="0.00in" position="absolute">
               <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
            </fo:block-container>

            <fo:block-container top="1.10in" left="4.0in" position="absolute">
                <fo:table font-size="12pt" table-layout="fixed" width="3.5in" >
                    <fo:table-column column-number="1" column-width="45%"/>
                    <fo:table-column column-number="2" column-width="55%"/>
                    <fo:table-body border-style="solid" >

                      <fo:table-row text-align="center" display-align="center" height="8mm" >
                        <fo:table-cell border-style="solid" >
                          <fo:block>Statement</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border-style="solid">
                          <fo:block>
                            <xsl:value-of select="stmt/Chart"/>-<xsl:value-of select="stmt/id"/>
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>

                      <fo:table-row text-align="center" display-align="center" height="8mm" >
                        <fo:table-cell border-style="solid">
                          <fo:block>Due Date</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border-style="solid" >
                          <fo:block><xsl:value-of select="stmt/due_date"/></fo:block>
                        </fo:table-cell>
                      </fo:table-row>

                      <fo:table-row text-align="center" display-align="center" height="8mm" >
                        <fo:table-cell border-style="solid">
                          <fo:block>Amount Due</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border-style="solid">
                          <fo:block><xsl:value-of select="stmt/total"/></fo:block>
                        </fo:table-cell>
                      </fo:table-row>

                      <fo:table-row text-align="center" display-align="center" height="8mm" >
                        <fo:table-cell border-style="solid">
                          <fo:block>Amount Included</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border-style="solid" >
                          <fo:block> </fo:block>
                        </fo:table-cell>
                      </fo:table-row>

                    </fo:table-body>
                </fo:table>
            </fo:block-container>

        </fo:static-content>


        <fo:flow flow-name="xsl-region-body">

            <fo:block-container width="7.0in" top="0.30in" left="0.0in" >
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" 
                    font-size="10pt" margin-top="5mm" >
                    Chart: <fo:inline font-weight="bold" font-size="12pt"> 
                            <xsl:value-of select="stmt/Chart"/></fo:inline>
                        <fo:inline color="#ffffff"> _ _ _ _ _  </fo:inline>
                    Patient: <xsl:value-of select="stmt/patient"/>
                </fo:block>

<!-- xsl:comment >
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="10pt">
                    Case: [<xsl:value-of select="stmt/case"/>] <xsl:value-of select="stmt/case_name"/>
                </fo:block>
 <! /xsl:comment -->

            </fo:block-container>


            <fo:table font-size="10pt" margin-top="5mm" table-layout="fixed"  width="7.9in" >

            <fo:table-header text-align="center" >
              <fo:table-row height="10mm" >
                <fo:table-cell width="0.60in" >
                  <fo:block>Date</fo:block>
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
 
      <xsl:for-each select="stmt/trans">
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
 

            <fo:block-container height="1cm" width="7.9in" top="0.50in" >
                <fo:block  line-height="12pt" font-family="sans-serif" 
                    font-size="10pt" margin-top="5mm" text-align="right" margin-right="4mm">
                   Total due:  <fo:inline color="#ffffff"> ..... </fo:inline>
                            <xsl:value-of select="stmt/total"/>
                </fo:block>
            </fo:block-container>
 
 
            <fo:block-container height="1cm" width="7.9in" left="0.00in" margin-top="3mm" >
               <fo:block><fo:leader leader-pattern="rule" leader-length="7.9in" /> </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="7.9in" left="0.00in" font-family="sans-serif" 
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

        </fo:flow>

      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
