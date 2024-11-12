

Get-ChildItem -Path "D:/" -File -Recurse

function Write-Log {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$LogMessage,

        [Parameter()]
        # [ValidateScript({ Test-Path -Path $_ })]
        [string]$logFilePath = (Get-Location)
    )
    $timeGenerated = Get-Date -Format HH:mm:ss
    $dateGenerated = Get-Date -Format MM-dd-yyyy 
    Add-Content -Path $logFilePath -Value "$dateGenerated - $timeGenerated - $LogMessage"
}
function Archive-FileOlderThan {
    param (
        [Parameter(Mandatory)]
        [string]$FolderPath,
        [Parameter(Mandatory)]
        [string]$DaysOld
    )

    $DateNow = Get-Date
    $LogDirectory = "Archive_log"
   
    try {
        New-Item -Path $FolderPath -Name $LogDirectory -ItemType Directory -ErrorAction Stop
        Write-Log -LogMessage "Folder $($LogDirectory) has been created." -logFilePath "$FolderPath\$LogDirectory\log.log"
    }
    catch [ System.Management.Automation.ActionPreferenceStopException] {
        Write-Host $LogDirectory "already exists... Moving on."
         Write-Log -LogMessage "Folder $($LogDirectory) exists..." -logFilePath "$FolderPath\$LogDirectory\log.log"
    }

    $LastWrite = $DateNow.AddDays(-$DaysOld)
    $fileList = (Get-ChildItem -Path $FolderPath -File -Recurse -Filter *pdf).Where({ $_.LastWriteTime -le $LastWrite }) 
    foreach ($file in $fileList) {
        try {
            $file | Compress-Archive -DestinationPath "$($file.DirectoryName)\$LogDirectory" -Update
            Write-Log -LogMessage "File $($file.FullName) has been archived." -logFilePath "$($file.DirectoryName)\log"
        }
        catch [System.IO.IOException] {
            Write-Warning " File $($file.FullName) is probably read only and cannot be moved." 
            $SetWritable = Write-host "Would you like to change read-only attribute? (Y,N,A)"
            if ($SetWritable -eq 'Y') {
                Set-ItemProperty $file.FullName -Name IsReadOnly -Value $false
                $file | Compress-Archive -DestinationPath "$($file.DirectoryName)\Archive" -Update
            }


        }

    }   
}

function Write-Log {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$LogMessage,

        [Parameter()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$logFilePath = "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function_default.log"
    )
    $timeGenerated = Get-Date -Format HH:mm:ss
    $dateGenerated = Get-Date -Format MM-dd-yyyy 
    Add-Content -Path $logFilePath -Value "$dateGenerated - $timeGenerated - $LogMessage"
}



