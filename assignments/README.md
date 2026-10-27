# Bicep Practice Assignments

Welcome to your Bicep practice suite! These assignments are designed to take you from basic syntax to writing production-quality Azure Bicep code without needing an active Azure subscription or incurring cloud costs.

---

## 🎯 Concepts Covered
1. **`param`**: Declarations, data types (`string`, `int`, `bool`, `object`, `array`), default values.
2. **Decorations / Decorators**:
   - `@description('...')`
   - `@allowed([...])`
   - `@minLength(...)` and `@maxLength(...)`
   - `@minValue(...)` and `@maxValue(...)`
   - `@secure()`
3. **`resource`**: Symbolic names, type and API versions, property mapping, and symbolic resource references (`<symbolicName>.id`).
4. **Industry Best Practices**:
   - Parameter naming conventions (camelCase).
   - Never hardcoding Azure locations or environment names.
   - Safe defaults (`resourceGroup().location`).
   - Secure parameter guidelines (no hardcoded secrets or defaults).
   - Clean resource tagging.

---

## 📚 Curriculum Roadmap

| # | Assignment Directory | Focus Concepts | Real-World Scenario |
|---|----------------------|----------------|---------------------|
| 1 | [`01-storage-account-hardening`](./01-storage-account-hardening/README.md) | `param`, `@description`, `@allowed`, `@minLength`, `@maxLength` | Transform a hardcoded storage account into a hardened, multi-environment storage module. |
| 2 | [`02-hosting-web-app-and-plan`](./02-hosting-web-app-and-plan/README.md) | Multi-resource referencing, `int`, `bool`, `@minValue`, `@maxValue`, `@allowed` | Link an App Service Plan and Web App together with capacity guards and HTTPS enforcement. |
| 3 | [`03-secure-sql-database`](./03-secure-sql-database/README.md) | `@secure()`, `object`, complex constraints, security baselines | Provision an Azure SQL Server and Database while securing administrative credentials. |

---

## 🛠️ How to Practice
1. Open the assignment folder (e.g. `01-storage-account-hardening`).
2. Read the `README.md` for context, real-world best practices, and the task requirements.
3. Open `starter.bicep` (or create your own `main.bicep`) and complete the tasks.
4. Verify your work using the **Self-Verification Checklist** at the end of each assignment's README.
