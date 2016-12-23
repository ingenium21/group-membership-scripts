 # Get resursive user members for a particular USER
    Clear-Host
    $userName = Read-Host "Enter user name you wish to check recursive group membership for: "
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement            
    $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain            
    $user = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($ct,$userName)                  
    $user.GetAuthorizationGroups() | Select-Object SamAccountName, Description | Sort-Object -Property SamAccountName -Descending | Out-GridView

    # Get resursive user members for a particular SECURITY GROUP 
    $groupname = Read-Host "Enter the account name of the security group whose recusive members you wish to enumerate: "
    $dn = (Get-ADGroup $groupname).DistinguishedName
    $Users = Get-ADUser -LDAPFilter "(memberOf:1.2.840.113556.1.4.1941:=$dn)" | Out-GridView

    # Get resursive user members for a particular DISTRIBUTION GROUP
    $groupname = Read-Host "Enter the display name of the distribution list whose recursive membership you wish to enumerate: "
    $groupDN = Get-ADGroup $groupname | Select-Object -ExpandProperty DistinguishedName
    $LDAPFilterString = "(memberOf:1.2.840.113556.1.4.1941:=" + $groupDN + ")"
    $Users = Get-ADUser -LDAPFilter $LDAPFilterString | Select-Object UserPrincipalName | Out-GridView

    # Get all the groups that a user has DIRECT membership of
    $User = Read-Host "Enter the username of the user for which you wish to search: "
    Get-ADUser $User | Get-ADPrincipalGroupMembership | Select-Object -ExpandProperty Name | Out-GridView
