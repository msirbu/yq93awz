$configFile = "C:\apln\bin\copyclaims.txt"
$claimDir = "c:\medidata\RMData\Sent"
$destPath = "c:\data\medical\claims\"
$crtMax = 0

$Ins = @{"6400" = "aet"; "2425" = "car"; "1730" = "car"; "6405" = "cig"; 
         "3429" = "uni"; "3777" = "uni"; "2464" = "med"; 
         "2893" = "uni"; "5406" = "uni"; "4456" = "tri"}

if( test-path $configFile ) {
    write-host  "Config file exists"

    $strConfig = get-content copyclaims.txt
    $maxClaim = $strConfig
    write-host "Max Claim processed =" $maxClaim
    $crtMax = $maxClaim
}
else {
    write-host  "Config file does NOT exist, creating..."
    New-Item $configFile -type file -force -value "0"

}

write-host  " "

# Verify all the claim files

$strClaims =  dir $claimDir -filter *.CLM -name 
if( $strClaims -eq $null )
{
   write-host "No claim files, done."
   exit
}

foreach ($claim in $strClaims) {
    $claimName = ($claim.trim()).TrimEnd('.CLM')
    [int] $fileNumber = $claimName
    $fullFileName = $claimDir + "\" + $claim

    if( $fileNumber -le $maxClaim ) 
    {
        continue   #skip over claims already processed
    }

    $crtIns = "err"

    if( $fileNumber -gt $crtMax ) { $crtMax = $fileNumber }

    write-host  " "
	write-host "Processing claim file" $claim $fileNumber $fullFileName
    $content = get-content $fullFileName

    write-host " "

    $regex = [regex]"\*\*PI\*[0-9]+|CLM\*[0-9]+"
#    $regex.Matches($content) | Select-Object -Property Value
    foreach( $matchElem in $regex.Matches($content) )
    {
        if( $matchElem.Value.Contains( "PI" ) )
        {
            [string] $insCode = $matchElem.Value.Remove(0,5)
            $insName = $Ins[$insCode]
            if( $insName -eq $null )
            {
                write-host "insurance code:" $insCode "not found"
                $crtIns = "err"
                continue
            }

            if( $crtIns -ne $insName )
            {
                $crtIns = $insName
                write-host "Insurance:" $insCode $crtIns 
            }
            continue
        }

        if( $matchElem.Value.Contains( "CLM" ) )
        {
            [string] $claimCode = $matchElem.Value.Remove(0,4)
            if( $claimCode -eq $null )
            {
                write-host "parsing error for claim" $matchElem
                continue
            }

            write-host "    Claim" $claimCode $crtIns
            $destDir = $destPath + $claimCode + "_" + $crtIns
            if( test-path $destDir )
            {
                write-host "        Directory" $destDir "exists"
            }
            else
            {
                mkdir $destDir | out-null
                
                if( test-path $destDir ) {
                    write-host "        dir " $destDir "created"
                }
                else {
                    write-host "        creating dir " $destDir "failed, skipping."
                    continue
                }

            }

            # target claim directory exists
            
            $destFileName = $destDir + "\claim_" + $claimCode + "_" + $crtIns + "_" + $claim

            if( test-path $destFileName ) {
                write-host "        skippink existing file " $destFileName
                continue
            }

            cp $fullFileName $destFileName
            write-host "        file " $destFileName "created"

        }
    }

    #break  # debug, for now process one file
}

write-host  " "
#$Ins
write-host  "test done; last claim =" $crtMax

Clear-content $configFile   # erases the configuration file
Add-Content $configFile $crtMax 

exit

#   $date = "{0, -20:MM/dd/yyyy  hh:mm tt}" -f $i.LastWriteTime
#Rename-Item c:\scripts\test.txt new_name.txt



$strClaims =  dir -filter claim_* -name 
if( $strClaims -eq $null )
{
   write-host "No claims files, done."
   exit
}

foreach ($claim in $strClaims) {
    if( -not $claim.Contains(".pdf") ) {
	write-host $claim "is not a pdf file, ignored."
	continue
    }

    if( $claim.Length -lt 19 ) {
	write-host $claim "has a short name, ignored."
	continue
    }


    $dir = "c:\data\medical\claims\" + $claim.substring(6,9)
    write-host "claim: " $claim ", move to dir" $dir "; ."

    if( test-path $dir ) {
  	 write-host "dir " $dir "exists, skipping"
         continue
    }

    mkdir $dir

    if( test-path $dir ) {
  	 write-host "dir " $dir "created"
    }
    else {
  	 write-host "creating dir " $dir "failed, skipping."
         continue
    }

    mv $claim $dir
}

write-host "End of processing."
