param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [switch]$Json
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing.Common

$resolvedPath = (Resolve-Path -LiteralPath $Path).Path
$bitmap = [System.Drawing.Bitmap]::new($resolvedPath)

try {
    $width = $bitmap.Width
    $height = $bitmap.Height
    $alphaCounts = @{}
    $rgbCounts = @{}
    $rgbaCounts = @{}
    $visible = [System.Collections.Generic.HashSet[int]]::new()
    $semiTransparent = 0
    $dirtyTransparent = 0
    $minX = $width
    $minY = $height
    $maxX = -1
    $maxY = -1

    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            $color = $bitmap.GetPixel($x, $y)
            $alphaKey = [string]$color.A
            if (-not $alphaCounts.ContainsKey($alphaKey)) {
                $alphaCounts[$alphaKey] = 0
            }
            $alphaCounts[$alphaKey]++

            if ($color.A -eq 0) {
                if ($color.R -ne 0 -or $color.G -ne 0 -or $color.B -ne 0) {
                    $dirtyTransparent++
                }
                continue
            }

            if ($color.A -lt 255) {
                $semiTransparent++
            }

            $index = $y * $width + $x
            [void]$visible.Add($index)
            $minX = [Math]::Min($minX, $x)
            $minY = [Math]::Min($minY, $y)
            $maxX = [Math]::Max($maxX, $x)
            $maxY = [Math]::Max($maxY, $y)

            $rgbKey = "{0},{1},{2}" -f $color.R, $color.G, $color.B
            if (-not $rgbCounts.ContainsKey($rgbKey)) {
                $rgbCounts[$rgbKey] = 0
            }
            $rgbCounts[$rgbKey]++

            $rgbaKey = "{0},{1},{2},{3}" -f $color.R, $color.G, $color.B, $color.A
            if (-not $rgbaCounts.ContainsKey($rgbaKey)) {
                $rgbaCounts[$rgbaKey] = 0
            }
            $rgbaCounts[$rgbaKey]++
        }
    }

    $visited = [System.Collections.Generic.HashSet[int]]::new()
    $islands = 0
    foreach ($start in $visible) {
        if ($visited.Contains($start)) {
            continue
        }

        $islands++
        $queue = [System.Collections.Generic.Queue[int]]::new()
        $queue.Enqueue($start)
        [void]$visited.Add($start)

        while ($queue.Count -gt 0) {
            $current = $queue.Dequeue()
            $currentX = $current % $width
            $currentY = [Math]::Floor($current / $width)
            foreach ($offset in @(@(-1, 0), @(1, 0), @(0, -1), @(0, 1))) {
                $nextX = $currentX + $offset[0]
                $nextY = $currentY + $offset[1]
                if ($nextX -lt 0 -or $nextX -ge $width -or $nextY -lt 0 -or $nextY -ge $height) {
                    continue
                }
                $next = $nextY * $width + $nextX
                if ($visible.Contains($next) -and -not $visited.Contains($next)) {
                    [void]$visited.Add($next)
                    $queue.Enqueue($next)
                }
            }
        }
    }

    $alphaHistogram = [ordered]@{}
    foreach ($key in ($alphaCounts.Keys | Sort-Object { [int]$_ })) {
        $alphaHistogram[$key] = $alphaCounts[$key]
    }

    $visibleRgbPalette = @(
        foreach ($key in ($rgbCounts.Keys | Sort-Object)) {
            $parts = $key -split ','
            [pscustomobject]@{
                r = [int]$parts[0]
                g = [int]$parts[1]
                b = [int]$parts[2]
                count = $rgbCounts[$key]
            }
        }
    )

    $visibleRgbaPalette = @(
        foreach ($key in ($rgbaCounts.Keys | Sort-Object)) {
            $parts = $key -split ','
            [pscustomobject]@{
                r = [int]$parts[0]
                g = [int]$parts[1]
                b = [int]$parts[2]
                a = [int]$parts[3]
                count = $rgbaCounts[$key]
            }
        }
    )

    $boundingBox = $null
    if ($maxX -ge 0) {
        $boundingBox = [pscustomobject]@{
            x = $minX
            y = $minY
            width = $maxX - $minX + 1
            height = $maxY - $minY + 1
        }
    }

    $result = [pscustomobject]@{
        path = $resolvedPath
        width = $width
        height = $height
        pixelFormat = [string]$bitmap.PixelFormat
        alphaHistogram = [pscustomobject]$alphaHistogram
        visibleRgbPalette = $visibleRgbPalette
        visibleRgbaPalette = $visibleRgbaPalette
        visibleBoundingBox = $boundingBox
        semiTransparentPixelCount = $semiTransparent
        dirtyTransparentRgbCount = $dirtyTransparent
        connectedAlphaIslands = $islands
    }

    if ($Json) {
        $result | ConvertTo-Json -Depth 10 -Compress
    }
    else {
        $result
    }
}
finally {
    $bitmap.Dispose()
}
