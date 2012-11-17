# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.

$configFile = "C:\apln\bin\copyclaims.txt"

#   $claimDir = "C:\medidata\RMData\MHC\Archive\Report"
#   $claimDir = "C:\medidata\RMData\MHC\ReportCopies"
$claimDir = "C:\medidata\RMData\MHC\Report"

$selectFiles = "*"

#  $selectFiles = "*277*"
#  $selectFiles = "RSD_*"
#  $selectFiles = "RS26*"

$destPath = "c:\data\medical\claims\"
$claimBasePath = "c:\data\medical\claims\"
$destPath_271 = "C:\medidata\RMData\MHC\Archive\Report"
$destPath_277 = "C:\medidata\RMData\MHC\Archive\Report"
$destPath_997 = "C:\medidata\RMData\MHC\Archive\Report"
$destPath_RSF = "C:\medidata\RMData\MHC\Archive\Report"
$destPath_RCF = "C:\medidata\RMData\MHC\Archive\Report"
$destPath_RSD = "C:\medidata\RMData\MHC\Archive\Report"
$crtMax = 0
$crtHeader = ""
$pHeader = @{}
$errReport = @()

function hasHeader
{ 
    param([string] $mycontent, $hdr )

    $regex = [regex]"^<CM4.*CM4>"
    $myMatch = $regex.Matches($mycontent)
    $i = 0

    if( ( -not $mycontent.startsWith( "<CM4  " ) ) -or ( -not $mycontent.Contains( "  CM4>" ) ) )
    {  # potential header
        # write-host "header is not present"
        $hdr = "none"
        return $false
    }

    write-output $true
}  # end hasHeader


# =========================================================================================

function getHeader
{ 
    param([string] $mycontent )

    if( hasHeader $mycontent )
    {
        $i = $mycontent.IndexOf( "CM4>" )
        $mycontent.substring(6, $i-8)
    }
    else
    {
        ""
    }

}  # end getHeader


# =========================================================================================

function stripHeader
{ 
    param([string] $mycontent )

    if( hasHeader $mycontent )
    {
        $i = $mycontent.IndexOf( "CM4>" )
        $mycontent.substring($i+4)
    }
    else
    {
        $mycontent
    }

}  # end stripHeader

# =========================================================================================

function parseHeader
{ 
    param([string] $mycontent )

    $result = $mycontent.split(";")
    foreach( $matchElem in $result  )
    {
        if( $matchElem.trim().contains("=") )
        {
            $res2 = $matchElem.trim().split("=")
            # write-host "parsed " $res2[0] $res2[1] 
            $pHeader.Add( $res2[0], $res2[1] ) 
        }

    }

}  # end parseHeader


# =========================================================================================

function transfer_report_to_dir
{ 
    param([string] $reportFileName,
          $claimNumber,
          $newName,
          $move = $false )
          
#    write-host "reportFileName" $reportFileName
#    write-host "claimNumber" $claimNumber
#    write-host "newName" $newName
#    write-host "move" $move

    if( $move ) 
    { 
        $opName = "move" 
    } else 
    { 
        $opName = "copy" 
    }


#find target directory based on claim number

    $claimDir = $claimNumber + "_???"
    $foundDir = dir $claimBasePath -filter $claimDir -recurse
    # $foundDir | get-member

# process for only first directory found
    foreach( $elem in $foundDir )
    {
        $dirCount = $dirCount + 1
        write-host " `t Claim dir:" $elem.FullName

        $destFullName = $elem.FullName + "\" + $newName

#if target file exists, return
        if( test-path $destFullName )
        {
             # write-host $destFullName -nonewline
             # write-host -foregroundColor Green " already exists, $opName skipped"
             return $false
        }

#copy or move the file there
        if( $move ) 
        { 
            mv $reportFileName $destFullName -force
        } else 
        { 
            cp  $reportFileName $destFullName -force
        }
        # write-host -foregroundColor Green $opName $reportFileName.substring( $reportFileName.lastindexof( "\" ) ) -nonewline
        # write-host  " to" $destFullName 
        
        return $true
    }

# should not reach here; could not find claim directory
    $msg =  "Could not find dir for claim " + $claimNumber + ", $opName skipped."
    write-host " "
    write-host -backgroundColor Yellow -foregroundColor Red $msg 
    write-host " "

    return $false

}  # end transfer_report_to_dir


