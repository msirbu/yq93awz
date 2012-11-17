# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# quickly view the status of an account

$transferPath = "Z:\transfer\"
$dataPath = ".\temp\"
# $superbillBlank = "C:\apln\bin\temp\superbill.pdf"
$configFile = "C:\apln\bin\resource\stmt_config.txt"
$opName = "quickview"

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
    write-host -foregroundcolor yellow "`t $my_cmd <chart>          [quickly view the account status]"
    write-host -foregroundcolor yellow "`t $my_cmd -full <chart>    [quickly view the full account status]"
    
#    write-host "`t (not yet) cmd -name <beginning of name>"
#    write-host "`t (not yet) cmd <chart> [-fac {r|s}] [-date <date>]"
#    write-host "`t (not yet) cmd -all [-fac {r|s}] [-date <date>]"
#    write-host  " "

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

while ( $i -lt $len )
{
    # write-host $i $args[$i]

    if( $args[$i] -eq "-full" )
    {
        $full_view = $true
        $i = $i + 1
        continue
    }

	$chart = expand_medisoft_chart $args[$i]
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

write-host " "

write-host "Printing $opName for $chart " -nonewline
if( $full_view )
{
    write-host "  using full information." -nonewline
}
write-host "`n"
write-host " "

$chart = $chart.toUpper()

# --------------------------------------------------------------------------

$fileName = "quickview_" + $chart + "_$defaultDayString"

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

if( $full_view )
{
    $content = "full $chart 12 -only"
}
else
{
    $content = "stmt $chart 12 -only"
}
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

        if( ( $inputXml.stmt.total -eq '$0.00' ) -and ( -not $full_view ) )
        {
             write-host -foregroundcolor green "No balance.`n"
             exit
        }

        # -----------------------------------------------------------------
        # create statement .pdf image
        #PS C:\apln\bin> ..\java\fop-1.0\fop -xml z:\transfer\dir1.xml 
        # -xsl ..\java\fop-1.0\mihai_test\name2fo.xsl -pdf .\temp\na
        #PS C:\apln\bin> java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay 
        # .\temp\name.pdf ..\java\fop-1.0\mihai_test\superbill
        #.pdf .\temp\sup.pdf

        &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl .\resource\quickview2fo.xsl -pdf $pdfFileDestFull

        # -----------------------------------------------------------------

        # -----------------------------------------------------------------
        # print statement
     
        if( -not ( test-path $pdfFileDestFull ) )
        {
            # can't find the PDF file
             write-host -foregroundcolor red "Did not generate PDF file; operation failed.`n"
             exit
        }

        Start-Process $pdfFileDestFull -verb open

        #exit loop
        $done = $true
        break
    }
    start-sleep 1
    $i = $i - 1
    write-host "." -nonewline
}


# --------------------------------------------------------------------------

write-host "End of processing."
