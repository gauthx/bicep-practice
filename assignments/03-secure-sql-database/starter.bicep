// ==============================================================================
// Assignment 03: Secure SQL Database & Credential Handling
// Follow the instructions in README.md to replace the TODO comments.
// ==============================================================================

// TODO: Task 1 - Declare 'sqlServerName' (string, @minLength(3), @maxLength(63)) and 'sqlDatabaseName' (string, default 'appdb')
@description('The name of the sql server')
@minLength(3)
@maxLength(63)
param sqlServerName string = 'appdb'

// TODO: Task 2 - Declare 'administratorLogin' parameter (string, default: 'sqladminuser')
@description('The username of the sql server')
param administratorLogin string = 'sqladminuser'

// TODO: Task 3 - Declare 'administratorLoginPassword' parameter
// Decorators: @description, @secure(), @minLength(12)
// NOTE: DO NOT provide a default value!
@description('The password of the sql server')
@secure()
@minLength(12)
param administratorLoginPassword string

// TODO: Task 4 - Declare 'location' parameter (string, default: resourceGroup().location)
@description('The location of the sql server to be deployed')
param location string = resourceGroup().location

// TODO: Task 5 - Declare 'dbSkuName' parameter (string, @allowed: 'Basic', 'S0', 'S1', default: 'Basic')
@allowed(['Basic', 'S0', 'S1'])
param dbSkuName string = 'Basic'
// TODO: Task 6 - Define 'sqlServer' resource ('Microsoft.Sql/servers@2022-05-01-preview')
// Properties: administratorLogin, administratorLoginPassword, minimalTlsVersion: '1.2'

resource sqlServer 'Microsoft.Sql/servers@2026-08-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    minimalTlsVersion: '1.2'
  }
}

// TODO: Task 7 - Define 'sqlDatabase' child resource ('Microsoft.Sql/servers/databases@2022-05-01-preview')
// Use 'parent: sqlServer'

resource sqlDatabase 'Microsoft.Sql/servers/databases@2026-08-01-preview' = {
  name: sqlServerName
  location: location
  parent: sqlServer
  sku: { name: dbSkuName }
}
