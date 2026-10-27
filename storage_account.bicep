var varStorageAccountName = 'toylaunchstorage'

param storageAccountName string = uniqueString(resourceGroup().id) 

resource storageAccount 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
}
