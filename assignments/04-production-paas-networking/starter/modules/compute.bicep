@description('Base name for the compute resources')
param baseName string

@description('App Service Plan SKU name (e.g. B1 for dev, P1v3 for prod)')
param skuName string = 'B1'

@description('Resource ID of the delegated subnet for VNet Integration')
param subnetId string

@description('Endpoint URL of the App Configuration store')
param appConfigEndpoint string

@description('Azure region for the resources')
param location string = resourceGroup().location

// Helper: Storage account required by Azure Function App for runtime state
resource funcStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: take('stfunc${uniqueString(resourceGroup().id, baseName)}', 24)
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// ============================================================================
// TASK 3A: App Service Plan
// ============================================================================
// TODO: Define a 'Microsoft.Web/serverfarms@2024-04-01' resource named 'plan-${baseName}'.
// Requirements:
// 1. Set location to 'location'.
// 2. Set sku.name to 'skuName'.

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'plan-${baseName}'
  location: location
  sku: {
    // TODO: Configure sku name
  }
}

// ============================================================================
// TASK 3B: Web App with Regional VNet Integration & App Settings
// ============================================================================
// TODO: Define a 'Microsoft.Web/sites@2024-04-01' resource named 'app-${baseName}'.
// Requirements:
// 1. Link to serverFarmId: appServicePlan.id
// 2. Enable httpsOnly: true
// 3. Attach virtualNetworkSubnetId: subnetId (This connects the Web App to your private subnet!)
// 4. In properties.siteConfig.appSettings:
//    Add an appSetting named 'APPCONFIG_ENDPOINT' with its value set to appConfigEndpoint

resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: 'app-${baseName}'
  location: location
  properties: {
    // TODO: Link serverFarmId, httpsOnly, virtualNetworkSubnetId, and siteConfig.appSettings
  }
}

// ============================================================================
// TASK 3C: Function App sharing Plan & Subnet
// ============================================================================
// TODO: Define a 'Microsoft.Web/sites@2024-04-01' resource named 'func-${baseName}'.
// Requirements:
// 1. Set kind: 'functionapp'
// 2. Link to serverFarmId: appServicePlan.id
// 3. Enable httpsOnly: true
// 4. Attach virtualNetworkSubnetId: subnetId
// 5. In properties.siteConfig.appSettings:
//    - 'AzureWebJobsStorage': Use the connection string with funcStorage.name and funcStorage.listKeys()
//    - 'FUNCTIONS_WORKER_RUNTIME': 'node'
//    - 'APPCONFIG_ENDPOINT': appConfigEndpoint

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name: 'func-${baseName}'
  location: location
  kind: 'functionapp'
  properties: {
    // TODO: Link serverFarmId, httpsOnly, virtualNetworkSubnetId, and siteConfig.appSettings
  }
}

// ============================================================================
// Outputs
// ============================================================================
// TODO: Output webAppId, webAppDefaultHostName, functionAppId, and functionAppDefaultHostName
output webAppId string = webApp.id
output webAppDefaultHostName string = webApp.properties.defaultHostName
output functionAppId string = functionApp.id
output functionAppDefaultHostName string = functionApp.properties.defaultHostName
