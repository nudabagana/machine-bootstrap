$shimDir = Join-Path $PSScriptRoot "winget_shims"

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathParts = $currentPath -split ";" | Where-Object { $_ }

if ($pathParts -notcontains $shimDir) {
    [Environment]::SetEnvironmentVariable("Path", ($pathParts + $shimDir) -join ";", "User")
    Write-Output "Added shim directory to user PATH: $shimDir"
} else {
    Write-Output "Shim directory already on user PATH: $shimDir"
}

Write-Output "Restart all terminal windows to pick up PATH changes."
