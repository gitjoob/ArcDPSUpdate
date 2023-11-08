wget https://www.deltaconnected.com/arcdps/x64/d3d11.dll -O 'F:\Guild Wars 2\ArcDPS Temp\d3d11.dll'

$newfile = Get-Item 'F:\Guild Wars 2\ArcDPS Temp\d3d11.dll'
$currentfile = Get-Item 'F:\Guild Wars 2\d3d11.dll'
$date = Get-Date -Format yyyy-MM-dd

$version = $currentfile.VersionInfo.FileVersion

if ($newfile.VersionInfo.FileVersion -ne $version)
{
    Move-Item 'F:\Guild Wars 2\ArcDPS Temp\d3d11.dll' 'F:\Guild Wars 2\d3d11.dll' -Force
    Write-EventLog -LogName "Application" -Source EventSystem -EventID 6969 -EntryType Information -Message "ArcDPS Updated on $date" -RawData 10,20
}
else
{
    Remove-Item 'F:\Guild Wars 2\ArcDPS Temp\d3d11.dll'
}