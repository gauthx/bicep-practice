@description('Name of the Virtual Network')
param vnetName string

@description('Virtual Network address prefix in CIDR notation (e.g. 10.0.0.0/16)')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Name of the delegated subnet for App Service / Function App VNet integration')
param appSubnetName string = 'snet-app-integration'

@description('Subnet address prefix in CIDR notation (e.g. 10.0.1.0/24). Must fit inside vnetAddressPrefix!')
param appSubnetPrefix string = '10.0.1.0/24'

@description('Azure region for the resources')
param location string = resourceGroup().location

// ============================================================================
// TASK 1A: Network Security Group (NSG)
// ============================================================================
// TODO: Define a 'Microsoft.Network/networkSecurityGroups@2024-05-01' resource named '${vnetName}-nsg'.
// Requirements:
// 1. Add an inbound security rule named 'AllowFrontDoorInbound':
//    - Priority: 100
//    - Protocol: 'Tcp'
//    - Access: 'Allow'
//    - Direction: 'Inbound'
//    - SourceAddressPrefix: 'AzureFrontDoor.Backend'
//    - SourcePortRange: '*'
//    - DestinationAddressPrefix: 'VirtualNetwork'
//    - DestinationPortRange: '443'
// 2. Add an inbound security rule named 'DenyAllInternetInbound':
//    - Priority: 4000
//    - Protocol: '*'
//    - Access: 'Deny'
//    - Direction: 'Inbound'
//    - SourceAddressPrefix: 'Internet'
//    - SourcePortRange: '*'
//    - DestinationAddressPrefix: '*'
//    - DestinationPortRange: '*'

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: '${vnetName}-nsg'
  location: location
  properties: {
    securityRules: [
      // TODO: Place your security rules here
    ]
  }
}

// ============================================================================
// TASK 1B: Virtual Network and Subnet with Delegation
// ============================================================================
// TODO: Define a 'Microsoft.Network/virtualNetworks@2024-05-01' resource.
// Requirements:
// 1. Address space: use vnetAddressPrefix.
// 2. Subnet named appSubnetName with addressPrefix appSubnetPrefix.
// 3. Attach the NSG created above via 'networkSecurityGroup: { id: nsg.id }'.
// 4. Add delegation to 'Microsoft.Web/serverFarms' so App Service & Function App can join:
//    delegations: [
//      {
//        name: 'appServiceDelegation'
//        properties: {
//          serviceName: 'Microsoft.Web/serverFarms'
//        }
//      }
//    ]

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        // TODO: Pass vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: appSubnetName
        properties: {
          addressPrefix: appSubnetPrefix
          // TODO: Attach NSG and add delegation
        }
      }
    ]
  }
}

// ============================================================================
// Outputs
// ============================================================================
// TODO: Output the vnetId, appSubnetId, and nsgId for consumption by other modules
output vnetId string = vnet.id
output appSubnetId string = vnet.properties.subnets[0].id
output nsgId string = nsg.id
