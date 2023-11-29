Connect-MgGraph
Connect-MicrosoftTeams
$userId = ""
$teamId = "0000000-0000-0000-0000-000000000"
$nocSched = Get-MgTeamScheduleShift -teamId $teamId -All
$lastDayShifts = $nocSched | Where-Object { $_.SharedShift.EndDateTime.ToString('yyyy-MM-dd') -like '2023-04-02*' } | Select-Object -Property Id
$getShifts = foreach ($shift in $lastDayShifts.Id) {
    Get-MgTeamScheduleShift -teamId $teamId -ShiftId $shift
}
$lastShift = $getShifts | Where-Object { $_.UserId -eq $userId } | Select-Object UserId, @{Name="Start Time";Expression={$_.SharedShift.StartDateTime.AddHours(-7).ToString("yyyy-MM-dd hh:mm:ss tt 'PST'")}}, @{Name="End Time";Expression={$_.SharedShift.EndDateTime.AddHours(-7).ToString("yyyy-MM-dd hh:mm:ss tt 'PST'")}}
$user = Get-MgUser -UserId $lastshift.UserId
$lastshift | Add-Member -NotePropertyMembers @{
    "DisplayName" = $user.DisplayName
    "UserPrincipalName" = $user.UserPrincipalName
}
$lastshift
