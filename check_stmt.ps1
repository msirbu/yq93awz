# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# quickly view the status of an account

$transferPath = "Z:\transfer\"
$dataPath = ".\temp\"
# $superbillBlank = "C:\apln\bin\temp\superbill.pdf"
$configFile = "C:\apln\bin\resource\stmt_config.txt"
$opName = "check_stmt"

# --------------------------------------------- functions ------------------------------

# ----------------------------------------------------------
# adds needed 0's at the end or to replace "." inside a chart name

function expand_medisoft_chart
{
    param([string] $in_chart )

    $len=$in_chart.length

    if( $len -ge 8 )   # full chart name, no processing
    {
        return $in_chart.toupper()
    }

    $out_chart = $in_chart

    # ---------------------------
    # fill "." with 0's

    if( $out_chart.contains( "." ) )
    {
        while( $out_chart.length -le 8 )
        {
            $out_chart = $out_chart.replace( ".", ".0" )
        }
        $out_chart = $out_chart.replace( ".", "" )

        return $out_chart.toupper()        
    }

    # fill end with 0's; no "." present
    while( $out_chart.length -lt 8 )
    {
        $out_chart += "0"
    }

    return $out_chart.toupper()

}   # end expand_medisoft_chart

# --------------------------------------------- end functions --------------------------

# check that the transfer directory exists

