# Appends Claude's compaction summary to "Session Summary.md" in the work folder.
# Claude's working notes before the summary are left out.
# This script writes one local file and sends nothing over the network.

$reader = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), [Text.Encoding]::UTF8)
$hook = $reader.ReadToEnd() | ConvertFrom-Json
$summary = $hook.compact_summary -replace '(?s)^\s*<analysis>.*?</analysis>\s*', ''
$summary = $summary -replace '(?s)^\s*<summary>\s*(.*?)\s*</summary>\s*$', '$1'
$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
$entry = "`r`n## $stamp ($($hook.trigger))`r`n`r`n$summary`r`n"
$path = Join-Path $env:CLAUDE_PROJECT_DIR 'Session Summary.md'
[IO.File]::AppendAllText($path, $entry, (New-Object Text.UTF8Encoding $false))
