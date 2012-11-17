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
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="mypage">
        <fo:flow flow-name="xsl-region-body">

            <fo:block-container height="1cm" width="14cm" top="0.95in" left="0.95in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    <xsl:value-of select="refund/name"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="0.50in" left="6.85in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    <xsl:value-of select="refund/Date"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="6in" top="1.30in" left="0.25in" position="absolute">
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="12pt">
                    <xsl:value-of select="refund/suminwords"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="5cm" top="1.00in" left="6.70in" position="absolute">
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="14pt">
                    <xsl:value-of select="refund/sum"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="1cm" width="14cm" top="2.30in" left="0.70in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    Chart <xsl:value-of select="refund/Chart"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container height="8cm" width="8cm" top="3.5in" left="5.50in" position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                Simona N. Sirbu, M.D. 
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                Socrates Fotiu, M.D.
                </fo:block>           
            </fo:block-container>


            <fo:block-container height="5cm" width="15cm" top="3.5in" left="0.50in" position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                14800 Physicians Ln, Suite 131 
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                Rockville, MD 20850
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                Ph: 301-251-9800    Fax: 301-251-9802  
                </fo:block>           
            </fo:block-container>
 
            <fo:block-container height="5cm" width="15cm" top="4.20in" left="0.50in" position="absolute" >
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                1776 Powder Mill Rd
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                Silver Spring, MD 20903
                </fo:block>           
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                Ph: 301-434-0599    Fax: 301-434-0157  
                </fo:block>           
            </fo:block-container>
 
            <fo:block-container height="1cm" width="14cm" top="5.30in" left="1.00in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt">
                    Enclosed: MHC check for $<xsl:value-of select="refund/sum"/>, refund for the 
                    <xsl:value-of select="refund/Chart"/> account.
                </fo:block>
            </fo:block-container>

            <fo:block-container height="2in" width="6.5in" top="5.80in" left="1.00in" position="absolute">
                <fo:block text-align="start" line-height="12pt" font-family="sans-serif" font-size="12pt" >
                    For any billing questions call us at 301-251-9800. 
                </fo:block>
            </fo:block-container>



            <fo:block-container height="4cm" width="4in" top="9.25in" left="4.50in" position="absolute">
                <fo:block text-align="start" line-height="13pt" font-family="sans-serif" font-size="11pt">
                    <xsl:value-of select="refund/name"/>
                </fo:block>           
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="11pt">
                    <xsl:value-of select="refund/Adr1"/>
                </fo:block>           
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="11pt">
                    <xsl:value-of select="refund/Adr2"/>
                </fo:block>           
                <fo:block text-align="start" line-height="14pt" font-family="sans-serif" font-size="11pt">
                    <xsl:value-of select="refund/Adr3"/>
                </fo:block>           
            </fo:block-container>
 



        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
