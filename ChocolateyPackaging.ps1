
Function Console-Prompt {
  Param( [String[]]$choiceList,[String]$Caption = "Please make a selection",[String]$Message = "Choices are presented below",[int]$default = 0 )
$choicedesc = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription] 
$choiceList | foreach { 
$comps = $_ -split '=' 
$choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $comps[0],$comps[1]))} 
#$choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))} 
$Host.ui.PromptForChoice($caption, $message, $choicedesc, $default) 
}

Write-output "`r`n`r`nQuick Config by Darwin (CSI-Windows.com)...`r`n`r`n"
Write-output "Gets Your Machine Ready to Author Chocolatey Packages"

"Getting Started..." | out-default

Set-ExecutionPolicy RemoteSigned

$os = (Get-WmiObject "Win32_OperatingSystem")

If (!(Test-Path env:ChocolateyInstall))
  {
  "Installing Chocolatey Package Manager..." | out-default
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 
  $env:path = "$($env:ALLUSERSPROFILE)\chocolatey\bin;$($env:Path)"
  }

Write-Output "Installing Packages"
cinst -y notepadplusplus
cinst -y warmup
cinst -y git
$gitpath = 'C:\Program Files (x86)\git\cmd'
$CurrentMachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$CurrentProcessPath = [Environment]::GetEnvironmentVariable("Path", "Process")
if (!($CurrentMachinePath -ilike "*\git\cmd*"))
  {
  [Environment]::SetEnvironmentVariable("Path", $CurrentMachinePath + ";$gitpath", "Machine")
  }

if (!($CurrentProcessPath -ilike "*\git\cmd*"))
  {
  [Environment]::SetEnvironmentVariable("Path", $CurrentProcessPath + ";$gitpath", "Process")
  }
git config --global credential.helper wincred

choco install nuget.commandline
$env:path = $env:path + ";C:\Program Files (x86)\git\cmd"
cd $env:chocolateyinstall
git clone https://github.com/chocolatey/chocolateytemplates.git
cd chocolateytemplates\_templates
