If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "telegraf"
}

If (Test-Path "$env:ProgramFiles\telegraf\telegraf.conf" -ErrorAction SilentlyContinue) {
    Copy-Item -Force -Path "$env:ProgramFiles\telegraf\telegraf.conf" -Destination "$env:ProgramFiles\telegraf\telegraf.backup.conf"
}
