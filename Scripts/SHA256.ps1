#!/snap/bin/powershell
<#
.SYNTAX         ./SHA256.ps1 [<file>]
.DESCRIPTION	prints the SHA256 checksum of the given file
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

param([string]$File = "")

try {
	if ($File -eq "" ) {
		$File = read-host "Enter file"
	}

	$Result = get-filehash $File -algorithm SHA256
	write-output "SHA256 hash is:" $Result.Hash
	exit 0
} catch {
	write-error "ERROR in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
