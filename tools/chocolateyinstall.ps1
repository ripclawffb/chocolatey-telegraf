$ErrorActionPreference = 'Stop';

$unzipFolder    = $env:ProgramFiles
$installFolder  = "$unzipFolder\telegraf"
$configDirectory = Join-Path $installFolder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.22.1_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.22.1_windows_amd64.zip'
$fileLocation    = Join-Path $installFolder 'telegraf.exe'
$telegrafRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\telegraf"

# Extract current version of telegraf
$versionSearch = $url -match '.*-(\d*\.\d*\.\d*)_.*'
if ($versionSearch) {
  $version = $matches[1]
}

If(!(Test-Path -Path $configDirectory)){
  New-Item -Path $configDirectory -ItemType Directory
}

If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
  $servicePath = (Get-WmiObject win32_service | ?{$_.Name -like 'telegraf'}).PathName.Split('--')[0].Trim().Replace("""","")
  & $servicePath --service uninstall
}

If (Test-Path $telegrafRegPath) {
  Remove-Item $telegrafRegPath -Force
}

If (Test-Path "$installFolder\telegraf.conf" -ErrorAction SilentlyContinue) {
  Copy-Item -Force -Path "$installFolder\telegraf.conf" -Destination "$installFolder\telegraf.backup.conf"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $unzipFolder
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64
  file          = $fileLocation
  file64        = $fileLocation

  softwareName  = 'telegraf*'

  checksum       = 'a59c8df6530a9b2dda65554c08d7225e0e6f323a86fd9875aca7772ce5304df3'
  checksumType   = 'sha256'
  checksum64     = 'ae3146e91494646536c14e53c82bd20a53012cc74b3ac5cd938c3115e4dcda89'
  checksumType64 = 'sha256'

  silentArgs     = "--config-directory `"$configDirectory`" --service install"
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs

# Move files to non versioned telegraf folder
If((Test-Path -Path "$installFolder-$version")){
  Write-Host "Moving telegraf files"
  Move-Item -Force -Path "$installFolder-$version\*" -Destination "$installFolder\"
  Remove-Item -Path "$installFolder-$version" -Recurse -Force
}

Install-ChocolateyInstallPackage @packageArgs

If (Test-Path "$installFolder\telegraf.backup.conf" -ErrorAction SilentlyContinue) {
  Move-Item -Force -Path "$installFolder\telegraf.backup.conf" -Destination "$installFolder\telegraf.conf"
  Restart-Service -Name "telegraf"
}
