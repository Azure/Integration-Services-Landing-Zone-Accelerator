param([System.Collections.Hashtable] $provisionTeamsMessage, $TriggerMetadata)

$ErrorActionPreference = "Stop"

Import-Module TeamsAuthentication
Import-Module TeamsAutomation

$clientSecret = $env:AzureAdClientSecret
$applicationId = $env:AzureAdClientId
$tenantId = $env:AzureAdTenantId

$graphToken, $teamsToken = Get-TeamsAccessTokens -ApplicationId $applicationId `
  -ClientSecret $clientSecret `
  -TenantId $tenantId

$response = @{
  uri      = $provisionTeamsMessage.clientCallback.uri;
  method   = $provisionTeamsMessage.clientCallback.method;
  response = @{
    token   = $provisionTeamsMessage.clientCallback.token;
    status  = "Success";
    message = "Team provisioned successfully"
  }
}

try {
  New-TeamsItems -GraphToken $graphToken `
    -TeamsToken $teamsToken `
    -OwnerUserPrincipalName $provisionTeamsMessage.request.ownerUserPrincipalName `
    -TeamName $provisionTeamsMessage.request.teamName `
    -ChannelName $provisionTeamsMessage.request.channelName
}
catch {
  $response.response.status = "Failed"
  $response.response.message = $_.Exception.Message
}

Push-OutputBinding -Name "callbackTopic" `
  -Value $response