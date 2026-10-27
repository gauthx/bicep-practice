// ==============================================================================
// Assignment 03: Secure SQL Database & Credential Handling
// Follow the instructions in README.md to replace the TODO comments.
// ==============================================================================

// TODO: Task 1 - Declare 'sqlServerName' (string, @minLength(3), @maxLength(63)) and 'sqlDatabaseName' (string, default 'appdb')


// TODO: Task 2 - Declare 'administratorLogin' parameter (string, default: 'sqladminuser')


// TODO: Task 3 - Declare 'administratorLoginPassword' parameter
// Decorators: @description, @secure(), @minLength(12)
// NOTE: DO NOT provide a default value!


// TODO: Task 4 - Declare 'location' parameter (string, default: resourceGroup().location)


// TODO: Task 5 - Declare 'dbSkuName' parameter (string, @allowed: 'Basic', 'S0', 'S1', default: 'Basic')


// TODO: Task 6 - Define 'sqlServer' resource ('Microsoft.Sql/servers@2022-05-01-preview')
// Properties: administratorLogin, administratorLoginPassword, minimalTlsVersion: '1.2'


// TODO: Task 7 - Define 'sqlDatabase' child resource ('Microsoft.Sql/servers/databases@2022-05-01-preview')
// Use 'parent: sqlServer'
