param privateDnsZoneName string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

output privateDnsZoneName string = privateDnsZone.name
