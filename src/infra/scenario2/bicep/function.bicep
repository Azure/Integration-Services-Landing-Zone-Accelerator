param location string
param appServicePlanName string
param provisionTeamsFunctionAppName string
param callbackFunctionAppName string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param keyVaultName string
param functionAppStorageAccountName string
param serviceBusNamespaceName string
param functionAADServicePrincipalClientIdSecretName string
param functionAADServicePrincipalClientSecretSecretName string
param callbackFunctionAppPrivateEndpointName string
param provisionTeamsFunctionAppPrivateEndpointName string
param functionAppStorageAccountPrivateEndpointName string
param appServicePrivateDnsZoneName string
param storageAccountPrivateDnsZoneName string
param vNetName string
param privateEndpointSubnetName string
param appServiceSubnetName string

resource functionAppStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: functionAppStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

module functionAppStorageAccountPrivateEndpoint 'private-endpoint.bicep' = {
  name: '${functionAppStorageAccount.name}-pe-deployment'
  params: {
    groupIds: [
      'blob'
    ]
    privateEndpointDnsZoneName: storageAccountPrivateDnsZoneName
    privateEndpointName: functionAppStorageAccountPrivateEndpointName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateLinkServiceId: functionAppStorageAccount.id
    vNetName: vNetName
    location: location
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: managedIdentityName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: appServicePlanName
}

resource appServiceSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' existing = {
  name: '${vNetName}/${appServiceSubnetName}'
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' existing = {
  name: serviceBusNamespaceName
}

resource provisionTeamsFunctionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: provisionTeamsFunctionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    keyVaultReferenceIdentity: managedIdentity.id
    httpsOnly: true
    virtualNetworkSubnetId: appServiceSubnet.id
    siteConfig: {
      powerShellVersion: '7.2'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'Recommended'
        }
        {
          name: 'ServiceBusConnection__fullyQualifiedNamespace'
          value: '${serviceBusNamespace.name}.servicebus.windows.net'
        }
        {
          name: 'ServiceBusConnection__credential'
          value: 'managedIdentity'
        }
        {
          name: 'ServiceBusConnection__clientId'
          value: managedIdentity.properties.clientId
        }
        {
          name: 'AzureAdClientId'
          value: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=${functionAADServicePrincipalClientIdSecretName})'
        }
        {
          name: 'AzureAdClientSecret'
          value: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=${functionAADServicePrincipalClientSecretSecretName})'
        }
        {
          name: 'AzureAdTenantId'
          value: subscription().tenantId
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionAppStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionAppStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(provisionTeamsFunctionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

module provisionTeamsFunctionAppPrivateEndpoint 'private-endpoint.bicep' = {
  name: '${provisionTeamsFunctionApp.name}-pe-deployment'
  params: {
    groupIds: [
      'sites'
    ]
    privateEndpointDnsZoneName: appServicePrivateDnsZoneName
    privateEndpointName: provisionTeamsFunctionAppPrivateEndpointName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateLinkServiceId: provisionTeamsFunctionApp.id
    vNetName: vNetName
    location: location
  }
}

resource callbackFunctionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: callbackFunctionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    keyVaultReferenceIdentity: managedIdentity.id
    httpsOnly: true
    virtualNetworkSubnetId: appServiceSubnet.id
    siteConfig: {
      powerShellVersion: '7.2'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'Recommended'
        }
        {
          name: 'ServiceBusConnection__fullyQualifiedNamespace'
          value: '${serviceBusNamespace.name}.servicebus.windows.net'
        }
        {
          name: 'ServiceBusConnection__credential'
          value: 'managedIdentity'
        }
        {
          name: 'ServiceBusConnection__clientId'
          value: managedIdentity.properties.clientId
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionAppStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionAppStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(provisionTeamsFunctionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

module callbackFunctionAppPrivateEndpoint 'private-endpoint.bicep' = {
  name: '${callbackFunctionApp.name}-pe-deployment'
  params: {
    groupIds: [
      'sites'
    ]
    privateEndpointDnsZoneName: appServicePrivateDnsZoneName
    privateEndpointName: callbackFunctionAppPrivateEndpointName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateLinkServiceId: callbackFunctionApp.id
    vNetName: vNetName
    location: location
  }
}

resource provisionTeamsFunctionAppNameDiagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: provisionTeamsFunctionApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

resource callbackFunctionAppNameDiagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: callbackFunctionApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output provisionTeamsFunctionAppName string = provisionTeamsFunctionApp.name
output callbackFunctionAppName string = callbackFunctionApp.name
