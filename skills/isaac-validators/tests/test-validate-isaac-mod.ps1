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

$typoRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("isaac-validator-xml-filename-" + [guid]::NewGuid().ToString("N"))
try {
    $contentRoot = Join-Path $typoRoot "content"
    New-Item -ItemType Directory -Path $contentRoot -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $contentRoot "costymes2.xml") -Encoding UTF8 -Value '<costumes anm2root="gfx/characters/" />'

    $typoOutput = & $validator -Root $typoRoot 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) {
        throw "Expected a near-native XML filename to remain a warning, not a hard failure.`n$typoOutput"
    }
    if ($typoOutput -notmatch '\[XML_FILENAME\].*costymes2\.xml.*costumes2\.xml') {
        throw "Expected a targeted XML_FILENAME warning for costymes2.xml.`n$typoOutput"
    }
} finally {
    if (Test-Path -LiteralPath $typoRoot) {
        Remove-Item -LiteralPath $typoRoot -Recurse -Force
    }
}

Write-Output "Generic validator module callback and XML filename tests passed."
