targetScope = 'resourceGroup'

var varLocation = 'westeurope'
var varContainers = [ 'container1', 'container2', 'container3' ]


resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law${uniqueString(subscription().subscriptionId)}'
  location: varLocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'stbwa${uniqueString(subscription().subscriptionId)}'
  location: varLocation
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource resBlobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: resStorageAccount
  name: 'default'
}

resource resContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [for container in varContainers: { 
  parent: resBlobService
  name: container
}]

resource resDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag${uniqueString(subscription().subscriptionId)}'
  scope: resBlobService
  properties: {
    workspaceId: resLogAnalyticsWorkspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
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
