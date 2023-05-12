param([System.Collections.Hashtable] $callbackMessage, $TriggerMetadata)

Write-Information ("Calling callback URL {0} with response {1}..." -f $callbackMessage.uri, $callbackMessage.response.status)

Invoke-RestMethod -Method $callbackMessage.method `
  -Uri $callbackMessage.uri `
  -Body ($callbackMessage.response | ConvertTo-Json) `
  -ContentType "application/json"

Write-Information ("Called callback URL {0} with response {1}" -f $callbackMessage.uri, $callbackMessage.response.status)