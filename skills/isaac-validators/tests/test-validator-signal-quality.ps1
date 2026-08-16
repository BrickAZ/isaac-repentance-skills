$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $scriptRoot "scripts\validate-isaac-mod.ps1"

$signalRoot = Join-Path $scriptRoot "fixtures\generic-validator-signal-quality"
$output = @(& $validator -Root $signalRoot -ModObjectName MyMod 2>&1)
if ($LASTEXITCODE -ne 0) { throw "Signal-quality fixture should pass with warnings." }
$text = $output -join [Environment]::NewLine

$duplicates = @($output | Where-Object { "$_" -match '^WARN \[XML_DUPLICATE\]' })
if ($duplicates.Count -ne 1 -or $duplicates[0] -notmatch 'entry:2') {
    throw "Expected only the same-parent id=2 duplicate, found: $($duplicates -join ' | ')"
}
if ($text -match 'entry:1') { throw "Same id under different parents must not be reported as a duplicate." }

$assets = @($output | Where-Object { "$_" -match '^WARN \[ASSET_UNRESOLVED\]' })
if ($assets.Count -ne 1 -or $assets[0] -notmatch '8 asset reference') {
    throw "Expected one aggregated unresolved-asset warning for eight references."
}
if (($text | Select-String -Pattern 'missing-[1-8]\.png' -AllMatches).Matches.Count -gt 3) {
    throw "Unresolved-asset summary must cap samples instead of dumping every path."
}

$hotpaths = @($output | Where-Object { "$_" -match '^WARN \[LUA_HOTPATH\]' })
if ($hotpaths.Count -ne 1 -or $hotpaths[0] -notmatch 'BadVisual.OnRender') {
    throw "Expected one handler-scoped hot-path warning for BadVisual.OnRender only."
}
if ($hotpaths[0] -match 'safe_visual') { throw "Initialization-time Sprite:Load must not be attributed to the render handler." }
if ($text -notmatch 'Warning categories:') { throw "Expected a warning-category summary." }

$malformedRoot = Join-Path $scriptRoot "fixtures\generic-validator-malformed"
$badOutput = @(& $validator -Root $malformedRoot 2>&1)
if ($LASTEXITCODE -eq 0) { throw "Malformed XML fixture must fail." }
$badText = $badOutput -join [Environment]::NewLine
if ($badText -notmatch 'FAIL \[XML_INVALID\].*line\s+\d+.*position\s+\d+') {
    throw "Malformed XML failure must contain a concise code and source location."
}
if ($badText -match 'This long payload|More payload') {
    throw "Malformed XML output must not dump source payload."
}

Write-Output "Validator signal-quality and concise XML failure tests passed."
