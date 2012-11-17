# (C) Copyright 2012 Mihai G. Sirbu, Blue Ice Health Services, LLC.
#
# convert xml files

# notes - for now works only:
#           - stmt files
#           - conversion from v1.0.1 into v1.1

$len = $args.Length

if ( $len -lt 4 )
{
    write-host "`nUsage:"
    write-host -foregroundColor green  "`t cmd stmt input_file output_file version"
    # write-host "`t cmd cfg"
    # write-host "`t cmd set <stmt_number>"
    
#    write-host "`t (not yet) cmd -name <beginning of name>"
#    write-host "`t (not yet) cmd <chart> [-fac {r|s}] [-date <date>]"
#    write-host "`t (not yet) cmd -all [-fac {r|s}] [-date <date>]"
#    write-host  " "

    write-host "`nDone.`n"
    exit
}

# ------------------------------------------
# parse command agruments

$fileType = $args[0]
$inputFileName = $args[1]
$outputFileName = $args[2]
$version = $args[3]

# are we reporting all individual operations?
# $verbose = $true   
$verbose = $false

# ------------------------------------------
# verify command arguments

if( $fileType -ne "stmt" )
{
    write-host -foregroundColor red "`nUnrecognized file type."
    write-host -foregroundColor red "For now, file type should be `"stmt`", not `"$fileType`""
    write-host "`nDone.`n"    
    exit
}

if( -not ( test-path $inputFileName ) )
{
    write-host  " "
    write-host -foregroundColor Red "`nInput file" $inputFileName "does not exist, nothing to convert."
    write-host "`nDone.`n"    
    exit
}

if( ( test-path $outputFileName ) )
{
    write-host  " "
    write-host -foregroundColor Red "`nOutput file" $outputFileName "already exists, cannot convert."
    write-host "`nDone.`n"    
    exit
}

if( $version -ne "v1.1.0" )
{
    write-host -foregroundColor red "`nUnknown output version."
    write-host -foregroundColor red "For now, target version should be `"v1.1.0`", not `"$version`""
    write-host "`nDone.`n"    
    exit
}

# ------------------------------------------
# report the operation; echo arguments

write-host -foregroundColor green "`nConverting xml stmt $inputFileName into "
write-host -foregroundColor green "`t`t    $outputFileName (version $version). "

# ------------------------------------------
# read the input file

[xml] $inputXml = get-content $inputFileName
$sb = New-Object System.Text.StringBuilder
$sw = New-Object System.IO.StringWriter($sb)
$writer = New-Object System.Xml.XmlTextWriter($sw)
$writer.Formatting = [System.Xml.Formatting]::Indented

$inputXml.Save($writer)
$writer.Close()
$sw.Dispose()

if( $verbose )
{
    write-host " "
    write-host $sb.ToString() "`n"
}


# ------------------------------------------
# check the input data

write-host "`nChecking infput file..."

#is it a stmt file?  (i.e. is there a <stmt> at the top level?

write-host "`t<stmt> tag at the root level...  " -nonewline

$node = $inputXml.SelectSingleNode( "stmt" )

if( $node -eq $null )
{   # no stmt node
    write-host -foregroundColor red "fails."
    write-host -foregroundColor red "`t`tThe file does not have a <stmt> tag."
    
    # should we print all existing top level tags here?

    write-host "`nDone.`n"    
    exit
   
}

write-host -foregroundColor green "OK."

# write-host $node.tostring()

# ----------------------------
# is it the right version (or no version)?

$node = $inputXml.SelectSingleNode( "stmt/ver" )

write-host "`tversion node...  " -nonewline

if( $node -eq $null )
{   # no stmt node
    write-host -foregroundColor red "fails."
    write-host -foregroundColor red "`t`tThe file does not have a <ver> node."
    
    # should we print all existing top level tags here?

    write-host "`nDone.`n"    
    exit  
}

write-host -foregroundColor green "OK."


# write-host -foregroundColor yellow "Version node:" $node.tostring()
# $node

write-host "`tright input version (v1.0.1)...  " -nonewline

$verValue = $inputXml.stmt.ver.tostring()
# write-host -foregroundColor yellow "Version value: `"$verValue`""

