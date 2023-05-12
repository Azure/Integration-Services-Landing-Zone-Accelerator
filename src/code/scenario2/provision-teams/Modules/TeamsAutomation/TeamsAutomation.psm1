function New-TeamsItems {
  param ($GraphToken, $TeamsToken, $OwnerUserPrincipalName, $TeamName, $ChannelName)

  Write-Information "Connecting to Microsoft Teams API..."

  Connect-MicrosoftTeams -AccessTokens @("$GraphToken", "$TeamsToken") | Out-Null

  Write-Information "Connected to Microsoft Teams API"

  Write-Information "Creating team ${TeamName}..."

  $group = New-Team -DisplayName $TeamName `
    -Visibility Public `
    -Owner $OwnerUserPrincipalName

  Write-Information "Created team ${TeamName}"

  Write-Information "Adding user ${OwnerUserPrincipalName} as owner..."

  Add-TeamUser -GroupId $group.GroupId `
    -User $OwnerUserPrincipalName `
    -Role Owner

  Write-Information "Added user ${OwnerUserPrincipalName} as owner"

  Write-Information "Creating channel ${ChannelName}..."

  New-TeamChannel -GroupId $group.GroupId `
    -DisplayName $ChannelName

  Write-Information "Created channel ${ChannelName}"
}

Export-ModuleMember -Function New-TeamsItems