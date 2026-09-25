# Open a bash shell, as the container's user, in a running devbox container.
. "$PSScriptRoot\common.ps1"
Assert-DevboxDocker

$containers = Get-DevboxContainers -Running $true
if ($containers.Count -eq 0) {
    Write-Host "No running containers starting with '$DevboxPrefix-' were found."
    exit 0
}

$selected = Select-DevboxItem -Title 'Select the container to connect to:' -Items $containers
if (-not $selected) {
    Write-Host 'Cancelled.'
    exit 0
}

$userName = Get-DevboxContainerUser -Container $selected
if (-not $userName) {
    Write-Host "Error: '$selected' has no DEVBOX_USER variable; it was not created by container-create." -ForegroundColor Red
    exit 1
}

docker exec -it -u $userName -w "/home/$userName" $selected bash
