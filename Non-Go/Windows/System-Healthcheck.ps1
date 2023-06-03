#
# Welcome to The Cyber Helpline's Enumeration/healthcare script! Maintained by Will Brooke.
# Avalible under the GNU public licence V3.0.
# Download an execute using command: PowerShell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/redbrooke/Golang-Security-Suite/main/Non-Go/Windows/System-Healthcheck.ps1'))"
#

#
# TODO: Add password protected zips. DONE
# TODO: Stop using transcript and write to separate files
# TODO: Re-wording questions, more user friendly. Informed consent. Perhaps for every single command.
# TODO: After-action sheet to tell users not to run .exes or .ps1 normally.
# TODO: Find a cleaner way to get the event log stuff
#

function CreatePopupWindow {
      Add-Type -AssemblyName System.Windows.Forms
      $FormObject = [System.Windows.Forms.Form]
      $labelObject = [System.Windows.Forms.Label]

      $mainPage=New-Object $FormObject
      $mainPage.ClientSize='700,700'
      $mainPage.Text='The CyberHelpline HealthcareScript'
      $mainPage.BackColor="white"

      $header=New-Object $LabelObject
      $header.text='The CyberHelpline healthcare check tool'
      $header.AutoSize = $true
      $header.font = 'Verdana,24,style=Bold'
      $header.Location=New-Object System.Drawing.Point(20,20)

      $mainPage.controls.AddRange(@($header))

      $mainPage.ShowDialog()

      $mainPage.Dispose()
}

#This grabs your WiFi info.
function howYouConnectToInternet{ 
      New-Item "~\Documents\HelplineOutput" -ItemType "file" -Name "wifiInfo.txt"
      Get-NetIPConfiguration | Format-Table -AutoSize | Out-File -append -FilePath ~\Documents\HelplineOutput\wifiInfo.txt
      Get-NetIPAddress | Format-Table -AutoSize | Out-File -append -FilePath ~\Documents\HelplineOutput\wifiInfo.txt
      Get-NetNeighbor | Format-Table -AutoSize | Out-File -append -FilePath ~\Documents\HelplineOutput\wifiInfo.txt
      Get-NetRoute | Format-Table -AutoSize | Out-File -append -FilePath ~\Documents\HelplineOutput\wifiInfo.txt
}

function currentlyTalking{
      New-Item "~\Documents\HelplineOutput" -ItemType "file" -Name "liveInfo.txt"
      Get-NetTCPConnection | Out-File -append -FilePath ~\Documents\HelplineOutput\liveInfo.txt
      Get-SMBShare | Out-File -append -FilePath ~\Documents\HelplineOutput\liveInfo.txt
}

function currentlyRunning{
      Get-Process 
      Get-Process -FileVersionInfo
      Get-service
      
}

function getInstalledStuff{
      Get-CimInstance Win32_StartupCommand | select Name, command, Location, User
      Get-ScheduledTask | select TaskName,State
      Get-WmiObject -Class Win32_Product

}

function environmentInfo{
      Get-ComputerInfo
      Get-ChildItem -Path Env:
}

function fileNames{
      Get-ChildItem C:\ -Recurse
}

function usersAndGroups{
      Get-LocalUser
      Get-LocalGroup
}

New-Item "~\Documents" -ItemType "directory" -Name "HelplineOutput"    




# This will compress and send the archive. 
$compress = @{
  Path = "~\Documents\HelplineOutput"
  CompressionLevel = "Fastest"
  DestinationPath = "~/Documents"
}
Compress-Archive @compress



