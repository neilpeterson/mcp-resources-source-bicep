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

param frontDoorName = '<placeholder-front-door-name>'
param domain = '<placeholder-front-door-domain>'
param frontDoorEndpointName = 'scops'

// These values come from the account-management-imports.bicep file and are common to the account-management workspace.
import * as localImports from 'local-imports.bicep'

param workspaceName = localImports.workspaceShortName
param ruleSets = localImports.ruleSets
param routingSuffix = localImports.routingSuffix
param routeName = localImports.routeName
param originGroupName = localImports.originGroupName
param originEndpointPath = localImports.originEndpointPath
param originProbePath = localImports.originProbePath
