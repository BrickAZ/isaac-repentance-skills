$ErrorActionPreference = "Stop"

$skillRoot = Split-Path -Parent $PSScriptRoot
$builder = Join-Path $skillRoot "scripts\build-anm2-crop-manifest.ps1"
if (-not (Test-Path -LiteralPath $builder)) {
    throw "Missing build-anm2-crop-manifest.ps1"
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("isaac-anm2-manifest-" + [Guid]::NewGuid().ToString("N"))
[System.IO.Directory]::CreateDirectory($tempRoot) | Out-Null

try {
    $anm2Path = Join-Path $tempRoot "fixture.anm2"
    @'
<AnimatedActor>
  <Info CreatedBy="Codex" CreatedOn="2026-09-01" Version="1" Fps="30" />
  <Content>
    <Spritesheets>
      <Spritesheet Path="gfx/base.png" Id="0" />
      <Spritesheet Path="gfx/alt.png" Id="1" />
    </Spritesheets>
    <Layers>
      <Layer Name="Body" Id="0" SpritesheetId="0" />
      <Layer Name="Hat" Id="1" SpritesheetId="1" />
    </Layers>
  </Content>
  <Animations DefaultAnimation="Idle">
    <Animation Name="Idle" FrameNum="2" Loop="true">
      <RootAnimation>
        <Frame XPosition="0" YPosition="0" Delay="1" Visible="true" />
      </RootAnimation>
      <LayerAnimations>
        <LayerAnimation LayerId="0" Visible="true">
          <Frame XPosition="1" YPosition="2" XPivot="8" YPivot="9" XCrop="0" YCrop="0" Width="16" Height="16" Delay="1" Visible="true" />
          <Frame XPosition="3" YPosition="4" XPivot="7" YPivot="10" XCrop="16" YCrop="0" Width="16" Height="16" Delay="2" Visible="true" SpritesheetId="1" />
        </LayerAnimation>
        <LayerAnimation LayerId="1" Visible="false">
          <Frame XPosition="0" YPosition="0" XPivot="4" YPivot="5" XCrop="0" YCrop="16" Width="8" Height="8" Delay="1" Visible="true" />
        </LayerAnimation>
      </LayerAnimations>
    </Animation>
  </Animations>
</AnimatedActor>
'@ | Set-Content -LiteralPath $anm2Path -Encoding utf8NoBOM

    $manifest = (& $builder -Path $anm2Path -Json) | ConvertFrom-Json
    if ($manifest.defaultAnimation -ne "Idle" -or @($manifest.crops).Count -ne 3) {
        throw "Manifest did not preserve the default animation or frame count."
    }

    $body0 = $manifest.crops | Where-Object { $_.layerName -eq "Body" -and $_.frameIndex -eq 0 }
    if ($body0.spritesheetPath -ne "gfx/base.png" -or $body0.xCrop -ne 0 -or $body0.width -ne 16 -or $body0.xPivot -ne 8 -or $body0.yPosition -ne 2) {
        throw "Manifest lost Body frame crop, pivot, position, or spritesheet data."
    }

    $body1 = $manifest.crops | Where-Object { $_.layerName -eq "Body" -and $_.frameIndex -eq 1 }
    if ($body1.spritesheetPath -ne "gfx/alt.png" -or $body1.delay -ne 2) {
        throw "Frame-level spritesheet overrides were not preserved."
    }

    $hat = $manifest.crops | Where-Object { $_.layerName -eq "Hat" }
    if ($hat.visible -ne $false -or $hat.blankCrop -ne $true) {
        throw "Layer visibility was not folded into the frame manifest."
    }

    Write-Output "ANM2 crop-manifest tests passed."
}
finally {
    if ($tempRoot.StartsWith([System.IO.Path]::GetTempPath(), [System.StringComparison]::OrdinalIgnoreCase)) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
