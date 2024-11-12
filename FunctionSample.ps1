$timeGenerated = Get-Date -Format HH:mm:ss
$dateGenerated = Get-Date -Format MM-dd-yyyy
Add-Content -Path "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.log" -Value "$dateGenerated - $timeGenerated - Starting Install.."
Start-Process -FilePath 'installer.exe' -ArgumentList '/i /s' -Wait -NoNewWindow
Add-Content -Path "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.log" -Value "$dateGenerated - $timeGenerated - Finished Install.."

Get-Content -Path "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.log"

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

function Install-Software {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet(1, 2, 3)]
        [string]$Version,
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$ComputerName

    )

    begin {}
    process {
        Write-Host "Installing software version $Version on $ComputerName" -ForegroundColor Green
        Write-Log -LogMessage "Installing software version $Version on $ComputerName" -logFilePath "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.log"

    }
    end {}

}

function Install-Software {
    <#
    .SYNOPSIS
            Installs software on a remote computer
    .PARAMETER Version
    
            Version of software to install
    .PARAMETER ComputerName
    
            Computer to install software on
    .EXAMPLE

            Install-Software -Version 1 -ComputerName SRV1
            




    #>

    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet(1, 2, 3)]
        [string]$Version,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ComputerName

    
    )

    begin {}
    process {
        Write-Host "Installing software version $Version on $ComputerName" -ForegroundColor Green
        Write-Log -LogMessage "Installing software version $Version on $ComputerName" -logFilePath "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.log"

    }
    end {}
}

##Creating a csv with fake data

@(
    [PSCustomObject]@{'ComputerName' = 'SRV1'; 'Version' = 1 }
    [PSCustomObject]@{'ComputerName' = 'SRV2'; 'Version' = 2 }
    [PSCustomObject]@{'ComputerName' = 'SRV3'; 'Version' = 3 }
    [PSCustomObject]@{'ComputerName' = 'SRV4'; 'Version' = 3 }
) | Export-Csv -Path "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.csv" -Append


Import-Csv -Path "C:\Users\cristobalf\Desktop\PSCourse\Sample_Function.csv" | Install-Software