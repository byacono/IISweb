# --------------------------------------------------------------------
# Simple IIS Web feature installation and static pages
# Author - Brian Yacono
# Date - 2/12/2015
# Version 1.0
# Checking Execution Policy
# --------------------------------------------------------------------
$Policy = "Unrestricted"
$Policy = "RemoteSigned"
If ((get-ExecutionPolicy) -ne $Policy) {
  Write-Host "Script Execution is disabled. Enabling it now"
  Set-ExecutionPolicy $Policy -Force
  Write-Host "Please Re-Run this script in a new powershell enviroment"
  Exit
}
#Installation of IIS Features & Modules
Add-WindowsFeature -Name Web-Common-Http,Web-Asp-Net,Web-Net-Ext,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Http-Logging,Web-Request-Monitor,Web-Basic-Auth,Web-Windows-Auth,Web-Filtering,Web-Performance,Web-Mgmt-Console,Web-Mgmt-Compat,RSAT-Web-Server,WAS -IncludeAllSubFeature
Import-Module WebAdministration
Enable-WindowsOptionalFeature –online –featurename IIS-WebServerRole
$webroot=New-Item c:\Stweb -type Directory
New-Item c:\Stweb\brianweb -type Directory
Set-Content c:\Stweb\default.htm “Automation for the People”
Set-Content c:\Stweb\brianweb\default.htm “Web Test Page”
New-Item iis:\apppools\Stweb
New-Item iis:\Sites\Stweb -physicalpath $webroot -bindings @{protocol=”http”;bindingInformation=”:81:”}
Set-ItemProperty iis:\Sites\Stweb -Name applicationpool -Value Stweb
New-Item iis:\Sites\Stweb\brianweb -physicalpath c:\Stweb\brianweb -type Application
Set-ItemProperty iis:\Sites\Stweb\brianweb -Name applicationpool -Value Stweb
#IIS reset with sleep
invoke-command -scriptblock {iisreset}
Start-Sleep -s 10
#automated test ie window
$ie=New-Object -com internetexplorer.application
$ie.visible = $true
$ie.Navigate(“http://localhost:81/”)