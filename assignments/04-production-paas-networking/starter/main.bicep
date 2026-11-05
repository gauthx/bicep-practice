@description('The target environment name')
@allowed([
  'dev'
  'prod'
])
param environment string

@description('Azure region for regional resources')
param location string = resourceGroup().location

@description('App Service Plan SKU size')
param appServicePlanSku string

@description('VNet Address Prefix (CIDR block, e.g. 10.10.0.0/16)')
param vnetAddressPrefix string

@description('App Subnet Address Prefix (CIDR block, e.g. 10.10.1.0/24)')
param appSubnetPrefix string

// Unique suffix to guarantee globally unique DNS names across environments
var uniqueSuffix = uniqueString(resourceGroup().id, environment)
var vnetName = 'vnet-${environment}-${location}'
var appConfigName = 'appcs-${environment}-${uniqueSuffix}'
var baseComputeName = '${environment}-${uniqueSuffix}'
var frontDoorProfileName = 'afd-${environment}-${uniqueSuffix}'
var frontDoorEndpointName = 'fde-${environment}-${uniqueSuffix}'

// ============================================================================
// TASK 5A: Network Module
// ============================================================================
// TODO: Instantiate 'modules/network.bicep' with symbolic name 'network'.
// Pass params:
//   vnetName: vnetName
//   vnetAddressPrefix: vnetAddressPrefix
//   appSubnetName: 'snet-app-${environment}'
//   appSubnetPrefix: appSubnetPrefix
//   location: location

module network 'modules/network.bicep' = {
  name: 'networkDeployment-${environment}'
  params: {
    // TODO: Wire parameters
  }
}

// ============================================================================
// TASK 5B: App Configuration Module
// ============================================================================
// TODO: Instantiate 'modules/appconfig.bicep' with symbolic name 'appConfig'.
// Pass params:
//   appConfigName: appConfigName
//   environment: environment
//   sku: environment == 'prod' ? 'standard' : 'free'
//   location: location

module appConfig 'modules/appconfig.bicep' = {
  name: 'appConfigDeployment-${environment}'
  params: {
    // TODO: Wire parameters
  }
}

// ============================================================================
// TASK 5C: Compute Module (App Service & Function App)
// ============================================================================
// TODO: Instantiate 'modules/compute.bicep' with symbolic name 'compute'.
// Pass params:
//   baseName: baseComputeName
//   skuName: appServicePlanSku
//   subnetId: network.outputs.appSubnetId  <-- Notice the cross-module dependency!
//   appConfigEndpoint: appConfig.outputs.appConfigEndpoint
//   location: location

module compute 'modules/compute.bicep' = {
  name: 'computeDeployment-${environment}'
  params: {
    // TODO: Wire parameters
  }
}

// ============================================================================
// TASK 5D: Azure Front Door Module
// ============================================================================
// TODO: Instantiate 'modules/frontdoor.bicep' with symbolic name 'frontDoor'.
// Pass params:
//   profileName: frontDoorProfileName
//   endpointName: frontDoorEndpointName
//   webAppHostName: compute.outputs.webAppDefaultHostName  <-- Routes traffic to your Web App!

module frontDoor 'modules/frontdoor.bicep' = {
  name: 'frontDoorDeployment-${environment}'
  params: {
    // TODO: Wire parameters
  }
}

// ============================================================================
// Outputs
// ============================================================================
output frontDoorUrl string = 'https://${frontDoor.outputs.frontDoorEndpointHostName}'
output webAppUrl string = 'https://${compute.outputs.webAppDefaultHostName}'
output appConfigEndpoint string = appConfig.outputs.appConfigEndpoint
output appSubnetId string = network.outputs.appSubnetId
