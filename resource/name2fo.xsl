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



        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
