###
# Purpose        : 
# Created        : 
# Author         : 
# Pre-requisites : 
###

#---------------------------------------------------------- 
# LOAD ASSEMBLIES AND MODULES 
#---------------------------------------------------------- 
Try 
{ 
  Import-Module ActiveDirectory -ErrorAction Stop 
} 
Catch 
{ 
  Write-Host "[ERROR]`t ActiveDirectory Module couldn't be loaded. Script will stop!" 
  Exit 1 
} 
 
 
#---------------------------------------------------------- 
# ADD USER TO AD
#---------------------------------------------------------- 

##AD

		$Domain = "domain.nl"
		# $AD_Group = "AD-group"
		# $AD_User_DN = "OU=Users,DC=domain,DC=nl"
		
#------------------------------------------------------------

## change user


$Identity=Read-Host -Prompt "Enter User Name"

Import-Module ActiveDirectory

## Search user
Try {
    Get-ADUser $Identity -wa Stop -ea Stop
} Catch {
    Write "[$($_.Exception.GetType().FullName)] - $($_.Exception.Message)"
    Write-Host "[ERROR]`t User can't be found. Script will stop!" 
	Exit 1
}


$Title = ""
$Info = "Auto Wachtwoord of Handmatige Invoer?"
 
$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Auto", "&Handmatig", "&Quit")
[int]$defaultchoice = 2
$opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
switch($opt)
{
0 { 
	#Write-Host "auto" -ForegroundColor Green
	
	$password=Get-Random -InputObject (get-content password-list.txt)
		
	# change password
	Set-ADAccountPassword -Identity $Identity  -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) -PassThru -Confirm:$false
	
	# never have to change password
	# Set-ADUser -ChangePasswordAtLogon $true -Identity $Identity -Confirm:$false -verbose
	
	
	Write-Host "########################################################"
	Write-Host ""
	Write-Host "Password:" $password -ForegroundColor Red
	Write-Host ""
	Write-Host "########################################################"
	
	
  }
1 { 
	#Write-Host "manuel" -ForegroundColor Green
	
	$password=Read-Host -Prompt "Enter Password"
	
	# change password
	Set-ADAccountPassword -Identity $Identity  -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) -PassThru -Confirm:$false
	
	# never have to change password
	# Set-ADUser -ChangePasswordAtLogon $true -Identity $Identity -Confirm:$false -verbose

  }
2 {Write-Host "Good Bye!!!" -ForegroundColor Green}
}

























