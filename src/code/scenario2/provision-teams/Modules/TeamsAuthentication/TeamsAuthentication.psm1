function Get-TeamsAccessTokens {
  param ($ApplicationId, $ClientSecret, $TenantId)

  $graphTokenBody = @{   
    Grant_Type    = "client_credentials"   
    Scope         = "https://graph.microsoft.com/.default"   
    Client_Id     = $ApplicationId
    Client_Secret = $ClientSecret   
  }

  Write-Information "Retriving Graph token..."

  $graphToken = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $graphTokenBody | Select-Object -ExpandProperty Access_Token 
  
  Write-Information "Retrieved Graph token"

  $teamsTokenBody = @{   
    Grant_Type    = "client_credentials"   
    Scope         = "48ac35b8-9aa8-4d74-927d-1f4a14a0b239/.default"   
    Client_Id     = $ApplicationId   
    Client_Secret = $ClientSecret 
  } 
  
  Write-Information "Retriving Teams token..."

  $teamsToken = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $teamsTokenBody | Select-Object -ExpandProperty Access_Token
  
  Write-Information "Retrieved Teams token"

  return @($graphToken, $teamsToken)
}

Export-ModuleMember -Function Get-TeamsAccessTokens