param(
    [int]$ProcessId
)
$p = Get-CimInstance Win32_Process -Filter "ProcessId=$ProcessId"
if ($null -eq $p) {
    Write-Output "Process $ProcessId not found"
    exit 1
}
Write-Output $p.CommandLine
