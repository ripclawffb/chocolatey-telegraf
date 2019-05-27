﻿$ErrorActionPreference = 'Stop';

$unzip_folder    = $env:ProgramFiles
$install_folder  = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName     = 'telegraf'
$softwareName    = 'telegraf*'
$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url             = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.5.1_windows_i386.zip'
$url64           = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.5.1_windows_amd64.zip'
$fileLocation    = Join-Path $install_folder 'telegraf.exe'

# Make sure the config directory exists
If(!(Test-Path -Path $configDirectory)){
  New-Item -Path $configDirectory -ItemType Directory
}

# If telegraf.exe exists, and the service is running, stop the service
If (Test-Path -Path $fileLocation){
  If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "telegraf"
    Start-Sleep -s 10
  }
}

# If telegraf.exe exists, and the service is enabled, uninstall the service
If (Test-Path -Path $fileLocation){
  If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    & $fileLocation --service uninstall
  }
}

# if the service is already defined, do not install the service
# otherwise install the service.
If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
  $installArgs = ""
} Else {
  $installArgs = "--service install"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $unzip_folder
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64
  file          = $fileLocation
  file64        = $fileLocation

  softwareName  = 'telegraf*'

  checksum       = 'fdc8f33f3bffe445cc5e9d5ea9b45f9fbbc5068b4090b152d3b69b5f0cf5cfa2'
  checksumType   = 'sha256'
  checksum64     = 'afba1bf33f221a6e16a1c48e996abfd02e00037185ddf9082869108dbf4c5351'
  checksumType64 = 'sha256'

  silentArgs     = "--config-directory `"$configDirectory`" $installArgs"
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
