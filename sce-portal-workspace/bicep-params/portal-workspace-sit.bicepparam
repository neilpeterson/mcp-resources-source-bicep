using '../main.bicep'

param origins = [
  {
    name: 'infra-sit-west'
    endpoint: ''
    privateLinkResourceId: ''
  }
  {
    name: 'infra-sit-east'
    endpoint: ''
    privateLinkResourceId: ''
  }
]

param frontDoorName = ''
param domain = ''
param frontDoorEndpointName = ''
param workspaceName = ''
param ruleSets = []
param routingSuffix = []
param routeName = ''
param originGroupName = ''
param originEndpointPath = ''
param originProbePath = ''
