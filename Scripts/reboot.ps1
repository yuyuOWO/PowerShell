#!/snap/bin/powershell
<#
.SYNTAX         ./reboot.ps1
.DESCRIPTION	reboots the local computer, administrator rights are required
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

#Requires -RunAsAdministrator

try {
	Restart-Computer
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
