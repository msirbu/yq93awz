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
	
 		<xsl:for-each select="paid_time/ins">

            <fo:block-container font-family="Courier" >
                <fo:block margin-top="2mm">
                    <xsl:value-of select="code"/>
                    <fo:inline color="#ffffff"> ... </fo:inline>
                    <xsl:if test="edi"> <!--  != ''do only if cell is not null -->
                           
                                Edi: <xsl:value-of select="edi/total"/>
                                <fo:inline color="#ffffff"> ... </fo:inline>
                                ( <xsl:value-of select="edi/lim75"/>, 
                                  <xsl:value-of select="edi/lim90"/>, 
                                  <xsl:value-of select="edi/lim95"/> )
                                <xsl:value-of select="edi/lim90"/>
                        
                    </xsl:if>	
                </fo:block>


				<xsl:if test="paper"> <!--  != ''do only if cell is not null -->
						<fo:block start-indent="2.7cm" end-indent=".5cm"  margin-bottom="2mm">
                            Paper: <xsl:value-of select="paper/total"/>
							<fo:inline color="#ffffff"> ... </fo:inline>
                            ( <xsl:value-of select="paper/lim75"/>, 
                            <xsl:value-of select="paper/lim90"/>, 
                            <xsl:value-of select="paper/lim95"/>)
                            <xsl:value-of select="paper/lim90"/>
					</fo:block> 
                </xsl:if>	

            </fo:block-container>

	</xsl:for-each>


        </fo:flow>

      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
