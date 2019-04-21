function Show-Menu 
{ 
     param ( 
           [string]$Title = 'My Menu' 
     ) 
     cls 
     Write-Host "================ $Title ================" 
     
     Write-Host "1: Press '1' Add User." 
     Write-Host "2: Press '2' Change User." 
     Write-Host "3: Press '3' for this option." 
     Write-Host "Q: Press 'Q' to quit." 
} 
do 
{ 
     Show-Menu 
     $input = Read-Host "Please make a selection" 
     switch ($input) 
     { 
           '1' { 
               
			    $ScriptPath = Split-Path $MyInvocation.InvocationName
				& "$ScriptPath\add-user.ps1"
                
				Exit 1
				
           } '2' { 
			 
				$ScriptPath = Split-Path $MyInvocation.InvocationName
				& "$ScriptPath\change-pwd-user.ps1"
             
				Exit 1
				
           } '3' { 
                cls 
                'You chose option #3' 
           } 'q' { 
                return 
           } 
     } 
     pause 
} 
until ($input -eq 'q') 