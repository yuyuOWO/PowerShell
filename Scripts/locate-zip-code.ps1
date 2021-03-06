#!/snap/bin/powershell
<#
.SYNTAX         ./locate-zip-code.ps1 [<country-code>] [<zip-code>]
.DESCRIPTION	prints the geographic location of the given zip-code
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

param([string]$CountryCode = "", [string]$ZipCode = "")
$PathToRepo = "$PSScriptRoot/.."

try {
	if ($CountryCode -eq "" ) {
		$CountryCode = read-host "Enter the country code"
	}
	if ($ZipCode -eq "" ) {
		$ZipCode = read-host "Enter the zip code"
	}

	write-progress "Reading zip-codes.csv..."
	$Table = import-csv "$PathToRepo/Data/zip-codes.csv"

	$FoundOne = 0
	foreach($Row in $Table) {
		if ($Row.country -eq $CountryCode) {
			if ($Row.postal_code -eq $ZipCode) {
				$Country=$Row.country
				$City = $Row.city
				$Lat = $Row.latitude
				$Lon = $Row.longitude
				write-output "* $Country $ZipCode $City is at $Lat°N, $Lon°W"
				$FoundOne = 1
			}
		}
	}

	if ($FoundOne) {
		exit 0
	}
	write-error "Zip-code $ZipCode in country $CountryCode not found"
	exit 1
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
