# Copy scripts/bash/* to <resources>\devbox-scripts\, overwriting existing files.
# Use it after editing the bash scripts, without creating a container.
. "$PSScriptRoot\common.ps1"

$resourcesPath = Read-Host "Host resources path [$DevboxDefaultResourcesPath]"
if ([string]::IsNullOrWhiteSpace($resourcesPath)) { $resourcesPath = $DevboxDefaultResourcesPath }
$resourcesPath = $resourcesPath.Trim().TrimEnd('\')

if (-not (Test-Path -LiteralPath $resourcesPath -PathType Container)) {
    Write-Host "Error: host path does not exist (nothing is created): $resourcesPath" -ForegroundColor Red
    exit 1
}

Sync-DevboxScripts -ResourcesPath $resourcesPath