# =========================================================================================
# to a filename "name.ext" adds the claim number XXXX as follows: "name_XXXXX.ext"
# to a filename "name" adds the claim number XXXX as follows: "name_XXXXX"

function add_claim_number_to_name
{ 
    param([string] $fileName, $claimNumber )

    $newFileName = $fileName
    $extra = "_" + $claimNumber
    $i = $fileName.lastindexof(".")
    if ( $i -eq -1 )
    {
        $newFileName = $newFileName + $extra
    }
    else
    {
        $newFileName = $newFileName.insert( $i, $extra )
    }

    write-output $newFileName

}  # end add_claim_number_to_name


# =========================================================================================

$reportDate = (get-date -year 2010 -month 8 -day 26 -hour 16)

$Ins = @{"6400" = "aet"; "2425" = "car"; "6405" = "cig"; 
         "3429" = "uni"; "3777" = "uni"; "2464" = "med"; 
         "2893" = "uni"; "5406" = "uni"}

if( -not ( test-path $claimDir ) )
{
    write-host  " "
    write-host "Report directory" $claimDir "does not exist, we are done."
    write-host  " "
    exit
}

# Process payment files (835) first
$strClaims =  dir $claimDir -filter "*_835.*" | sort-object -property LastWriteTime
if( $strClaims -eq $null )
{
    write-host  " "
    write-host "No remittance files, done."
    write-host  " "
} else
{  # process 835 files
    write-host  "Payment files:"

    foreach ($report in $strClaims) 
    {
        $fullFileName = $claimDir + "\" + $report
        $content = get-content $fullFileName

        # get CM-header if present
        $pHeader = @{}
        $header_yes = hasHeader $content
        if( -not $header_yes )
        {  #no header, we don't analyze
            continue
        }

        $crtHeader = getHeader $content
        parseHeader $crtHeader

        if( $pHeader.ContainsKey( "Filetype" ) )
        {
            if( $pHeader["Filetype"] -ne "835" )
            {
                $msg = "Error, Header FILETYPE should be 835, it is " + $pHeader["Filetype"]
                write-host -backgroundColor Yellow -foregroundColor Red  $msg

                continue
            }
        }

        write-host "    " $pHeader["Filedate"] "  `t" $pHeader["Amount"] " `t" $pHeader["Receivedfrom"]
    }

}  # end process 835 files

write-host "  "


$strClaims =  dir $claimDir -filter $selectFiles | sort-object -property LastWriteTime
if( $strClaims -eq $null )
{
    write-host  " "
    write-host "No report files, done."
    write-host  " "
    exit
}

# & ( ".\copyclaims.ps1" )
# write-host  "Date" $reportDate

