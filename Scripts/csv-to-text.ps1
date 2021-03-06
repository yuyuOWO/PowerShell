#!/snap/bin/powershell
<#
.SYNTAX         ./csv-to-text.ps1 [<csv-file>]
.DESCRIPTION	converts the given CSV file into a text list
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

param([String]$Path)

try {
	if ($Path -eq "" ) {
		$Path = read-host "Enter path to CSV file"
	}

	$Table = Import-CSV -path "$Path" -header A,B,C,D,E,F,G,H

	foreach($Row in $Table) {
		write-output "* $($Row.A) $($Row.B) $($Row.C) $($Row.D) $($Row.E) $($Row.F) $($Row.G) $($Row.H)"
#		write-output "* [$($Row.B)](ipfs::$($Row.A))"
	}
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
