New-Item -ItemType File -Path "$PSScriptRoot\hash_scan_results.txt" -Force *>$null

$HashFile = Resolve-Path (Read-Host "Please insert the hash database to compare against")
$Path_to_scan = Resolve-Path (Read-Host "Please insert the path you would like to scan")
$hash = Read-Host "What algorithm would you like to use? (MD5, SHA1, SHA256)"

$Hash_compare = (Get-Content $HashFile) | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ }

echo ""
echo "Example C:\Users"
echo "scanning this may take a while :)"
echo ""

foreach ($d in Get-ChildItem -Path $Path_to_scan -Recurse -Force -File -ErrorAction SilentlyContinue) {

    $File_hash = Get-FileHash  -Algorithm $hash -LiteralPath $d.FullName -ErrorAction SilentlyContinue

    if ($Hash_compare -contains $File_hash.Hash) {
        echo $File_hash.Path >> "$PSScriptRoot\hash_scan_results.txt"
    }
}

echo "Scanning complete results will be saved at hash_scan_results.txt"