if( -not ( test-path $transferPath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Transfer directory" $transferPath "does not exist, we have failed."
    write-host "Please print $opName manually."
    write-host  " "
    exit
}

# check that the data directory exists

if( -not ( test-path $dataPath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Data directory" $dataPath "does not exist, we have failed."
    write-host "Please print $opName manually."
    write-host  " "
    exit
}

# --------------------------------------------- program constants, ops, etc.

$verbose = $false    #if we report various operations to the console

$len = $args.Length

if ( $len -lt 1 )
{
    $my_cmd = $myinvocation.mycommand.name
    write-host
    write-host "Usage:"
    write-host -foregroundcolor yellow "`t $my_cmd <stmt_number>          [check payment status for stmt]"
#    write-host -foregroundcolor yellow "`t $my_cmd -full <chart>    [quickly view the full account status]"

    exit
}


# ============================ process special commands =====================


# ===================================

$have_args = $false  #use if we get arguments from the xml file.


# ============================ process "regular" statements ================= 

$defaultDay = get-date -uformat "%m/%d/%Y"
$defaultDayString = get-date -uformat "%Y_%m_%d"

$hasName = $false
$full_view = $false
$prefix = ""
$i = 0;
$index = 0
$r1 = @()
$r2 = @()

if( $false )
{

while ( $i -lt $len )
{
    # write-host $i $args[$i]

    if( $args[$i] -eq "-full" )
    {
        $full_view = $true
        $i = $i + 1
        continue
    }

	$stmt_start = expand_medisoft_chart $args[$i]
    break       # for now process only the first argument

    if( $i -eq 0 )
    {
        $chart = expand_medisoft_chart $args[$i]
        $i = $i + 1
        continue
    }

    if( $i -eq 1 )
    {
        $flag = $args[$i]
        $i = $i + 1
        continue
    }

    if( $i -eq 2 )
    {
     #   [int] $flag = $args[$i]
        $i = $i + 1
        continue
    }

    $i = $i + 1
} # end while

}

[int] $stmt_start = $args[0]
if( $args.length -ge 2 )
{
    [int] $stmt_end = $args[1]
}
else
{
    $stmt_end = $stmt_start 
}

write-host " "

write-host "checking statements $stmt_start to $stmt_end" 
write-host " "

$stmt = $stmt_start

while( $stmt -le $stmt_end )
{
    $filterStr = "stmt_" + $stmt.tostring("00000") + "*.xml"
           write-host "filter: " $filterStr
    $foundDir = dir "." -filter $filterStr -recurse

    if( $foundDir -eq $null )
    {  # could not find the original statement
        write-host "Can't find xml for " $stmt

        $r1 += $stmt
        $r2 += "Not found."


        $stmt += 1    
        continue
    } 

    $xmlPrevStmtName = ""

    foreach( $elem in $foundDir )
    {
        write-host "check stmt" $elem.FullName
        # Start-Process $elem.FullName -verb open   
        [xml] $inputFile = get-content $elem.FullName

        $xmlPrevStmtName = $elem.FullName 
        $converted = $false

        $sb = New-Object System.Text.StringBuilder
        $sw = New-Object System.IO.StringWriter($sb)
        $writer = New-Object System.Xml.XmlTextWriter($sw)
        $writer.Formatting = [System.Xml.Formatting]::Indented

        $inputFile.Save($writer)
        $writer.Close()
        $sw.Dispose()

        if( $verbose )
        {
            write-host $sb.ToString()
        }

        # --------------------------------------------------------
        # read the file, convert it to current version if needed.

        $version = $inputFile.stmt.ver
        if( $version -eq $null )
        {  #can't work if file has no version.
            write-host -foregroundColor red "No version for xml statement, can't rebill" $stmt
            write-host -foregroundColor yellow "`nDone.`n"    
            $stmt += 1    
            continue
        }

        if( $version -eq "v1.0.1" )
        {  #need to convert to latest version
            # write-host -foregroundColor yellow "`nbefore conversion.`n"    

            #generate the destination file name (add _02 before the .xml)

            $xmlPrevStmtName = $xmlPrevStmtName.Replace(".xml", "_02.xml")
            $converted = $true    # converted file; we can move the copy to the transfer directory.

            & .\convertxml.ps1 stmt $elem.FullName $xmlPrevStmtName v1.1.0
            # write-host -foregroundColor yellow "`nafter conversion.`n"    
            
            $inputFile = get-content $xmlPrevStmtName  # $elem.FullName

            $sb = New-Object System.Text.StringBuilder
            $sw = New-Object System.IO.StringWriter($sb)
            $writer = New-Object System.Xml.XmlTextWriter($sw)
            $writer.Formatting = [System.Xml.Formatting]::Indented

            $inputFile.Save($writer)
            $writer.Close()
            $sw.Dispose()

            if( $verbose )
            {
                write-host " "
                write-host -foregroundColor yellow $sb.ToString() "`n"
            }

        }

        # ------------------------------
        # prepare information to generate the new file

        break   # do this for only one file.
    }
    
    # --------------------------------------------------------------------------
    # get the information from the xml file
    $chart = $inputFile.stmt.Chart

    $fileName = "checkstmt_" + $chart + "_$defaultDayString"
    
    $cmdFileName = $fileName + ".appcmd"
    $cmdFileNameFull = $dataPath + $cmdFileName
    $cmdFileDestFull = $transferPath + $cmdFileName

    $resFileName = $fileName + ".appres"
    $resFileDestFull = $transferPath + $resFileName

    $xmlFileName = $fileName + ".xml"
    $xmlFileNameFull = $dataPath + $xmlFileName
    $xmlFileDestFull = $transferPath + $xmlFileName

    $pdfFileName = $fileName + ".pdf"
    $pdfFileDestFull = $dataPath + $pdfFileName

    $tempFileName = $fileName + ".temp"
    $tempFileDestFull = $dataPath + $tempFileName

    # --------------------------------------------------------------------------
    write-host "creating file `"$cmdFileNameFull`""
    write-host " "

    $content = "full $chart 12 -only"
    $test = New-Item $cmdFileNameFull -type file -force -value $content

    # --------------------------------------------------------------------------
    # prepare processing

    # Delete potential result.

    if( test-path $resFileDestFull )
    {
        rm -force $resFileDestFull
    }

    #-----
    # move command

    mv -force $cmdFileNameFull $cmdFileDestFull

    # scan for result

    $i=30

    $done = $false
    $retry = 1
    while ( ($i -gt 0) -and (-not $done) )
    {

        if( test-path $resFileDestFull )
        {
            write-host "`n $opName processed, transferring ." -nonewline

            if( -not (test-path $xmlFileDestFull) )
            {
                # cannot find results file; go around again if allowed.
                if( $retry -gt 0 )
                {
                    write-host -foregroundcolor yellow  "`n`nNo results found, automatically trying again.`n"
                    $retry -= 1
                    # delete results

                    rm -force $resFileDestFull 
                    continue
                }
                else
                {  
                    # give up...
                    write-host "`n Operation failed." -nonewline
                    write-host "`t cleaning up:  " -nonewline
                    write-host "." -nonewline
                    rm -force $cmdFileDestFull 
                    write-host "."  -nonewline
                    rm -force $resFileDestFull 
                    write-host "#" 
                    write-host "Please try again "

                    $done = true
                    break
                }
            }

            mv -force $xmlFileDestFull $xmlFileNameFull 
            write-host "." -nonewline
            #clean results
            rm -force $cmdFileDestFull 
            write-host "." -nonewline
            rm -force $resFileDestFull 
            write-host "." 
            write-host " " 

            # read the results.
            [xml] $inputXml = get-content $xmlFileNameFull

            $result = "paid"
            $stmt_done = $false

            $test_node = $inputFile.stmt.prev_stmt.case
            if( $test_node -ne $null )
            {
                foreach( $tNode in $inputFile.stmt.prev_stmt.SelectNodes( "case/trans" ) )
                {
                    $has_prev_stmt = $true          #flag that there were prev_stmt transactions in the orig stmt
                    $trans_id = $tNode.id
                    [float] $trans_remainder = $tNode.remainder.replace("$", "")
                    write-host "`tevaluating = $trans_id, rem = $trans_remainder.  " -nonewline

                    if( $trans_remainder -eq 0.0 )
                    {
                        write-host "ignored."
                        continue
                    }

                    $t_node = $inputXml.stmt.patient.SelectSingleNode("case/trans[id=$trans_id]")
                    if( $t_node -eq $null )
                    {
                        write-host -foregroundcolor red "not found."
                        if( -not $stmt_done )
                        {
                            $result = "error, transaction $trans_id not found"
                            $stmt_done = $true
                        }
                        continue
                    }

                    [float] $trans_remainder2 = $t_node.remainder.replace("$", "")
                    if( $trans_remainder2 -eq 0.0 )
                    {
                        write-host -foregroundcolor green "paid."
                        continue
                    }

                    if( $trans_remainder2 -lt $trans_remainder )
                    {
                        write-host -foregroundcolor yellow "partially paid."
                    }
                    else
                    {
                        write-host "unpaid."
                    }

                    if( -not $stmt_done )
                    {
                        $result = "not paid"
                        $stmt_done = $true
                    }

                } # end foreach transaction in prev stmt
            }

            $test_node = $inputFile.stmt.patient.case
            if( $test_node -ne $null )
            {
                foreach( $tNode in $inputFile.stmt.patient.SelectNodes( "case/trans" ) )
                {
                    $has_trans = $true          #flag that there were transaction in the orig stmt

                    $trans_id = $tNode.id
                    [float] $trans_remainder = $tNode.remainder.replace("$", "")
                    write-host "`tevaluating = $trans_id, rem = $trans_remainder.  " -nonewline

                    if( $trans_remainder -eq 0.0 )
                    {
                        write-host "ignored."
                        continue
                    }

                    $t_node = $inputXml.stmt.patient.SelectSingleNode("case/trans[id=$trans_id]")
                    if( $t_node -eq $null )
                    {
                        write-host -foregroundcolor red "not found."
                        if( -not $stmt_done )
                        {
                            $result = "error, transaction $trans_id not found"
                            $stmt_done = $true
                        }
                        continue
                    }

                    [float] $trans_remainder2 = $t_node.remainder.replace("$", "")
                    if( $trans_remainder2 -eq 0.0 )
                    {
                        write-host -foregroundcolor green "paid."
                        continue
                    }

                    if( $trans_remainder2 -lt $trans_remainder )
                    {
                        write-host -foregroundcolor yellow "partially paid."
                    }
                    else
                    {
                        write-host "unpaid."
                    }

                    if( -not $stmt_done )
                    {
                        $result = "not paid"
                        $stmt_done = $true
                    }
                } # end foreach transaction in new stmt
            }

            # -----------------------------------------------------------------
            # report result

            write-host -foregroundColor yellow "`nStmt $stmt`: $result`n"

            $r1 += $stmt
            $r2 += $result

            #exit loop
            $done = $true
            break
        }
        start-sleep 1
        $i = $i - 1
        write-host "." -nonewline
    }


    # ------------------------------
    # go to next stmt

    $stmt += 1

}  #end while for each statement

write-host -foregroundColor yellow "`nResults:`n"
#$r1
#$r2

$i=0
foreach( $elem in $r1 )
{
    $stmt = $r1[$i]
    $res = $r2[$i]
    write-host -foregroundColor yellow "$stmt`:`t$res"
    $i += 1
}

# --------------------------------------------------------------------------

write-host "`nEnd of processing."
