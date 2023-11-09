$gw2path = "F:\Guild Wars 2"
New-Item -ItemType Directory -Path "$gw2path\ArcDPSUpdate" -ErrorAction SilentlyContinue
$arcDPSpath = "$gw2path\ArcDPSUpdate"
Invoke-WebRequest https://www.deltaconnected.com/arcdps/x64/d3d11.dll -O 'F:\Guild Wars 2\ArcDPSUpdate\d3d11.dll'

$newfile = Get-Item "$arcDPSpath\d3d11.dll"
$currentfile = Get-Item "$gw2path\d3d11.dll"
$date = Get-Date -Format yyyy-MM-dd

$currentversion = $currentfile.VersionInfo.FileVersion
$newversion = $newfile.VersionInfo.FileVersion

Write-Host "Current file $currentversion"
Write-Host "New File "

if ($newversion -ne $currentversion)
{
    Move-Item "$arcDPSpath\d3d11.dll" "$gw2path\d3d11.dll" -Force
    Write-EventLog -LogName "Application" -Source EventSystem -EventID 6969 -EntryType Information -Message "ArcDPS Updated on $date" -RawData 10,20
}
else
{
    Remove-Item "$arcDPSpath\d3d11.dll"
    Write-Host "Removing Downloaded file"
}