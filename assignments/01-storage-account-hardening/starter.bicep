// ==============================================================================
// Assignment 01: Storage Account Hardening
// Follow the instructions in README.md to replace the TODO comments.
// ==============================================================================

// TODO: Task 1 - Declare 'storageAccountName' parameter with @description, @minLength(3), @maxLength(24)
@description('Globally unique name for the storage account (lowercase letters and numbers only, max 24 chars).')
@minLength(3)
@maxLength(24)
param storageAccountName string

// TODO: Task 2 - Declare 'location' parameter with @description and default to resourceGroup().location

@description('The Azure region where the storage account will be deployed.')
param location string = resourceGroup().location

// TODO: Task 3 - Declare 'storageSku' parameter with @description, @allowed list, and default to 'Standard_LRS'
@description('The storage redundancy SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param storageSku string = 'Standard_LRS'

// TODO: Task 4 - Declare 'environment' parameter with @description, @allowed list ('dev', 'test', 'prod'), and default to 'dev'
@description('The deployment environment (dev, test, prod).')
@allowed(['dev', 'test', 'prod'])
param environment string = 'dev'

// TODO: Task 5 - Declare 'tags' parameter with @description and default object tags

@description('Resource tags for ownership and cost tracking.')
param tags object = {
  Environment: environment
  Project: 'LearningBicep'
}

// TODO: Task 6 - Define the 'storageAccount' resource using Microsoft.Storage/storageAccounts@2023-01-01
// Map the parameters to name, location, sku.name, kind, tags, and set properties.supportsHttpsTrafficOnly = true

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'BlobStorage'
  sku: { name: storageSku }
  tags: tags
  properties: { supportsHttpsTrafficOnly: true }
}
