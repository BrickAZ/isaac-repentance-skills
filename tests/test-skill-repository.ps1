param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$Python,
    [string]$QuickValidate,
    [switch]$SkipQuickValidate
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure([string]$message) {
    $failures.Add($message) | Out-Null
}

function Resolve-RepoRelativePath([string]$baseDirectory, [string]$relativePath) {
    $normalized = $relativePath -replace '/', '\'
    return [System.IO.Path]::GetFullPath((Join-Path $baseDirectory $normalized))
}

function Test-PythonRunner([string]$candidate) {
    if ([string]::IsNullOrWhiteSpace($candidate) -or -not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        return $false
    }

    try {
        & $candidate --version *> $null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Resolve-PythonRunner {
    foreach ($commandName in @('python3', 'python')) {
        $command = Get-Command $commandName -ErrorAction SilentlyContinue
        if ($command -and (Test-PythonRunner $command.Source)) {
            return $command.Source
        }
    }

    $runtimeRoot = Join-Path $HOME '.cache\codex-runtimes'
    if (Test-Path -LiteralPath $runtimeRoot -PathType Container) {
        foreach ($candidate in Get-ChildItem -LiteralPath $runtimeRoot -Recurse -Filter python.exe -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match '[\\/]dependencies[\\/]python[\\/]python\.exe$' } |
            Sort-Object LastWriteTime -Descending) {
            if (Test-PythonRunner $candidate.FullName) {
                return $candidate.FullName
            }
        }
    }

    return $null
}

$skillsRoot = Join-Path $RepoRoot "skills"
$skillDirectories = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)
$skillNames = @($skillDirectories | Select-Object -ExpandProperty Name)

if ($skillDirectories.Count -eq 0) {
    Add-Failure "No skills were found under $skillsRoot"
}

$canonicalTbdLines = @(
    'Whenever an active `TBD` affects this turn''s recommendation, implementation, test plan, or completion claim',
    'In every response that relies on one or more active `TBD`s',
    'Give optional alternatives only as suggestions.',
    'If safe discovery or validation can continue',
    'Do not create artificial `TBD`s'
)

foreach ($directory in $skillDirectories) {
    $skillFile = Join-Path $directory.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
        Add-Failure "Missing SKILL.md: $($directory.Name)"
        continue
    }

    $text = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
    foreach ($required in $canonicalTbdLines) {
        if (-not $text.Contains($required)) {
            Add-Failure "Non-canonical TBD contract in $skillFile; missing: $required"
        }
    }
    if (-not $text.Contains('tbd-disclosure.md')) {
        Add-Failure "TBD contract does not link the canonical disclosure reference: $skillFile"
    }

    $lines = Get-Content -LiteralPath $skillFile -Encoding UTF8
    for ($index = 0; $index -lt $lines.Count; $index++) {
        $line = $lines[$index]
        if ($line -match '(?<![A-Za-z])eferences/[A-Za-z0-9._/-]+\.md') {
            Add-Failure "Malformed references path at ${skillFile}:$($index + 1): $($matches[0])"
        }

        foreach ($match in [regex]::Matches($line, '(?<![A-Za-z])(?:\.\./[^\s]+/)?references/[A-Za-z0-9._/-]+\.md')) {
            $target = Resolve-RepoRelativePath $directory.FullName $match.Value
            if (-not (Test-Path -LiteralPath $target)) {
                Add-Failure "Missing reference target at ${skillFile}:$($index + 1): $($match.Value)"
            }
        }
    }

    $evalFile = Join-Path $directory.FullName "evals\evals.json"
    if (-not (Test-Path -LiteralPath $evalFile)) {
        Add-Failure "Missing evals.json: $($directory.Name)"
        continue
    }

    $evalDocument = Get-Content -LiteralPath $evalFile -Raw -Encoding UTF8 | ConvertFrom-Json
    if ([string]$evalDocument.skill_name -ne $directory.Name) {
        Add-Failure "Eval skill_name does not match directory: $($directory.Name)"
    }
    if (@($evalDocument.evals).Count -lt 2) {
        Add-Failure "Skill needs at least two eval cases: $($directory.Name)"
    }
    $seenEvalIds = @{}
    foreach ($evalCase in @($evalDocument.evals)) {
        if ($null -eq $evalCase.id -or $seenEvalIds.ContainsKey([string]$evalCase.id)) {
            Add-Failure "Eval id is missing or duplicated in $($directory.Name): $($evalCase.id)"
        } else {
            $seenEvalIds[[string]$evalCase.id] = $true
        }
        if ([string]::IsNullOrWhiteSpace([string]$evalCase.prompt) -or [string]::IsNullOrWhiteSpace([string]$evalCase.expected_output)) {
            Add-Failure "Eval $($evalCase.id) in $($directory.Name) needs prompt and expected_output"
        }
        if (@($evalCase.files).Count -eq 0) {
            Add-Failure "Eval $($evalCase.id) in $($directory.Name) has no real skill context file"
        }
        foreach ($path in @($evalCase.files)) {
            if ([string]$path -notmatch '^skills/') {
                Add-Failure "Eval $($evalCase.id) in $($directory.Name) has non-skill context path: $path"
                continue
            }
            $target = Resolve-RepoRelativePath $RepoRoot ([string]$path)
            if (-not (Test-Path -LiteralPath $target)) {
                Add-Failure "Eval $($evalCase.id) in $($directory.Name) references missing context file: $path"
            }
        }
        foreach ($fixturePath in @($evalCase.fixture_files)) {
            if ([string]$fixturePath -match '^(?:[A-Za-z]:[\\/]|/|file:)') {
                Add-Failure "Eval $($evalCase.id) in $($directory.Name) leaks an absolute fixture path: $fixturePath"
            }
        }
    }
}

