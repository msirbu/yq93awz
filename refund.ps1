# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# print refund checks

$transferPath = "\\mdsil01\medidata\transfer\"
#$transferPath = "T:\"
$dataPath = ".\temp\"
$superbillBlank = "C:\apln\bin\temp\superbill.pdf"
$configFile = "C:\apln\bin\resource\refund_config.txt"
$opName = "refund"

# --------------------------------------------- functions ------------------------------

# returns the refund number from the configuration file

function get_next_check_number
{
    if( test-path $configFile ) {
        $strConfig = get-content $configFile
        $next_check = [int] $strConfig
        return $next_check
    }
    return [int] 0  #default if no configuration file

}   # end get_next_check_number

# ----------------------------------------------------------
# sets configuration check number to given parameter

function set_next_check_number
{
    param([int] $next_check )

    if( test-path $configFile ) {
        Clear-content $configFile   # erases the configuration file
        Add-Content $configFile $next_check 
        write-host "`updating config file: check=$next_check`n"
    } 
    else
    {
        write-host  "Creating config file $configFile, check=$next_check`n"
        New-Item $configFile -type file -force -value $next_check.tostring()
    }
}   # end set_next_check_number

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


$len = $args.Length

if ( $len -le 0 )
{
    $my_cmd = $myinvocation.mycommand.name
    write-host
    write-host "Usage:"
    write-host -foregroundcolor yellow "`t $my_cmd <chart> <$opName-amt>"
    write-host -foregroundcolor yellow "`t $my_cmd cfg                       [shows $opName configuration]"
    write-host -foregroundcolor yellow "`t $my_cmd set <$opName-number>  "
    write-host -foregroundcolor yellow "`t $my_cmd back                      [rolls $opName number back by one]"

#    write-host "`t (not yet) cmd -name <beginning of name>"
#    write-host "`t (not yet) cmd <chart> [-fac {r|s}] [-date <date>]"
#    write-host "`t (not yet) cmd -all [-fac {r|s}] [-date <date>]"
#    write-host  " "

    exit
}


# ============================ process special commands =====================

if( $args[0] -eq "cfg" )
{
    $next_check = get_next_check_number
    write-host "`nNext $opName = $next_check"
    write-host "`nDone.`n"
    
    exit
}

# ===================================

if( $args[0] -eq "set" )
{
    if ( $len -le 1 )
    {
        write-host "Usage:"
        write-host "`t cmd set <check_number>"
        exit
    }
    $next_check = [int] $args[1]
    set_next_check_number $next_check

    write-host "`nDone.`n"
    
    exit
}

# ===================================

if( $args[0] -eq "back" )
{

    $next_check =  get_next_check_number
    $next_check -= 1
    set_next_check_number $next_check

    write-host "`nNext $opName = $next_check"
    write-host "`nDone.`n"
    
    exit
}

# ===================================

# ============================ process "regular" statements ================= 

$defaultDay = get-date -uformat "%m/%d/%Y"
$defaultDayString = get-date -uformat "%Y_%m_%d"

$hasName = $false
$prefix = ""
$i = 0;
while ( $i -lt $len )
{
    # write-host $i $args[$i]

    if( $i -eq 0 )
    {
        $chart = expand_medisoft_chart $args[$i]
        $i = $i + 1
        continue
    }

    if( $i -eq 1 )
    {
        [float] $sum = $args[$i]
        $i = $i + 1
        continue
    }

    break       # for now process only the first argument

    $i = $i + 1
}

$check = get_next_check_number  # check number

write-host " "

$printsum = $sum.tostring("F")

write-host "Printing refund for $chart, amount = $printsum, check = $check"
write-host " "

$chart = $chart.toUpper()

# --------------------------------------------------------------------------

$fileName = "refund_" + $check.tostring("00000") + "_" + $chart + "_$defaultDayString"

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

$content = "refund $chart $sum"
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
while ( ($i -gt 0) -and (-not $done) )
{

    if( test-path $resFileDestFull )
    {
        write-host "`n Refund check processed, transferring ." -nonewline
        
        mv -force $xmlFileDestFull $xmlFileNameFull 
        write-host "." -nonewline
        #clean results
        rm -force $cmdFileDestFull 
        write-host "." -nonewline
        rm -force $resFileDestFull 
        write-host "." 
        write-host " " 


        # -----------------------------------------------------------------
        # create refund check .pdf image
        #PS C:\apln\bin> ..\java\fop-1.0\fop -xml z:\transfer\dir1.xml 
        # -xsl ..\java\fop-1.0\mihai_test\name2fo.xsl -pdf .\temp\na
        #PS C:\apln\bin> java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay 
        # .\temp\name.pdf ..\java\fop-1.0\mihai_test\superbill
        #.pdf .\temp\sup.pdf

        &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl .\resource\refund2fo.xsl -pdf $pdfFileDestFull

        # -----------------------------------------------------------------
        # print check
     
        Start-Process $pdfFileDestFull -verb open

        # -----------------------------------------------------------------
        # update check number

        $check = $check + 1
        set_next_check_number $check

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
