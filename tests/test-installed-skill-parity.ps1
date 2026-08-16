param(
    [string]$SourceSkillRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "skills"),
    [string]$InstalledSkillRoot = (Join-Path $HOME ".codex\skills")
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]

foreach ($sourceDirectory in Get-ChildItem -LiteralPath $SourceSkillRoot -Directory | Sort-Object Name) {
    $installedDirectory = Join-Path $InstalledSkillRoot $sourceDirectory.Name
    if (-not (Test-Path -LiteralPath $installedDirectory -PathType Container)) {
        $failures.Add("Installed skill is missing: $($sourceDirectory.Name)") | Out-Null
        continue
    }

    $sourceFiles = @{}
    foreach ($file in Get-ChildItem -LiteralPath $sourceDirectory.FullName -Recurse -File) {
        $relative = $file.FullName.Substring($sourceDirectory.FullName.Length).TrimStart('\')
        $sourceFiles[$relative] = $file
        $installedFile = Join-Path $installedDirectory $relative
        if (-not (Test-Path -LiteralPath $installedFile -PathType Leaf)) {
            $failures.Add("Installed file is missing: $($sourceDirectory.Name)/$relative") | Out-Null
            continue
        }
        $sourceHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        $installedHash = (Get-FileHash -LiteralPath $installedFile -Algorithm SHA256).Hash
        if ($sourceHash -ne $installedHash) {
            $failures.Add("Installed file differs: $($sourceDirectory.Name)/$relative") | Out-Null
        }
    }

    foreach ($file in Get-ChildItem -LiteralPath $installedDirectory -Recurse -File) {
        $relative = $file.FullName.Substring($installedDirectory.Length).TrimStart('\')
        if (-not $sourceFiles.ContainsKey($relative)) {
            $failures.Add("Installed skill has stale extra file: $($sourceDirectory.Name)/$relative") | Out-Null
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Output "Installed skill parity failed with $($failures.Count) issue(s):"
    $failures | ForEach-Object { Write-Output "FAIL $_" }
    exit 1
}

Write-Output "Installed skill parity passed for $(@(Get-ChildItem -LiteralPath $SourceSkillRoot -Directory).Count) skill(s)."
