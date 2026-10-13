resource storageAccount 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: 'toylaunchstorage'
  location: 'eastus'
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
}
