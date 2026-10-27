# Assignment 01: Storage Account Hardening

## 📖 Scenario & Background
In your previous toy example (`storage_account.bicep`), you may have written something like:
```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'toylaunchstorage'
  location: 'eastus'
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
}
```

In real-world cloud engineering, **hardcoding values is a serious anti-pattern**:
1. **Name collisions & limits**: Azure Storage accounts have global uniqueness requirements and must be between **3 and 24 characters**, alphanumeric lowercase only.
2. **Fixed locations**: Hardcoding `'eastus'` prevents re-using the template across different regions or environments.
3. **Unrestricted SKUs**: Developers might accidentally pick expensive or unsupported SKUs (e.g., `Premium_LRS` when `Standard_LRS` is sufficient).

Your task is to refactor this into a configurable, hardened Bicep template using parameters and decorators.

---

## 🎯 Objectives
You will practice:
- Declaring `param` with default values and standard data types (`string`, `object`).
- Using `@description` to document every parameter.
- Using `@minLength` and `@maxLength` to enforce Azure's 3–24 character limit.
- Using `@allowed` to restrict allowed SKUs and environment names.
- Defining a `resource` block for `Microsoft.Storage/storageAccounts`.

---

## 📋 Best Practices to Follow
- **camelCase for parameters**: Use `storageAccountName` instead of `StorageAccountName` or `storage_account_name`.
- **Default location pattern**: Set the default location to `resourceGroup().location`.
- **Meaningful descriptions**: Always explain the intent of the parameter in `@description('...')`.
- **SKU governance**: Restrict deployment to cost-effective, standard SKUs using `@allowed`.
- **Resource tagging**: Pass an optional `tags` object parameter so resources can be tracked for cost and ownership.

---

## 📝 Tasks

Open [`starter.bicep`](file:///Users/gautham/workspace/bicep/assignments/01-storage-account-hardening/starter.bicep) (or create `main.bicep`) and complete the following:

### Task 1: Storage Account Name Parameter
- Declare a parameter named `storageAccountName` of type `string`.
- Add `@description` explaining that this is the globally unique name of the storage account.
- Add `@minLength(3)` and `@maxLength(24)` decorators.

### Task 2: Location Parameter
- Declare a parameter named `location` of type `string`.
- Set its default value to `resourceGroup().location`.
- Add a `@description` explaining it defaults to the resource group's region.

### Task 3: Storage SKU Parameter
- Declare a parameter named `storageSku` of type `string`.
- Add an `@allowed` decorator restricting choices to:
  - `'Standard_LRS'` (Locally-redundant storage)
  - `'Standard_GRS'` (Geo-redundant storage)
  - `'Standard_ZRS'` (Zone-redundant storage)
- Set the default value to `'Standard_LRS'`.
- Add a `@description`.

### Task 4: Environment Parameter
- Declare a parameter named `environment` of type `string`.
- Add an `@allowed` decorator restricting values to:
  - `'dev'`
  - `'test'`
  - `'prod'`
- Set the default value to `'dev'`.
- Add a `@description`.

### Task 5: Tags Parameter
- Declare a parameter named `tags` of type `object`.
- Provide a default value containing at least:
  - `Environment: 'dev'`
  - `Project: 'LearningBicep'`
- Add a `@description`.

### Task 6: Storage Account Resource
- Declare a resource with symbolic name `storageAccount` and type `'Microsoft.Storage/storageAccounts@2023-01-01'`.
- Set `name` using the `storageAccountName` parameter.
- Set `location` using the `location` parameter.
- Set `kind` to `'StorageV2'`.
- Set `sku.name` using the `storageSku` parameter.
- Set `tags` using the `tags` parameter.
- Set `properties.supportsHttpsTrafficOnly` to `true` (enterprise security standard).

---

## ✅ Self-Verification Checklist
Before moving to the next assignment, check your work:
- [ ] Are all parameter names formatted in camelCase?
- [ ] Does every parameter have a `@description(...)` decorator right above it?
- [ ] Is `storageAccountName` protected with both `@minLength(3)` and `@maxLength(24)`?
- [ ] Does `storageSku` use `@allowed` with standard tiers and default to `'Standard_LRS'`?
- [ ] Does `location` default to `resourceGroup().location` instead of a hardcoded string?
- [ ] Does the storage account enforce `supportsHttpsTrafficOnly: true`?