foreach ($report in $strClaims) 
{
    if( $report.name.Contains("_835.") ) 
    {  # already processed
        continue;
    }

    write-host  " "
    write-host "Report" $report.LastWriteTime $report 

    $fullFileName = $claimDir + "\" + $report

    $content = get-content $fullFileName

# get CM-header if present

    $pHeader = @{}
    $header_yes = hasHeader $content
    $crtHeader = getHeader $content
    $crtBody = stripHeader  $content
    if ( $header_yes )
    {
        parseHeader $crtHeader
        write-host "Report has a valid CM4 header, file type" $pHeader["Filetype"]
    }

    $fileType = ""
    $regex = [regex]"\~ST\*[^\*]+"
    foreach( $matchElem in $regex.Matches($crtBody) )
    {
        $fileType = $matchElem.Value.remove(0,4)
        write-host -foregroundColor Green  "X12 File type" $fileType
    }


    if( ($fileType -eq "997") -or $report.name.Contains("_997.") ) 
    {
        write-host -foregroundColor Green "997 report" $report

        if( $header_yes )
        {
            if( $pHeader.ContainsKey( "Filetype" ) )
            {
                if( $pHeader["Filetype"] -eq "997" )
                {
                    write-host  -foregroundColor Green "Header FILETYPE: 997  ...correct"
                }
                else
                {
                    $msg = "Error, Header FILETYPE should be 997, it is " + $pHeader["Filetype"]
                    write-host -backgroundColor Yellow -foregroundColor Red  $msg
                }
            }
        }

        $ackOk = $true
        $regex = [regex]"AK5\*[^\~]\~"
        foreach( $matchElem in $regex.Matches($content) )
        {
            if( $matchElem.Value -ne "AK5*A~" )
            {
                $msg = "Wrong ACK " + $matchElem.Value + ", should be AK5*A~"
                write-host -backgroundColor Yellow -foregroundColor Red $msg
                $ackOK = $false
            }            
        }

        if( $ackOk )
        {
            write-host -foregroundColor Green "Ack file OK, archiving."

            $destFileName = $destPath_997 + "\" + $report

            mv $fullFileName $destFileName -force
        }
        else
        {
            write-host -backgroundColor Yellow -foregroundColor Red "Wrong ACK file, keeping."
        }
        continue;
    }

    if( $report.name.Contains("RCF_") ) 
    {
        write-host -foregroundColor Green "RCF report" $report

        $localResOk = $true

        foreach( $crtLine in $content )
        {
            #strip CM4 header, if needed
            if ( $crtLine.startswith("<CM4") )
            {
                $crtLine = $crtLine.substring( $crtLine.indexof("CM4>") + 4 )
            }

            $res2 = $crtLine.trim().split("|")
            #    write-host "elements " $res2.Count

            if( $res2.Count -ge 27 )
            {  #standard line

                # write-host " "
                # write-host "parsed " $crtLine

                $claimNo = $res2[18]
                $date = $res2[22].substring(4,2) + "/" + $res2[22].substring(6,2)+ "/" + $res2[22].substring(0,4)

                $patName = $res2[21].substring(0,1).ToUpper() + $res2[21].substring(1).tolower()
                $patName = $patName + ", " + $res2[19].substring(0,1).ToUpper() + $res2[19].substring(1).tolower()
                if ( $res2[20] -ne "" )
                { 
                    $patName = $patName + ", " + $res2[20].substring(0,1).ToUpper() + $res2[20].substring(1).tolower()
                }

                write-host " "

                if( $res2[17] -match [regex]"A" )
                {
                    write-host $date $claimNo $patName
                    write-host -foregroundColor Green " `t" $res2[17] 
                    $res = transfer_report_to_dir $fullFileName $claimNo ( add_claim_number_to_name $report $claimNo )
                }                 
                else
                {
                    write-host -backgroundColor Yellow -foregroundColor Red $date $claimNo $patName "   `t" 
                    write-host -backgroundColor Yellow -foregroundColor Red " `t" $res2[17] 
                    write-host " "
                    write-host $crtLine
                    write-host " "
                    $res = transfer_report_to_dir $fullFileName $claimNo ( add_claim_number_to_name $report $claimNo )
                    $localResOK = $false   #at least one entry has an error
                }


            }

        }

        write-host " "
        if( $localResOk )
        {  # file prosessed OK, move it to archive
            write-host -foregroundColor Green "Report OK, file is archived."
            mv $fullFileName $destPath_RSF -force
        }
        else
        {
            write-host -foregroundColor Red "Report with errors, file was not archived."
            cp $fullFileName $destPath_RSF -force
        }

        continue;
    }

    if( $report.name.Contains("RSF_") ) 
    {
        write-host -foregroundColor Green "RSF report" $report

        # write-host "Content" $crtBody 

        # write-host "" 

        $localResOk = $true

        foreach( $crtLine in $content )
        # foreach( $crtLine in $regex.Matches($crtBody) )
        {
            if( ( $crtLine -eq "B|" ) -or ( $crtLine -eq "D|" ) )  # ignore empty lines
            {
                continue
            }

            $res2 = $crtLine.trim().split("|")
            if( $res2.Count -ge 60 )
            {  #standard line

                # write-host " "
                # write-host "parsed " $crtLine
                # write-host " "

                if( $res2[47] -ne "" )
                {
                    $claimNo = $res2[47]
                }
                else
                {
                    if( $res2[8] -ne "" )
                    {
                        $claimNo = $res2[8]
                    }
                    else
                    {
                        $claimNo = "?????"
                    }
                }
                # write-host "Claim" $claimNo "Name" $res2[48] $res2[49] $res2[50] "Element 5" $res2[5] "Element 51" $res2[51] 
                # write-host "Element 10" $res2[10] "Element 15" $res2[15]  "Element 28" $res2[28]  "Element 35" $res2[35]  "Element 50" $res2[50] 
                # write-host "Element 12" $res2[12] "Element 48" $res2[48]  "Element 28" $res2[28]  "Element 35" $res2[35]  "Element 50" $res2[50] 
                # write-host -foregroundColor Green "Report" $res2[43] 
                # write-host "TaxId" $res2[45]  
                # write-host "Result" $res2[40] $res2[41]
                # write-host "Result" $res2[28] $res2[29]
                

                if ( $res2[12] -ne "" )
                { 
                    $date = $res2[12].substring(4,2) + "/" + $res2[12].substring(6,2)+ "/" + $res2[12].substring(0,4)
                }
                else
                {
                    $date = " "
                }

                write-host " "


                if ( $res2[48] -ne "" )
                { 
                    $patName = $res2[48].substring(0,1).ToUpper() + $res2[48].substring(1).tolower()
                }
                else
                {
                    if ( $res2[9] -ne "" )
                    { 
                        $patName = "**" + $res2[9].substring(0,1).ToUpper() + $res2[9].substring(1).tolower()
                    }
                    else
                    {
                        $patName = "**"
                    }
                }

                if ( $res2[49] -ne "" )
                { 
                    $patName = $patName + ", " + $res2[49].substring(0,1).ToUpper() + $res2[49].substring(1).tolower()
                }
                else
                {
                    $patName = $patName + ", **"
                }

                if ( $res2[50] -ne "" )
                { 
                    $patName = $patName + ", " + $res2[50].substring(0,1).ToUpper() + $res2[50].substring(1).tolower()
                }

                # if( $res2[29] -match [regex]"A -.*|M -.*|F -.*" )
                if( $res2[29] -match [regex]"[AMF] -.*" )
                {
                    write-host $date $claimNo $patName " `t" $res2[43] 
                    write-host -foregroundColor Green " `t" $res2[28] $res2[29] 
                    $res = transfer_report_to_dir $fullFileName $claimNo ( add_claim_number_to_name $report $claimNo )
                }                 
                else
                {
                    write-host -backgroundColor Yellow -foregroundColor Red $date $claimNo $patName "   `t"  $res2[43] 
                    write-host -backgroundColor Yellow -foregroundColor Red " `t" $res2[28] $res2[29]
                    write-host " "
                    write-host $crtLine
                    write-host " "
                    $res = transfer_report_to_dir $fullFileName $claimNo ( add_claim_number_to_name $report $claimNo )
                    $localResOK = $false   #at least one entry has an error
                }
            }
            else
            {  #nonstandard line
                # write-host "nonstandard line, count =" $res2.Count
            }

        }

        write-host " "
        if( $localResOk )
        {  # file prosessed OK, move it to archive
            write-host -foregroundColor Green "Report OK, file is archived."
            mv $fullFileName $destPath_RSF -force
        }
        else
        {
            write-host -foregroundColor Red "Report with errors, file was not archived."
            cp $fullFileName $destPath_RSF -force
        }

        continue;
    }

    # -------------------------------------------------------------------------------------


    if( $report.name.Contains("RSD_") ) 
    {
        write-host -foregroundColor Green "RSD report" $report
        
        $localResOk = $true

        foreach( $crtLine in $content )
        {
            #strip CM4 header, if needed
            if ( $crtLine.startswith("<CM4") )
            {
                $crtLine = $crtLine.substring( $crtLine.indexof("CM4>") + 4 )
            }

            $res2 = $crtLine.trim().split("|")
            #   write-host "elements " $res2.Count
            #   write-host "parsed " $crtLine

            if( ($res2[0] -eq "B" ) -and ( $res2.Count -gt 35 ) -and ( $res2[29] -ne "" ) )
            {
                if( $res2[29] -eq "ACCEPTED" )
                {
                    write-host -foregroundColor Green "Batch result"   $res2[29]
                }
                else
                {
                    write-host -foregroundColor Red "Batch result"   $res2[29]
                    $localResOK = $false   #at least one entry has an error
                }
                
                continue  # Done with "B" lines
            }

            if( ($res2[0] -eq "D" ) -and ( $res2.Count -gt 10 ) )
            {  #standard line

                # write-host -foregroundColor Green "Claim"   $res2[1]

                # write-host " "
                # write-host "parsed " $crtLine

                $claimNo = $res2[1]
                $date = $res2[5].substring(4,2) + "/" + $res2[5].substring(6,2)+ "/" + $res2[5].substring(0,4)

                $patName = $res2[2].substring(0,1).ToUpper() + $res2[2].substring(1).tolower()
                $patName = $patName + ", " + $res2[3].substring(0,1).ToUpper() + $res2[3].substring(1).tolower()
                if ( $res2[4] -ne "" )
                { 
                    $patName = $patName + ", " + $res2[4].substring(0,1).ToUpper() + $res2[4].substring(1).tolower()
                }

                write-host " "

                write-host $date $claimNo $patName
                $res = transfer_report_to_dir $fullFileName $claimNo ( add_claim_number_to_name $report $claimNo )
 
            }

        }

        write-host " "
        if( $localResOk )
        {  # file prosessed OK, move it to archive
            write-host -foregroundColor Green "Report OK, file is archived."
            mv $fullFileName $destPath_RSD -force
        }
        else
        {
            write-host -foregroundColor Red "Report with errors, file was not archived."
            cp $fullFileName $destPath_RSD -force
        }

        continue;
    }

    # -------------------------------------------------------------------------------------


    if( ($fileType -eq "277") -or $report.name.Contains("_277.") -or $report.name.Contains("_277_") -or $report.name.startswith("277_") ) 
    {

        write-host -foregroundColor Green "277 report" $report
        $ackOk = $true
        
#        write-host -backgroundColor Yellow -foregroundColor Red "Header =" $crtHeader
        
#        write-host " "
#        write-host -backgroundColor Yellow -foregroundColor Black "277 report: " $crtBody

        if( $header_yes )
        {
            if( $pHeader.ContainsKey( "Filetype" ) )
            {
                if( $pHeader["Filetype"] -eq "277" )
                {
                    write-host  -foregroundColor Green "FILETYPE: 277  ...correct"
                }
                else
                {
                    write-host -backgroundColor Yellow -foregroundColor Red  "Error, FILETYPE should be 277, it is" $pHeader["Filetype"]
                    write-host -backgroundColor Yellow -foregroundColor Red  "Cannot archive."
                    $ackOK = $false
                }
            }

            # test for posted file, ignore for now
#            if( $pHeader.ContainsKey( "POSTED" ) )
#            {
#                if( $pHeader["POSTED"] -eq "True" )
#                {
#                    write-host  -foregroundColor Green "POSTED: True  ...correct"
#                }
#                else
#                {
#                    write-host -backgroundColor Yellow -foregroundColor Red  "File not posted, cannot archive."
#                    $ackOK = $false
#                }
#            }
        }
        else
        {  # there is no header, we don't know to archive or not.
            write-host -backgroundColor Yellow -foregroundColor Red  "Missing header for 277 file, can't archive."
            $ackOK = $false
        }


        $regex = [regex]"TRN\*\d+\*\d+|STC\*[^\*]+\*\d+"
        foreach( $matchElem in $regex.Matches($content) )
        {
            # write-host "Match =" $matchElem.Value

            if( $matchElem.Value.Contains( "TRN" ) )
            {
                $claimNo = $matchElem.Value.remove(0,4)
                if( $claimNo.contains( "*" ) )
                {
                    $i = $claimNo.IndexOf( "*" )
                    $claimNo = $claimNo.substring($i+1)
                }
                # write-host "Claim string:" $claimNo
            }

            if( $matchElem.Value.Contains( "STC" ) )
            {
                $resultCodeStr = $matchElem.Value.remove(0,4)
                if( $resultCodeStr.contains( "*" ) )
                {
                    $i = $resultCodeStr.IndexOf( "*" )
                    $resultCodeStr = $resultCodeStr.substring(0, $i)
                }
                #write-host "Result string:" $resultCodeStr
                
                if( $resultCodeStr -eq "a2:20" )
                {
                    write-host -foregroundColor Green "Claim" $claimNo "OK."
                }
                else
                { 
                    write-host " "
                    write-host -backgroundColor Yellow -foregroundColor Red "Claim" $claimNo "has result" $resultCodeStr "but should be A2:20"
                    write-host -backgroundColor Yellow -foregroundColor Red  "Cannot archive."
                    $ackOK = $false
                }

                $res = transfer_report_to_dir $fullFileName $claimNo ( 
                                add_claim_number_to_name $report $claimNo )
            }

        }
        
        if( $ackOk )
        {
            write-host -foregroundColor Green "Ack file OK, archiving."

            $destFileName = $destPath_277 + "\" + $report

            mv $fullFileName $destFileName -force
        }

        write-host " "

        continue
    }

    # -------------------------------------------------------------------------------------
    # potential text reports

    if( $report.name.startswith( "CR265549" ) )
    {
        write-host -foregroundColor yellow "manual report, skipping."
        continue
    }

    if( $report.name.startswith( "RS265549" ) )
    {
        write-host -foregroundColor yellow "Remittance report, manual, skipping."
        continue
    }

    if( ($fileType -eq "271") -or $report.name.Contains("_271.") -or $report.name.Contains("_271_") -or $report.name.startswith("271_") ) 
    {
        write-host -foregroundColor yellow "Eligibility report, manual, archiving..."

        $destFileName = $destPath_271 + "\" + $report

        mv $fullFileName $destFileName -force

        continue
    }

    if( $report.name.startswith( "report_" ) )
    {
        if( $crtBody.contains("Facility Receipt Report") )
        {
            write-host "Electronic Mailbox Facility receipt report... " -nonewline

            if( $crtBody -match [regex]"The following.*were received by the EMF" )
            {
                write-host -foregroundColor green "OK, deleting."
                rm $fullFileName -force
            }       
            else
            {
                write-host -foregroundColor Red "failed, skipping file."
            }

            continue
        }
    }

    if( $true )
    {
        $localResOk = $true
        
        if( $crtBody.contains("REPORT FOR TRANSMISSION") )
        {
            write-host "Transmission report... " -nonewline

            if( $crtBody -match [regex]"TRANSFER OF FILE.*SUCCESSFUL!!!" )
            {
                write-host -foregroundColor green "OK, deleting."
                rm $fullFileName -force
            }       
            else
            {
                write-host -foregroundColor Red "failed, skipping file."
            }

            continue
        }
    }

    write-host -foregroundColor Red "**** Unknown report" $report 

}

