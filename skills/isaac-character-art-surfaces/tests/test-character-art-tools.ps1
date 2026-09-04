$ErrorActionPreference = "Stop"

$skillRoot = Split-Path -Parent $PSScriptRoot
$inspect = Join-Path $skillRoot "scripts\inspect-png-surface.ps1"
$validate = Join-Path $skillRoot "scripts\validate-owned-crops.ps1"

if (-not (Test-Path -LiteralPath $inspect)) {
    throw "Missing inspect-png-surface.ps1"
}
if (-not (Test-Path -LiteralPath $validate)) {
    throw "Missing validate-owned-crops.ps1"
}

Add-Type -AssemblyName System.Drawing.Common
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("isaac-character-art-tools-" + [Guid]::NewGuid().ToString("N"))
[System.IO.Directory]::CreateDirectory($tempRoot) | Out-Null

function New-TransparentBitmap([int]$width, [int]$height) {
    return [System.Drawing.Bitmap]::new($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
}

function Save-Png([System.Drawing.Bitmap]$bitmap, [string]$path) {
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
}

try {
    $samplePath = Join-Path $tempRoot "sample.png"
    $sample = New-TransparentBitmap 4 3
    $sample.SetPixel(1, 1, [System.Drawing.Color]::FromArgb(255, 255, 0, 0))
    $sample.SetPixel(2, 1, [System.Drawing.Color]::FromArgb(128, 0, 0, 255))
    Save-Png $sample $samplePath

    $inspection = (& $inspect -Path $samplePath -Json) | ConvertFrom-Json
    if ($inspection.width -ne 4 -or $inspection.height -ne 3) {
        throw "PNG dimensions were not measured correctly."
    }
    if ($inspection.alphaHistogram.'0' -ne 10 -or $inspection.alphaHistogram.'128' -ne 1 -or $inspection.alphaHistogram.'255' -ne 1) {
        throw "Alpha histogram was not measured correctly."
    }
    if ($inspection.visibleBoundingBox.x -ne 1 -or $inspection.visibleBoundingBox.y -ne 1 -or $inspection.visibleBoundingBox.width -ne 2 -or $inspection.visibleBoundingBox.height -ne 1) {
        throw "Visible bounding box was not measured correctly."
    }
    if ($inspection.semiTransparentPixelCount -ne 1 -or $inspection.connectedAlphaIslands -ne 1) {
        throw "Semi-transparent pixels or connected islands were not measured correctly."
    }
    if (@($inspection.visibleRgbPalette).Count -ne 2 -or @($inspection.visibleRgbaPalette).Count -ne 2) {
        throw "Visible palettes were not measured correctly."
    }

    $sourcePath = Join-Path $tempRoot "source.png"
    $recolorPath = Join-Path $tempRoot "recolor.png"
    $fullSkinPath = Join-Path $tempRoot "full-skin.png"
    $outsidePath = Join-Path $tempRoot "outside.png"
    $maskPath = Join-Path $tempRoot "mask.png"
    $manifestPath = Join-Path $tempRoot "manifest.json"

    $source = New-TransparentBitmap 4 4
    $source.SetPixel(1, 1, [System.Drawing.Color]::FromArgb(255, 255, 0, 0))
    Save-Png $source $sourcePath

    $recolor = New-TransparentBitmap 4 4
    $recolor.SetPixel(1, 1, [System.Drawing.Color]::FromArgb(255, 0, 255, 0))
    Save-Png $recolor $recolorPath

    $fullSkin = New-TransparentBitmap 4 4
    $fullSkin.SetPixel(1, 1, [System.Drawing.Color]::FromArgb(255, 0, 255, 0))
    $fullSkin.SetPixel(2, 1, [System.Drawing.Color]::FromArgb(255, 0, 255, 0))
    Save-Png $fullSkin $fullSkinPath

    $outside = New-TransparentBitmap 4 4
    $outside.SetPixel(1, 1, [System.Drawing.Color]::FromArgb(255, 0, 255, 0))
    $outside.SetPixel(3, 3, [System.Drawing.Color]::FromArgb(255, 0, 255, 0))
    Save-Png $outside $outsidePath

    $mask = New-TransparentBitmap 4 4
    $mask.SetPixel(1, 1, [System.Drawing.Color]::White)
    $mask.SetPixel(2, 1, [System.Drawing.Color]::White)
    Save-Png $mask $maskPath

    @{
        crops = @(
            @{ xCrop = 0; yCrop = 0; width = 3; height = 3; visible = $true }
        )
    } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding utf8NoBOM

    $pureRecolor = (& $validate -Mode pure-recolor -Source $sourcePath -Output $recolorPath -Manifest $manifestPath -ApprovedMask $maskPath -Json) | ConvertFrom-Json
    if (-not $pureRecolor.pass -or $pureRecolor.changedPixels -ne 1 -or $pureRecolor.alphaAdded -ne 0) {
        throw "A legal pure recolor should pass without Alpha changes."
    }

    $wrongPureRecolor = (& $validate -Mode pure-recolor -Source $sourcePath -Output $fullSkinPath -Manifest $manifestPath -ApprovedMask $maskPath -Json) | ConvertFrom-Json
    if ($wrongPureRecolor.pass -or $wrongPureRecolor.alphaAdded -ne 1) {
        throw "Pure recolor must reject source-Alpha changes."
    }

    $legalFullSkin = (& $validate -Mode original-full-skin -Source $sourcePath -Output $fullSkinPath -Manifest $manifestPath -ApprovedMask $maskPath -Json) | ConvertFrom-Json
    if (-not $legalFullSkin.pass -or $legalFullSkin.alphaAdded -ne 1) {
        throw "Original full skin must allow controlled Alpha changes inside the approved owning mask."
    }

    $illegalFullSkin = (& $validate -Mode original-full-skin -Source $sourcePath -Output $outsidePath -Manifest $manifestPath -ApprovedMask $maskPath -Json) | ConvertFrom-Json
    if ($illegalFullSkin.pass -or $illegalFullSkin.changedOutsideMask -lt 1 -or $illegalFullSkin.visibleOutsideCrop -lt 1) {
        throw "Changes outside the approved mask and crop ownership must fail."
    }

    Write-Output "Character-art PNG inspection and owned-crop tests passed."
}
finally {
    if ($tempRoot.StartsWith([System.IO.Path]::GetTempPath(), [System.StringComparison]::OrdinalIgnoreCase)) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
