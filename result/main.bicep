targetScope = 'subscription'

type logAnalyticsWorkspaceConfig = {
  name: string
  sku: string
}

type storageAccountConfig = {
  name: string
  sku: string?
  kind: string?
  containers: string[]?
}

param parLocation string

param parResourceGroupName string

param parLogAnalyticsWorkspaceConfig logAnalyticsWorkspaceConfig

param parStorageAccountConfig storageAccountConfig

module modResourceGroup '.modules/resourceGroup/resourceGroup.bicep' = {
  name: '${deployment().name}-resourceGroup'
  params: {
    parLocation: parLocation
    parResourceGroupName: parResourceGroupName
    parLockLevel: 'CanNotDelete'
  }
}

module modLogAnalyticsWorkspace '.modules/logAnalyticsWorkspace/logAnalyticsWorkspace.bicep' = {
  scope: resourceGroup(parResourceGroupName)
  name: '${deployment().name}-logAnalyticsWorkspace'
  params: {
    parLocation: parLocation
    parLogAnalyticsWorkspaceName: parLogAnalyticsWorkspaceConfig.name
    parLogAnalyticsWorkspaceSku: parLogAnalyticsWorkspaceConfig.sku
  }
  dependsOn: [
    modResourceGroup
  ]
}

module modStorageAccount '.modules/storageAccount/storageAccount.bicep' = {
  scope: resourceGroup(parResourceGroupName)
  name: '${deployment().name}-storageAccount'
  params: {
    parLocation: parLocation
    parStorageAccountName: parStorageAccountConfig.name
    parStorageAccountKind: parStorageAccountConfig.?kind
    parStorageAccountSku: parStorageAccountConfig.?sku
    parContainers: parStorageAccountConfig.?containers
    parDiagSettingsWorkspaceId: modLogAnalyticsWorkspace.outputs.outLogAnalyticsWorkspaceId
  }
}
