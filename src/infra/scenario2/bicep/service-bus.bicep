param serviceBusNamespaceName string
param location string
param provisionTeamsServiceBusTopicName string
param provisionTeamsServiceBusSubscriptionName string
param callbackServiceBusTopicName string
param callbackServiceBusSubscriptionName string
param serviceBusPrivateEndpointName string
param serviceBusPrivateDnsZoneName string
param vNetName string
param privateEndpointSubnetName string
param managedIdentityName string
param serviceNowAADServicePrincipalObjectId string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
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

resource serviceBusDataOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '090c5cfd-751d-490a-894a-3ce6f1109419'
}

resource functionAppServiceBusDataOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: serviceBusNamespace
  name: guid(serviceBusNamespace.id, managedIdentity.name, serviceBusDataOwnerRoleDefinition.name)
  properties: {
    roleDefinitionId: serviceBusDataOwnerRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource serviceBusDataSenderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
}

resource serviceNowServiceBusDataSenderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: serviceBusNamespace
  name: guid(serviceBusNamespace.id, serviceNowAADServicePrincipalObjectId, serviceBusDataSenderRoleDefinition.name)
  properties: {
    roleDefinitionId: serviceBusDataSenderRoleDefinition.id
    principalId: serviceNowAADServicePrincipalObjectId
    principalType: 'ServicePrincipal'
  }
}

output serviceBusNamespaceName string = serviceBusNamespaceName
output provisionTeamsServiceBusTopicName string = provisionTeamsServiceBusTopicName
output provisionTeamsServiceBusSubscriptionName string = provisionTeamsServiceBusSubscriptionName
output callbackServiceBusTopicName string = callbackServiceBusTopicName
output callbackServiceBusSubscriptionName string = callbackServiceBusSubscriptionName
