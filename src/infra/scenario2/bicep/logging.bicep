param logAnalyticsWorkspaceName string
param appInsightsName string
param vNetName string
param privateEndpointSubnetName string
param location string
param privateLinkScopePrivateEndpointName string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Enabled'
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  tags: {}
}

resource privateLinkScope 'microsoft.insights/privateLinkScopes@2021-07-01-preview' = {
  name: 'private-link-scope'
  location: 'global'
  properties: {
    accessModeSettings: {
      ingestionAccessMode: 'Open'
      queryAccessMode: 'Open'
    }
  }
}

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' existing = {
  name: '${vNetName}/${privateEndpointSubnetName}'
}

resource privateLinkScopePrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: privateLinkScopePrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: privateLinkScope.name
        properties: {
          privateLinkServiceId: privateLinkScope.id
          groupIds: [
            'azuremonitor'
          ]
        }
      }
    ]
  }
}

resource logAnalyticsScopedResource 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  parent: privateLinkScope
  name: '${logAnalytics.name}-connection'
  properties: {
    linkedResourceId: logAnalytics.id
  }
}

resource appInsightsScopedResource 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  parent: privateLinkScope
  name: '${appInsights.name}-connection'
  properties: {
    linkedResourceId: appInsights.id
  }
}

output logAnalyticsWorkspaceName string = logAnalytics.name
output appInsightsName string = appInsights.name
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
