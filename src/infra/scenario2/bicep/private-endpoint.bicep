param privateEndpointName string
param privateEndpointSubnetName string
param vNetName string
param privateLinkServiceId string
param groupIds array
param privateEndpointDnsZoneName string
param location string

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' existing = {
  name: '${vNetName}/${privateEndpointSubnetName}'
}

resource privateEndpointDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateEndpointDnsZoneName
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: groupIds
        }
      }
    ]
  }
}

resource privateEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = {
  parent: privateEndpoint
  name: 'privateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'default'
        properties: {
          privateDnsZoneId: privateEndpointDnsZone.id
        }
      }
    ]
  }
}

output privateEndpointName string = privateEndpoint.name
