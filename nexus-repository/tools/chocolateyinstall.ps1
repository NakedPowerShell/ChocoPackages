
$packageid = "nexus-repository"
$url = 'http://download.sonatype.com/nexus/3/nexus-3.0.0-m7-win64.exe'
$checksum = '0D0A271147CB0639B778BC7469BF5FB8E837390B'
$checksumtype = 'sha1'
$installfolder = "c:\Program Files\Nexus"
$silentargs = "-q -console -dir `"$installfolder`""
$validExitCodes = @(0)

$packageName= 'nexus-repository'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$downloadedfile = "$toolsDir\$packageNameinstall.exe"

If (Test-Path "$installfolder\bin\uninstall.exe")
{
  Throw "There appears to be an installation of Nexus at `"$installfolder`", please remove it and try this package again."
}

Write-Warning "Installation log will be at $env:temp\i4j_nlog_<SEQ#>"

If (!(Get-ProcessorBits -eq 64))
{
  Throw "Sonatype Nexus Repository 3.0.0 and greater only supports 64-bit Windows."
}
Else
{
  #$env:temp\chocolatey\$packageid\3.0.0\nexus-repositoryinstall.exe
  #block install to prevent firewall popup, does not affect installation completing normally
  Get-ChocolateyWebFile -packageName $packageName -filefullpath $downloadedfile -url64 $url -checksum64 $checksum -checksumtype64 $checksumtype
  netsh advfirewall firewall add rule name="nexus-respositoryInstall.exe" program="$downloadedfile" dir=in action=block
  Install-ChocolateyInstallPackage -packageName $packageName -fileType 'EXE' -file $downloadedfile -silentargs $silentargs
  netsh advfirewall firewall delete rule name="nexus-respositoryInstall.exe"
}

Write-Warning "`r`n"
Write-Warning "***************************************************************************"
Write-Warning "*  You can manage the repository by visiting http://localhost:8081"
Write-Warning "*  The default user is 'admin' with password 'admin123'"
Write-Warning "*  Nexus availability is controlled via the service `"$servicename`""
Write-Warning "***************************************************************************"
