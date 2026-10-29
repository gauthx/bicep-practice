// ==============================================================================
// Assignment 02: Hosting Web App & App Service Plan
// Follow the instructions in README.md to replace the TODO comments.
// ==============================================================================

// TODO: Task 1 - Declare 'webAppName' parameter (string, @description, @minLength(3), @maxLength(60))

@description('The name of the web app to be created. Must be between 3 and 60 characters.')
@minLength(3)
@maxLength(60)
param webAppName string

// TODO: Task 2 - Declare 'appServicePlanName' parameter (string, @description, default value)
@description('The name of the App Service Plan to be created.')
param appServicePlanName string = 'myAppServicePlan'

// TODO: Task 3 - Declare 'skuName' parameter (string, @description, @allowed: 'F1', 'B1', 'S1', 'P1v3', default: 'B1')

@description('The SKU name for the App Service Plan. Allowed values: F1, B1, S1, P1v3.')
@allowed([
  'F1'
  'B1'
  'S1'
  'P1v3'
])
param skuName string = 'B1'

// TODO: Task 4 - Declare 'skuCapacity' parameter (int, @description, @minValue(1), @maxValue(3), default: 1)

@description('The capacity for the App Service Plan SKU.')
@minValue(1)
@maxValue(3)
param skuCapacity int = 1

// TODO: Task 5 - Declare 'httpsOnly' parameter (bool, @description, default: true)
@description('Enforce HTTPS-only traffic to the web application.')
param httpsOnly bool = true

// TODO: Task 6 - Declare 'location' parameter (string, default: resourceGroup().location)
@description('The Azure region where resources will be deployed.')
param location string = resourceGroup().location

// TODO: Task 7 - Define 'appServicePlan' resource ('Microsoft.Web/serverfarms@2023-12-01')
// Properties: name, location, sku: { name: skuName, capacity: skuCapacity }
resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appServicePlanName
  location: location
  sku: { name: skuName, capacity: skuCapacity }
}

// TODO: Task 8 - Define 'appServiceApp' resource ('Microsoft.Web/sites@2023-12-01')
// Properties: name, location, properties: { serverFarmId: appServicePlan.id, httpsOnly: httpsOnly }
resource appServiceApp 'Microsoft.Web/sites@2025-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: httpsOnly
  }
}
