targetScope = 'resourceGroup'

param parLocation string

param parLogAnalyticsWorkspaceName string

param parLogAnalyticsWorkspaceSku string = 'PerGB2018'

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: parLogAnalyticsWorkspaceName
  location: parLocation
  properties: {
    sku: {
      name: parLogAnalyticsWorkspaceSku
    }
  }
}

output outLogAnalyticsWorkspaceName string = resLogAnalyticsWorkspace.name
output outLogAnalyticsWorkspaceId string = resLogAnalyticsWorkspace.id
