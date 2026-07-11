$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $scriptRoot "scripts\validate-isaac-mod.ps1"
$validRoot = Join-Path $scriptRoot "fixtures\generic-validator-valid"
$invalidRoot = Join-Path $scriptRoot "fixtures\generic-validator-invalid"

& $validator -Root $validRoot -ModObjectName MyMod
if ($LASTEXITCODE -ne 0) {
    throw "Expected the valid module callback fixture to pass."
}

& $validator -Root $invalidRoot -ModObjectName MyMod
if ($LASTEXITCODE -eq 0) {
    throw "Expected the missing module callback handler fixture to fail."
}

Write-Output "Generic validator module callback tests passed."
