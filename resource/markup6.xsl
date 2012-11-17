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

		<!-- print report header
		     -->
		<fo:block-container width="7.5in" margin-top="6mm" text-align="start" font-family="sans-serif" 
			font-size="16pt">
			<fo:block>
				Superbill and demographic information for
				<xsl:value-of select="info_review/date"/>

			</fo:block>
			<fo:block><fo:leader leader-pattern="rule" leader-length="7.0in" /> </fo:block>
		</fo:block-container>


	 	<!-- START OF lookup code cycle
		     -->
		<xsl:for-each select="info_review/patient">
			<!-- print out name address info  -->
			<fo:block-container width="7.5in" margin-top="6mm" text-align="start" font-family="sans-serif" font-size="10pt">
				<fo:block>
					<xsl:value-of select="chart"/>
                			<fo:inline color="#ffffff"> ... </fo:inline>
					<xsl:value-of select="name"/>
                			<fo:inline color="#ffffff"> ... </fo:inline>
					(DOB:
                			<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
					<xsl:value-of select="dob"/>)
                			<fo:inline color="#ffffff"> ... </fo:inline>
					Age:
                			<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
					<xsl:value-of select="age"/>
				</fo:block>
				<fo:block><xsl:value-of select="adr1"/></fo:block>
				<fo:block><xsl:value-of select="adr2"/></fo:block>
				<fo:block><xsl:value-of select="adr3"/></fo:block>
				<fo:block><xsl:value-of select="case/id"/><fo:inline color="#ffffff"> ... 
					</fo:inline><xsl:value-of select="case/name"/></fo:block>
				<fo:block>signature date (<xsl:value-of select="signature/date"/>)</fo:block>

				<xsl:if test="not(signature/on-file)"> <!--i.e. tag missing-->
					<fo:block font-family="sans-serif" font-size="10pt" color="red">
					**ERROR: missing signature (code:tag)**
		  			</fo:block>
				</xsl:if>
				<xsl:if test="not(signature/on_file='1')">
					<fo:block font-family="sans-serif" font-size="10pt" color="red">
						**ERROR: missing signature (code:value)
		  			</fo:block>
				</xsl:if>
			</fo:block-container>
			<xsl:for-each select="case">
				<fo:block-container width="7.5in" margin-top="6mm" text-align="start" font-family="sans-serif" font-size="10pt">
					<xsl:if test="ins1/code != ''"> <!-- do only if cell is not null -->
					<fo:block>
						<xsl:value-of select="ins1/code"/>
	                			<fo:inline color="#ffffff"> ... </fo:inline>
						<xsl:value-of select="ins1/name"/>
					</fo:block> 
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						ID:
						<xsl:value-of select="ins1/id"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Group:
						<xsl:value-of select="ins1/group"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Copay:
						<xsl:value-of select="ins1/copay"/>
					</fo:block>
					<fo:block>
					<fo:inline color="#ffffff"> ... </fo:inline>
						Insured:
						<xsl:value-of select="ins1/insured"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Relationship:
						<xsl:value-of select="ins1/relationship"/>
					</fo:block>
				    </xsl:if>	
				    <xsl:if test="ins2/code != ''"> <!-- do only if cell is not null -->
					<fo:block>
						<xsl:value-of select="ins2/code"/>
        	        			<fo:inline color="#ffffff"> ... </fo:inline>
						<xsl:value-of select="ins2/name"/>
					</fo:block> 
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						ID:
						<xsl:value-of select="ins2/id"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Group:
						<xsl:value-of select="ins2/group"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Copay:
						<xsl:value-of select="ins2/copay"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Insured:
						<xsl:value-of select="ins2/insured"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Relationship:
						<xsl:value-of select="ins2/relationship"/>
					</fo:block>
				    </xsl:if>	
				    <xsl:if test="ins3/code != ''"> <!-- do only if cell is not null -->

					<fo:block>
						<xsl:value-of select="ins3/code"/>
	                			<fo:inline color="#ffffff"> ... </fo:inline>
						<xsl:value-of select="ins3/name"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						ID:
						<xsl:value-of select="ins3/id"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Group:
						<xsl:value-of select="ins3/group"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Copay:
						<xsl:value-of select="ins3/copay"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Insured:
						<xsl:value-of select="ins3/insured"/>
					</fo:block>
					<fo:block>
						<fo:inline color="#ffffff"> ... </fo:inline>
						Relationship:
						<xsl:value-of select="ins3/relationship"/>
					</fo:block>
				    </xsl:if>	

					<fo:block><!--blank line spacer-->
                				<fo:inline color="#ffffff"> ... </fo:inline>
					</fo:block>
				</fo:block-container>
			<xsl:for-each select="visit">
			
		            	<fo:block-container top="0.0in" left="0.0in">
		                <fo:table font-size="10pt" table-layout="fixed" width="6.5in" >
		                    <fo:table-column column-number="1" column-width="2%"/>
		                    <fo:table-column column-number="2" column-width="2%"/>
		                    <fo:table-column column-number="3" column-width="2%"/>
		                    <fo:table-column column-number="4" column-width="2%"/>
		                    <fo:table-column column-number="5" column-width="1%"/>
		                    <fo:table-column column-number="6" column-width="9%"/>
		                    <fo:table-column column-number="7" column-width="6%"/>
		                    <fo:table-column column-number="8" column-width="6%"/>
		                    <fo:table-column column-number="9" column-width="70%"/>
		                    <fo:table-body border-style="solid" >
		
		                      <fo:table-row text-align="center" display-align="center" height="3mm" >
		                        <fo:table-cell border-style="solid" >
		                          <fo:block>x</fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
				  	</fo:table-cell>
		                        <fo:table-cell border-style="solid" background-color="#dddddd" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
					  <fo:block><xsl:value-of select="d1/code"/></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell padding="1mm" border-style="solid" text-align="left">
					  <fo:block><xsl:value-of select="d1/name"/></fo:block>
		                        </fo:table-cell>
		                      </fo:table-row>
			
		                      <fo:table-row text-align="center" display-align="center" height="3mm" >
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block>x</fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" background-color="#dddddd" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
					  <fo:block><xsl:value-of select="d2/code"/></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell padding="1mm" border-style="solid" text-align="left">
					  <fo:block><xsl:value-of select="d2/name"/></fo:block>
		                        </fo:table-cell>
		                      </fo:table-row>

				      <fo:table-row text-align="center" display-align="center" height="3mm" >
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block>x</fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" background-color="#dddddd" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
					  <fo:block><xsl:value-of select="d3/code"/></fo:block>
		                        </fo:table-cell>
					<fo:table-cell border-style="solid"> 
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell padding="1mm" border-style="solid" text-align="left">
					  <fo:block><xsl:value-of select="d3/name"/></fo:block>
		                        </fo:table-cell>
		                      </fo:table-row>
		
				      <fo:table-row text-align="center" display-align="center" height="3mm" >
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block>x</fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" background-color="#dddddd" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
					  <fo:block><xsl:value-of select="d4/code"/></fo:block>
		                        </fo:table-cell>
					<fo:table-cell border-style="solid"> 
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell border-style="solid" >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell padding="1mm" border-style="solid" text-align="left">
					  <fo:block><xsl:value-of select="d4/name"/></fo:block>
		                        </fo:table-cell>
		                      </fo:table-row>
		
				      <!-- start thin row -->
				      <fo:table-row text-align="center" display-align="center" height="1mm" border-style="solid" background-color="#dddddd" >
		                        <fo:table-cell  >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell>
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell>
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell>
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell>
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell >
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell>
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell>
		                          <fo:block></fo:block>
		                        </fo:table-cell>
		                        <fo:table-cell padding="1mm">
					  <fo:block text-align="left"></fo:block>
		                        </fo:table-cell>
		                      </fo:table-row>
		
		
				<xsl:for-each select="trans">

					<!-- start treatment rows, conditional -->

		                      <fo:table-row text-align="center" display-align="center" height="3mm" >
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
		                        <fo:table-cell border-style="solid" background-color="#dddddd" >
		                          <fo:block></fo:block>
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
		                        <fo:table-cell padding="1mm" border-style="solid" text-align="left">
					  <fo:block><xsl:value-of select="name"/></fo:block>
		                        </fo:table-cell>
				      </fo:table-row> 




				</xsl:for-each>	
		  	          </fo:table-body>
		                </fo:table>
				
				<fo:block><!--blank line spacer-->
                			<fo:inline color="#ffffff"> ... </fo:inline>
				</fo:block>

		            </fo:block-container>
			</xsl:for-each>	
		</xsl:for-each>
		<!-- test for missing chart
		     -->	
		<xsl:for-each select="person">
			<xsl:if test="not(chart)"> <!--both chart number and tag missing-->
				<fo:block font-family="sans-serif" font-size="10pt" color="red">
				**ERROR: missing chart number (code:tag)**
		  		</fo:block>
			</xsl:if>
			<xsl:if test="chart = ''"> <!--tag present, empty value-->
				<fo:block font-family="sans-serif" font-size="10pt" color="red">
				**ERROR: missing chart number (code:value)**
		  		</fo:block>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="person">

			<!-- print out each person  -->
			<fo:block font-family="sans-serif" font-size="10pt">
				<xsl:value-of select="chart"/>
               			<fo:inline color="#ffffff"> ... </fo:inline>
				<xsl:value-of select="name"/>
               			<fo:inline color="#ffffff"> ... </fo:inline>
				(DOB:
               			<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
				<xsl:value-of select="dob"/>)
               			<fo:inline color="#ffffff"> ... </fo:inline>
				Age:
               			<fo:inline color="#ffffff" font-size="5pt"> . </fo:inline>
				<xsl:value-of select="age"/>
		  	</fo:block>
			<!-- alert on lack of signature  -->
			<fo:block font-family="sans-serif" font-size="10pt">

				<xsl:if test="not(signature/on-file)"> <!--i.e. tag missing-->
					<fo:block font-family="sans-serif" font-size="10pt" color="red">
					**ERROR: missing signature (code:tag)**
		  			</fo:block>
				</xsl:if>

				Signature
				date:
				<xsl:value-of select="signature/date"/>
				<xsl:choose>
					<xsl:when test="signature/on_file='1'">
						<!-- do nothing -->
					</xsl:when>
					<xsl:otherwise>
		              			<fo:inline color="red"> 
						**ERROR: missing signature (code:value)**</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
			<fo:block>
			</fo:block>




			<fo:block font-family="sans-serif" font-size="10pt">
				<fo:inline color="#ffffff"> ... </fo:inline>
				Name:
				<xsl:value-of select="name"/>
			</fo:block>

			<fo:block font-family="sans-serif" font-size="10pt">
				<fo:inline color="#ffffff"> ... </fo:inline>
				ID:
				<xsl:value-of select="id"/>
			</fo:block>

			<fo:block font-family="sans-serif" font-size="10pt">
				<fo:inline color="#ffffff"> ... </fo:inline>
				Group:
				<xsl:value-of select="group"/>
			</fo:block>

			<fo:block font-family="sans-serif" font-size="10pt">
				<fo:inline color="#ffffff"> ... </fo:inline>
				Copay:
				<xsl:value-of select="copay"/>
			</fo:block>

			<fo:block font-family="sans-serif" font-size="10pt">
				<fo:inline color="#ffffff"> ... </fo:inline>
				Insured:
				<xsl:value-of select="insured"/>
			</fo:block>

			<fo:block font-family="sans-serif" font-size="10pt">
				<fo:inline color="#ffffff"> ... </fo:inline>
				Relationship:
				<xsl:value-of select="relationship"/>
			</fo:block>


			<fo:block font-family="sans-serif" font-size="10pt">
				<xsl:value-of select="adr1"/>
			</fo:block>
			<fo:block font-family="sans-serif" font-size="10pt">
				<xsl:value-of select="adr2"/>
			</fo:block>
			<fo:block font-family="sans-serif" font-size="10pt">
				<xsl:value-of select="adr3"/>
			</fo:block>
			<fo:block><!--blank line spacer-->
                		<fo:inline color="#ffffff"> ... </fo:inline>
			</fo:block>


		</xsl:for-each>	
		<!-- next 3 lines make ruler -->
		<fo:block-container height="0.20in" width="7.9in" top="1.30in" left="0.00in">
			<fo:block><fo:leader leader-pattern="rule" leader-length="7.0in" /> </fo:block>
		</fo:block-container>
		<fo:block><!--blank line spacer-->
               		<fo:inline color="#ffffff"> ... </fo:inline>
		</fo:block>

	</xsl:for-each>


        </fo:flow>

      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
