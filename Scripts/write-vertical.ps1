#!/snap/bin/powershell
<#
.SYNTAX         ./write-vertical.ps1 [<text>]
.DESCRIPTION	writes the given text in vertical direction
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

param([string]$Text = "")

try {
	if ($Text -eq "" ) {
		[String]$Text = read-host "Enter text to write"
	}
	[char[]]$TextArray = $Text
	foreach($Char in $TextArray) {
		write-output $Char
	}
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
