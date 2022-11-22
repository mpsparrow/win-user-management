######################################################
# Windows User Management Script
# By Matthew Sparrow
######################################################

# Create a new user
function CreateUser
{
    param (
        [Parameter(Mandatory=$true,Position=0)] $Username,
        [Parameter(Mandatory=$true,Position=1)] $Password,
        [Parameter(Mandatory=$true,Position=2)] $Description
    )

    if(Get-LocalUser | Where-Object {$_.Name -eq $Username})
    {
        # User exists
        Write-Output "Warning! User $Username already exists."
    } else {
        # Create new user
        New-LocalUser $Username -Password $Password -Description $Description | Out-Null
        Write-Output "User $Username successfully created!"
    }
}

# Change a users password
function ChangePassword
{
    param (
        [Parameter(Mandatory=$true,Position=0)] $Username,
        [Parameter(Mandatory=$true,Position=1)] $Password
    )

    if(Get-LocalUser | Where-Object {$_.Name -eq $Username})
    {
        # Change user password
        Set-LocalUser -Name $Username -Password $Password | Out-Null
        Write-Output "User $Username password successfully changed!"
    } else {
        # User doesn't exist
        Write-Output "Warning! User $Username does not exist."
    }
}

# Create a new group
function CreateGroup
{
    param (
        [Parameter(Mandatory=$true,Position=0)] $GroupName,
        [Parameter(Mandatory=$true,Position=1)] $Description
    )

    if(Get-LocalGroup | Where-Object {$_.Name -eq $GroupName})
    {
        # Group exists
        Write-Output "Warning! Group $GroupName already exists."
    } else {
        # Create group
        New-LocalGroup $GroupName -Description $Description | Out-Null
        Write-Output "Group $GroupName successfully created!"
    }
}

# Adds user to a group
function AddUserGroup
{
    param (
        [Parameter(Mandatory=$true,Position=0)] $Username,
        [Parameter(Mandatory=$true,Position=1)] $GroupName
    )

    if(Get-LocalUser | Where-Object {$_.Name -eq $Username})
    {
        # User exists

        if(Get-LocalGroup | Where-Object {$_.Name -eq $GroupName})
        {
            # Group exists

            if(Get-LocalGroupMember $GroupName | Where-Object {$_.Name -eq $env:computername + "\" + $Username})
            {
                # User already in group
                Write-Output "Warning! User $Username already in group $GroupName."
            } else {
                # Add user to group
                Add-LocalGroupMember -Group $GroupName -Member $Username | Out-Null
                Write-Output "User $Username added to group $GroupName."
            }
        } else {
            # Group doesn't exist
            Write-Output "Warning! Group $GroupName does not exist."
        }
    } else {
        # User doesn't exist
        Write-Output "Warning! User $Username does not exist."
    }
}

# Pauses execution of script for given amount of time
function PauseScript
{
    param (
        [Parameter(Mandatory=$true,Position=0)] $Length
    )

    Write-Output "`r`n`r`nPausing for $Length seconds..."
    $Length..1 | % {
        write "$_"
        Start-Sleep -Seconds 1
    }
}

# While loop state variable
$ExitBool = 0

while ($ExitBool -eq 0)
{
    clear-host
    Write-Output "User Management Menu"
    Write-Output "`r`n"
    Write-Output "[1] Create User"
    Write-Output "[2] Change User Password"
    Write-Output "[3] Create Group"
    Write-Output "[4] Add User to Group"
    Write-Output "[5] Quit Program"
    Write-Output "`r`n"

    $menuItem = Read-Host -Prompt "Enter Menu Item "

    clear-host

    Switch ($menuitem) {
        1 { 
            # CreateUser
            Write-Output "Creating User"

            # Get User Input
            $getUserName = Read-Host -Prompt "Enter Username"
            $getPassword = Read-Host -Prompt "Enter Secure Password" | ConvertTo-SecureString -AsPlainText -Force
            $getDescription = Read-Host -Prompt "Enter User Description"
            Write-Output "`r`n"

            # Run CreateUser Function
            CreateUser $getUserName $getPassword $getDescription

            # Pause
            PauseScript 5
        }
        2 { 
            # ChangePassword
            Write-Output "Changing User Password"

            # Get User Input
            $getUserName = Read-Host -Prompt "Enter Username"
            $getPassword = Read-Host -Prompt "Enter Secure Password" | ConvertTo-SecureString -AsPlainText -Force
            Write-Output "`r`n"

            # Run ChangePassword Function
            ChangePassword $getUserName $getPassword

            # Pause
            PauseScript 5
        }
        3 { 
            # CreateGroup
            Write-Output "Creating Group"

            # Get User Input
            $getGroupName = Read-Host -Prompt "Enter Group Name"
            $getDescription = Read-Host -Prompt "Enter Group Description"
            Write-Output "`r`n"

            # Run CreateGroup
            CreateGroup $getGroupName $getDescription

            # Pause
            PauseScript 5
        }
        4 {
            # AddUserGroup
            Write-Output "Adding User to Group"

            # Get User Input
            $getUserName = Read-Host -Prompt "Enter Username"
            $getGroupName = Read-Host -Prompt "Enter Group Name"
            Write-Output "`r`n"

            # Run AddUserGroup
            AddUserGroup $getUserName $getGroupName

            # Pause
            PauseScript 5
        }
        5 {
            # Exit script
            $ExitBool = 1
            Write-Output "Goodbye"
        }
        default {
            # If menu item invalid
            Write-Output "Invalid input"
        }
    }
}
