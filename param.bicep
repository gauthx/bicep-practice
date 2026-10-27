param appServiceAppName string = 'myAppService'

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: 'eastus'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'myAppServicePlan')
    httpsOnly: true
  }
}
