param(
    [Parameter(Mandatory=$true)][string]$Lua,
    [Parameter(Mandatory=$true)][string]$Python
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
function Invoke-Checked([string]$Runner, [string[]]$Arguments) {
    & $Runner @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Check failed: $($Arguments[0])" }
}
Invoke-Checked $Lua @((Join-Path $repoRoot 'skills\isaac-repentogon-compat\tests\test-version-gate.lua'))
Invoke-Checked $Python @('-B', '-X', 'utf8', (Join-Path $repoRoot 'skills\isaac-repentogon-compat\tests\test_surface_inventory.py'))
Invoke-Checked $Lua @((Join-Path $repoRoot 'skills\isaac-repentogon-ui\tests\test-developer-panel.lua'))
Invoke-Checked $Python @('-B', '-X', 'utf8', (Join-Path $PSScriptRoot 'check-repentogon-examples.py'), '--lua', $Lua)
Write-Output 'REPENTOGON offline checks passed. Native game behavior remains unverified.'

