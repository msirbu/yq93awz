# check all claim files if
# they have only .clm files in them; and no other reports.

#$claimDir = "Z:\claims"
$claimDir = "C:\data\medical\claims"


if( -not ( test-path $claimDir ) )
{
    write-host  " "
    write-host "Claim directory" $claimDir "does not exist, we are done."
    write-host  " "
    exit
}


$strClaims =  dir $claimDir -filter "?????_???" | sort-object -property Name

if( $strClaims -eq $null )
{
    write-host  " "
    write-host "No remittance files, done."
    write-host  " "
} else
{  # process 835 files
    write-host  "Claims missing reports:"
    write-host " "
    $count = 0
     
    foreach ($report in $strClaims) 
    {
        $claimYes = $false
        $reportNo = $true

        # write-host "$report"
        $strFiles = dir "$claimDir\$report"
        foreach ( $fileName in $strFiles )
        {
            # write-host "`t $fileName"
            
            if( $fileName.name.Contains(".CLM") ) 
            {  # electronic claim file
                 $claimYes = $true
            }
            else
            {
                $reportNo = $false
            }


        }
        
        #  write-host "`t`t $claimYes $reportNo"
                  
        if( $claimYes -and $reportNo )
        {
            write-host "$report"
            $count = $count + 1
        }

        # write-host " "

    }

    write-host " "
    write-host "Done processing ($count claims). "

}  # end process 835 files
