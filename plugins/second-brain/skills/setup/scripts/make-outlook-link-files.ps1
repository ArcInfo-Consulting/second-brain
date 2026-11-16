<#
Writes two registry files that turn outlook: links on and off for the current Windows user.
This script doesn't change the registry. The user decides whether to import the files.
It reads the registry to find classic Outlook and sends nothing over the network.

Prints each file it wrote or kept, ALREADY ENABLED if the links already work,
or NO CLASSIC OUTLOOK if classic Outlook isn't installed.
#>
param(
    [Parameter(Mandatory = $true)][string]$OutDir
)

if (Test-Path 'Registry::HKEY_CLASSES_ROOT\outlook\shell\open\command') {
    'ALREADY ENABLED'
    exit 0
}

$outlook = $null
$appPath = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE'
if (Test-Path $appPath) { $outlook = "$((Get-ItemProperty $appPath).'(default)')".Trim('"') }
if (-not $outlook -or -not (Test-Path $outlook)) {
    $outlook = @(
        "$env:ProgramFiles\Microsoft Office\root\Office16\OUTLOOK.EXE",
        "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\OUTLOOK.EXE"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $outlook) {
    'NO CLASSIC OUTLOOK'
    exit 0
}

$command = $outlook.Replace('\', '\\')
$files = [ordered]@{
    'outlook-links-enable.reg' = @"
Windows Registry Editor Version 5.00

; Lets "outlook:" links open the matching email in classic Outlook.
; Affects only the current Windows user. Undo with outlook-links-disable.reg.

[HKEY_CURRENT_USER\Software\Classes\outlook]
@="URL:Outlook Item"
"URL Protocol"=""

[HKEY_CURRENT_USER\Software\Classes\outlook\shell\open\command]
@="\"$command\" /select \"%1\""
"@
    'outlook-links-disable.reg' = @"
Windows Registry Editor Version 5.00

; Turns "outlook:" links back off by removing what outlook-links-enable.reg added.

[-HKEY_CURRENT_USER\Software\Classes\outlook]
"@
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
foreach ($name in $files.Keys) {
    $path = Join-Path $OutDir $name
    if (Test-Path $path) {
        "KEPT $path"
    } else {
        # Registry Editor expects UTF-16 for version 5.00 files.
        Set-Content -Path $path -Value $files[$name] -Encoding Unicode
        "WROTE $path"
    }
}
