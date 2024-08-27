using 'main.bicep'

param parLocation = 'westeurope'

param parResourceGroupName = 'rg-bicep-workshop-we-001'

param parLogAnalyticsWorkspaceConfig = {
  name: 'law-bicep-workshop-we-001' 
  sku: 'PerGB2018'
}

param parStorageAccountConfig =  {
  name: 'stmocbicepworkwe001'
  sku: 'Standard_LRS'
  kind: 'StorageV2'
  containers: [ 'container1', 'container2', 'container3' ]
}
