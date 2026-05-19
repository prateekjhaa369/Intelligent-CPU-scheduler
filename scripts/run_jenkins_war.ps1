$jenkinsHome = (Resolve-Path (Join-Path $PSScriptRoot '..\.jenkins_home')).Path
$warDir = Join-Path $PSScriptRoot '..\.tools'
$warPath = Join-Path $warDir 'jenkins.war'
$warUrl = 'https://get.jenkins.io/war-stable/2.555.2/jenkins.war'
$javaZipPath = Join-Path $warDir 'temurin21-jre.zip'
$javaExtractDir = Join-Path $warDir 'temurin21-jre'
$javaDownloadUrl = 'https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jre_x64_windows_hotspot_21.0.11_10.zip'

if (-not (Test-Path $warDir)) {
    New-Item -ItemType Directory -Path $warDir | Out-Null
}

if (-not (Test-Path $warPath)) {
    Write-Output "Downloading Jenkins WAR from $warUrl"
    Invoke-WebRequest -Uri $warUrl -OutFile $warPath -UseBasicParsing
}

if (-not (Test-Path $javaExtractDir)) {
    New-Item -ItemType Directory -Path $javaExtractDir | Out-Null
}

if (-not (Test-Path (Join-Path $javaExtractDir 'bin\java.exe'))) {
    if (-not (Test-Path $javaZipPath)) {
        Write-Output "Downloading Java 21 JRE from $javaDownloadUrl"
        Invoke-WebRequest -Uri $javaDownloadUrl -OutFile $javaZipPath -UseBasicParsing
    }
    Write-Output 'Extracting Java 21 JRE...'
    Expand-Archive -Path $javaZipPath -DestinationPath $javaExtractDir -Force
}

$java = (Get-ChildItem -Path $javaExtractDir -Filter java.exe -Recurse | Select-Object -First 1).FullName

if (-not $java) {
    Write-Output "Java runtime not found after extraction in $javaExtractDir"
    exit 1
}

Write-Output "Using Jenkins home: $jenkinsHome"
Write-Output 'Starting Jenkins WAR...'

$env:JENKINS_HOME = $jenkinsHome
Start-Process -FilePath $java -ArgumentList @('-jar', $warPath) -WorkingDirectory $warDir | Out-Null

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
