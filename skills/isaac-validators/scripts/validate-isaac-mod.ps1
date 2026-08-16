[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Root,
    [string]$ModObjectName = "",
    [string[]]$LuaDirectories = @("scripts"),
    [string[]]$ResourceDirectories = @(),
    [string]$SkillRoot = "",
    [switch]$CheckPngTransparency
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path -LiteralPath $Root).Path
$script:warnings = @()
$script:failures = @()
$script:warningCategoryCounts = @{}
$script:failureCategoryCounts = @{}
$script:nativeFallbackCounts = @{}
$script:unresolvedAssetGroups = @{}

function Add-Warning([string]$message, [string]$code = "GENERAL") {
    $script:warnings += "[$code] $message"
    if (-not $script:warningCategoryCounts.ContainsKey($code)) { $script:warningCategoryCounts[$code] = 0 }
    $script:warningCategoryCounts[$code]++
}
function Add-Failure([string]$message, [string]$code = "GENERAL") {
    $script:failures += "[$code] $message"
    if (-not $script:failureCategoryCounts.ContainsKey($code)) { $script:failureCategoryCounts[$code] = 0 }
    $script:failureCategoryCounts[$code]++
}

$script:resourceRoots = New-Object System.Collections.Generic.List[string]

function Initialize-ResourceRoots {
    $candidates = New-Object System.Collections.Generic.List[string]
    if ($ResourceDirectories.Count -gt 0) {
        foreach ($directory in $ResourceDirectories) {
            if ([string]::IsNullOrWhiteSpace($directory)) { continue }
            $candidate = if ([System.IO.Path]::IsPathRooted($directory)) {
                $directory
            } else {
                Join-Path $Root $directory
            }
            $candidates.Add($candidate) | Out-Null
        }
    } else {
        foreach ($directory in Get-ChildItem -LiteralPath $Root -Directory) {
            if ($directory.Name -match '^resources(?:-.+)?$') {
                $candidates.Add($directory.FullName) | Out-Null
            }
        }
    }

    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            $script:resourceRoots.Add((Resolve-Path -LiteralPath $candidate).Path) | Out-Null
        } else {
            Add-Warning "Resource root does not exist: $candidate" "RESOURCE_ROOT"
        }
    }
}

function Test-Xml([string]$path) {
    try {
        [xml](Get-Content -Raw -Encoding UTF8 -LiteralPath $path)
    } catch {
        $exception = $_.Exception
        while ($exception.InnerException -and -not ($exception -is [System.Xml.XmlException])) {
            $exception = $exception.InnerException
        }
        $line = 0
        $position = 0
        if ($exception -is [System.Xml.XmlException]) {
            $line = $exception.LineNumber
            $position = $exception.LinePosition
        }
        $message = (($exception.Message -split "[`r`n]")[0] -replace '\s+', ' ').Trim()
        if ($message.Length -gt 240) { $message = $message.Substring(0, 240) + '...' }
        Add-Failure "Invalid XML: $path (line $line, position $position): $message" "XML_INVALID"
        return $null
    }
}

function Test-XmlShape([string]$path, [xml]$doc) {
    foreach ($attributeName in @("id", "name")) {
        # costumes2.xml may intentionally repeat an id to compose multiple visual layers.
        if ($attributeName -eq "id" -and [System.IO.Path]::GetFileName($path) -ieq "costumes2.xml") { continue }
        $seen = @{}
        foreach ($node in $doc.SelectNodes("//*[@$attributeName]")) {
            $value = $node.GetAttribute($attributeName)
            if ([string]::IsNullOrWhiteSpace($value)) { continue }
            $qualifiers = New-Object System.Collections.Generic.List[string]
            foreach ($qualifierName in @("id", "type", "variant", "subtype", "skinColor", "player", "character", "bSkinParent")) {
                if ($qualifierName -eq $attributeName -or -not $node.HasAttribute($qualifierName)) { continue }
                $qualifierValue = $node.GetAttribute($qualifierName)
                if (-not [string]::IsNullOrWhiteSpace($qualifierValue)) {
                    $qualifiers.Add("$qualifierName=$qualifierValue") | Out-Null
                }
            }
            $displayKey = "$($node.Name):$value"
            if ($qualifiers.Count -gt 0) {
                $displayKey += ":" + ($qualifiers -join ",")
            }
            $parentIdentity = if ($node.ParentNode) {
                [System.Runtime.CompilerServices.RuntimeHelpers]::GetHashCode($node.ParentNode)
            } else { 0 }
            $scopeKey = "${parentIdentity}:${displayKey}"
            if ($seen.ContainsKey($scopeKey)) {
                Add-Warning "Duplicate ${attributeName} in ${path}: $displayKey" "XML_DUPLICATE"
            } else {
                $seen[$scopeKey] = $true
            }
        }
    }
}