if( $verValue -ne "v1.0.1" )
{   # no stmt node
    write-host -foregroundColor red "fails."
    write-host -foregroundColor red "`t`tThe file has $verValue version, not v1.0.1 as expected."
    
    # should we print all existing top level tags here?

    write-host "`nDone.`n"    
    exit  
}

write-host -foregroundColor green "OK."


# ------------------------------------------
# convert the data

#clone the data

$outputXml = $inputXml.Clone()

# now we work on converting.

#   ========  version  ========
$outputXml.stmt.ver = "$version"

#   ========  various info  ========

$chart = $inputXml.stmt.Chart
$stmtDate = $inputXml.stmt.Date

#   ========  patient name  ========
# remove patient name from the stmt root

$patientName = $inputXml.stmt.patient
if( $verbose )
{
    write-host "`npatient name: `"$patientName`""
}

$patientNode = $outputXml.stmt.SelectSingleNode( "patient" )
$ignore = $outputXml.stmt.RemoveChild( $patientNode ) 

#   ========  case number  ========
# remove case number from the stmt root

$caseNumber = $inputXml.stmt.case
if( $verbose )
{
    write-host "`nCase: `"$caseNumber`""
}

$caseNode = $outputXml.stmt.SelectSingleNode( "case" )
$ignore = $outputXml.stmt.RemoveChild( $caseNode ) 


#   ========  update date node  ========

$dateNode = $outputXml.stmt.SelectSingleNode( "Date" )
$ignore = $outputXml.stmt.RemoveChild( $dateNode ) 

$newDate = $outputXml.CreateElement("date")
$newDate.set_InnerXML( "$stmtDate" )
$ignore = $outputXml.stmt.AppendChild($newDate)


#   ========  create patient node  ========

$newPatient = $outputXml.CreateElement("patient")
$newPatient.set_InnerXML( "<name>$patientName</name>" )
$ignore = $outputXml.stmt.AppendChild($newPatient)

$newChart = $outputXml.CreateElement("Chart")
$newChart.set_InnerXML( "$chart" )
$ignore = $outputXml.stmt.patient.AppendChild($newChart)

#   ========  create case node  ========

$newCase = $outputXml.CreateElement("case")
$newCase.set_InnerXML( "<id>$caseNumber</id>" )
$ignore = $outputXml.stmt.patient.AppendChild($newCase)


#   ========  remove trans nodes and add them under case  ========
# removing transactions from under stmt

if( $verbose )
{
    write-host "moving transaction nodes" 
}

foreach( $tNode in $outputXml.stmt.SelectNodes( "trans" ) )
{
    if( $verbose )
    {
        write-host "`tmoving" $tNode.id.tostring()
    }
    $newTrans = $tNode.Clone()
    $ignore = $outputXml.stmt.RemoveChild( $tNode ) 
    $ignore = $outputXml.stmt.patient.case.AppendChild($newTrans)
}

#   ========  add first statement date if needed  ========

if( $verbose )
{
    write-host "adding first statement dates" 
}

$newDate = $outputXml.CreateElement("first_stmt_date")
$newDate.set_InnerXML( "$stmtDate" )

foreach( $tNode in $outputXml.stmt.patient.case.SelectNodes( "trans" ) )
{
    if( $verbose )
    {
        write-host "`tchecking" $tNode.id.tostring()
    }
    if( $tNode.first_stmt_date -eq $null )
    {
        if( $verbose )
        {
            write-host "`t`tneed to add date"
        }
        $ignore = $tNode.AppendChild( $newDate.Clone() )
    }
}


# -------------------------------------------------------------------------
# write the output file

$sb = New-Object System.Text.StringBuilder
$sw = New-Object System.IO.StringWriter($sb)
$writer = New-Object System.Xml.XmlTextWriter($sw)
$writer.Formatting = [System.Xml.Formatting]::Indented

$outputXml.Save($writer)
$writer.Close()
$sw.Dispose()

$outputXml =  $sb.ToString()
if( $verbose )
{
    write-host -foregroundColor yellow "`n$outputXml`n"
}


#  output file does not exist (checked before)

write-host  "Writing xml file $outputFileName with new content"
$ignore = New-Item $outputFileName -type file -force -value $outputXml

if( $verbose )
{
    write-host -foregroundColor green "`nDone."
}

write-host " "

# =================================================================================