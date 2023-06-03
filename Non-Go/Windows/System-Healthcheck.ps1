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



function Helpline-Checks {
  New-Item "~\Documents" -ItemType "directory" -Name "HelplineOutput"
  Start-Transcript -Path "~\Documents\HelplineOutput\TheCyberHelpline.txt" # Outputs everything to a file.
# WELCOME SECTION -----------------
  Write-Output "==========================================================================="
  Write-Output "Welcome! This script aims to give us an overview of your system."
  $networking_approve = Read-Host "Do you agree to share a snapshot of your networking config? (Connection info, active connections and saved wireless networks) y/n?"
  $environment_approve = Read-Host "Do you agree to share environment info? (Windows version, patches, installed programs and the names of all files) y/n?"
  $process_approve = Read-Host "Do you agree to share everything running on your system? (All running processes, Scheduled tasks and named pipes) y/n?"
  $users_approve = Read-Host "Are you comfortable sharing all accounts and their permissions? (all users, groups and administrative users) y/n?"
  Write-Output "==========================================================================="

  # NETWORKING SECTION ---------------
  # Computer networks basically handle sending stuff over the internet (or to other computers). 
  #
  if ($networking_approve -eq "y")
  {
    Write-Output "RETRIEVING NETWORK INFO"
    Write-Output "==========================================================================="
    
    Write-Output "ipconfig"
    Write-Output "---------------------------------------------------------------------------"
    ipconfig /all | Out-File -FilePath ~\Documents\HelplineOutput\network.txt | Wait-Process	# Pulls network info 
    Write-Output "arp"
    Write-Output "---------------------------------------------------------------------------"
    arp -a 	| Out-File -Path ~\Documents\HelplineOutput\arp.txt  #ARP(address resolution protocol) table, links MAC addresses to IPs
    Write-Output "route print"
    Write-Output "---------------------------------------------------------------------------"
    route print 	#Review routing table, basically how you reach different networks
    Write-Output "Netstat"
    Write-Output "---------------------------------------------------------------------------"
    netstat -ano  #Display active network connections
    Echo "netsh wlan to show wireless profiles"
    Write-Output "---------------------------------------------------------------------------"
    netsh wlan show profile   #View saved wireless networks
    Echo "Show network shares"
    ECho "---------------------------------------------------------------------------"
    net share
  }

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



