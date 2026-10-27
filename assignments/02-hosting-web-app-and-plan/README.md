# Assignment 02: Hosting Web App & App Service Plan

## 📖 Scenario & Background
In your previous file (`param.bicep`), you started writing:
```bicep
param appServiceAppName string = 'myAppService'

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: 'eastus'
  properties: {
    serverFarmId: // left blank!
    httpsOnly: true
  }
}
```

Notice `serverFarmId` was left empty. In Azure, a Web App (`Microsoft.Web/sites`) cannot exist in isolation—it must run inside an **App Service Plan** (`Microsoft.Web/serverfarms`), which defines the underlying CPU, memory, and scaling tier.

In real-world Bicep, you rarely hardcode resource IDs. Instead, you declare both resources in the same template and use **symbolic referencing** (`appServicePlan.id`) to wire them together. Bicep automatically understands this dependency and provisions the plan before the web app!

---

## 🎯 Objectives
You will practice:
- Declaring numeric parameters (`int`) and using `@minValue` and `@maxValue` to avoid runaway cloud costs.
- Declaring boolean parameters (`bool`) for feature flags.
- Using `@allowed` for App Service Plan pricing tiers (SKUs).
- Defining multiple interdependent resources in Bicep.
- Linking resources using symbolic references (`<symbolicName>.id`).

---

## 📋 Best Practices to Follow
- **Resource referencing**: Always use `planResource.id` rather than manually constructing resource IDs or subscription strings.
- **Capacity bounds**: When accepting instance counts or scale tiers, always clamp the range with `@minValue` and `@maxValue` to prevent accidental cost overruns.
- **Enforce HTTPS**: Always default `httpsOnly` to `true` to follow Azure Security Benchmarks.
- **Avoid hardcoded unique names**: Provide default parameter names with room for customization.

---

## 📝 Tasks

Open [`starter.bicep`](file:///Users/gautham/workspace/bicep/assignments/02-hosting-web-app-and-plan/starter.bicep) (or create `main.bicep`) and complete the following:

### Task 1: Web App Name Parameter
- Declare a parameter named `webAppName` of type `string`.
- Add `@description` explaining that this is the globally unique name for the Azure Web App.
- Add `@minLength(3)` and `@maxLength(60)`.

### Task 2: App Service Plan Name Parameter
- Declare a parameter named `appServicePlanName` of type `string`.
- Set a sensible default value like `'asp-myapp-dev'`.
- Add `@description`.

### Task 3: App Service Plan SKU Parameter
- Declare a parameter named `skuName` of type `string`.
- Add an `@allowed` decorator restricting values to standard tiers:
  - `'F1'` (Free - testing)
  - `'B1'` (Basic - small workloads)
  - `'S1'` (Standard - production)
  - `'P1v3'` (Premium - high performance)
- Set the default value to `'B1'`.
- Add `@description`.

### Task 4: Capacity / Instance Count Parameter
- Declare a parameter named `skuCapacity` of type `int`.
- Add `@description` explaining this is the number of instances for the hosting plan.
- Add `@minValue(1)` (minimum 1 server).
- Add `@maxValue(3)` (prevent spinning up too many instances accidentally).
- Set the default value to `1`.

### Task 5: HTTPS Only Flag Parameter
- Declare a parameter named `httpsOnly` of type `bool`.
- Add `@description` explaining whether to enforce HTTPS traffic redirection.
- Set the default value to `true`.

### Task 6: Location Parameter
- Declare `location` of type `string` with default `resourceGroup().location`.

### Task 7: App Service Plan Resource
- Declare a resource with symbolic name `appServicePlan` and type `'Microsoft.Web/serverfarms@2023-12-01'`.
- Map `name` to `appServicePlanName`.
- Map `location` to `location`.
- Set `sku`:
  - `name`: use parameter `skuName`
  - `capacity`: use parameter `skuCapacity`

### Task 8: Web App Resource
- Declare a resource with symbolic name `appServiceApp` and type `'Microsoft.Web/sites@2023-12-01'`.
- Map `name` to `webAppName`.
- Map `location` to `location`.
- In `properties`:
  - Set `serverFarmId: appServicePlan.id` (symbolic reference!).
  - Set `httpsOnly: httpsOnly`.

---

## ✅ Self-Verification Checklist
- [ ] Does `skuCapacity` have both `@minValue(1)` and `@maxValue(3)`?
- [ ] Is `httpsOnly` of type `bool` with a default of `true`?
- [ ] Is `serverFarmId` referencing `appServicePlan.id` without hardcoded strings?
- [ ] Does every parameter have an informative `@description`?
