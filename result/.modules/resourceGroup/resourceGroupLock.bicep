targetScope = 'resourceGroup'

param parResourceGroupName string

@allowed([
  'None'
  'CanNotDelete'
  'ReadOnly'
])
param parLockLevel string = 'None'

resource resResourceGroupLock 'Microsoft.Authorization/locks@2020-05-01' = if (parLockLevel != 'None') {
  name: '${parResourceGroupName}-lock'
  properties: {
    level: parLockLevel
  }
}
