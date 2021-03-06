#!/snap/bin/powershell
<#
.SYNTAX         ./query-smart-data.ps1 [<directory>]
.DESCRIPTION	queries the S.M.A.R.T. data of your HDD/SSD's and saves it to the current/given directory
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
                requires smartctl from smartmontools
		it's recommended to call this script once per day
#>

#Requires -RunAsAdministrator

param([string]$Directory = "")


function CheckIfInstalled {
	try {
		$null = $(smartctl --version)
	} catch {
		write-error "smartctl is not installed - make sure smartmontools are installed"
		exit 1
	}
}

try {
	if ($Directory -eq "") {
		$Directory = "$PWD"
	}

	write-output "(1) Checking for 'smartctl'..."
	CheckIfInstalled

	write-output "(2) Scanning for S.M.A.R.T. devices..."
	$Devices = $(smartctl --scan-open)

	[int]$DevNo = 1
	foreach($Device in $Devices) {
		write-output "(3) Querying data from S.M.A.R.T. device $Device..."

		$Time = (Get-Date)
		$Filename = "$Directory/SMART-dev$($DevNo)-$($Time.Year)-$($Time.Month)-$($Time.Day).json"
		write-output "(4) Saving data to $Filename..."

		$Cmd = "smartctl --all --json " + $Device 

		Invoke-Expression $Cmd > $Filename
		$DevInfo++
	}
	write-output "DONE."
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
