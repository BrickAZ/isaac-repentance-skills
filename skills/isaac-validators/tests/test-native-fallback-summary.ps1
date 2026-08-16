$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $scriptRoot "scripts\validate-isaac-mod.ps1"
$root = Join-Path $scriptRoot "fixtures\generic-validator-native-fallback"

$output = @(& $validator -Root $root 2>&1)
if ($LASTEXITCODE -ne 0) {
    throw "Expected the native-table fallback fixture to pass with warnings."
}
$text = $output -join [Environment]::NewLine
if ($text -match "Asset path was not resolved") {
    throw "Native-table fallback references should be summarized instead of emitted one by one."
}
$summaries = @($output | Where-Object { "$_" -match '^WARN \[ASSET_NATIVE_FALLBACK\] Native-table override has ' })
if ($summaries.Count -ne 1) {
    throw "Expected exactly one native fallback summary, found $($summaries.Count)."
}
if ($summaries[0] -notmatch "2 asset reference") {
    throw "Expected the native fallback summary to report both unresolved references."
}

Write-Output "Native resource fallback warning summary test passed."
