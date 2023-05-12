param keyVaultName string
param location string
param logAnalyticsWorkspaceName string
param managedIdentityName string
param functionAADServicePrincipalClientIdSecretName string
@secure()
param functionAADServicePrincipalClientId string
param functionAADServicePrincipalClientSecretSecretName string
@secure()
param functionAADServicePrincipalClientSecret string
param keyVaultPrivateEndpointName string
param vNetName string
param privateEndpointSubnetName string
param keyVaultDnsZoneName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    enabledForTemplateDeployment: true
    accessPolicies: [
      {
        objectId: managedIdentity.properties.principalId
        tenantId: managedIdentity.properties.tenantId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

module privateEndpoint 'private-endpoint.bicep' = {
  name: '${keyVault.name}-privateEndpoint-deployment'
  params: {
    groupIds: [
      'vault'
    ]
    privateEndpointDnsZoneName: keyVaultDnsZoneName
    privateEndpointName: keyVaultPrivateEndpointName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateLinkServiceId: keyVault.id
    vNetName: vNetName
    location: location
  }
}

resource functionAADServicePrincipalClientIdSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: functionAADServicePrincipalClientIdSecretName
  parent: keyVault
  properties: {
    value: functionAADServicePrincipalClientId
  }
}

resource functionAADServicePrincipalClientSecretSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: functionAADServicePrincipalClientSecretSecretName
  parent: keyVault
  properties: {
    value: functionAADServicePrincipalClientSecret
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
      {
        category: 'AzurePolicyEvaluationDetails'
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

output keyVaultName string = keyVault.name
output keyVaultResourceId string = keyVault.id
output functionAADServicePrincipalClientIdSecretName string = functionAADServicePrincipalClientIdSecretName
output functionAADServicePrincipalClientSecretSecretName string = functionAADServicePrincipalClientSecretSecretName
