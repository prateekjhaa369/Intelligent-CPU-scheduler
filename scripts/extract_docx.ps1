param(
    [string]$DocxPath
)
if (-not $DocxPath) {
    Write-Host "Usage: extract_docx.ps1 <file.docx>"
    exit 2
}
$out = Join-Path $env:TEMP 'docx_extracted'
if (Test-Path $out) { Remove-Item $out -Recurse -Force }
$zipTemp = Join-Path $env:TEMP 'tmp_docx.zip'
Copy-Item -Path $DocxPath -Destination $zipTemp -Force
Expand-Archive -Path $zipTemp -DestinationPath $out
$docXmlPath = Join-Path $out 'word\document.xml'
if (-not (Test-Path $docXmlPath)) { Write-Host 'document.xml not found in archive'; exit 1 }
$xml = [xml](Get-Content -Raw -Path $docXmlPath)
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace('w','http://schemas.openxmlformats.org/wordprocessingml/2006/main')
$paras = $xml.SelectNodes('//w:p', $ns)
foreach ($p in $paras) {
    $ts = $p.SelectNodes('.//w:t', $ns) | ForEach-Object { $_.InnerText }
    if ($ts) { Write-Output ($ts -join '') }
}
