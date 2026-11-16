<#
Searches text inside .docx, .xlsx, .pptx, .md, .txt, and .csv files without Microsoft Office.
This script only reads files and sends nothing over the network.
It skips online-only OneDrive files so a search doesn't download them.

Output is tab-separated: path, part of the file, matching text.
The last line summarizes what was searched and skipped.
#>
param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Query,
    [int]$MaxResults = 50,
    [int]$MaxFileMB = 100
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

# Keeps accented characters intact. Some hosts refuse this, and search still works without it.
try { [Console]::OutputEncoding = New-Object Text.UTF8Encoding $false } catch { }

# RECALL_ON_OPEN, RECALL_ON_DATA_ACCESS, and OFFLINE mark files that aren't stored locally.
$onlineOnlyFlags = 0x00040000 -bor 0x00400000 -bor 0x00001000
$officeExtensions = @('.docx', '.xlsx', '.pptx')
$textExtensions = @('.md', '.txt', '.csv')
$searched = 0
$matchedFiles = 0
$results = 0
$fileMatched = $false
$onlineOnly = 0
$tooLarge = 0
$unreadable = 0

function Get-PartPattern([string]$Extension) {
    switch ($Extension) {
        '.docx' { return '^word/(document|comments|footnotes|endnotes|header\d*|footer\d*)\.xml$' }
        '.xlsx' { return '^xl/(sharedStrings|worksheets/sheet\d+)\.xml$' }
        '.pptx' { return '^ppt/(slides/slide\d+|notesSlides/notesSlide\d+)\.xml$' }
    }
}

function ConvertTo-PlainText([string]$Xml) {
    # Drop formulas and cells that only point to the shared text list.
    $text = $Xml -creplace '<f\b[^>]*/>', ''
    $text = $text -creplace '(?s)<f\b[^>]*>.*?</f>', ''
    $text = $text -creplace '(?s)<c\b[^>/]*\bt="s"[^>/]*>.*?</c>', ''
    $text = $text -creplace '</(w:p|a:p|si|c)>', "`n"
    $text = $text -creplace '<w:tab\s*/>', ' '
    $text = $text -replace '<[^>]+>', ''
    return [System.Net.WebUtility]::HtmlDecode($text)
}

function Get-Snippet([string]$Line, [int]$Index, [int]$Length) {
    $start = [Math]::Max(0, $Index - 80)
    $end = [Math]::Min($Line.Length, $Index + $Length + 80)
    return $Line.Substring($start, $end - $start).Trim()
}

function Search-Lines($Lines, [string]$Relative, [string]$Part) {
    foreach ($line in $Lines) {
        $index = $line.IndexOf($Query, [StringComparison]::OrdinalIgnoreCase)
        if ($index -lt 0) { continue }
        if ($script:results -lt $MaxResults) {
            "{0}`t{1}`t{2}" -f $Relative, $Part, (Get-Snippet $line $index $Query.Length)
        }
        $script:results++
        $script:fileMatched = $true
    }
}

$root = (Resolve-Path -LiteralPath $Path).Path
$extensions = $officeExtensions + $textExtensions
$files = Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() -and $_.Name -notlike '~$*' }

foreach ($file in $files) {
    if (([int64]$file.Attributes -band $onlineOnlyFlags) -ne 0) {
        $onlineOnly++
        continue
    }
    if ($file.Length -gt ($MaxFileMB * 1MB)) {
        $tooLarge++
        continue
    }

    $searched++
    $fileMatched = $false
    $extension = $file.Extension.ToLowerInvariant()
    $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')

    if ($textExtensions -contains $extension) {
        try {
            Search-Lines ([IO.File]::ReadLines($file.FullName)) $relative 'text'
        }
        catch {
            $unreadable++
        }
    }
    else {
        $archive = $null
        try {
            $archive = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
            $pattern = Get-PartPattern $extension
            foreach ($entry in $archive.Entries) {
                if ($entry.FullName -notmatch $pattern) { continue }
                $reader = New-Object System.IO.StreamReader($entry.Open(), [Text.Encoding]::UTF8)
                try { $xml = $reader.ReadToEnd() } finally { $reader.Dispose() }
                Search-Lines ((ConvertTo-PlainText $xml) -split "`n") $relative $entry.FullName
            }
        }
        catch {
            $unreadable++
        }
        finally {
            if ($archive) { $archive.Dispose() }
        }
    }
    if ($fileMatched) { $matchedFiles++ }
}

"# Searched $searched files. Matches: $results in $matchedFiles files (showing up to $MaxResults). Skipped: $onlineOnly online-only, $tooLarge too large, $unreadable unreadable or password-protected."
