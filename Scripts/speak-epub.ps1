#!/snap/bin/powershell
<#
.SYNTAX         ./speak-epub.ps1 [<epub-file>]
.DESCRIPTION	speaks the content of the given Epub file by text-to-speech (TTS)
.LINK		https://github.com/fleschutz/PowerShell
.NOTES		Author:	Markus Fleschutz / License: CC0
#>

$read = New-Object -com SAPI.SpVoice
 
function readBook() { param([string]$book, [string]$bookPath, [int]$lineNumber = 0)
	$data = Get-Content $book
	for([int]$i=$lineNumber;$i -lt $data.Count;$i++) {
		Set-Content -Path $bookPath"\progress.txt" -Value ($book+","+$i)
		$line = $data[$i]
		if ($line.Contains("<title>")) {
			$line = $line -Replace "<.+?>",""
		 	$read.Speak($line)
		}
		if ($line.contains("<p")) {
			$line = $line -Replace "<.+?>",""
			$read.Speak($line)
		}
	 }
	 Set-Content -Path $bookPath"\progress.txt" -Value ("")
}

function Get-FileName() {
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	#$OpenFileDialog.initialDirectory = "c:\"
	$OpenFileDialog.filter = "ePub files (*.epub)| *.epub"
	$OpenFileDialog.ShowDialog() | Out-Null
	return $OpenFileDialog.filename
}
 
function unzip() { param([string]$file, [string]$dest)
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($file)
	foreach($item in $zip.items()) {
		$shell.Namespace($dest).copyhere($item)
	}
}
 
$epubFile = Get-FileName
$file = get-item $epubFile
if (!(Test-Path($file.DirectoryName+"\"+$file.Name+".zip"))) {
	$zipFile = $file.DirectoryName+"\"+$file.Name+".zip"
	$file.CopyTo($zipFile)
}

$destination = $file.DirectoryName+"\"+$file.Name.Replace($file.Extension,"")
if (!(Test-Path($destination))) {
	md $destination
	unzip -file $zipFile -dest $destination
}
 
[xml]$container = Get-Content $destination"\META-INF\container.xml"
$contentFilePath = $container.container.rootfiles.rootfile."full-path"
[xml]$content = Get-Content $destination"\"$contentFilePath
$tmpPath = Get-Item $destination"\"$contentFilePath
$bookPath = $tmpPath.DirectoryName
$progress = $null
 
foreach($item in $content.package.manifest.Item) {
	if ($item."media-type" -eq "application/xhtml+xml") {
		if (Test-Path($bookPath+"\progress.txt")) {
			$progress = Get-Content $bookPath"\progress.txt"
			$progress = $progress.Split(",")
		}
		$bookFileName = $item.href
		if ($progress.Count -eq 2) {
			if ($progress[0] -eq $bookPath+"\"+$bookFileName) {
				readBook -book $bookPath"\"$bookFileName -bookPath $bookPath -lineNumber $progress[1]
			}
		}
		else {
			readBook -book $bookPath"\"$bookFileName -bookPath $bookPath
		}
	}
}