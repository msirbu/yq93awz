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
          <fo:region-body margin-top="0.0in" margin-bottom="0.0in"/>
          <fo:region-before extent=".1in"/>
          <fo:region-after extent=".1in"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="otherpages"
            margin-right="0.3in"
            margin-left="0.3in"
            margin-bottom="0.5in"
            margin-top="0.4in"
            page-height="11in" page-width="8.5in">
          <fo:region-body margin-top="0.0in" margin-bottom="0.0in"/>
          <fo:region-before extent=".1in"/>
          <fo:region-after extent=".1in"/>
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="my-sequence">
            <fo:single-page-master-reference master-reference="firstpage"/>
            <fo:repeatable-page-master-reference master-reference="otherpages"/>
        </fo:page-sequence-master>
      </fo:layout-master-set>

            
      <fo:page-sequence master-reference="my-sequence">

        <fo:flow flow-name="xsl-region-body">
	
        <fo:block-container font-family="Courier" >
            <fo:block margin-top="2mm">
                Claim
                <fo:inline color="#ffffff">..</fo:inline>
                Chart<fo:inline color="#ffffff">.</fo:inline>
                Service date
                <fo:inline color="#ffffff">.</fo:inline>
                Ins
                <fo:inline color="#ffffff">.</fo:inline>
                Billing date
                <fo:inline color="#ffffff">.</fo:inline>
                Days   Status
            </fo:block>
        </fo:block-container>

 		<xsl:for-each select="unpaid/claim">

            <fo:block-container font-family="Courier" >
                <fo:block margin-top="1mm">
                    <xsl:value-of select="id"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                    <xsl:value-of select="chart"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                    <xsl:value-of select="service_date"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                    <xsl:value-of select="ins1"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                    <xsl:value-of select="billing_date1"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                    <xsl:value-of select="pending"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                    <xsl:value-of select="status"/>
                    <fo:inline color="#ffffff">..</fo:inline>
                </fo:block>

 <!--
				<xsl:if test="paper"> 
						<fo:block start-indent="2.7cm" end-indent=".5cm"  margin-bottom="2mm">
                            Paper: <xsl:value-of select="paper/total"/>
							<fo:inline color="#ffffff"> ... </fo:inline>
                            ( <xsl:value-of select="paper/lim75"/>, 
                            <xsl:value-of select="paper/lim90"/>, 
                            <xsl:value-of select="paper/lim95"/>)
                            <xsl:value-of select="paper/lim90"/>
					</fo:block> 
                </xsl:if>	
 -->
            </fo:block-container>

	</xsl:for-each>


        </fo:flow>

      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
