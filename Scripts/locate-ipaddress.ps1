#!/snap/bin/powershell
<#
.SYNTAX         ./locate-ipaddress.ps1 [<IPaddress>]
.DESCRIPTION	prints the geographic location of the given IP address
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

param([string]$IPaddr)
try {
	if ($IPaddr -eq "" ) {
		$IPaddr = read-host "Enter IP address to locate"
	}
	$result = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPaddr"
	write-output $result
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
