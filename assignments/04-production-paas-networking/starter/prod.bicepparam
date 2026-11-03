using 'main.bicep'

param environment = 'prod'
param appServicePlanSku = 'P1v3'
param vnetAddressPrefix = '10.20.0.0/16'
param appSubnetPrefix = '10.20.1.0/24'
