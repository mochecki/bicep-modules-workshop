targetScope = 'resourceGroup'

@description('Azure Region where Storage Account will be created.')
param parLocation string

@description('Name of the Storage Account to be created.')
param parStorageAccountName string

@description('Type of the Storage Account to be created.')
param parStorageAccountKind string = 'StorageV2'

@description('SKU of the Storage Account to be created.')
param parStorageAccountSku string = 'Standard_LRS'

@description('Optional list of containers to be created in the Storage Account.')
param parContainers array = []

param parDiagSettingsWorkspaceId string = ''

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: parStorageAccountName
  location: parLocation
  kind: parStorageAccountKind
  sku: {
    name: parStorageAccountSku
  }
}

resource resBlobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = if(!empty((parContainers))) {
  parent: resStorageAccount
  name: 'default'
}

resource resContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = [for container in parContainers: { 
  parent: resBlobService
  name: container
}]

resource resDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if(!empty(parDiagSettingsWorkspaceId)) {
  name: 'diagnosticSettings'
  scope: resBlobService
  properties: {
    workspaceId: parDiagSettingsWorkspaceId
    logs: [
      {
        categoryGroup: 'AllLogs'
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

output outStorageAccountName string = resStorageAccount.name
output outStorageAccountId string = resStorageAccount.id
