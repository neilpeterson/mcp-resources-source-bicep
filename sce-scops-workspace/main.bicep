@description('The name of the Azure Front Door. This value is stored in the common-imports.bicep parameter imports file.')
param frontDoorName string

@description('The name of the Azure Front Door endpoint. This value is stored in the common-imports.bicep parameter imports file.')
param frontDoorEndpointName string

@description('The domain name associated with the Azure Front Door. This value is stored in the common-imports.bicep parameter imports file.')
param domain string

@description('The name of the workspace/service for the Azure Front Door. This value is stored in the workspace-specific bicep parameter imports file.')
param workspaceName string

@description('The name of the route for the Azure Front Door. This value is stored in the workspace-specific bicep parameter imports file.')
param routeName string

@description('The name of the origin group for the Azure Front Door. This value is stored in the workspace-specific bicep parameter imports file.')
param originGroupName string

@description('The path to the origin endpoint. This value is stored in the workspace-specific bicep parameter imports file.')
param originEndpointPath string

@description('The path to be used for health probes. This value is stored in the workspace-specific bicep parameter imports file.')
param originProbePath string

@description('The list of routing suffixes for the Azure Front Door route. This value is stored in the workspace-specific bicep parameter imports file.')
param routingSuffix array

@description('The list of origins for the Azure Front Door origin group. The values are stored in the workspace specific parameter file')
param origins array

@description('The rulesets to be applied to the Azure Front Door. This value is stored in the workspace-specific bicep parameter imports file.')
param ruleSets array // TODO, I think it is more idomatic to use an array instead of an objects here.

var noRules = [empty(ruleSets) ? true : false]
var ruleId = [for rule in ruleSets: { id: resourceId('Microsoft.Cdn/profiles/ruleSets', frontDoorName, format('{0}{1}',workspaceName,rule.name)) }]

resource frontDoor 'Microsoft.Cdn/profiles@2024-02-01' existing = {
  name: frontDoorName
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' existing = {
  name: frontDoorEndpointName
  parent: frontDoor
}

resource domainName 'Microsoft.Cdn/profiles/customDomains@2024-02-01' existing = {
  name: split(domain, '.')[0]
  parent: frontDoor
}

module afdRules './bicep-modules/afd-rules.bicep' = [
  for (rule, i) in ruleSets: {   
  name: format('{0}{1}','afd-rules',rule.name)
  params: {
    frontDoorName: frontDoorName
    workspaceName: workspaceName
    ruleSets: rule
  }  
  }
]

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = {
  parent: frontDoor
  name: originGroupName
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probeIntervalInSeconds: 100
      probePath: originProbePath
      probeProtocol: 'Https'
      probeRequestType: 'GET'
    }
    sessionAffinityState: 'Disabled'
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = [
  for origin in origins: {
    name: origin.name
    parent: frontDoorOriginGroup
    properties: {
      hostName: origin.endpoint
      httpPort: 80
      httpsPort: 443
      originHostHeader: origin.endpoint
      priority: 1
      weight: 1000
      enabledState: 'Enabled'
      enforceCertificateNameCheck: true
      sharedPrivateLinkResource: {
        privateLink: {
          id: origin.privateLinkResourceId
        }
        groupId: 'web'
        privateLinkLocation: 'centralus'
        requestMessage: 'Azure Front Door Private Link Request.'
      }
    }
  }
]

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  name: routeName
  parent: frontDoorEndpoint
  properties: {
    customDomains: [
      {
        id: domainName.id
      }
    ]
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: routingSuffix
    originPath: originEndpointPath
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Disabled'
    httpsRedirect: 'Disabled'
    enabledState: 'Enabled'
    ruleSets: empty(noRules) ? null : ruleId
  }
  dependsOn: [
    frontDoorOrigin
    afdRules
  ]
}