function Resolve-AssetCandidates([string]$value, [string]$basePath) {
    $relative = $value -replace '/', '\'
    $base = if ($basePath) { $basePath -replace '/', '\' } else { "" }
    $candidates = New-Object System.Collections.Generic.List[string]
    $candidates.Add((Join-Path $Root $relative)) | Out-Null

    foreach ($resourceRoot in $script:resourceRoots) {
        $candidates.Add((Join-Path $resourceRoot $relative)) | Out-Null
        if ($base) {
            $candidates.Add((Join-Path $resourceRoot (Join-Path $base $relative))) | Out-Null
        }
        if ($relative -match '(?i)\.png$') {
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'gfx\Items\Collectibles' $relative))) | Out-Null
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'gfx\Items\Trinkets' $relative))) | Out-Null
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'gfx\PocketItems' $relative))) | Out-Null
        }
        if ($relative -match '(?i)\.anm2$') {
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'gfx' $relative))) | Out-Null
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'gfx\characters' $relative))) | Out-Null
        }
        if ($relative -match '(?i)\.(ogg|mp3|wav)$') {
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'music' $relative))) | Out-Null
            $candidates.Add((Join-Path $resourceRoot (Join-Path 'sfx' $relative))) | Out-Null
        }
    }
    return $candidates | Select-Object -Unique
}
function Test-LowLuminanceMatte([System.Drawing.Bitmap]$bitmap, [string]$context, [string]$path) {
    $darkCount = 0
    $minX = $bitmap.Width
    $minY = $bitmap.Height
    $maxX = -1
    $maxY = -1

    for ($x = 0; $x -lt $bitmap.Width; $x++) {
        for ($y = 0; $y -lt $bitmap.Height; $y++) {
            $pixel = $bitmap.GetPixel($x, $y)
            if ($pixel.A -lt 240) { continue }
            $luminance = (0.2126 * $pixel.R) + (0.7152 * $pixel.G) + (0.0722 * $pixel.B)
            if ($luminance -gt 105) { continue }

            $darkCount++
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }

    if ($darkCount -eq 0) { return }
    $regionWidth = $maxX - $minX + 1
    $regionHeight = $maxY - $minY + 1
    $regionArea = $regionWidth * $regionHeight
    $density = $darkCount / $regionArea
    $minimumWidth = [Math]::Max(8, [Math]::Ceiling($bitmap.Width * 0.40))
    $minimumHeight = [Math]::Max(8, [Math]::Ceiling($bitmap.Height * 0.40))
    $minimumCoverage = [Math]::Ceiling(($bitmap.Width * $bitmap.Height) * 0.12)

    if ($regionWidth -ge $minimumWidth -and $regionHeight -ge $minimumHeight -and $density -ge 0.58 -and $darkCount -ge $minimumCoverage) {
        Add-Warning "Collectible gfx has a large dense low-luminance region that may be an internal matte; inspect the subject mask and three backgrounds: $context -> $path" "ART_ALPHA"
    }
}
function Test-CollectiblePngTransparency([string]$path, [string]$context) {
    if (-not $CheckPngTransparency) { return }

    try {
        Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue
        $bitmap = [System.Drawing.Bitmap]::new($path)
        try {
            if (($bitmap.PixelFormat -band [System.Drawing.Imaging.PixelFormat]::Alpha) -eq 0) {
                Add-Warning "Collectible gfx has no alpha channel: $context -> $path" "ART_ALPHA"
                return
            }

            $corners = @(
                $bitmap.GetPixel(0, 0),
                $bitmap.GetPixel($bitmap.Width - 1, 0),
                $bitmap.GetPixel(0, $bitmap.Height - 1),
                $bitmap.GetPixel($bitmap.Width - 1, $bitmap.Height - 1)
            )
            $cornerArgb = @($corners | ForEach-Object { $_.ToArgb() })
            $opaqueUniformCorners = @($corners | Where-Object { $_.A -eq 255 }).Count -eq 4 -and @($cornerArgb | Select-Object -Unique).Count -eq 1
            if ($opaqueUniformCorners) {
                $corner = $corners[0]
                $samePixels = 0
                for ($x = 0; $x -lt $bitmap.Width; $x++) {
                    for ($y = 0; $y -lt $bitmap.Height; $y++) {
                        if ($bitmap.GetPixel($x, $y).ToArgb() -eq $corner.ToArgb()) { $samePixels++ }
                    }
                }
                if ($samePixels / ($bitmap.Width * $bitmap.Height) -ge 0.50) {
                    Add-Warning "Collectible gfx likely has an opaque rectangular background: $context -> $path" "ART_ALPHA"
                }
            }
            Test-LowLuminanceMatte $bitmap $context $path
        } finally {
            $bitmap.Dispose()
        }
    } catch {
        Add-Warning "PNG alpha check could not inspect ${path}: $($_.Exception.Message)" "ART_ALPHA"
    }
}
function Get-ResourceRelativePath([string]$path) {
    foreach ($resourceRoot in $script:resourceRoots) {
        if ($path.StartsWith($resourceRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $path.Substring($resourceRoot.Length + 1)
        }
    }
    return $null
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

    foreach ($node in $doc.SelectNodes("//*")) {
        foreach ($attribute in $node.Attributes) {
            $value = [string]$attribute.Value
            if ($value -notmatch '(?i)\.(anm2|png|wav|ogg|mp3|fs|fsh)$') { continue }
            if ($value -match '^(?:[A-Za-z]:[\\/]|/)') {
                Add-Warning "Absolute asset path in $path [$($attribute.Name)=$value]" "ASSET_ABSOLUTE"
                continue
            }

            $resolved = Resolve-AssetCandidates $value $assetBase | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
            if (-not $resolved) {
                $resourceRelativePath = Get-ResourceRelativePath $path
                if ($resourceRelativePath -in @("players.xml", "costumes2.xml")) {
                    if (-not $script:nativeFallbackCounts.ContainsKey($path)) {
                        $script:nativeFallbackCounts[$path] = 0
                    }
                    $script:nativeFallbackCounts[$path]++
                } else {
                    $groupKey = "$path|$($attribute.Name)"
                    if (-not $script:unresolvedAssetGroups.ContainsKey($groupKey)) {
                        $script:unresolvedAssetGroups[$groupKey] = [ordered]@{
                            Path = $path
                            Attribute = $attribute.Name
                            Count = 0
                            Samples = New-Object System.Collections.Generic.List[string]
                        }
                    }
                    $group = $script:unresolvedAssetGroups[$groupKey]
                    $group.Count++
                    if ($group.Samples.Count -lt 3 -and -not $group.Samples.Contains($value)) {
                        $group.Samples.Add($value) | Out-Null
                    }
                }
                continue
            }
            if ($CheckPngTransparency -and $attribute.LocalName -eq "gfx" -and $node.LocalName -in @("active", "passive", "familiar")) {
                Test-CollectiblePngTransparency $resolved "$path [$($node.LocalName) $($attribute.LocalName)=$value]"
            }
        }
    }
}

function Get-LuaFiles {
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
    return @($luaFiles | Sort-Object FullName -Unique)
}

function Test-CallbackContracts {
    $luaFiles = Get-LuaFiles
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
                Add-Failure "Callback $($match.Groups['callback'].Value) registers missing handler '$handlerKey' in $($file.FullName)" "CALLBACK_HANDLER"
            }
            $key = "${mod}:$($match.Groups['callback'].Value):${handlerKey}:$filter"
            if ($registrations.ContainsKey($key)) {
                Add-Warning "Duplicate callback registration: $key in $($file.FullName) and $($registrations[$key])" "CALLBACK_DUPLICATE"
            } else {
                $registrations[$key] = $file.FullName
            }
        }
    }
}

