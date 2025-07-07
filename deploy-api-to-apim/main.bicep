
param apimInstanceName string
param apiBackendUrl string
param apiName string
param apiDisplayName string
param apiDescription string
param apiPath string
param apiRevision string = '1'
param apiOperationSampleName string
param apiOperationSampleDisplayName string

@allowed([
  'GET'
  'POST'
  'PUT'
  'DELETE'
  'HEAD'
  'OPTIONS'
  'PATCH'
  'TRACE'
])
param apiOperstionOperationMethod string = 'GET'
param apiOperationsMethodPath string = '/hello'

var policyContent = loadTextContent('apim-policy-xml/apim-policy.xml')

resource apiManagementInstance 'Microsoft.ApiManagement/service@2023-09-01-preview' existing = {
  name: apimInstanceName
}

resource apiDefinition 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' = {
  parent: apiManagementInstance
  name: apiName
  properties: {
    displayName: apiDisplayName
    description: apiDescription
    apiRevision: apiRevision
    subscriptionRequired: true
    serviceUrl: apiBackendUrl
    path: apiPath
    protocols: [
      'https'
    ]
    isCurrent: true
  }
}

resource apimSampleOperation 'Microsoft.ApiManagement/service/apis/operations@2023-09-01-preview' = {
  parent: apiDefinition
  name: apiOperationSampleName
  properties: {
    displayName: apiOperationSampleDisplayName
    method: apiOperstionOperationMethod
    urlTemplate: apiOperationsMethodPath
  }
}

resource symbolicname 'Microsoft.ApiManagement/service/apis/policies@2023-09-01-preview' = {
  parent: apiDefinition
  name: 'cors-policy'
  properties: {
    format: 'xml'
    value: policyContent
  }
}
