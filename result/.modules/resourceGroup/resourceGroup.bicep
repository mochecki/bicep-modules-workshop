targetScope = 'subscription'

@description('Azure Region where Resource Group will be created.')
param parLocation string

@description('Name of the Resource Group to be created.')
param parResourceGroupName string

@description('Tags to be applied to the Resource Group.')
param parTags object = {}

@allowed([
  'None'
  'CanNotDelete'
  'ReadOnly'
])
param parLockLevel string = 'None'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: parResourceGroupName
  location: parLocation
  tags: parTags
}

module modResourceGroupLock 'resourceGroupLock.bicep' = {
  scope: resourceGroup(parResourceGroupName)
  name: '${deployment().name}-lock'
  params: {
    parResourceGroupName: resResourceGroup.name
    parLockLevel: parLockLevel
  }
}

output outResourceGroupName string = resResourceGroup.name
output outResourceGroupId string = resResourceGroup.id