write-host  " "
write-host "Reports done."
write-host  " "

exit


# ============================================================

#   $date = "{0, -20:MM/dd/yyyy  hh:mm tt}" -f $i.LastWriteTime
#Rename-Item c:\scripts\test.txt new_name.txt
# dir \data\medical\claims -filter 12100_??? -recurse     (find a claim directory)

if( test-path $configFile ) {
    write-host  "Config file exists"

    $strConfig = get-content copyclaims.txt
    $maxClaim = $strConfig
    write-host "Max Claim processed =" $maxClaim
    $crtMax = $maxClaim
}
else {
    write-host  "Config file does NOT exist, creating..."
    New-Item $configFile -type file -force -value "0"

}

write-host  " "

# Verify all the claim files

$strClaims =  dir $claimDir -filter *.CLM -name 
if( $strClaims -eq $null )
{
   write-host "No claim files, done."
   exit
}

foreach ($claim in $strClaims) {
    $claimName = ($claim.trim()).TrimEnd('.CLM')
    [int] $fileNumber = $claimName
    $fullFileName = $claimDir + "\" + $claim

    if( $fileNumber -le $maxClaim ) 
    {
        continue   #skip over claims already processed
    }

    $crtIns = "err"

    if( $fileNumber -gt $crtMax ) { $crtMax = $fileNumber }

    write-host  " "
	write-host "Processing claim file" $claim $fileNumber $fullFileName
    $content = get-content $fullFileName

    write-host " "

    $regex = [regex]"\*\*PI\*[0-9]+|CLM\*[0-9]+"
#    $regex.Matches($content) | Select-Object -Property Value
    foreach( $matchElem in $regex.Matches($content) )
    {
        if( $matchElem.Value.Contains( "PI" ) )
        {
            [string] $insCode = $matchElem.Value.Remove(0,5)
            $insName = $Ins[$insCode]
            if( $insName -eq $null )
            {
                write-host "insurance code:" $insCode "not found"
                continue
            }

            if( $crtIns -ne $insName )
            {
                $crtIns = $insName
                write-host "Insurance:" $insCode $crtIns 
            }
            continue
        }

        if( $matchElem.Value.Contains( "CLM" ) )
        {
            [string] $claimCode = $matchElem.Value.Remove(0,4)
            if( $claimCode -eq $null )
            {
                write-host "parsing error for claim" $matchElem
                continue
            }

            write-host "    Claim" $claimCode $crtIns
            $destDir = $destPath + $claimCode + "_" + $crtIns
            if( test-path $destDir )
            {
                write-host "        Directory" $destDir "exists"
            }
            else
            {
                mkdir $destDir | out-null
                
                if( test-path $destDir ) {
                    write-host "        dir " $destDir "created"
                }
                else {
                    write-host "        creating dir " $destDir "failed, skipping."
                    continue
                }

            }

            # target claim directory exists
            
            $destFileName = $destDir + "\claim_" + $claimCode + "_" + $crtIns + "_" + $claim

            if( test-path $destFileName ) {
                write-host "        skippink existing file " $destFileName
                continue
            }

            cp $fullFileName $destFileName
            write-host "        file " $destFileName "created"

        }
    }

    #break  # debug, for now process one file
}

