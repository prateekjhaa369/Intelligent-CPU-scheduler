$processes = Get-CimInstance Win32_Process | Where-Object { $_.Name -like 'java*' -and $_.CommandLine -match 'jenkins' }
if (-not $processes) {
    Write-Output 'No Jenkins Java process found'
    exit 1
}
$processes | Select-Object ProcessId, Name, CommandLine | Format-List
