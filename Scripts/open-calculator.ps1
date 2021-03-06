#!/snap/bin/powershell
<#
.SYNTAX         ./open-calculator.ps1
.DESCRIPTION	starts the calculator program
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

try {
	start-process calc.exe
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