function Get-LuaFunctionBody([string]$source, [string]$handlerReference) {
    $normalized = $handlerReference -replace ':', '.'
    $parts = $normalized -split '\.'
    if ($parts.Count -eq 2) {
        $declaration = '(?m)^\s*(?:local\s+)?function\s+' + [regex]::Escape($parts[0]) + '[:.]' + [regex]::Escape($parts[1]) + '\s*\([^\r\n]*\)'
    } else {
        $declaration = '(?m)^\s*(?:local\s+)?function\s+' + [regex]::Escape($normalized) + '\s*\([^\r\n]*\)'
    }
    $match = [regex]::Match($source, $declaration)
    if (-not $match.Success) { return $null }

    $tail = $source.Substring($match.Index)
    $lines = [regex]::Split($tail, '\r?\n')
    $depth = 1
    $body = New-Object System.Collections.Generic.List[string]
    for ($index = 1; $index -lt $lines.Count; $index++) {
        $line = $lines[$index]
        $code = $line -replace '--.*$', ''
        $opens = ([regex]::Matches($code, '\bfunction\b')).Count
        $opens += ([regex]::Matches($code, '\bif\b[^\r\n]*\bthen\b')).Count
        $opens += ([regex]::Matches($code, '\bfor\b[^\r\n]*\bdo\b')).Count
        $opens += ([regex]::Matches($code, '\bwhile\b[^\r\n]*\bdo\b')).Count
        $opens += ([regex]::Matches($code, '\brepeat\b')).Count
        $closes = ([regex]::Matches($code, '\bend\b')).Count
        $closes += ([regex]::Matches($code, '\buntil\b')).Count
        $depth += $opens - $closes
        if ($depth -le 0) { break }
        $body.Add($line) | Out-Null
    }
    return $body -join "`n"
}

