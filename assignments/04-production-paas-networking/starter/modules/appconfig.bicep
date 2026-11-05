@description('Globally unique name of the Azure App Configuration store')
param appConfigName string

@description('The SKU of the App Configuration store')
@allowed([
  'free'
  'standard'
])
param sku string = 'standard'

@description('Environment tag or identifier (e.g. dev, prod)')
param environment string = 'dev'

@description('Azure region for the resources')
param location string = resourceGroup().location

// ============================================================================
// TASK 2A: App Configuration Store
// ============================================================================
// TODO: Define a 'Microsoft.AppConfiguration/configurationStores@2024-05-01' resource.
// Requirements:
// 1. SKU name set to the parameter sku.
// 2. Disable public access or keep standard properties.

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = {
  name: appConfigName
  location: location
  sku: {
    name: sku
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

// ============================================================================
// TASK 2B: Key-Value Settings
// ============================================================================
// TODO: Define key-values using 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01'.
// Note: In Bicep, child resources can use the 'parent' property or nested syntax.
// Resource name format: '${key}$${label}' or '${key}' for no label.

resource configEnvironment 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  parent: appConfig
  name: 'Settings:Environment'
  properties: {
    value: environment
  }
}

resource configFeatureFlag 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  parent: appConfig
  name: 'Features:EnableNewCheckout'
  properties: {
    value: environment == 'prod' ? 'true' : 'false'
  }
}

// ============================================================================
// Outputs
// ============================================================================
output appConfigId string = appConfig.id
output appConfigEndpoint string = appConfig.properties.endpoint
