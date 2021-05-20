param([String]$appenv="")

$release_path = "C:\Users\F3MSA\release\$($appenv)"
$site_path = "C:\inetpub\wwwroot\$($appenv)"
$file = Get-ChildItem $release_path | Sort-Object LastWriteTime | Select-Object -last 1

Write-Host "Expand Archite in $($site_path)"

Expand-Archive "$($release_path)\$($file.name)" $site_path -Force

Write-Host "Last deployed file $($file.name)"