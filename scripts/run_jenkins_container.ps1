$docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
$dockerBin = Split-Path $docker
$env:PATH = "$dockerBin;$env:PATH"
$jenkinsHome = (Resolve-Path (Join-Path $PSScriptRoot '..\.jenkins_home')).Path
$dockerConfig = Join-Path $env:TEMP 'docker-empty-config'
if (-not (Test-Path $dockerConfig)) {
    New-Item -ItemType Directory -Path $dockerConfig | Out-Null
}
Set-Content -Path (Join-Path $dockerConfig 'config.json') -Value '{}' -NoNewline
$env:DOCKER_CONFIG = $dockerConfig

if (-not (Test-Path $docker)) {
    Write-Output "docker.exe not found at $docker"
    exit 1
}

Write-Output "Using Jenkins home: $jenkinsHome"

& $docker rm -f jenkins 2>$null | Out-Null

Write-Output 'Starting Jenkins container...'
$volumeArg = ('{0}:/var/jenkins_home' -f $jenkinsHome)
& $docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v $volumeArg jenkins/jenkins:lts | Write-Output

Write-Output 'Waiting for Jenkins to become available on http://localhost:8080'
for ($i = 0; $i -lt 60; $i++) {
    try {
        Invoke-WebRequest -UseBasicParsing -Uri http://localhost:8080 -TimeoutSec 3 -ErrorAction Stop | Out-Null
        Write-Output 'Jenkins is reachable'
        exit 0
    } catch {
        Start-Sleep -Seconds 5
    }
}

Write-Output 'Timed out waiting for Jenkins'
exit 1
