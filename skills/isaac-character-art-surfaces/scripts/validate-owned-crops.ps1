param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("pure-recolor", "original-full-skin", "separate-decoration")]
    [string]$Mode,
    [Parameter(Mandatory = $true)]
    [string]$Source,
    [Parameter(Mandatory = $true)]
    [string]$Output,
    [Parameter(Mandatory = $true)]
    [string]$Manifest,
    [Parameter(Mandatory = $true)]
    [string]$ApprovedMask,
    [switch]$Json
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing.Common

function Get-Crops([object]$document) {
    if ($null -ne $document.PSObject.Properties["crops"]) {
        return @($document.crops)
    }
    return @($document)
}

function Test-InOwnedCrop([int]$x, [int]$y, [object[]]$crops) {
    foreach ($crop in $crops) {
        if ($crop.visible -eq $false) {
            continue
        }
        $cropX = [int]$crop.xCrop
        $cropY = [int]$crop.yCrop
        $cropWidth = [int]$crop.width
        $cropHeight = [int]$crop.height
        if ($cropWidth -le 0 -or $cropHeight -le 0) {
            continue
        }
        if ($x -ge $cropX -and $x -lt ($cropX + $cropWidth) -and $y -ge $cropY -and $y -lt ($cropY + $cropHeight)) {
            return $true
        }
    }
    return $false
}

function Test-SameColor([System.Drawing.Color]$left, [System.Drawing.Color]$right) {
    return $left.ToArgb() -eq $right.ToArgb()
}

$sourcePath = (Resolve-Path -LiteralPath $Source).Path
$outputPath = (Resolve-Path -LiteralPath $Output).Path
$maskPath = (Resolve-Path -LiteralPath $ApprovedMask).Path
$manifestPath = (Resolve-Path -LiteralPath $Manifest).Path
$sourceBitmap = [System.Drawing.Bitmap]::new($sourcePath)
$outputBitmap = [System.Drawing.Bitmap]::new($outputPath)
$maskBitmap = [System.Drawing.Bitmap]::new($maskPath)

try {
    $errors = [System.Collections.Generic.List[string]]::new()
    $warnings = [System.Collections.Generic.List[string]]::new()
    $changedPixels = 0
    $alphaAdded = 0
    $alphaRemoved = 0
    $changedOutsideMask = 0
    $visibleOutsideCrop = 0

    if ($sourceBitmap.Width -ne $outputBitmap.Width -or $sourceBitmap.Height -ne $outputBitmap.Height) {
        $errors.Add("Source and output canvas dimensions differ.")
    }
    if ($maskBitmap.Width -ne $outputBitmap.Width -or $maskBitmap.Height -ne $outputBitmap.Height) {
        $errors.Add("Approved mask and output canvas dimensions differ.")
    }

    $manifestDocument = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    $crops = @(Get-Crops $manifestDocument)
    if ($crops.Count -eq 0) {
        $errors.Add("Crop manifest contains no crop entries.")
    }

    if ($errors.Count -eq 0) {
        for ($y = 0; $y -lt $outputBitmap.Height; $y++) {
            for ($x = 0; $x -lt $outputBitmap.Width; $x++) {
                $sourceColor = $sourceBitmap.GetPixel($x, $y)
                $outputColor = $outputBitmap.GetPixel($x, $y)
                $maskColor = $maskBitmap.GetPixel($x, $y)
                $changed = -not (Test-SameColor $sourceColor $outputColor)
                $approved = $maskColor.A -gt 0

                if ($outputColor.A -gt 0 -and -not (Test-InOwnedCrop $x $y $crops)) {
                    $visibleOutsideCrop++
                }

                if (-not $changed) {
                    continue
                }

                $changedPixels++
                if ($sourceColor.A -eq 0 -and $outputColor.A -gt 0) {
                    $alphaAdded++
                }
                elseif ($sourceColor.A -gt 0 -and $outputColor.A -eq 0) {
                    $alphaRemoved++
                }

                if (-not $approved) {
                    $changedOutsideMask++
                }

                if ($Mode -eq "pure-recolor" -and $sourceColor.A -ne $outputColor.A) {
                    $errors.Add("Pure recolor changed source Alpha at ($x,$y).")
                }
            }
        }
    }

    if ($changedOutsideMask -gt 0) {
        $errors.Add("$changedOutsideMask changed pixel(s) fall outside the approved mask.")
    }
    if ($visibleOutsideCrop -gt 0) {
        $errors.Add("$visibleOutsideCrop visible output pixel(s) fall outside discovered crop ownership.")
    }
    if ($Mode -ne "pure-recolor") {
        $warnings.Add("This checker validates owned-crop and approved-mask contracts, not visual quality, identity, pivot motion, or in-game rendering.")
    }

    $result = [pscustomobject]@{
        pass = $errors.Count -eq 0
        mode = $Mode
        source = $sourcePath
        output = $outputPath
        manifest = $manifestPath
        approvedMask = $maskPath
        changedPixels = $changedPixels
        alphaAdded = $alphaAdded
        alphaRemoved = $alphaRemoved
        changedOutsideMask = $changedOutsideMask
        visibleOutsideCrop = $visibleOutsideCrop
        errors = @($errors)
        warnings = @($warnings)
    }

    if ($Json) {
        $result | ConvertTo-Json -Depth 8 -Compress
    }
    else {
        $result
    }
}
finally {
    $sourceBitmap.Dispose()
    $outputBitmap.Dispose()
    $maskBitmap.Dispose()
}
