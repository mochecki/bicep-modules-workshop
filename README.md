# \[Workshop\] Bicep modules

## Workshop

### \[STEP_01\] Create a folder for modules in root directory

### \[STEP_02\] Create a module for Log Analytics Workspace

#### 1. Add a parameter list 

Parameters:
- parLocation
- parLogAnalyticsWorkspaceName
- parLogAnalyticsWorkspaceSku - default value: PerGB2018

#### 2. Add a Log Analytics Workspace resource

#### 3. Add an output list

Output:
- name
- id

### \[STEP_03\] Create a module for Storage Account

#### 1. Add a parameter list 

Parameters:
- parLocation
- parStorageAccountName
- parStorageAccountKind - default value: StorageV2
- parStorageAccountSku - default value: Standard_LRS

#### 2. Add a Storage Account resource

#### 3. Add an output list

Output:
- name
- id

### \[STEP_04\] Create a main.bicep file in the workload folder

Docs: [Target scopes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-resource-group?tabs=azure-cli)

#### 1. Add a resource group in main.bicep with parameters

Parameters:
- parLocation
- parResourceGroupName

#### 2. Add .biceparam paremeter file in workload folder

#### 3. Deploy main.bicep file

Az CLI:
```
az deployment sub create --template-file main.bicep --parameters parameters.bicepparam --location westeurope
```

Powershell
```
New-AzSubscriptionDeployment -TemplateFile .\main.bicep -TemplateParameterFile parameters.bicepparam -Location westeurope
```

### \[STEP_05\] Add Log Analytics Workspace module in main.bicep

#### 1. Create user-defined data type for Log Analytics Workspace configuration

Docs: [User-defined data types in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types)

```
type logAnalyticsWorkspaceConfig = {
  name: string
  sku: string
}
```

#### 2. Call Log Analytics Workspace module in main.bicep

### \[STEP_06\] Add Storage Account module in main.bicep

#### 1. Create user-defined data type for Storage Account configuration

Docs: [User-defined data types in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types)

```
type storageAccountConfig = {
  name: string
  sku: string?
  kind: string?
  containers: string[]?
}
```

#### 2. Call Storage Account module in main.bicep

### \[STEP_07\] Extend Storage Account module with diagnostic settings (conditional deployment)

Docs: [Conditional deployment](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/conditional-resource-deployment)


### \[STEP_08\] Create a module for Resource Group

#### 1. Replace resource group with module in main.bicep

#### 2. Create a module for Resource Group Lock

Parameters:
- parResourceGroupName
- parLockLevel - allowed values: None, CanNotDelete, ReadOnly

#### 3. Create a module for Resource Group Lock 

```
resource resResourceGroupLock 'Microsoft.Authorization/locks@2020-05-01' = if (parLockLevel != 'None') {
  name: '${parResourceGroupName}-lock'
  properties: {
    level: parLockLevel
  }
}
```

#### 4. Update Resource Group module with conditional deployment of Resource Group Lock


## Examples:

### Azure Landing Zones (ALZ) - Bicep
https://github.com/Azure/ALZ-Bicep







