targetScope = 'subscription'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-bicep-workshop'
  location: 'westeurope'
}
