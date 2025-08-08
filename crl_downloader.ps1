# Define source and target directories
$crlUrl = "http://crl.gds.disa.mil/getcrlzip?ALL+CRL+ZIP"
$downloadPath = "C:\Path\Of\Your\Choosing\ALLCRLZIP.ZIP"
$tempExtractFolder = "C:\Path\To\Staging\CRLTemp"
$finalCRLFolder = "C:\Path\To\Final\StagedCRLs"

# Download ALLCRLZIP.ZIP
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($crlUrl, $downloadPath)

# Create staging and target folders if not exist
If (!(Test-Path $tempExtractFolder)) { New-Item -ItemType Directory -Force -Path $tempExtractFolder }
If (!(Test-Path $finalCRLFolder)) { New-Item -ItemType Directory -Force -Path $finalCRLFolder }

# Unzip the CRL files
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, $tempExtractFolder)

# Move CRLs to final destination, overwrite if needed
Get-ChildItem -Path $tempExtractFolder -Filter *.crl | ForEach-Object {
    Move-Item $_.FullName -Destination $finalCRLFolder -Force
}

# Optional: Clean up
Remove-Item $tempExtractFolder -Recurse -Force
Remove-Item $downloadPath -Force
