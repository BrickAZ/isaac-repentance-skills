param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

function Get-IntAttribute([object]$node, [string]$name, [int]$default = 0) {
    $attribute = $node.Attributes[$name]
    if ($null -eq $attribute -or [string]::IsNullOrWhiteSpace($attribute.Value)) {
        return $default
    }
    return [int]$attribute.Value
}

function Get-BoolAttribute([object]$node, [string]$name, [bool]$default = $true) {
    $attribute = $node.Attributes[$name]
    if ($null -eq $attribute) {
        return $default
    }
    return $attribute.Value -notin @("false", "False", "0")
}

$resolvedPath = (Resolve-Path -LiteralPath $Path).Path
[xml]$document = Get-Content -Raw -LiteralPath $resolvedPath
$actor = $document.AnimatedActor

$spritesheets = @{}
foreach ($sheet in @($actor.Content.Spritesheets.Spritesheet)) {
    $spritesheets[[string]$sheet.Id] = [string]$sheet.Path
}

$layers = @{}
foreach ($layer in @($actor.Content.Layers.Layer)) {
    $layers[[string]$layer.Id] = [pscustomobject]@{
        id = [int]$layer.Id
        name = [string]$layer.Name
        spritesheetId = [string]$layer.SpritesheetId
    }
}

$crops = [System.Collections.Generic.List[object]]::new()
foreach ($animation in @($actor.Animations.Animation)) {
    foreach ($layerAnimation in @($animation.LayerAnimations.LayerAnimation)) {
        $layerId = [string]$layerAnimation.LayerId
        $layer = $layers[$layerId]
        if ($null -eq $layer) {
            $layer = [pscustomobject]@{
                id = [int]$layerId
                name = ""
                spritesheetId = ""
            }
        }
        $layerVisible = Get-BoolAttribute $layerAnimation "Visible" $true
        $frameIndex = 0

        foreach ($frame in @($layerAnimation.Frame)) {
            $frameVisible = Get-BoolAttribute $frame "Visible" $true
            $visible = $layerVisible -and $frameVisible
            $sheetAttribute = $frame.Attributes["SpritesheetId"]
            $sheetId = if ($null -ne $sheetAttribute) { [string]$sheetAttribute.Value } else { [string]$layer.spritesheetId }
            $width = Get-IntAttribute $frame "Width"
            $height = Get-IntAttribute $frame "Height"

            $crops.Add([pscustomobject]@{
                spritesheetId = if ([string]::IsNullOrWhiteSpace($sheetId)) { $null } else { [int]$sheetId }
                spritesheetPath = if ($spritesheets.ContainsKey($sheetId)) { $spritesheets[$sheetId] } else { $null }
                layerId = [int]$layer.id
                layerName = [string]$layer.name
                animation = [string]$animation.Name
                frameIndex = $frameIndex
                xCrop = Get-IntAttribute $frame "XCrop"
                yCrop = Get-IntAttribute $frame "YCrop"
                width = $width
                height = $height
                xPivot = Get-IntAttribute $frame "XPivot"
                yPivot = Get-IntAttribute $frame "YPivot"
                xPosition = Get-IntAttribute $frame "XPosition"
                yPosition = Get-IntAttribute $frame "YPosition"
                delay = Get-IntAttribute $frame "Delay" 1
                visible = $visible
                blankCrop = (-not $visible) -or $width -le 0 -or $height -le 0
            })
            $frameIndex++
        }
    }
}

$result = [pscustomobject]@{
    source = $resolvedPath
    defaultAnimation = [string]$actor.Animations.DefaultAnimation
    crops = @($crops)
}

if ($Json) {
    $result | ConvertTo-Json -Depth 10 -Compress
}
else {
    $result
}