$routerPath = Join-Path $skillsRoot "isaac-repentance-router\SKILL.md"
$routerText = Get-Content -LiteralPath $routerPath -Raw -Encoding UTF8
$routerPrimaryCounts = @{}
foreach ($line in Get-Content -LiteralPath $routerPath -Encoding UTF8) {
    if ($line -match '^\|.*\|\s*`(isaac-[a-z0-9-]+)`\s*\|\s*$') {
        $routedName = [string]$matches[1]
        if (-not $routerPrimaryCounts.ContainsKey($routedName)) {
            $routerPrimaryCounts[$routedName] = 0
        }
        $routerPrimaryCounts[$routedName]++
    }
}
foreach ($name in $skillNames) {
    if ($name -eq "isaac-repentance-router") { continue }
    if (-not $routerText.Contains($name)) {
        Add-Failure "Generic router does not name shipped skill: $name"
    }
    $primaryCount = if ($routerPrimaryCounts.ContainsKey($name)) { [int]$routerPrimaryCounts[$name] } else { 0 }
    if ($primaryCount -ne 1) {
        Add-Failure "Generic router must contain exactly one primary-matrix row for ${name}; found $primaryCount"
    }
}

$readmePath = Join-Path $RepoRoot 'README.md'
$readmeSkillCounts = @{}
foreach ($line in Get-Content -LiteralPath $readmePath -Encoding UTF8) {
    if ($line -match '^\|\s*`(isaac-[a-z0-9-]+)`\s*\|') {
        $documentedName = [string]$matches[1]
        if (-not $readmeSkillCounts.ContainsKey($documentedName)) {
            $readmeSkillCounts[$documentedName] = 0
        }
        $readmeSkillCounts[$documentedName]++
    }
}
foreach ($name in $skillNames) {
    $documentedCount = if ($readmeSkillCounts.ContainsKey($name)) { [int]$readmeSkillCounts[$name] } else { 0 }
    if ($documentedCount -ne 1) {
        Add-Failure "README Skill Map must contain exactly one row for ${name}; found $documentedCount"
    }
}

$evidencePath = Join-Path $RepoRoot "docs\evidence-matrix.md"
$evidenceText = Get-Content -LiteralPath $evidencePath -Raw -Encoding UTF8
foreach ($name in $skillNames) {
    if (-not $evidenceText.Contains($name)) {
        Add-Failure "Evidence matrix does not classify shipped skill: $name"
    }
}

foreach ($name in @('isaac-eid-compat', 'isaac-mcm-compat', 'isaac-stageapi-compat', 'isaac-repentogon-compat')) {
    $references = @(Get-ChildItem -LiteralPath (Join-Path $skillsRoot "$name\references") -File -ErrorAction SilentlyContinue)
    if ($references.Count -eq 0) {
        Add-Failure "Third-party compatibility skill has no bundled offline reference: $name"
    }
}

if (-not $SkipQuickValidate) {
    if (-not $Python) {
        $Python = Resolve-PythonRunner
    }
    if (-not $QuickValidate) {
        $QuickValidate = Join-Path $HOME ".codex\skills\.system\skill-creator\scripts\quick_validate.py"
    }
    if (-not (Test-PythonRunner $Python)) {
        Add-Failure "A working Python runner was not found; pass -Python explicitly"
    } elseif (-not (Test-Path -LiteralPath $QuickValidate)) {
        Add-Failure "quick_validate.py was not found; pass -QuickValidate explicitly"
    } else {
        $previousUtf8 = $env:PYTHONUTF8
        $env:PYTHONUTF8 = '1'
        try {
            foreach ($directory in $skillDirectories) {
                & $Python $QuickValidate $directory.FullName | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    Add-Failure "quick_validate failed: $($directory.Name)"
                }
            }
        } finally {
            $env:PYTHONUTF8 = $previousUtf8
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Output "Skill repository audit failed with $($failures.Count) issue(s):"
    $failures | ForEach-Object { Write-Output "FAIL $_" }
    exit 1
}

Write-Output "Skill repository audit passed for $($skillDirectories.Count) skill(s)."
