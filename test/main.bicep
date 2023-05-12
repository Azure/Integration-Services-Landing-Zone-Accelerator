param enableTelemetry bool = true
param location string

@description('Enable usage and telemetry feedback to Microsoft.')
var telemetryId = '760265E1-F55D-412E-B9AB-EF676C0C472E-${location}-islza-2'
resource telemetrydeployment 'Microsoft.Resources/deployments@2021-04-01' = if (enableTelemetry) {
  name: telemetryId
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
      contentVersion: '1.0.0.0'
      resources: {}
    }
  }
}
