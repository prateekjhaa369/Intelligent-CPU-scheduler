Param()
$paths = @('C:\Program Files','C:\Program Files (x86)')
$found = $false
foreach ($p in $paths) {
    if (Test-Path $p) {
        Get-ChildItem -Path $p -Filter docker.exe -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Output $_.FullName
            $found = $true
        }
    }
}
if (-not $found) { Write-Output 'NOT FOUND' ; exit 1 }
exit 0