function Test-LuaVisualContracts {
    $declaredEvents = @{}
    foreach ($resourceRoot in $script:resourceRoots) {
        foreach ($file in Get-ChildItem -LiteralPath $resourceRoot -Recurse -Filter "*.anm2") {
            try {
                [xml]$doc = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
                foreach ($eventNode in $doc.SelectNodes("//Event[@Name]")) {
                    $name = $eventNode.GetAttribute("Name")
                    if (-not [string]::IsNullOrWhiteSpace($name)) {
                        $declaredEvents[$name] = $true
                    }
                }
            } catch {
                Add-Failure "Invalid ANM2 XML: $($file.FullName) :: $($_.Exception.Message)" "ANM2_INVALID"
            }
        }
    }

    $highCallbacks = 'MC_POST_RENDER|MC_POST_UPDATE|MC_POST_PLAYER_RENDER|MC_POST_PLAYER_UPDATE|MC_FAMILIAR_UPDATE'
    $registrationPattern = '(?<callback>' + $highCallbacks + ')\s*,\s*(?<handler>[A-Za-z_][A-Za-z0-9_]*(?:[.:][A-Za-z_][A-Za-z0-9_]*)?)'
    $assetReloadPattern = '(?::Load\s*\(|ReplaceSpritesheet\s*\(|LoadGraphics\s*\()'
    $eventPattern = '(?:IsEventTriggered|WasEventTriggered)\s*\(\s*["''](?<event>[^"'']+)["'']'
    $luaFiles = @(Get-LuaFiles)
    $sourceByPath = @{}
    foreach ($file in $luaFiles) {
        $sourceByPath[$file.FullName] = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    }

    foreach ($file in $luaFiles) {
        $source = $sourceByPath[$file.FullName]
        foreach ($registration in [regex]::Matches($source, $registrationPattern)) {
            $handlerReference = $registration.Groups['handler'].Value -replace ':', '.'
            $handlerBody = $null
            $handlerPath = $null
            foreach ($candidate in $luaFiles) {
                $candidateBody = Get-LuaFunctionBody $sourceByPath[$candidate.FullName] $handlerReference
                if ($null -ne $candidateBody) {
                    $handlerBody = $candidateBody
                    $handlerPath = $candidate.FullName
                    break
                }
            }
            if ($null -ne $handlerBody -and $handlerBody -match $assetReloadPattern) {
                Add-Warning "Asset reload in high-frequency handler $handlerReference ($($registration.Groups['callback'].Value)): $handlerPath" "LUA_HOTPATH"
            }
        }
        if ($source -match 'Isaac\.GetPlayer\s*\(\s*0\s*\)') {
            Add-Warning "Isaac.GetPlayer(0) may assume the first player is the owner; verify per-player/co-op behavior: $($file.FullName)" "COOP_OWNER"
        }
        foreach ($match in [regex]::Matches($source, $eventPattern)) {
            $eventName = $match.Groups['event'].Value
            if (-not $declaredEvents.ContainsKey($eventName)) {
                Add-Warning "ANM2 event reference was not resolved: $eventName in $($file.FullName). The Sprite may use a vanilla or optional ANM2; bind the target before treating this as a failure." "ANM2_EVENT"
            }
        }
    }
}

