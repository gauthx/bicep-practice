# Assignment 03: Secure SQL Database & Credential Handling

## 📖 Scenario & Background
Databases and virtual machines frequently require administrative credentials. A major security risk in Infrastructure as Code (IaC) is **hardcoded passwords** or exposing secrets in deployment logs.

In Azure Bicep:
- The `@secure()` decorator ensures that parameter values are treated as secrets.
- Values marked with `@secure()` are **not logged** in deployment history and **not visible** in Azure Resource Manager deployment outputs.
- **Rule of thumb**: Never commit default values for `@secure()` parameters to source control!

In this assignment, you will provision an Azure SQL logical server and an Azure SQL Database while strictly following enterprise security standards.

---

## 🎯 Objectives
You will practice:
- Using the `@secure()` decorator for sensitive inputs like administrator passwords.
- Using `@minLength` to enforce password complexity standards.
- Declaring parent/child relationships between resources using the `parent` property.
- Enforcing TLS encryption baselines (`minimalTlsVersion`).
- Following security best practices around parameter defaults.

---

## 📋 Best Practices to Follow
1. **Never provide a default value for `@secure()` parameters**: If you provide a default value like `param adminPassword string = 'Password123!'`, anyone viewing your Git repository can read the secret.
2. **Enforce minimum length for secrets**: Weak passwords can be brute-forced; use `@minLength(12)`.
3. **Use child resource syntax**: A database belongs to a SQL server. In Bicep, you can link them using the `parent:` keyword.
4. **Enforce TLS 1.2+**: Modern security baselines reject old TLS versions (1.0 and 1.1).

---

## 📝 Tasks

Open [`starter.bicep`](file:///Users/gautham/workspace/bicep/assignments/03-secure-sql-database/starter.bicep) (or create `main.bicep`) and complete the following:

### Task 1: Server and Database Name Parameters
- Declare `sqlServerName` of type `string` with `@description`, `@minLength(3)`, and `@maxLength(63)`.
- Declare `sqlDatabaseName` of type `string` with `@description` and a default value like `'appdb'`.

### Task 2: Administrator Login Name Parameter
- Declare `administratorLogin` of type `string`.
- Set a sensible default (e.g., `'sqladminuser'`).
- Add `@description`.

### Task 3: Secure Administrator Password Parameter
- Declare `administratorLoginPassword` of type `string`.
- Add `@description` explaining this is the admin password for the SQL server.
- Add `@secure()` decorator.
- Add `@minLength(12)` decorator.
- **IMPORTANT**: Do **NOT** provide a default value for this parameter!

### Task 4: Location Parameter
- Declare `location` of type `string` with default `resourceGroup().location`.

### Task 5: Database SKU Parameter
- Declare `dbSkuName` of type `string`.
- Add `@allowed` restricting to `'Basic'`, `'S0'`, `'S1'`.
- Set default to `'Basic'`.
- Add `@description`.

### Task 6: Azure SQL Server Resource
- Declare a resource with symbolic name `sqlServer` and type `'Microsoft.Sql/servers@2022-05-01-preview'`.
- Map `name` to `sqlServerName`.
- Map `location` to `location`.
- In `properties`:
  - `administratorLogin`: map to `administratorLogin` parameter.
  - `administratorLoginPassword`: map to `administratorLoginPassword` parameter.
  - `minimalTlsVersion`: set to `'1.2'`.

### Task 7: Azure SQL Database (Child Resource)
- Declare a resource with symbolic name `sqlDatabase` and type `'Microsoft.Sql/servers/databases@2022-05-01-preview'`.
- Set `parent: sqlServer`.
- Set `name: sqlDatabaseName`.
- Set `location: location`.
- Set `sku: { name: dbSkuName }`.

---

## ✅ Self-Verification Checklist
- [ ] Is `administratorLoginPassword` marked with `@secure()`?
- [ ] Did you avoid putting a default value for `administratorLoginPassword`?
- [ ] Is `administratorLoginPassword` protected with `@minLength(12)`?
- [ ] Is `minimalTlsVersion` explicitly set to `'1.2'` on the SQL Server?
- [ ] Does `sqlDatabase` use `parent: sqlServer` instead of manually formatting the resource name?
