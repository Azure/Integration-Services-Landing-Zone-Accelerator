function New-TeamsItems {
  param ($GraphToken, $TeamsToken, $UserPrincipalName, $TeamName, $ChannelName)

  Write-Information "Connecting to Microsoft Teams API..."

  Connect-MicrosoftTeams -AccessTokens @("$GraphToken", "$TeamsToken")

  Write-Information "Connected to Microsoft Teams API"

  Write-Information "Creating team ${TeamName}..."

  $group = New-Team -DisplayName $TeamName `
    -Visibility Public `
    -Owner $UserPrincipalName

  Write-Information "Created team ${TeamName}"

  Write-Information "Adding user ${UserPrincipalName} as owner..."

  Add-TeamUser -GroupId $group.GroupId `
    -User $UserPrincipalName `
    -Role Owner

  Write-Information "Added user ${UserPrincipalName} as owner"

  Write-Information "Creating channel ${ChannelName}..."

  New-TeamChannel -GroupId $group.GroupId `
    -DisplayName $ChannelName

  Write-Information "Created channel ${ChannelName}"
}

Export-ModuleMember -Function New-TeamsItems