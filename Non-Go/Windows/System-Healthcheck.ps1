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
# TODO: add the More info panel
#

$runningGranted         = $false
$appsAndProgramsGranted = $false
$talkingOnlineGranted   = $false
$networkGranted         = $false
$accountGranted         = $false
$fileGranted            = $false


function CreatePopupWindow {
      <# 
      .NAME
          Untitled
      #>

      Add-Type -AssemblyName System.Windows.Forms
      [System.Windows.Forms.Application]::EnableVisualStyles()

      Write-Out "test"
      
      $Form                            = New-Object system.Windows.Forms.Form
      $Form.ClientSize                 = New-Object System.Drawing.Point(1179,553)
      $Form.text                       = "The Cyber Helpline information gathering tool"
      $Form.TopMost                    = $false

      $Label2                          = New-Object system.Windows.Forms.Label
      $Label2.text                     = "Welcome!"
      $Label2.AutoSize                 = $true
      $Label2.width                    = 25
      $Label2.height                   = 10
      $Label2.location                 = New-Object System.Drawing.Point(543,18)
      $Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label1                          = New-Object system.Windows.Forms.Label
      $Label1.text                     = "Do you agree to gather information around what is currently running on your computer with the helpline?"
      $Label1.AutoSize                 = $true
      $Label1.width                    = 25
      $Label1.height                   = 10
      $Label1.location                 = New-Object System.Drawing.Point(29,147)
      $Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label3                          = New-Object system.Windows.Forms.Label
      $Label3.text                     = "We invite you to read our privacy policy and terms of service before sharing the output of this tool with our responders."
      $Label3.AutoSize                 = $true
      $Label3.width                    = 25
      $Label3.height                   = 10
      $Label3.location                 = New-Object System.Drawing.Point(236,419)
      $Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button1                         = New-Object system.Windows.Forms.Button
      $Button1.text                    = "Start collection"
      $Button1.width                   = 169
      $Button1.height                  = 30
      $Button1.location                = New-Object System.Drawing.Point(506,455)
      $Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button2                         = New-Object system.Windows.Forms.Button
      $Button2.text                    = "More info"
      $Button2.width                   = 109
      $Button2.height                  = 30
      $Button2.location                = New-Object System.Drawing.Point(1026,144)
      $Button2.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Consent                         = New-Object system.Windows.Forms.Label
      $Consent.text                    = "consent"
      $Consent.AutoSize                = $true
      $Consent.width                   = 25
      $Consent.height                  = 10
      $Consent.location                = New-Object System.Drawing.Point(869,118)
      $Consent.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label4                          = New-Object system.Windows.Forms.Label
      $Label4.text                     = "See commands"
      $Label4.AutoSize                 = $true
      $Label4.width                    = 25
      $Label4.height                   = 10
      $Label4.location                 = New-Object System.Drawing.Point(1042,113)
      $Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label5                          = New-Object system.Windows.Forms.Label
      $Label5.text                     = "Do you agree to gather information around apps & programs installed on your computer?"
      $Label5.AutoSize                 = $true
      $Label5.width                    = 25
      $Label5.height                   = 10
      $Label5.location                 = New-Object System.Drawing.Point(29,184)
      $Label5.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button3                         = New-Object system.Windows.Forms.Button
      $Button3.text                    = "More info"
      $Button3.width                   = 109
      $Button3.height                  = 30
      $Button3.location                = New-Object System.Drawing.Point(1026,181)
      $Button3.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label6                          = New-Object system.Windows.Forms.Label
      $Label6.text                     = "Do you agree to gather information around what programs are talking over the internet on your computer?"
      $Label6.AutoSize                 = $true
      $Label6.width                    = 25
      $Label6.height                   = 10
      $Label6.location                 = New-Object System.Drawing.Point(29,222)
      $Label6.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button4                         = New-Object system.Windows.Forms.Button
      $Button4.text                    = "More info"
      $Button4.width                   = 109
      $Button4.height                  = 30
      $Button4.location                = New-Object System.Drawing.Point(1026,218)
      $Button4.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label7                          = New-Object system.Windows.Forms.Label
      $Label7.text                     = "Do you agree to gather information around how you connect to the internet?"
      $Label7.AutoSize                 = $true
      $Label7.width                    = 25
      $Label7.height                   = 10
      $Label7.location                 = New-Object System.Drawing.Point(29,262)
      $Label7.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button5                         = New-Object system.Windows.Forms.Button
      $Button5.text                    = "More info"
      $Button5.width                   = 109
      $Button5.height                  = 30
      $Button5.location                = New-Object System.Drawing.Point(1026,255)
      $Button5.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label8                          = New-Object system.Windows.Forms.Label
      $Label8.text                     = "Do you agree to gather information around different accounts on your computer?"
      $Label8.AutoSize                 = $true
      $Label8.width                    = 25
      $Label8.height                   = 10
      $Label8.location                 = New-Object System.Drawing.Point(29,302)
      $Label8.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button6                         = New-Object system.Windows.Forms.Button
      $Button6.text                    = "More info"
      $Button6.width                   = 109
      $Button6.height                  = 30
      $Button6.location                = New-Object System.Drawing.Point(1026,293)
      $Button6.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label9                          = New-Object system.Windows.Forms.Label
      $Label9.text                     = "Do you agree to gather the names (but not contents) of all files on this computer?"
      $Label9.AutoSize                 = $true
      $Label9.width                    = 25
      $Label9.height                   = 10
      $Label9.location                 = New-Object System.Drawing.Point(29,332)
      $Label9.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Button7                         = New-Object system.Windows.Forms.Button
      $Button7.text                    = "More info"
      $Button7.width                   = 109
      $Button7.height                  = 30
      $Button7.location                = New-Object System.Drawing.Point(1026,333)
      $Button7.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label10                         = New-Object system.Windows.Forms.Label
      $Label10.text                    = "This tool is designed to make it easy for you to send us useful system information. Send the file it creates to your responder.         "
      $Label10.AutoSize                = $true
      $Label10.width                   = 25
      $Label10.height                  = 10
      $Label10.location                = New-Object System.Drawing.Point(212,56)
      $Label10.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Label11                         = New-Object system.Windows.Forms.Label
      $Label11.text                    = "Description"
      $Label11.AutoSize                = $true
      $Label11.width                   = 25
      $Label11.height                  = 10
      $Label11.location                = New-Object System.Drawing.Point(444,107)
      $Label11.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $CheckBox1                       = New-Object system.Windows.Forms.CheckBox
      $CheckBox1.text                  = "I consent"
      $CheckBox1.AutoSize              = $false
      $CheckBox1.width                 = 130
      $CheckBox1.height                = 20
      $CheckBox1.location              = New-Object System.Drawing.Point(841,156)
      $CheckBox1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $CheckBox3                       = New-Object system.Windows.Forms.CheckBox
      $CheckBox3.text                  = "I consent"
      $CheckBox3.AutoSize              = $false
      $CheckBox3.width                 = 111
      $CheckBox3.height                = 20
      $CheckBox3.location              = New-Object System.Drawing.Point(840,197)
      $CheckBox3.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $CheckBox4                       = New-Object system.Windows.Forms.CheckBox
      $CheckBox4.text                  = "I consent"
      $CheckBox4.AutoSize              = $false
      $CheckBox4.width                 = 110
      $CheckBox4.height                = 20
      $CheckBox4.location              = New-Object System.Drawing.Point(841,240)
      $CheckBox4.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $CheckBox5                       = New-Object system.Windows.Forms.CheckBox
      $CheckBox5.text                  = "I consent"
      $CheckBox5.AutoSize              = $false
      $CheckBox5.width                 = 110
      $CheckBox5.height                = 20
      $CheckBox5.location              = New-Object System.Drawing.Point(841,271)
      $CheckBox5.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $CheckBox6                       = New-Object system.Windows.Forms.CheckBox
      $CheckBox6.text                  = "I consent"
      $CheckBox6.AutoSize              = $false
      $CheckBox6.width                 = 110
      $CheckBox6.height                = 20
      $CheckBox6.location              = New-Object System.Drawing.Point(841,310)
      $CheckBox6.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $CheckBox7                       = New-Object system.Windows.Forms.CheckBox
      $CheckBox7.text                  = "I consent"
      $CheckBox7.AutoSize              = $false
      $CheckBox7.width                 = 110
      $CheckBox7.height                = 20
      $CheckBox7.location              = New-Object System.Drawing.Point(841,348)
      $CheckBox7.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

      $Form.controls.AddRange(@($Label2,$Label1,$Label3,$Button1,$Button2,$Consent,$Label4,$Label5,$Button3,$Label6,$Button4,$Label7,$Button5,$Label8,$Button6,$Label9,$Button7,$Label10,$Label11,$CheckBox1,$CheckBox3,$CheckBox4,$CheckBox5,$CheckBox6,$CheckBox7))
     
      $Button1.Add_Click({onSubmit})
      $CheckBox1.Add_CheckedChanged({ $runningGranted         = $true  })
      $CheckBox3.Add_CheckedChanged({ $appsAndProgramsGranted = $true  })
      $CheckBox4.Add_CheckedChanged({ $talkingOnlineGranted   = $true  })
      $CheckBox5.Add_CheckedChanged({ $networkGranted         = $true })
      $CheckBox6.Add_CheckedChanged({ $accountGranted         = $true })
      $CheckBox7.Add_CheckedChanged({ $fileGranted            = $true })
      
      #region Logic 

      #endregion

      [void]$Form.ShowDialog() 
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

function onSubmit{
      
      
      if ($runningGranted){ currentlyRunning }
      if ($appsAndProgramsGranted){ getInstalledStuff }
      if ($talkingOnlineGranted){ currentlyTalking }
      if ($networkGranted){ howYouConnectToInternet }
      if ($accountGranted){ usersAndGroups environmentInfo }
      if ($fileGranted){ fileNames }
      
      
      # This will compress and send the archive. 
      $compress = @{
        Path = "~\Documents\HelplineOutput"
        CompressionLevel = "Fastest"
        DestinationPath = "~/Documents"}
      Compress-Archive @compress
      
}

Write-Out "test out of func"
CreatePopupWindow



