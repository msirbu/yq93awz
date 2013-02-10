# (C) Copyright 2010 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# print refund checks

$transferPath = "\\mdsil01\medical\transfer\"
#$transferPath = "Z:\transfer\"
#$transferPath = "\\mdsil01\medidata\transfer\"
# $transferPath = "T:\"
$dataPath = ".\temp\"
$superbillBlank = "C:\apln\bin\temp\superbill.pdf"
$configFile = "C:\apln\bin\resource\stmt_config.txt"
$opName = "statement"

# original .xsl file was stmt2fo.xsl
# current file uses test2fo.xsl

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
$op = "stmt"   # the default op is stmt; could be also "rebill"


$len = $args.Length

if ( $len -lt 1 )
{
    $my_cmd = $myinvocation.mycommand.name
    write-host
    write-host "Usage:"
    write-host -foregroundcolor yellow "`t $my_cmd <chart> <stmt_number>"
    write-host -foregroundcolor yellow "`t $my_cmd cfg                       [shows $opName configuration]"
    write-host -foregroundcolor yellow "`t $my_cmd set <stmt_number>"
    write-host -foregroundcolor yellow "`t $my_cmd back                      [rolls $opName number back by one]"
    write-host -foregroundcolor yellow "`t $my_cmd reprint <stmt_number>"
    write-host -foregroundcolor yellow "`t $my_cmd rebill <stmt_number>"
    write-host -foregroundcolor yellow "`t $my_cmd status <stmt_number>"
    
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
    write-host "`nNext $opName = $next_stmt"
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

if( $args[0] -eq "back" )
{

    $next_stmt =  get_next_stmt_number
    $next_stmt -= 1
    set_next_stmt_number $next_stmt

    write-host "`nNext $opName = $next_stmt"
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
        write-host "No $opName" $stmt
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

$have_args = $false  #use if we get arguments from the xml file.
$late_flag = $false  # while rebilling, to signal a statement is late

# --------------------------------------------  rebill  --------------------

if( $args[0] -eq "rebill" )
{
    if ( $len -le 1 )
    {
        write-host "Usage:"
        write-host "`t cmd rebill <stmt_number>"
        exit
    }

    $op = "rebill"
    $stmt = [int] $args[1]

    if ( $len -gt 2 )
    {
        if ( $args[2] -eq "-late" )
        {
            $late_flag = $true
        }
    }

    $filterStr = "stmt_" + $stmt.tostring("00000") + "*.xml"
           write-host "filter: " $filterStr
    $foundDir = dir "." -filter $filterStr -recurse

    if( $foundDir -eq $null )
    {  # could not find the original statement
        write-host "No statement to rebill" $stmt
        write-host "`nDone.`n"
    
        exit
    } 

    $xmlPrevStmtName = ""

    foreach( $elem in $foundDir )
    {
        write-host "rebill stmt" $elem.FullName
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
            exit        
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

    # get the information from the xml file
    $chart = $inputFile.stmt.Chart

    write-host "`nDone.`n"

    # exit
}

# ============================ process "regular" statements ================= 

$defaultDay = get-date -uformat "%m/%d/%Y"
$defaultDayString = get-date -uformat "%Y_%m_%d"

$hasName = $false
$prefix = ""
$i = 0;
if( $op -eq "stmt" )   # do parameter parsing, otherwise info is available
{
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

$num = get_next_stmt_number

write-host " "

$printnum = $num.tostring("00000")

if( $late_flag )
{
    $temp = "<Mark as late.>"
}

write-host "Printing $opName for $chart, number = $printnum" -nonewline
write-host -foregroundcolor yellow "   $temp"
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
# copy/move previous xml file for rebills

if( $op -eq "rebill" )
{
    #determine the "pure file name"
    $xmlPrevStmtDestFileName = $xmlPrevStmtName.substring( $xmlPrevStmtName.lastindexof("\") + 1)
    $xmlDestName = $transferPath + $xmlPrevStmtDestFileName

    if( $converted )
    {
        #move file
        write-host "moving $xmlPrevStmtName $xmlDestName"
        mv $xmlPrevStmtName $xmlDestName
    }
    else
    {
        #copy file
        write-host "copying $xmlPrevStmtName $xmlDestName"
        cp $xmlPrevStmtName $xmlDestName
    }
}

# --------------------------------------------------------------------------
write-host "creating file `"$cmdFileNameFull`""
write-host " "

if( $op -eq "rebill" )
{
    $content = "$op $chart $printnum $xmlPrevStmtDestFileName"
}
else
{
    $content = "stmt $chart $printnum $flag"
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
while ( ($i -gt 0) -and (-not $done) )
{

    if( test-path $resFileDestFull )
    {
        write-host "`n $opName processed, transferring ." -nonewline
        
        mv -force $xmlFileDestFull $xmlFileNameFull 
        write-host "." -nonewline
        #clean results
        rm -force $cmdFileDestFull 
        write-host "." -nonewline
        rm -force $resFileDestFull 
        write-host "." -nonewline 
        if( $op -eq "rebill" )
        {
            # rm -force $xmlDestName
            write-host "."  -nonewline 
        }
        write-host " " 

        if( $late_flag )
        {
            write-host "Marking the statement `"late`"." 

            [xml] $inputFile = get-content $xmlFileNameFull
            $node = $inputFile.SelectSingleNode( "stmt/summary" )
            if( $node -ne $null )
            {
                # there is a summary node
                $node2 = $node.SelectSingleNode( "late" )
                if( $node2 -eq $null )
                {
                    write-host "`"Late`" node does NOT exist." 
                }
                else
                {
                    write-host "`"Late`" node exists." 
                    $node.late = "1"
                }  #endif $node2
            }

            $sb = New-Object System.Text.StringBuilder
            $sw = New-Object System.IO.StringWriter($sb)
            $writer = New-Object System.Xml.XmlTextWriter($sw)
            $writer.Formatting = [System.Xml.Formatting]::Indented

            $inputFile.Save($writer)
            $writer.Close()
            $sw.Dispose()

            $outputXml =  $sb.ToString()
            # potential issue: we need to delete characters to the "<stmt>" tag.
            $outputXml = $outputXml.substring( $outputXml.indexof("<stmt>"))

            if( $verbose )
            {
                write-host -foregroundColor yellow "`n$outputXml`n"
            }

            $ignore = New-Item $xmlFileNameFull -type file -force -value $outputXml


        }  #endif late_flag

        # -----------------------------------------------------------------
        # create statement .pdf image

        &  ..\java\fop-1.0\fop -xml $xmlFileNameFull -xsl .\resource\test2fo.xsl -pdf $pdfFileDestFull

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
    start-sleep 1
    $i = $i - 1
    write-host "." -nonewline
}


# --------------------------------------------------------------------------

write-host "End of processing."
