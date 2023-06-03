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


function Helpline-Checks {
  New-Item "~\Documents" -ItemType "directory" -Name "HelplineOutput"    

  # SYSTEM AND ENVIRONMENT INFO -----------------
  # Gathers information about the current context we are running on, what and where are we?
  #

  if ($environment_approve -eq "y")
  {
      Echo "RETRIEVING ENVIRONMENT INFO"
      Echo "==========================================================================="
      Echo "Environment variables"
      Echo "---------------------------------------------------------------------------"
      gci env:* 	#Display all environment variables
      Echo "SystemInfo"
      ECho "---------------------------------------------------------------------------"
      systeminfo 	#View detailed system configuration information
      Echo "Patches"
      Echo "---------------------------------------------------------------------------"
      wmic qfe 	# Get patches and updates
      Echo "Installed programs"
      Echo "---------------------------------------------------------------------------"
      wmic product get name 	#Get installed programs
      Get-WmiObject -Class Win32_Product #Get installed programs
      Echo "Unquoted service paths"
      Echo "---------------------------------------------------------------------------"
      wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """"
      Echo "Tree output (all files)"
      Echo "---------------------------------------------------------------------------"
      tree \ /F /A #Outputs a diagram of all files.
  #Get-ChildItem C:\ -Recurse #Grabs the name and permission of all files.
  }


  # PROCESSES AND SERVICES ----------------------
  # What is runnong on this computer?
  #
  if ($process_approve -eq "y")
  {
      Echo "RETRIEVING PROCESS INFO"
      Echo "==========================================================================="
      Echo "Get-Process output"
      Echo "---------------------------------------------------------------------------"
      tasklist /svc 	#Display running processes
      Get-Process #Display running processes
      Get-Process -FileVersionInfo 2> $null # Displays more info about the processes that may fail due to lack of permissions.
      Echo "gci pipes"
      Echo "---------------------------------------------------------------------------"
      gci \\.\pipe\   #List named pipes
      Echo "Checking for scheduled tasks"
      Echo "---------------------------------------------------------------------------"
      Get-CimInstance Win32_StartupCommand | select Name, command, Location, User     | fl  #Check startup programs 
      Get-service # Pulls the name of all services   
      Get-ScheduledTask | select TaskName,State   #Enumerate scheduled tasks with     PowerShell
  }


  # USERS AND PERMISSIONS --------------------
  # Who has an account on this computer, and what can everyone do?
  #
  if ($users_approve -eq "y")
  { 
      Echo "RETRIEVING USER INFO"
      Echo "==========================================================================="
      Echo "Whoami permissions"
      Echo "---------------------------------------------------------------------------"
      whoami /priv 	#View current user privileges
      whoami /groups 	#View current user group information
      Echo "net command output"
      Echo "---------------------------------------------------------------------------"
      net user 	#Get all system users
      net localgroup 	#Get all system groups
      net localgroup administrators 	#View details about a group
      Echo "Event Logs"
      Echo "---------------------------------------------------------------------------"
      Get-EventLog -List
      Echo "==========================================================================="
      Echo "System"
      Echo "==========================================================================="
      Get-EventLog -LogName System -Newest 1000
      Echo "==========================================================================="
      Echo "Application log"
      Echo "==========================================================================="
      Get-EventLog -LogName Application -Newest 1000
  }

} # end of helpline check function.


Start-Job -Name Helpline -ScriptBlock {Helpline-Checks} #Runs approved checks
Get-Job -Name Helpline | Wait-Job # Waits for all checks to finish before zipping up (some commands may run for longer than this script takes to execute)
Echo "Compressing"

# This will compress and send the archive. 
$compress = @{
  Path = "~\Documents\HelplineOutput"
  CompressionLevel = "Fastest"
  DestinationPath = "~/Documents"
}
Compress-Archive @compress



