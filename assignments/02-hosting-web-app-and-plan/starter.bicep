// ==============================================================================
// Assignment 02: Hosting Web App & App Service Plan
// Follow the instructions in README.md to replace the TODO comments.
// ==============================================================================

// TODO: Task 1 - Declare 'webAppName' parameter (string, @description, @minLength(3), @maxLength(60))


// TODO: Task 2 - Declare 'appServicePlanName' parameter (string, @description, default value)


// TODO: Task 3 - Declare 'skuName' parameter (string, @description, @allowed: 'F1', 'B1', 'S1', 'P1v3', default: 'B1')


// TODO: Task 4 - Declare 'skuCapacity' parameter (int, @description, @minValue(1), @maxValue(3), default: 1)


// TODO: Task 5 - Declare 'httpsOnly' parameter (bool, @description, default: true)


// TODO: Task 6 - Declare 'location' parameter (string, default: resourceGroup().location)


// TODO: Task 7 - Define 'appServicePlan' resource ('Microsoft.Web/serverfarms@2023-12-01')
// Properties: name, location, sku: { name: skuName, capacity: skuCapacity }


// TODO: Task 8 - Define 'appServiceApp' resource ('Microsoft.Web/sites@2023-12-01')
// Properties: name, location, properties: { serverFarmId: appServicePlan.id, httpsOnly: httpsOnly }
