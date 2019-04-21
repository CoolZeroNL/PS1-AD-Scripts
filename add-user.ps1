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
	$AD_Group = "AD-group"
	$AD_User_DN = "OU=Users,DC=domain,DC=nl"
	
#------------------------------------------------------------

$Name=Read-Host -Prompt "Enter Name"

Try {
    $user =  Get-ADUser $Name -ErrorAction Stop
    $False
}
catch {
    $True
}


If ($user) {
	Write-Host "User Exitst"
	Exit 1
}

$GivenName=Read-Host -Prompt "Enter GivenName"
$LastName=Read-Host -Prompt "Enter LastName"
$SamAccountName=Read-Host -Prompt "Enter SamAccountName"
$UserPrincipalName=Read-Host -Prompt "Enter UserPrincipalName"
$Initials = Read-Host -Prompt "Enter Initials"
$AccountPassword=Read-Host -Prompt "Enter AccountPassword"


$selection = get-content afdelingen-ou.txt

If($selection.Count -gt 1){
    
    $title = "DN Selection"
    $message = "Which OU would you like to use?"

    # Build the choices menu
    $choices = @()
    For($index = 0; $index -lt $selection.Count; $index++){
		$line=$selection[$index]
        $choices += New-Object System.Management.Automation.Host.ChoiceDescription ("$line &$($index+1)")		
    }

    $options = [System.Management.Automation.Host.ChoiceDescription[]] @($choices)
    $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

    $selection = $selection[$result]
	
}

# $selection

$AD_User_DN_new = "$selection,$AD_User_DN"
Write-Host $AD_User_DN_new

#------------------------------------------------------------

Import-Module ActiveDirectory

#------------------------------------------------------------

## Search user

	Write-Host "Create User"
    
	New-ADUser -Name "$Name" -GivenName "$GivenName" -Initials $Initials -Surname "$LastName" `
	-DisplayName ($GivenName + " " + $LastName) `
	-SamAccountName "$SamAccountName" -UserPrincipalName "$UserPrincipalName" `
	-AccountPassword (ConvertTo-SecureString -AsPlainText "$AccountPassword" -Force) `
	-Path "$AD_User_DN_new" `
	-PassThru | Enable-ADAccount

#------------------------------------------------------------

## SET PASSWORD NEVER EXPIRES

	Write-Host "Never Expes"

	Set-ADUser -Identity "$SamAccountName" -PasswordNeverExpires $true

#------------------------------------------------------------

## ADD USER TO GROUP

	Add-ADGroupMember -Identity "$AD_Group" -Member "$SamAccountName"

#------------------------------------------------------------






