write-host  " "
#$Ins
write-host  "test done; last claim =" $crtMax

Clear-content $configFile   # erases the configuration file
Add-Content $configFile $crtMax 

exit

#   $date = "{0, -20:MM/dd/yyyy  hh:mm tt}" -f $i.LastWriteTime
#Rename-Item c:\scripts\test.txt new_name.txt



$strClaims =  dir -filter claim_* -name 
if( $strClaims -eq $null )
{
   write-host "No claims files, done."
   exit
}

foreach ($claim in $strClaims) {
    if( -not $claim.Contains(".pdf") ) {
	write-host $claim "is not a pdf file, ignored."
	continue
    }

    if( $claim.Length -lt 19 ) {
	write-host $claim "has a short name, ignored."
	continue
    }


    $dir = "c:\data\medical\claims\" + $claim.substring(6,9)
    write-host "claim: " $claim ", move to dir" $dir "; ."

    if( test-path $dir ) {
  	 write-host "dir " $dir "exists, skipping"
         continue
    }

    mkdir $dir

    if( test-path $dir ) {
  	 write-host "dir " $dir "created"
    }
    else {
  	 write-host "creating dir " $dir "failed, skipping."
         continue
    }

    mv $claim $dir
}

write-host "End of processing."

#$regex = (?<CMultilineComment>/\*[^*]*\*+(?:[^/*][^*]*\*+)*/)
#PS C:> Get-Content foo.c | Join-String -Newline | 
#           foreach {$regex.matches($_)} | 
#           foreach {$_.Groups["CMultilineComment"].Value} 
