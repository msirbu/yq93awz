# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# print superbills

# $transferPath = "T:\"
$transferPath = "Z:\transfer\"
$dataPath = ".\temp\"
$superbillShort = ".\resource\superbill.pdf"
$superbillLong = ".\resource\superbill2.pdf"
$xslShort = ".\resource\unpaid2fo.xsl"
$xslLong = ".\resource\superbill2fo2.xsl"
$opName = "unpaid claims"

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

# check that the blank superbill exists

if( -not ( test-path $superbillShort ) )
{
    write-host  " "
    write-host -foregroundColor Red "Blanc superbill $superbillShort does not exist, we have failed."
    write-host "Please print superbill from Office Hours."
    write-host  " "
    exit
}

$len = $args.Length

if ( $len -le 1 )
{
    $my_cmd = $myinvocation.mycommand.name
    write-host
    write-host "Usage:"
    write-host -foregroundcolor yellow "`t $my_cmd <date_start> <date_end>"

    exit
}

$defaultDay = get-date -uformat "%m/%d/%Y"
$defaultDayString = get-date -uformat "%Y_%m_%d"

$hasName = $false
$multipage = $false
$prefix = ""

[datetime]$start_date = $args[0]
[datetime]$end_date = $args[1]

$start_date_print = $start_date.tostring("MM/dd/yyyy")
$end_date_print = $end_date.tostring("MM/dd/yyyy")
$defaultDayString = $start_date.tostring("yyyy_MM_dd") 
 
write-host "`nPrinting unpaid claims, visits from $start_date_print to $end_date_print.`n" 


# --------------------------------------------------------------------------

$fileName = "unpaid_$defaultDayString"

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

$content = "unpaid $start_date_print $end_date_print"
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
        write-host "`nUnpaid claims processed, transfering ." -nonewline
        
        if( -not (test-path $xmlFileDestFull) )
        {
            # cannot find results file; go around again if allowed.
            if( $retry -gt 0 )
            {
                write-host "`n No results found, automatically trying again."
                $retry -= 1
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

        # -----------------------------------------------------------------
        # create intermediate file
        #PS C:\apln\bin> ..\java\fop-1.0\fop -xml z:\transfer\dir1.xml 
        # -xsl ..\java\fop-1.0\mihai_test\name2fo.xsl -pdf .\temp\na
        #PS C:\apln\bin> java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay 
        # .\temp\name.pdf ..\java\fop-1.0\mihai_test\superbill
        #.pdf .\temp\sup.pdf

        &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl $xslShort -pdf $pdfFileDestFull

        #view report
     
        if( -not (test-path $pdfFileDestFull) )
        {
            # cannot find PDF file; done processing.

            write-host "`n Failed creating PDF file; processing done.`n"
            
            exit
        }

        Start-Process $pdfFileDestFull -verb open


        $done = $true
        break
    }
    start-sleep 1
    $i = $i - 1
    write-host "." -nonewline
}


# --------------------------------------------------------------------------

write-host "End of processing."
