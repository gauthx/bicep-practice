@description('Name of the Front Door profile')
param profileName string

@description('Name of the Front Door endpoint')
param endpointName string

@description('Origin hostname (the defaultHostName of the Web App)')
param webAppHostName string

// ============================================================================
// TASK 4A: Azure Front Door Profile
// ============================================================================
// TODO: Define a 'Microsoft.Cdn/profiles@2024-02-01' resource with sku 'Standard_AzureFrontDoor'.
// Note: Azure Front Door is a global service; its location must be 'global'.

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
// TODO: Define an endpoint using 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01'.

resource afdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' = {
  parent: afdProfile
  name: endpointName
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

// ============================================================================
// TASK 4C: Origin Group & Origin (Points to Web App)
// ============================================================================
// TODO: Define an origin group and an origin child resource.

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = {
  parent: afdProfile
  name: 'default-origin-group'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource webAppOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = {
  parent: originGroup
  name: 'webapp-origin'
  properties: {
    hostName: webAppHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: webAppHostName
    priority: 1
    weight: 1000
    enforceCertificateNameCheck: true
  }
}

// ============================================================================
// TASK 4D: Routing Rule (Forwards requests from Endpoint to Origin Group)
// ============================================================================

resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  parent: afdEndpoint
  name: 'default-route'
  dependsOn: [
    webAppOrigin
  ]
  properties: {
    originGroup: {
      id: originGroup.id
    }
    supportedProtocols: [
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

// ============================================================================
// Outputs
// ============================================================================
output frontDoorEndpointHostName string = afdEndpoint.properties.hostName
output frontDoorProfileId string = afdProfile.id
