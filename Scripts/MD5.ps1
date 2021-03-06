#!/snap/bin/powershell
<#
.SYNTAX         ./MD5.ps1 [<file>]
.DESCRIPTION	prints the MD5 checksum of the given file
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

param([string]$File = "")

try {
	if ($File -eq "" ) {
		$File = read-host "Enter path to file"
	}
	$Result = get-filehash $File -algorithm MD5
	write-output "MD5 hash is" $Result.Hash
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
