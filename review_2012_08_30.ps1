# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# review entries for a particular date (transaction, demographics, etc)

$transferPath = "Z:\transfer\"
$dataPath = ".\temp\"
$superbillBlank = "C:\apln\bin\temp\superbill.pdf"
# $configFile = "C:\apln\bin\resource\stmt_config.txt"

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

# --------------------------------------------- program constants, ops, etc.

$verbose = $true    #if we report various operations to the console
$op = "review"   # the default op is stmt; could be also "rebill"


$len = $args.Length

if ( $len -lt 1 )
{
    write-host "Usage:"
    write-host "`t cmd <date>"

#    write-host "`t cmd cfg"
#    write-host "`t cmd set <stmt_number>"  
#    write-host "`t (not yet) cmd -name <beginning of name>"
#    write-host "`t (not yet) cmd <chart> [-fac {r|s}] [-date <date>]"
#    write-host "`t (not yet) cmd -all [-fac {r|s}] [-date <date>]"
#    write-host  " "

    exit
}

# ============================ process "regular" statements ================= 


$hasName = $false

$i = 0;
if( $op -eq "review" )   # do parameter parsing, otherwise info is available
{
    while ( $i -lt $len )
    {
        # write-host $i $args[$i]

        if( $i -eq 0 )
        {
            [datetime]$date = $args[$i]
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
} #end if

write-host " "
$defaultDayString = $date.tostring("yyyy_MM_dd") 

write-host "Reviewing transaction and demographics for $defaultDayString."
write-host " "


# --------------------------------------------------------------------------


$fileName = "review_$defaultDayString"

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

$content = "review " + $date.tostring("MM/dd/yyyy")

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
$retry = $false
$i=10

$done = $false
while ( ($i -gt 0) -and (-not $done) )
{
    write-host "$i " -nonewline

    if( test-path $resFileDestFull )
    {
        write-host "`n Review processed, transferring ." -nonewline
        
        #clean results
        rm -force $cmdFileDestFull 
        write-host "." -nonewline
        rm -force $resFileDestFull 
        write-host "." -nonewline

        if( -not (test-path $xmlFileDestFull) )
        {
            if( $retry )
            {
                write-host "`nProcessing failed; limited to one retry."
                $done = $true
                break
            }
            $retry = $true
            $i = 10
            write-host -foregroundcolor red "`n Missing results, one retry..."
            
            $test = New-Item $cmdFileNameFull -type file -force -value $content

            # move command
            mv -force $cmdFileNameFull $cmdFileDestFull

            break
        }
        mv -force $xmlFileDestFull $xmlFileNameFull 
        write-host "." 
        write-host " " 


        # -----------------------------------------------------------------
        # create statement .pdf image
        #PS C:\apln\bin> ..\java\fop-1.0\fop -xml z:\transfer\dir1.xml 
        # -xsl ..\java\fop-1.0\mihai_test\name2fo.xsl -pdf .\temp\na
        #PS C:\apln\bin> java -jar C:\downloads\pdfbox-app-1.6.0.jar Overlay 
        # .\temp\name.pdf ..\java\fop-1.0\mihai_test\superbill
        #.pdf .\temp\sup.pdf

        &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl .\resource\review2fo.xsl -pdf $pdfFileDestFull

        # -----------------------------------------------------------------

        # -----------------------------------------------------------------
        # print statement
     
        Start-Process $pdfFileDestFull -verb open

        #exit loop
        $done = $true
        break
    }
    start-sleep 3
    $i = $i - 1
}


# --------------------------------------------------------------------------

write-host "End of processing."
