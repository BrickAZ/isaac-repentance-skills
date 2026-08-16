$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $scriptRoot "scripts\validate-isaac-mod.ps1"
$root = Join-Path $scriptRoot "fixtures\generic-validator-composite-id"

$output = @(& $validator -Root $root 2>&1)
if ($LASTEXITCODE -ne 0) {
    throw "Expected composite XML identity warnings, not a hard failure."
}
$duplicateWarnings = @($output | Where-Object { "$_" -match '^WARN \[XML_DUPLICATE\] Duplicate id ' })
if ($duplicateWarnings.Count -ne 1) {
    throw "Expected exactly one true duplicate after type qualification, found $($duplicateWarnings.Count)."
}
if ($duplicateWarnings[0] -notmatch "type=passive") {
    throw "Expected the duplicate identity to include the type qualifier."
}


$legalRoot = Join-Path $scriptRoot "fixtures\generic-validator-legal-variants"
$legalOutput = @(& $validator -Root $legalRoot 2>&1)
if ($LASTEXITCODE -ne 0) { throw "Expected legal player variants and layered costumes to pass." }
if (($legalOutput -join [Environment]::NewLine) -match '\[XML_DUPLICATE\]') {
    throw "bSkinParent variants and layered costumes2 ids must not be reported as duplicates."
}
Write-Output "Composite XML identity test passed."
