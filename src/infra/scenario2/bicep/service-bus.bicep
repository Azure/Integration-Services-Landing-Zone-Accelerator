param serviceBusNamespaceName string
param location string
param provisionTeamsServiceBusTopicName string
param provisionTeamsServiceBusSubscriptionName string
param callbackServiceBusTopicName string
param callbackServiceBusSubscriptionName string
param serviceBusConnectionStringSecretName string
param keyVaultName string
param serviceBusPrivateEndpointName string
param serviceBusPrivateDnsZoneName string
param vNetName string
param privateEndpointSubnetName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Premium'
    tier: 'Premium'
  }
}

module privateEndpoint 'private-endpoint.bicep' = {
  name: '${serviceBusNamespace.name}-privateEndpoint-deployment'
  params: {
    groupIds: [
      'namespace'
    ]
    privateEndpointDnsZoneName: serviceBusPrivateDnsZoneName
    privateEndpointName: serviceBusPrivateEndpointName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateLinkServiceId: serviceBusNamespace.id
    vNetName: vNetName
    location: location
  }
}

resource provisionTeamsServiceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' = {
  name: provisionTeamsServiceBusTopicName
  parent: serviceBusNamespace
}

resource provisionTeamsServiceBusSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2017-04-01' = {
  name: provisionTeamsServiceBusSubscriptionName
  parent: provisionTeamsServiceBusTopic
  properties: {
    maxDeliveryCount: 1
  }
}

resource callbackServiceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' = {
  name: callbackServiceBusTopicName
  parent: serviceBusNamespace
}

resource callbackServiceBusSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2017-04-01' = {
  name: callbackServiceBusSubscriptionName
  parent: callbackServiceBusTopic
  properties: {
    maxDeliveryCount: 1
  }
}

var endpoint = '${serviceBusNamespace.id}/AuthorizationRules/RootManageSharedAccessKey'

resource serviceBusConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: serviceBusConnectionStringSecretName
  parent: keyVault
  properties: {
    value: 'Endpoint=sb://${serviceBusNamespace.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys(endpoint, serviceBusNamespace.apiVersion).primaryKey}'
  }
}

output serviceBusNamespaceName string = serviceBusNamespaceName
output provisionTeamsServiceBusTopicName string = provisionTeamsServiceBusTopicName
output provisionTeamsServiceBusSubscriptionName string = provisionTeamsServiceBusSubscriptionName
output callbackServiceBusTopicName string = callbackServiceBusTopicName
output callbackServiceBusSubscriptionName string = callbackServiceBusSubscriptionName
output serviceBusConnectionStringSecretName string = serviceBusConnectionStringSecretName
