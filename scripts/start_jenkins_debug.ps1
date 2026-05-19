$jenkinsHome = (Resolve-Path (Join-Path $PSScriptRoot '..\.jenkins_home')).Path
$warPath = (Resolve-Path (Join-Path $PSScriptRoot '..\.tools\jenkins.war')).Path
$javaExtractDir = Join-Path $PSScriptRoot '..\.tools\temurin21-jre'
$javaZipPath = Join-Path $PSScriptRoot '..\.tools\temurin21-jre.zip'
$javaDownloadUrl = 'https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jre_x64_windows_hotspot_21.0.11_10.zip'
$logPath = Join-Path $PSScriptRoot 'jenkins-startup.log'

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

if (-not (Test-Path $warPath)) {
    Write-Output "Jenkins WAR not found at $warPath"
    exit 1
}

$java = (Get-ChildItem -Path $javaExtractDir -Filter java.exe -Recurse | Select-Object -First 1).FullName

if (-not $java) {
    Write-Output "Java runtime not found after extraction in $javaExtractDir"
    exit 1
}

$env:JENKINS_HOME = $jenkinsHome
Write-Output "Starting Jenkins with JENKINS_HOME=$jenkinsHome"
Write-Output "Logging to $logPath"

& $java -jar $warPath 2>&1 | Tee-Object -FilePath $logPath
