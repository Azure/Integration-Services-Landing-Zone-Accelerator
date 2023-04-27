param location string
param appServicePlanName string
param appServicePlanSku string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'Windows'
  sku: {
    name: appServicePlanSku
  }
  properties: {}
}

output appServicePlanName string = appServicePlan.name
