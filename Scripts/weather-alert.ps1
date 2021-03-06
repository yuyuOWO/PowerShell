#!/snap/bin/powershell
<#
.SYNTAX         ./weather-alert.ps1
.DESCRIPTION	checks the current weather for critical values
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

$GeoLocation="" # empty means determine automatically

function Check { param([int]$Value, [int]$NormalMin,  [int]$NormalMax, [string]$Unit)  
	if ($Value -lt $NormalMin) {
		return "$Value $Unit ! "
	}
	if ($Value -gt $NormalMax) {
		return "$Value $Unit ! "
	}
	return ""
}

try {
	$Weather=(Invoke-WebRequest http://wttr.in/${GeoLocation}?format=j1 -UserAgent "curl" ).Content | ConvertFrom-Json

	$Result+=Check $Weather.current_condition.windspeedKmph 0 48 "km/h"
	$Result+=Check $Weather.current_condition.visibility 1 1000 "km visibility"
	$Result+=Check $Weather.current_condition.temp_C -20 40 "°C"
	$Result+=Check $Weather.current_condition.uvIndex 0 6 "UV"

	if ($Result -eq "") {
		echo "No weather alert"
	} else {
		echo "WEATHER ALERT: $Result"
	}
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
