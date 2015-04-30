
"`r`n`r`nQuick Config by Darwin (CSI-Windows.com)...`r`n`r`n" | out-default

"Getting Started..." | out-default

Write-Warning "Re-run this script as many times as necessary.  On Windows 7 SP1 and Server 2008 R2 SP1, this will probably be three times."

$os = (Get-WmiObject "Win32_OperatingSystem")

If (!(Test-Path env:ChocolateyInstall))
  {
  "Installing Chocolatey Package Manager..." | out-default
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 
  $env:path = "$($env:ALLUSERSPROFILE)\chocolatey\bin;$($env:Path)"
  }

"Available versions of Dot Net" | out-default
If ((get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue) -ge 378675)
  {
  "The minimum Dot Net Version (4.5.1), is installed." | out-default
  }
Else
  {
  "The minimum Dot Net Version (4.5.1), is not installed, installing 4.5.1..." | out-default
  Choco Install -y dotnet4.5.1    
  }

If ([version]$os.version -eq [version]"6.1.7600")
  {
  throw  "You must apply SP1 to Windows 7 or Server 2008 R2, exiting..."
  }

If (([version]$os.version -ge [version]"6.1.7601") -AND ([version]$os.version -lt [version]"6.2"))
  {
  If ($PSVersionTable.PSVersion -lt [Version]'4.0')
    {
    Write-Warning "For the time being, Windows 7 SP1 and Server 2008 R2 SP1 must have PowerShell 4 installed before installing version 5"  
    Write-Warning "Installing PowerShell version 4 and rebooting..."
    Write-Warning "Please re-run this script after the reboot."
    cinst -y PowerShell -version 4.0.20141001
    restart-computer
    }
  }

  If ($PSVersionTable.PSVersion -lt [Version]'5.0.10105')
  {
  "Installing PowerShell 5 Chocolatey Package..." | out-default
  #Choco Install -y PowerShell -Pre
  cinst -y powershell -version "5.0.10105-April2015Preview" -pre -source "C:\Users\public"
  restart-computer
  }

  If ([Version]$PSVersionTable.PSVersion -ge [Version]'5.0')
    {
	"You are running PowerShell 5, Installing all the latest DSCResourcekit modules from PowerShellGallery.com" | Out-Default
	"Automatically installing and activating the Nuget provider." | Out-Default
    Get-PackageProvider -Name NuGet -ForceBootstrap | out-null
	$existingrescount = (Get-DSCResource).count
    $reskitmodulecount = (find-module | where tags -contains "DSCResourceKit").count 
    "Installing $reskitmodulecount modules, please be patient as this can take a while..."
	#Get all the latest DSCResourcekit Modules
    find-module | where tags -contains "DSCResourceKit" | install-module -force
	$newDSCcount = (Get-DSCResource).count - $existingrescount
	"Installed $reskitmodulecount modules, containing $newDSCcount DSC Resources, use `"Get-DSCResource`" to see what was installed." | Out-Default
	}


"`r`n`r`nATTENTION: If this is a test or lab machine, do not forget to set your PowerShell Execution policy to RemoteSigned to allow scripts to run using `"Set-ExecutionPolicy RemoteSigned -Force`"`r`n`r`n" | out-default

"Please restart for WMF / PowerShell 5 to become active. (In PowerShell: `"Restart-Computer`")" | out-default

