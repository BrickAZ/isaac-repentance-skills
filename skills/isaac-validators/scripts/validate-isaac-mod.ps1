[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Root,
    [string]$ModObjectName = "",
    [string[]]$LuaDirectories = @("scripts"),
    [string]$SkillRoot = ""
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path -LiteralPath $Root).Path
$script:warnings = @()
$script:failures = @()

function Add-Warning([string]$message) { $script:warnings += $message }
function Add-Failure([string]$message) { $script:failures += $message }

function Test-Xml([string]$path) {
    try {
        [xml](Get-Content -Raw -Encoding UTF8 -LiteralPath $path)
    } catch {
        Add-Failure "Invalid XML: $path :: $($_.Exception.Message)"
        return $null
    }
}

function Test-XmlShape([string]$path, [xml]$doc) {
    foreach ($attributeName in @("id", "name")) {
        $seen = @{}
        foreach ($node in $doc.SelectNodes("//*[@$attributeName]")) {
            $value = $node.GetAttribute($attributeName)
            if ([string]::IsNullOrWhiteSpace($value)) { continue }
            $key = "$($node.Name):$value"
            if ($seen.ContainsKey($key)) {
                Add-Warning "Duplicate ${attributeName} in ${path}: $key"
            } else {
                $seen[$key] = $true
            }
        }
    }
}

function Resolve-AssetCandidates([string]$value, [string]$basePath) {
    $relative = $value -replace '/', '\\'
    $candidates = New-Object System.Collections.Generic.List[string]
    $candidates.Add((Join-Path $Root $relative)) | Out-Null
    $candidates.Add((Join-Path $Root (Join-Path 'resources' $relative))) | Out-Null
    if ($basePath) {
        $base = $basePath -replace '/', '\\'
        $candidates.Add((Join-Path $Root (Join-Path 'resources' (Join-Path $base $relative)))) | Out-Null
    }
    if ($relative -match '(?i)\.png$') {
        $candidates.Add((Join-Path $Root (Join-Path 'resources\gfx\Items\Collectibles' $relative))) | Out-Null
        $candidates.Add((Join-Path $Root (Join-Path 'resources\gfx\Items\Trinkets' $relative))) | Out-Null
        $candidates.Add((Join-Path $Root (Join-Path 'resources\gfx\PocketItems' $relative))) | Out-Null
    }
    if ($relative -match '(?i)\.anm2$') {
        $candidates.Add((Join-Path $Root (Join-Path 'resources\gfx' $relative))) | Out-Null
        $candidates.Add((Join-Path $Root (Join-Path 'resources\gfx\characters' $relative))) | Out-Null
    }
    if ($relative -match '(?i)\.(ogg|mp3|wav)$') {
        $candidates.Add((Join-Path $Root (Join-Path 'resources\music' $relative))) | Out-Null
        $candidates.Add((Join-Path $Root (Join-Path 'resources\sfx' $relative))) | Out-Null
    }
    return $candidates | Select-Object -Unique
}

function Test-XmlAssets([string]$path, [xml]$doc) {
    $assetBase = ""
    if ($doc.DocumentElement) {
        foreach ($attributeName in @('gfxroot', 'anm2root', 'root')) {
            if ($doc.DocumentElement.HasAttribute($attributeName)) {
                $assetBase = $doc.DocumentElement.GetAttribute($attributeName)
                break
            }
        }
    }

    foreach ($node in $doc.SelectNodes("//*[@*]")) {
        foreach ($attribute in $node.Attributes) {
            $value = [string]$attribute.Value
            if ($value -notmatch '(?i)\.(anm2|png|wav|ogg|mp3|fs|fsh)$') { continue }
            if ($value -match '^(?:[A-Za-z]:[\\/]|/)') {
                Add-Warning "Absolute asset path in $path [$($attribute.Name)=$value]"
                continue
            }

            if (-not (Resolve-AssetCandidates $value $assetBase | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1)) {
                Add-Warning "Asset path was not resolved: $path [$($attribute.Name)=$value]"
            }
        }
    }
}

