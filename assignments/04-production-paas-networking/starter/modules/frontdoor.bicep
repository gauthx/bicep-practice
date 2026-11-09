@description('Name of the Front Door profile')
param profileName string

@description('Name of the Front Door endpoint')
param endpointName string

@description('Origin hostname (the defaultHostName of the Web App)')
param webAppHostName string

// ============================================================================
// TASK 4A: Azure Front Door Profile
// ============================================================================
// TODO: Define a 'Microsoft.Cdn/profiles@2024-02-01' resource named profileName.
// Requirements:
// 1. Azure Front Door is a global service; its location must be 'global'.
// 2. Set sku.name to 'Standard_AzureFrontDoor'.

resource afdProfile 'Microsoft.Cdn/profiles@2024-02-01' = {
  name: profileName
  location: 'global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
}

// ============================================================================
// TASK 4B: Front Door Endpoint
// ============================================================================
// TODO: Define an endpoint using child resource 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01'.
// Requirements:
// 1. Set parent: afdProfile
// 2. Set name: endpointName
// 3. Set location: 'global'
// 4. Set properties.enabledState: 'Enabled'

resource afdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' = {
  parent: afdProfile
  name: endpointName
  location: 'global'
  properties: {
    enabledState:'Enabled'
  }
}

// ============================================================================
// TASK 4C: Origin Group & Origin (Points to Web App)
// ============================================================================
// An Origin Group defines where Front Door routes traffic to (your backend Web App).
// TODO 1: Define 'Microsoft.Cdn/profiles/originGroups@2024-02-01' named 'default-origin-group'.
//   - parent: afdProfile
//   - properties:
//       loadBalancingSettings: { sampleSize: 4, successfulSamplesRequired: 3 }
//       healthProbeSettings: { probePath: '/', probeRequestType: 'HEAD', probeProtocol: 'Https', probeIntervalInSeconds: 100 }
//
// TODO 2: Define child origin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' named 'webapp-origin'.
//   - parent: originGroup
//   - properties:
//       hostName: webAppHostName
//       httpPort: 80
//       httpsPort: 443
//       originHostHeader: webAppHostName
//       priority: 1
//       weight: 1000
//       enforceCertificateNameCheck: true

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = {
  parent: afdProfile
  name: 'default-origin-group'
  properties: {
    loadBalancingSettings:{sampleSize:4, successfulSamplesRequired:3}
    healthProbeSettings:{probePath:'/', probeRequestType:'HEAD', probeProtocol:'Https', probeIntervalInSeconds:100}
  }
}

resource webAppOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = {
  parent: originGroup
  name: 'webapp-origin'
  properties: {
    hostName: webAppHostName
    httpPort:80
    httpsPort: 443
    originHostHeader: webAppHostName
    priority:1
    weight: 1000
    enforceCertificateNameCheck: true
    // TODO: Configure origin hostName, ports, and originHostHeader
  }
}

// ============================================================================
// TASK 4D: Routing Rule (Forwards requests from Endpoint to Origin Group)
// ============================================================================
// TODO: Define route using 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' named 'default-route'.
// Requirements:
// 1. parent: afdEndpoint
// 2. dependsOn: [ webAppOrigin ]
// 3. properties:
//    - originGroup: { id: originGroup.id }
//    - supportedProtocols: [ 'Https' ]
//    - patternsToMatch: [ '/*' ]
//    - forwardingProtocol: 'HttpsOnly'
//    - linkToDefaultDomain: 'Enabled'
//    - httpsRedirect: 'Enabled'

resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  parent: afdEndpoint
  name: 'default-route'
  properties: {
    originGroup:{id:originGroup.id}
    supportedProtocols:['Https']
    patternsToMatch:['/*']
    forwardingProtocol:'HttpsOnly'
    linkToDefaultDomain:'Enabled'
    httpsRedirect:'Enabled'
  }
}

// ============================================================================
// Outputs
// ============================================================================
output frontDoorEndpointHostName string = afdEndpoint.properties.hostName
output frontDoorProfileId string = afdProfile.id
