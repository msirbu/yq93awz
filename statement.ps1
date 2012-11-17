# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# print refund checks

$transferPath = "T:\"
$dataPath = ".\temp\"
$superbillBlank = "C:\apln\bin\temp\superbill.pdf"
$configFile = "C:\apln\bin\resource\stmt_config.txt"

# --------------------------------------------- functions ------------------------------

# returns the statement number from the configuration file

function get_next_stmt_number
{
    if( test-path $configFile ) {
        $strConfig = get-content $configFile
        $next_stmt = [int] $strConfig
        return $next_stmt
    }
    return [int] 0  #default if no configuration file

}   # end get_next_stmt_number

# ----------------------------------------------------------
# sets configuration statment number to given parameter

function set_next_stmt_number
{
    param([int] $next_stmt )

    if( test-path $configFile ) {
        Clear-content $configFile   # erases the configuration file
        Add-Content $configFile $next_stmt 
        write-host "`updating config file: stmt=$next_stmt`n"
    } 
    else
    {
        write-host  "Creating config file $configFile, stmt=$next_stmt`n"
        New-Item $configFile -type file -force -value $next_stmt.tostring()
    }
}   # end set_next_stmt_number

# --------------------------------------------- end functions --------------------------

# check that the transfer directory exists

if( -not ( test-path $transferPath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Transfer directory" $transferPath "does not exist, we have failed."
    write-host "Please print refund manually."
    write-host  " "
    exit
}

# check that the data directory exists

if( -not ( test-path $dataPath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Data directory" $dataPath "does not exist, we have failed."
    write-host "Please print refund manually."
    write-host  " "
    exit
}


$len = $args.Length

if ( $len -lt 1 )
{
    write-host "Usage:"
    write-host "`t cmd <chart> <stmt_number>"
    write-host "`t cmd cfg"
    write-host "`t cmd set <stmt_number>"
    
#    write-host "`t (not yet) cmd -name <beginning of name>"
#    write-host "`t (not yet) cmd <chart> [-fac {r|s}] [-date <date>]"
#    write-host "`t (not yet) cmd -all [-fac {r|s}] [-date <date>]"
#    write-host  " "

    exit
}


# ============================ process special commands =====================

if( $args[0] -eq "cfg" )
{
    $next_stmt = get_next_stmt_number
    write-host "`nNext statement = $next_stmt"
    write-host "`nDone.`n"
    
    exit
}

# ===================================

if( $args[0] -eq "set" )
{
    if ( $len -le 1 )
    {
        write-host "Usage:"
        write-host "`t cmd set <stmt_number>"
        exit
    }
    $next_stmt = [int] $args[1]
    set_next_stmt_number $next_stmt

    write-host "`nDone.`n"
    
    exit
}

# ===================================

if( $args[0] -eq "reprint" )
{
    if ( $len -le 1 )
    {
        write-host "Usage:"
        write-host "`t cmd reprint <stmt_number>"
        exit
    }
    $stmt = [int] $args[1]
    $filterStr = "stmt_" + $stmt.tostring("00000") + "*.pdf"
           write-host "filter: " $filterStr
    $foundDir = dir "." -filter $filterStr -recurse

    if( $foundDir -eq $null )
    {
        write-host "No statement" $stmt
    } else 
    {
        foreach( $elem in $foundDir )
        {
            write-host "reprint file" $elem.FullName
            Start-Process $elem.FullName -verb open     
        }
    }
    write-host "`nDone.`n"
    
    exit
}



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
        $chart = $args[$i]
        $i = $i + 1
        continue
    }

    if( $i -eq 1 )
    {
     #   [int] $num = $args[$i]
        $i = $i + 1
        continue
    }

    $i = $i + 1
}

$num = get_next_stmt_number

write-host " "

$printnum = $num.tostring("00000")

write-host "Printing statement for $chart, number = $printnum"
write-host " "

$chart = $chart.toUpper()

# --------------------------------------------------------------------------

$fileName = "stmt_" + $printnum + "_" + $chart + "_$defaultDayString"

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


$content = "stmt $chart $printnum"
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
        write-host "`n Statement processed, transferring ." -nonewline
        
        mv -force $xmlFileDestFull $xmlFileNameFull 
        write-host "." -nonewline
        #clean results
        rm -force $cmdFileDestFull 
        write-host "." -nonewline
        rm -force $resFileDestFull 
        write-host "." 
        write-host " " 


        # -----------------------------------------------------------------
        # create statement .pdf image
        #PS C:\apln\bin> ..\java\fop-1.0\fop -xml z:\transfer\dir1.xml 
        # -xsl ..\java\fop-1.0\mihai_test\name2fo.xsl -pdf .\temp\na
        #PS C:\apln\bin> java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay 
        # .\temp\name.pdf ..\java\fop-1.0\mihai_test\superbill
        #.pdf .\temp\sup.pdf

        &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl .\resource\stmt2fo.xsl -pdf $pdfFileDestFull

        # -----------------------------------------------------------------
        # print statement
     
        Start-Process $pdfFileDestFull -verb open

        # -----------------------------------------------------------------
        # update statement number

        $num = $num + 1
        set_next_stmt_number $num

        #exit loop
        $done = $true
        break
    }
    start-sleep 3
    $i = $i - 1
}


# --------------------------------------------------------------------------

write-host "End of processing."
