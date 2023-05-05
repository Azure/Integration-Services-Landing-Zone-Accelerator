param appName string
param region string
param environment string
param location string = resourceGroup().location
@secure()
param functionAADServicePrincipalClientId string
@secure()
param functionAADServicePrincipalClientSecret string
param vNetAddressPrefix string
param privateEndpointSubnetAddressPrefix string
param appServicePlanSku string
param appServiceSubnetAddressPrefix string
param enableTelemetry bool = true

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    environment: environment
  }
}

var serviceBusPrivateDnsZoneName = 'privatelink.servicebus.windows.net'
var appServicePrivateDnsZoneName = 'privatelink.azurewebsites.net'
var storageAccountPrivateDnsZoneName = 'privatelink.blob.${az.environment().suffixes.storage}'
var keyVaultPrivateDnsZoneName = 'privatelink.vaultcore.azure.net'
var monitorPrivateDnsZoneName = 'privatelink.monitor.azure.com'
var omsPrivateDnsZoneName = 'privatelink.oms.opinsights.azure.com'
var odsPrivateDnsZoneName = 'privatelink.ods.opinsights.azure.com'
var agentSvcPrivateDnsZoneName = 'privatelink.agentsvc.azure-automation.net'
var applicationInsightsPrivateDnsZoneName = 'privatelink.applicationinsights.azure.com'

var privateDnsZoneNames = [
  keyVaultPrivateDnsZoneName
  serviceBusPrivateDnsZoneName
  monitorPrivateDnsZoneName
  omsPrivateDnsZoneName
  odsPrivateDnsZoneName
  agentSvcPrivateDnsZoneName
  storageAccountPrivateDnsZoneName
  appServicePrivateDnsZoneName
  applicationInsightsPrivateDnsZoneName
]

module dnsDeployment 'dns.bicep' = [for privateDnsZoneName in privateDnsZoneNames: {
  name: 'dns-deployment-${privateDnsZoneName}'
  scope: resourceGroup()
  params: {
    privateDnsZoneName: privateDnsZoneName
  }
}]

module loggingDeployment 'logging.bicep' = {
  name: 'logging-deployment'
  params: {
    appInsightsName: names.outputs.appInsightsName
    privateLinkScopePrivateEndpointName: names.outputs.privateLinkScopePrivateEndpointName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
    privateEndpointSubnetName: vNetDeployment.outputs.privateEndpointSubnetName
    vNetName: vNetDeployment.outputs.vNetName
  }
}

module managedIdentityDeployment 'managed-identity.bicep' = {
  name: 'managed-identity-deployment'
  params: {
    location: location
    managedIdentityName: names.outputs.managedIdentityName
  }
}

module vNetDeployment 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    appServiceSubnetNetworkSecurityGroupName: names.outputs.appServiceSubnetNetworkSecurityGroupName
    appServiceSubnetAddressPrefix: appServiceSubnetAddressPrefix
    appServiceSubnetName: names.outputs.appServiceSubnetName
    location: location
    privateEndpointSubnetNetworkSecurityGroupName: names.outputs.privateEndpointSubnetNetworkSecurityGroupName
    privateEndpointSubnetAddressPrefix: privateEndpointSubnetAddressPrefix
    privateEndpointSubnetName: names.outputs.privateEndpointSubnetName
    vNetAddressPrefix: vNetAddressPrefix
    vNetName: names.outputs.vNetName
    privateDnsZoneNames: privateDnsZoneNames
  }
}

module keyVaultDeployment 'key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    keyVaultPrivateEndpointName: names.outputs.keyVaultPrivateEndpointName
    vNetName: vNetDeployment.outputs.vNetName
    privateEndpointSubnetName: vNetDeployment.outputs.privateEndpointSubnetName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    functionAADServicePrincipalClientIdSecretName: names.outputs.functionAADServicePrincipalClientIdSecretName
    functionAADServicePrincipalClientId: functionAADServicePrincipalClientId
    functionAADServicePrincipalClientSecretSecretName: names.outputs.functionAADServicePrincipalClientSecretSecretName
    functionAADServicePrincipalClientSecret: functionAADServicePrincipalClientSecret
    keyVaultDnsZoneName: keyVaultPrivateDnsZoneName
  }
}

module appServicePlanDeployment 'app-service-plan.bicep' = {
  name: 'app-service-deployment'
  params: {
    appServicePlanName: names.outputs.appServicePlanName
    location: location
    appServicePlanSku: appServicePlanSku
  }
}

module serviceBusDeployment 'service-bus.bicep' = {
  name: 'service-bus-deployment'
  params: {
    serviceBusNamespaceName: names.outputs.serviceBusNamespaceName
    serviceBusPrivateEndpointName: names.outputs.serviceBusPrivateEndpointName
    location: location
    provisionTeamsServiceBusTopicName: names.outputs.provisionTeamsServiceBusTopicName
    provisionTeamsServiceBusSubscriptionName: names.outputs.provisionTeamsServiceBusSubscriptionName
    callbackServiceBusTopicName: names.outputs.callbackServiceBusTopicName
    callbackServiceBusSubscriptionName: names.outputs.callbackServiceBusSubscriptionName
    serviceBusConnectionStringSecretName: names.outputs.serviceBusConnectionStringSecretName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    privateEndpointSubnetName: vNetDeployment.outputs.privateEndpointSubnetName
    vNetName: vNetDeployment.outputs.vNetName
    serviceBusPrivateDnsZoneName: serviceBusPrivateDnsZoneName
  }
}

module functionAppDeployment 'function.bicep' = {
  name: 'function-app-deployment'
  params: {
    location: location
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServicePlanName: appServicePlanDeployment.outputs.appServicePlanName
    callbackFunctionAppName: names.outputs.callbackFunctionAppName
    callbackFunctionAppPrivateEndpointName: names.outputs.callbackFunctionAppPrivateEndpointName
    functionAADServicePrincipalClientIdSecretName: keyVaultDeployment.outputs.functionAADServicePrincipalClientIdSecretName
    functionAADServicePrincipalClientSecretSecretName: keyVaultDeployment.outputs.functionAADServicePrincipalClientSecretSecretName
    functionAppStorageAccountName: names.outputs.functionAppStorageAccountName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    provisionTeamsFunctionAppName: names.outputs.provisionTeamsFunctionAppName
    provisionTeamsFunctionAppPrivateEndpointName: names.outputs.provisionTeamsFunctionAppPrivateEndpointName
    serviceBusConnectionStringSecretName: serviceBusDeployment.outputs.serviceBusConnectionStringSecretName
    functionAppStorageAccountPrivateEndpointName: names.outputs.functionAppStorageAccountPrivateEndpointName
    appServicePrivateDnsZoneName: appServicePrivateDnsZoneName
    privateEndpointSubnetName: vNetDeployment.outputs.privateEndpointSubnetName
    storageAccountPrivateDnsZoneName: storageAccountPrivateDnsZoneName
    vNetName: vNetDeployment.outputs.vNetName
    appServiceSubnetName: vNetDeployment.outputs.appServiceSubnetName
  }
}

//  Telemetry Deployment
@description('Enable usage and telemetry feedback to Microsoft.')
var telemetryId = '760265E1-F55D-412E-B9AB-EF676C0C472E-${location}-islza-scenario2'
resource telemetrydeployment 'Microsoft.Resources/deployments@2021-04-01' = if (enableTelemetry) {
  name: telemetryId
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
      contentVersion: '1.0.0.0'
      resources: {}
    }
  }
}
