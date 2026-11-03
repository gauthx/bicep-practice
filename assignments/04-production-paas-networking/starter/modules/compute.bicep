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

// Storage account required by Azure Function App for runtime state
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
// TODO: Define a 'Microsoft.Web/serverfarms@2024-04-01' resource.
// Use skuName for sku.name.
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'plan-${baseName}'
  location: location
  sku: {
    name: skuName
  }
}

// ============================================================================
// TASK 3B: Web App with Regional VNet Integration & App Settings
// ============================================================================
// TODO: Define a 'Microsoft.Web/sites@2024-04-01' resource.
// Requirements:
// 1. Link to serverFarmId: appServicePlan.id
// 2. Enable httpsOnly: true
// 3. Attach virtualNetworkSubnetId: subnetId (Regional VNet Integration)
// 4. Configure appSettings with APPCONFIG_ENDPOINT pointing to appConfigEndpoint.

resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: 'app-${baseName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    virtualNetworkSubnetId: subnetId
    siteConfig: {
      appSettings: [
        {
          name: 'APPCONFIG_ENDPOINT'
          value: appConfigEndpoint
        }
      ]
    }
  }
}

// ============================================================================
// TASK 3C: Function App sharing Plan & Subnet
// ============================================================================
// TODO: Define a 'Microsoft.Web/sites@2024-04-01' with kind: 'functionapp'.
// Requirements:
// 1. Link to serverFarmId: appServicePlan.id
// 2. Attach virtualNetworkSubnetId: subnetId
// 3. Configure AzureWebJobsStorage and FUNCTIONS_WORKER_RUNTIME in siteConfig.appSettings.

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name: 'func-${baseName}'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    virtualNetworkSubnetId: subnetId
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcStorage.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPCONFIG_ENDPOINT'
          value: appConfigEndpoint
        }
      ]
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================
output webAppId string = webApp.id
output webAppDefaultHostName string = webApp.properties.defaultHostName
output functionAppId string = functionApp.id
output functionAppDefaultHostName string = functionApp.properties.defaultHostName
