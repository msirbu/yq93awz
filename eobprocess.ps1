#  Copyright (C) 2012 Blue Ice Health Services
#
#  Automatic processing of PDF files with claim reports
#
# all eob_.pdf files in the source directory
#   - check if they have a corresponding .txt file; if not, convert and create one
#   - determine the month based on the file name
#   - parse the text and find all corresponding EOBs
#       - for each EOB, find the target directory.
#       - copy the EOB into the target directory, if needed
#       - if target not in "done" state, move it to done based on month
#   - move the EOB file to archive (mail)
#   - delete the txt file

$sourcePath = "C:\data\medical\test"
$javaJar = "C:\downloads\pdfbox-app-1.6.0.jar"
$claimBasePath = "c:\data\medical\claims\"
$mailBasePath = "c:\data\medical\mail\"

# ====================================================================

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
        write-host " `t`t Claim dir:" $elem.FullName

        $destFullName = $elem.FullName + "\" + $newName

#if target file exists, return
        if( test-path $destFullName )
        {
             write-host "`t`t $destFullName" -nonewline
             write-host -foregroundColor Green " already exists, $opName skipped"
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
        write-host -foregroundColor Green $opName $reportFileName.substring( $reportFileName.lastindexof( "\" ) ) -nonewline
        write-host  " to" $destFullName 
        
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

#  all eob_.pdf files in the source directory

# check that the souce directory exists

if( -not ( test-path $sourcePath ) )
{
    write-host  " "
    write-host -foregroundColor Red "Source directory" $sourcePath "does not exist, we are done."
    write-host  " "
    exit
}

write-host " "
write-host  "Processing EOB .pdf files in directory $sourcePath..."
write-host " "

# select all EOB files

$strClaims =  dir $sourcePath -filter "eob_*.pdf"
if( $strClaims -eq $null )
{
    write-host -foregroundColor Green "No EOB files, done."
    write-host  " "
    exit
}

$today = [DateTime]::Today.Date
$month = "{0:MM}" -f $today
$year = "{0:####}" -f $today.year
$defaultMonth = $year + "_" + $month

write-host  " "
write-host "Default Date: $defaultMonth"
write-host  " "

foreach ($eob in $strClaims) 
{

    write-host $eob.name

    $baseName = $eob.name.substring( 0, $eob.name.indexof( ".pdf" ) );
    $textFileName = $basename + ".txt"
    $pdfFileNameFull = "$sourcePath/$eob"
    $textFileNameFull = "$sourcePath/$textFileName"

    $processOK = $true

#   - determine the month based on the file name
    if( $eob.name.startswith( "eob_20" ) -and ($eob.name.length -gt 20 ) )
    {
        $fileMonth = $eob.name.substring(4, 7);
        write-host "`t month = $fileMonth"
    }
    else
    {
        $fileMonth = $defaultMonth
        write-host "`t using default month = $fileMonth"
    }

#   - check if they have a corresponding .txt file; if not, convert and create one
    write-host "`t text file... " -nonewline

    if( test-path $textFileNameFull )
    {
        write-host -foregroundColor Green "OK"
    }
    else
    {
        write-host "converting... " -nonewline
        # write-host " "
        # write-host " java -jar $javaJar ExtractText $pdfFileNameFull $textFileNameFull "
        java -jar $javaJar ExtractText $pdfFileNameFull $textFileNameFull
        write-host -foregroundColor Green "done."
    }

#   - parse the text and find all corresponding EOBs
    $content = get-content $textFileNameFull
    $regex = [regex]"Acnt: [^:]* ICN"
    foreach( $matchElem in $regex.Matches($content) )
    {
        # write-host "`t`t $matchElem"

        # we need the claim of 5 digits; 
        # the claim # is alone or preceeded by 8 chars of chart, with or withour blanks

        $regex2 = [regex]"[0-9][0-9][0-9][0-9][0-9] ICN"
        foreach( $claimStr in $regex2.matches( $matchElem ) )
        {
            $claimNo = $claimStr.tostring().substring( 0, 5)
            write-host "`t Claim = $claimNo"

#       - for each EOB, find the target directory, if it exists

            $claimDir = $claimNo + "_???"
            $foundDir = dir $claimBasePath -filter $claimDir -recurse
            if( $foundDir -eq $null )
            {
                write-host "`t`t No claim dir: " -nonewline
                write-host -foregroundColor Red  "skipping report."
                write-host " "

                $processOK = $false  #mark error, we do not archive report file

                continue
            }

            $firstDir = $true
            foreach( $elem in $foundDir )
            {
                if( $firstDir )
                {
                    $destDirFull = $elem.FullName
                    $destDir = $elem.Name
                    $firstDir = $false
                }
            }

#       - copy the EOB into the target directory, if needed

            $res = transfer_report_to_dir $pdfFileNameFull $claimNo $eob.name $false 


#       - if target not in "done" state, move it to done based on month
            write-host  "`t`t Checking $destDir for DONE status... " -nonewline
            if( $destDirFull.contains("0 pd_done") )
            {
                # the claim directory is already in done state
                write-host -foregroundColor Green "OK"
            }
            else
            {
                # we need to move the claim directory to the done state
                write-host "need to move"

                $targetDoneDir = $claimBasePath + "0 pd_done\ $fileMonth"
                write-host  "`t`t target dir: $targetDoneDir " -nonewline
                if( test-path $targetDoneDir )
                {
                    write-host "moving... " -nonewline
                    mv $destDirFull $targetDoneDir
                    write-host -foregroundColor Green "done."
                }
                else
                {
                     write-host -foregroundColor Red  " failed."
                }

                write-host " "

            }

            write-host " "

        } #foreach eob


    } #foreach claim

    if( $processOK )
    {
        # all claims OK, archive eob file in mail directory
        write-host "`t archiving file in mail directory"
    
#   - move the EOB file to archive (mail)
        
        $mailDestDir = $mailBasePath + $fileMonth
        if( -not ( test-path $mailDestDir ) )
        {
            write-host -foregroundColor Red "`t Dest dir directory $mailDestDir does not exist, skip."
            write-host  " "
            continue
        }

        $mailDestName = $mailBasePath + $fileMonth + "\" + $eob.name
        if( test-path $mailDestName )
        {
            write-host "`t Dest file exists, skipping."
            continue
        }
        else
        {
            mv $pdfFileNameFull $mailDestName

#   - delete the txt file
            rm $textFileNameFull

            write-host "`t Done archiving."
        }

    }
    else
    {
        # error in claim processing
        write-host "`t Processing error; keep file in original directory"
    }
    write-host " "
}

write-host " "
write-host "Done EOB processing."
    