Param()
$paths = @(
    'C:\Program Files\Docker\Docker\Docker Desktop.exe',
    'C:\Program Files\Docker\Docker Desktop.exe',
    'C:\Program Files\Docker\Docker Desktop\Docker Desktop.exe'
)
$started = $false
foreach ($p in $paths) {
    if (Test-Path $p) {
        Start-Process -FilePath $p -ErrorAction SilentlyContinue
        $started = $true
        break
    }
}
if (-not $started) {
    Write-Output 'Docker Desktop executable not found'
    exit 2
}
Write-Output 'Started Docker Desktop (if not already running). Waiting for docker CLI...'
Start-Sleep -Seconds 10
for ($i = 0; $i -lt 24; $i++) {
    try {
        & docker --version | Out-String
        Write-Output (docker --version)
        exit 0
    } catch {
        Start-Sleep -Seconds 5
    }
}
Write-Output 'docker-not-found'
exit 1
