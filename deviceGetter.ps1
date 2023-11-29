$RequiredScopes = @("GroupMember.ReadWrite.All", "Device.Read.All")
Connect-MgGraph -Scopes $RequiredScopes

$global:groupWorkers = @(   "0000000-0000-0000-0000-000000000",
                            "0000000-0000-0000-0000-000000000",
                            "0000000-0000-0000-0000-000000000",
                            "0000000-0000-0000-0000-000000000",
                            "0000000-0000-0000-0000-000000000"
                        )  

function deviceGetter {

    $csvFilePath = "C:\Users\adam\Downloads\related-assets.csv"
    $devices1 = Get-MgDeviceManagementManagedDevice -All | Select-Object "UserPrincipalName", "DeviceName"
    $devices2 = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty A | Select-Object -Skip 2 -First 38
    $devices3 = $devices1 | Where-Object { $devices2 -contains $_.DeviceName } | Select-Object DeviceName, UserPrincipalName
    $userlist = $devices3 | Where-Object { $_.UserPrincipalName -like "*@adams.com" }
    $userlistUPN = $userlist.UserPrincipalName 
    $refinedlist = $userlistUPN | Select-Object -Unique
}
 
function userGetter {
    $userIds = foreach ($userUPN in $groupWorkers) {
        Get-MgUser -UserId $userUPN
    }
}

deviceGetter
userGetter

foreach ($userId in $userIds) {
    New-MgGroupMember -GroupId "0000000-0000-0000-0000-000000000" -DirectoryObjectId $userIds[23]
    }
}