function Test-CallbackContracts {
    $luaFiles = New-Object System.Collections.Generic.List[System.IO.FileInfo]
    $mainLua = Join-Path $Root "main.lua"
    if (Test-Path -LiteralPath $mainLua) {
        $luaFiles.Add((Get-Item -LiteralPath $mainLua)) | Out-Null
    }
    foreach ($directory in $LuaDirectories) {
        if ([string]::IsNullOrWhiteSpace($directory)) { continue }
        $sourceDir = Join-Path $Root $directory
        if (-not (Test-Path -LiteralPath $sourceDir)) { continue }
        foreach ($file in Get-ChildItem -LiteralPath $sourceDir -Recurse -Filter "*.lua") {
            if ($file.FullName -notmatch '[\\/]tests[\\/]') {
                $luaFiles.Add($file) | Out-Null
            }
        }
    }
    $handlers = @{}
    $registrations = @{}

    foreach ($file in ($luaFiles | Sort-Object FullName -Unique)) {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
        foreach ($match in [regex]::Matches($source, 'function\s+([A-Za-z_][A-Za-z0-9_]*)[:.]([A-Za-z_][A-Za-z0-9_]*)\s*\(')) {
            $handlers["$($match.Groups[1].Value).$($match.Groups[2].Value)"] = $file.FullName
        }
    }

    $pattern = '(?<mod>[A-Za-z_][A-Za-z0-9_]*)\s*:\s*AddCallback\s*\(\s*ModCallbacks\.(?<callback>MC_[A-Z_]+)\s*,\s*(?<owner>[A-Za-z_][A-Za-z0-9_]*)\.(?<handler>[A-Za-z_][A-Za-z0-9_]*)(?:\s*,\s*(?<filter>[^\)]+))?\s*\)'
    foreach ($file in ($luaFiles | Sort-Object FullName -Unique)) {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
        foreach ($match in [regex]::Matches($source, $pattern)) {
            $mod = $match.Groups['mod'].Value
            if ($ModObjectName -and $mod -ne $ModObjectName) { continue }
            $owner = $match.Groups['owner'].Value
            $handler = $match.Groups['handler'].Value
            $handlerKey = "$owner.$handler"
            $filter = ($match.Groups['filter'].Value -replace '\s+', ' ').Trim()
            if (-not $handlers.ContainsKey($handlerKey)) {
                Add-Failure "Callback $($match.Groups['callback'].Value) registers missing handler '$handlerKey' in $($file.FullName)"
            }
            $key = "${mod}:$($match.Groups['callback'].Value):${handlerKey}:$filter"
            if ($registrations.ContainsKey($key)) {
                Add-Warning "Duplicate callback registration: $key in $($file.FullName) and $($registrations[$key])"
            } else {
                $registrations[$key] = $file.FullName
            }
        }
    }
}

function Test-SkillPackage([string]$path) {
    if (-not $path) { return }
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Warning "Skill root does not exist: $path"
        return
    }
    foreach ($file in Get-ChildItem -LiteralPath $path -Recurse -File) {
        if ($file.Extension -notin @('.md', '.json')) { continue }
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
        if ($source -match '(?i)(?:[A-Za-z]:[\\/]|file://)') {
            Add-Failure "Skill contains an absolute local path: $($file.FullName)"
        }
        if ($file.Name -eq 'evals.json') {
            try { $null = $source | ConvertFrom-Json }
            catch { Add-Failure "Invalid evals.json: $($file.FullName) :: $($_.Exception.Message)" }
        }
    }

    foreach ($file in Get-ChildItem -LiteralPath $path -Recurse -Filter '*.md') {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
        $pattern = '(?:`|\]\()(?<reference>(?:\.\.[\\/]|references[\\/])[^`)\s]+?\.md)(?:`|\))'
        foreach ($match in [regex]::Matches($source, $pattern)) {
            $reference = $match.Groups['reference'].Value
            $candidate = Join-Path $file.DirectoryName ($reference -replace '/', '\\')
            if (-not (Test-Path -LiteralPath $candidate)) {
                Add-Failure "Skill reference does not exist: $reference in $($file.FullName)"
            }
        }
    }
}

Write-Output "Validating Isaac mod at $Root"
$contentDir = Join-Path $Root "content"
if (Test-Path -LiteralPath $contentDir) {
    foreach ($file in Get-ChildItem -LiteralPath $contentDir -Filter "*.xml") {
        $doc = Test-Xml $file.FullName
        if (-not $doc) { continue }
        Test-XmlShape $file.FullName $doc
        Test-XmlAssets $file.FullName $doc
    }
} else {
    Add-Warning "No content directory found: $contentDir"
}

Test-CallbackContracts
Test-SkillPackage $SkillRoot

if ($script:warnings.Count -gt 0) {
    Write-Output ""
    Write-Output "Warnings:"
    foreach ($warning in $script:warnings) { Write-Output "WARN $warning" }
}
if ($script:failures.Count -gt 0) {
    Write-Output ""
    Write-Output "Failures:"
    foreach ($failure in $script:failures) { Write-Output "FAIL $failure" }
    exit 1
}

Write-Output ""
Write-Output "Generic static validation completed with $($script:warnings.Count) warning(s) and 0 failure(s)."
exit 0