function Test-SkillPackage([string]$path) {
    if (-not $path) { return }
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Warning "Skill root does not exist: $path" "SKILL_PACKAGE"
        return
    }
    foreach ($file in Get-ChildItem -LiteralPath $path -Recurse -File) {
        if ($file.Extension -notin @('.md', '.json')) { continue }
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
        if ($source -match '(?i)(?:[A-Za-z]:[\\/]|file://)') {
            Add-Failure "Skill contains an absolute local path: $($file.FullName)" "SKILL_PACKAGE"
        }
        if ($file.Name -eq 'evals.json') {
            try { $null = $source | ConvertFrom-Json }
            catch { Add-Failure "Invalid evals.json: $($file.FullName) :: $($_.Exception.Message)" "SKILL_PACKAGE" }
        }
    }

    foreach ($file in Get-ChildItem -LiteralPath $path -Recurse -Filter '*.md') {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
        $pattern = '(?:`|\]\()(?<reference>(?:\.\.[\\/]|references[\\/])[^`)\s]+?\.md)(?:`|\))'
        foreach ($match in [regex]::Matches($source, $pattern)) {
            $reference = $match.Groups['reference'].Value
            $candidate = Join-Path $file.DirectoryName ($reference -replace '/', '\\')
            if (-not (Test-Path -LiteralPath $candidate)) {
                Add-Failure "Skill reference does not exist: $reference in $($file.FullName)" "SKILL_PACKAGE"
            }
        }
    }
}

Write-Output "Validating Isaac mod at $Root"
Initialize-ResourceRoots

$xmlFiles = New-Object System.Collections.Generic.List[System.IO.FileInfo]
$contentDir = Join-Path $Root "content"
if (Test-Path -LiteralPath $contentDir) {
    foreach ($file in Get-ChildItem -LiteralPath $contentDir -Recurse -Filter "*.xml") {
        $xmlFiles.Add($file) | Out-Null
    }
}
foreach ($resourceRoot in $script:resourceRoots) {
    foreach ($file in Get-ChildItem -LiteralPath $resourceRoot -Recurse -Filter "*.xml") {
        $xmlFiles.Add($file) | Out-Null
    }
}

if ($xmlFiles.Count -eq 0) {
    Add-Warning "No content or resource XML found under the discovered project roots." "XML_DISCOVERY"
}

foreach ($file in ($xmlFiles | Sort-Object FullName -Unique)) {
    $doc = Test-Xml $file.FullName
    if (-not $doc) { continue }
    Test-XmlShape $file.FullName $doc
    Test-XmlAssets $file.FullName $doc

    $resourceRelativePath = $null
    foreach ($resourceRoot in $script:resourceRoots) {
        if ($file.FullName.StartsWith($resourceRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
            $resourceRelativePath = $file.FullName.Substring($resourceRoot.Length + 1)
            break
        }
    }
    if ($resourceRelativePath -in @("players.xml", "costumes2.xml")) {
        Add-Warning "Broad exact-path resource override may be load-order sensitive: $($file.FullName)" "RESOURCE_OVERRIDE"
    }
}

foreach ($entry in $script:unresolvedAssetGroups.GetEnumerator() | Sort-Object Name) {
    $group = $entry.Value
    $sampleText = if ($group.Samples.Count -gt 0) { '; samples: ' + ($group.Samples -join ', ') } else { '' }
    Add-Warning "$($group.Count) asset reference(s) were not resolved in $($group.Path) for attribute '$($group.Attribute)'$sampleText" "ASSET_UNRESOLVED"
}
foreach ($entry in $script:nativeFallbackCounts.GetEnumerator() | Sort-Object Name) {
    Add-Warning "Native-table override has $($entry.Value) asset reference(s) unresolved inside this mod; they may rely on official game resources. Verify the target game build and in-game surface: $($entry.Key)" "ASSET_NATIVE_FALLBACK"
}

Test-CallbackContracts
Test-LuaVisualContracts
Test-SkillPackage $SkillRoot
if ($script:warnings.Count -gt 0) {
    Write-Output ""
    $categorySummary = @($script:warningCategoryCounts.GetEnumerator() | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join '; '
    Write-Output "Warning categories: $categorySummary"
    Write-Output "Warnings:"
    foreach ($warning in $script:warnings) { Write-Output "WARN $warning" }
}
if ($script:failures.Count -gt 0) {
    Write-Output ""
    $failureSummary = @($script:failureCategoryCounts.GetEnumerator() | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join '; '
    Write-Output "Failure categories: $failureSummary"
    Write-Output "Failures:"
    foreach ($failure in $script:failures) { Write-Output "FAIL $failure" }
    exit 1
}

Write-Output ""
Write-Output "Generic static validation completed with $($script:warnings.Count) warning(s) and 0 failure(s)."
exit 0
