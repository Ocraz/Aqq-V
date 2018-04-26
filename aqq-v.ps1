# This script has been created by Zarco Zwier, Aug 6th, 2017
# This script can freely be re-used and distributed as long as this comment remains.
# WARNING: THIS SCRIPT MESSES WITH YOUR SUBSTED OR NETWORK MAPPED DRIVES!
# USE AT YOUR OWN RISK AND ONLY FOR BENIGN PURPOSES!

param (
	[string]$method = "subst",
	[string]$hideq
)

function DriveMapping {
	Param([char]$letterStart,[char]$LetterEnd,[string]$Method, [bool]$Enabled)
	
	For ([byte]$l = [char]$letterStart; $l -le [char]$LetterEnd; $l++){	
		$letter = [char[]]$l
			$EnableDrive= "SUBST "+$letter+": C:\"
			$DisableDrive="SUBST "+$letter+": /D"

		If ($Enabled -eq $True -and !(Test-Path $Letter":")) {
			$output = & cmd.exe /c $EnableDrive
		}
		
		If ($Enabled -eq $False) {
				$output = & cmd.exe /c $DisableDrive
		}
	}
}

Write-Host "Creating C: - P:, insert USB-drive, waiting for Q:"
DriveMapping -letterStart 'C' -letterEnd 'P' -Method $method -Enabled $True

While (!(Get-PsDrive | Where{$_.Name -eq 'Q'})) {}

Write-Host "Q: detected, removing C: - P:"
DriveMapping -letterStart 'C' -letterEnd 'P' -Method $method -Enabled $False
