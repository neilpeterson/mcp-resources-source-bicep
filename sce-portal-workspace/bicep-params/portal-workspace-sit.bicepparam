using '../main.bicep'

param origins = [
  {
    name: 'infra-lab-west'
    endpoint: 'webafdtest001tmesbox.z19.web.core.windows.net'
    privateLinkResourceId: '/subscriptions/69a71900-fa96-4cea-8921-eeb051221357/resourceGroups/rg-web-afd-test-001-tme-sbox/providers/Microsoft.Storage/storageAccounts/webafdtest001tmesbox'
  }
  {
    name: 'infra-lab-east'
    endpoint: 'webafdtest001tmesbox.z19.web.core.windows.net'
    privateLinkResourceId: '/subscriptions/69a71900-fa96-4cea-8921-eeb051221357/resourceGroups/rg-web-afd-test-001-tme-sbox/providers/Microsoft.Storage/storageAccounts/webafdtest001tmesbox'
  }
]

param frontDoorName = ''
param domain = ''
param frontDoorEndpointName = ''
param workspaceName = ''
param ruleSets = []
param routingSuffix = ''
param routeName = ''
param originGroupName = ''
param originEndpointPath = ''
param originProbePath = ''
