# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# print superbills

# $transferPath = "T:\"
$transferPath = "Z:\transfer\"
$dataPath = ".\temp\"
$superbillShort = ".\resource\superbill.pdf"
$superbillLong = ".\resource\superbill2.pdf"
$xslShort = ".\resource\superbill2fo.xsl"
$xslLong = ".\resource\superbill2fo2.xsl"

# check that the transfer directory exists

if( -not ( test-path $transferPath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Transfer directory" $transferPath "does not exist, we have failed."
    write-host "Please print superbill from Office Hours."
    write-host  " "
    exit
}

# check that the data directory exists

if( -not ( test-path $dataPath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Data directory" $dataPath "does not exist, we have failed."
    write-host "Please print superbill from Office Hours."
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

if ( $len -le 0 )
{
    write-host "Usage:"
    write-host -foregroundcolor yellow "`t cmd [-full] <chart>"
    write-host -foregroundcolor yellow "`t cmd [-full] -name <beginning of name>"
    write-host " "
    write-host "`t (not yet) cmd <chart> [-fac {r|s}] [-date <date>]"
    write-host "`t (not yet) cmd -all [-fac {r|s}] [-date <date>]"
    write-host  " "

    exit
}

$defaultDay = get-date -uformat "%m/%d/%Y"
$defaultDayString = get-date -uformat "%Y_%m_%d"

$hasName = $false
$multipage = $false
$prefix = ""
$i = 0;
while ( $i -lt $len )
{
    # write-host $i $args[$i]
    if( $args[$i] -eq "-name" )
    {
        $hasName = $true
        $i = $i + 1
        $prefix = "-name "
        continue
    }

    if( $args[$i] -eq "-full" )
    {
        $multipage = $true
        $i = $i + 1
        continue
    }

    $chart = $args[$i]
    break       # for now process only the first argument

    $i = $i + 1
}

write-host " "

write-host "Printing superbill $chart, for $defaultDay  ($defaultDayString)" -nonewline
if( $multipage )
{
    write-host "  using full information." -nonewline
}
write-host "`n"

$chart = $chart.toUpper()

# --------------------------------------------------------------------------

$fileName = $chart + "_$defaultDayString"

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

$content = "superbill $prefix$chart"
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

$i=10

$done = $false
while ( ($i -gt 0) -and (-not $done) )
{
    write-host "$i " -nonewline

    if( test-path $resFileDestFull )
    {
        write-host "`n Superbill processed, transfering ." -nonewline
        
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

        if( $multipage )
        {
            &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl $xslLong -pdf $tempFileDestFull
            &  java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay $tempFileDestFull $superbillLong $pdfFileDestFull
        }
        else
        {
            &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl $xslShort -pdf $tempFileDestFull
            &  java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay $tempFileDestFull $superbillShort $pdfFileDestFull
        }

        # PS C:\apln\bin> ..\java\fop-1.0\fop -xml .\temp\CANDPE10_2012_04_25.xml -xsl ..\java\fop-1.0\mihai_test\name2fo.xsl -pdf
        #  .\temp\CANDPE10_2012_04_25.temp

        # -----------------------------------------------------------------
        # create superbill

        #print superbill
     
        Start-Process $pdfFileDestFull -verb open


        $done = $true
        break
    }
    start-sleep 3
    $i = $i - 1
}


# --------------------------------------------------------------------------

write-host "End of processing."
