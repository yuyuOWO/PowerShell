#!/snap/bin/powershell
<#
.SYNTAX         ./unmute-audio.ps1
.DESCRIPTION	unmutes audio output
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

try {
	$obj = new-object -com wscript.shell
	$obj.SendKeys([char]173)
	write-output "OK"
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
