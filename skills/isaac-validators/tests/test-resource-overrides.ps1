$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $scriptRoot "scripts\validate-isaac-mod.ps1"

function Invoke-Fixture([string]$name) {
    $root = Join-Path $scriptRoot "fixtures\$name"
    $output = @(& $validator -Root $root -ModObjectName MyMod 2>&1)
    $exitCode = $LASTEXITCODE
    return [pscustomobject]@{
        ExitCode = $exitCode
        Text = ($output -join [Environment]::NewLine)
    }
}

$resourceOnly = Invoke-Fixture "generic-validator-resource-only"
if ($resourceOnly.ExitCode -ne 0) {
    throw "Expected a resource-only mod fixture to pass."
}
if ($resourceOnly.Text -match "No content directory found") {
    throw "A resource-only mod must not be treated as incomplete merely because content is absent."
}
if ($resourceOnly.Text -notmatch "exact-path resource override") {
    throw "Expected a load-order warning for a broad players.xml override."
}

$multiRoot = Invoke-Fixture "generic-validator-multi-root"
if ($multiRoot.ExitCode -ne 0) {
    throw "Expected the resources-dlc3 fixture to pass."
}
if ($multiRoot.Text -match "Asset path was not resolved") {
    throw "Expected asset resolution to inspect resources-dlc3."
}
if ($multiRoot.Text -match "ANM2 event reference was not resolved: Ready") {
    throw "Expected the Ready event to resolve from the discovered ANM2."
}

$hotpath = Invoke-Fixture "generic-validator-hotpath"
if ($hotpath.ExitCode -ne 0) {
    throw "Expected conservative hot-path warnings, not a hard failure."
}
foreach ($expected in @(
    "Asset reload in high-frequency handler",
    "Isaac.GetPlayer(0)",
    "ANM2 event reference was not resolved: MissingEvent"
)) {
    if ($hotpath.Text -notmatch [regex]::Escape($expected)) {
        throw "Expected warning was not reported: $expected"
    }
}

Write-Output "Generic validator resource-root, hot-path, co-op, and ANM2-event tests passed."
