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

// Network Security Group: Locks down inbound traffic to Front Door only
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: '${vnetName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowFrontDoorInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureFrontDoor.Backend'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '443'
          description: 'Allows inbound traffic exclusively from Azure Front Door edge POPs'
        }
      }
      {
        name: 'DenyAllInternetInbound'
        properties: {
          priority: 4000
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          description: 'Blocks direct public internet ingress, enforcing Front Door as the single entry point'
        }
      }
    ]
  }
}

// Virtual Network with delegated subnet for App Service / Function App
resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: appSubnetName
        properties: {
          addressPrefix: appSubnetPrefix
          networkSecurityGroup: {
            id: nsg.id
          }
          delegations: [
            {
              name: 'appServiceDelegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output appSubnetId string = vnet.properties.subnets[0].id
output nsgId string = nsg.id
