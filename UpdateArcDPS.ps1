Function Find-GuildWars2() {
    Write-Host "Looking for Guild Wars 2 in $SearchPath"

    $gw2path = &{
        trap {
            $error[0].exception.message
            continue
        }
        Get-ChildItem "$SearchPath" -Filter "Gw2-64.exe" -Recurse `
          -ErrorAction SilentlyContinue | ForEach-Object {
            throw $_.DirectoryName
        }
    }
    # Look in all drive letters globally if we didn't find it
    if ($($gw2path | Measure-Object).Count -eq 0) {
        Write-Host "Unable to find in expected path, expanding search."
        $gw2path = &{
            Get-CimInstance win32_logicaldisk -Filter "DriveType='3'" | `
              ForEach-Object {
                trap {
                    $error[0].exception.message
                    continue
                }
                $drive_letter = $_.DeviceID
                Write-Host "Checking drive $drive_letter"
                Get-ChildItem "$drive_letter\*" -Filter "Gw2-64.exe" -Recurse `
                  -ErrorAction SilentlyContinue | ForEach-Object {
                    throw $_.DirectoryName
                }
            }
        }
    }
    Write-Host "Identified Guild Wars 2 in the following locations:"
    Write-Host "$gw2path"
}

Find-GuildWars2

New-Item -ItemType Directory -Path "$gw2path\ArcDPSUpdate" -ErrorAction SilentlyContinue
$arcDPSpath = "$gw2path\ArcDPSUpdate"
Invoke-WebRequest https://www.deltaconnected.com/arcdps/x64/d3d11.dll -O "$arcDPSpath\d3d11.dll"

$newfile = Get-Item "$arcDPSpath\d3d11.dll"
$currentfile = Get-Item "$gw2path\d3d11.dll"
$date = Get-Date -Format yyyy-MM-dd

$version = $currentfile.VersionInfo.FileVersion

if ($newfile.VersionInfo.FileVersion -ne $version)
{
    Move-Item "$arcDPSpath\d3d11.dll" "$gw2path\d3d11.dll" -Force
    Write-EventLog -LogName "Application" -Source EventSystem -EventID 6969 -EntryType Information -Message "ArcDPS Updated on $date" -RawData 10,20
}
else
{
    Remove-Item "$arcDPSpath\d3d11.dll"
}