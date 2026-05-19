$dockerBin = 'C:\Program Files\Docker\Docker\resources\bin'
if (Test-Path $dockerBin) {
    $env:PATH = "$dockerBin;$env:PATH"
    Write-Output "Updated session PATH to include $dockerBin"
    & "$dockerBin\docker.exe" --version
} else {
    Write-Output "docker bin not found at $dockerBin"
    exit 1
}
