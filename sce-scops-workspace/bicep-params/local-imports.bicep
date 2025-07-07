// These are common imports that will be userd across multiple workspace environments.

@export()
var workspaceShortName = '<placeholder-workspace-name>'

@export()
var routeName = '<placeholder-workspace-name>'

@export()
var originGroupName = '<placeholder-workspace-name>'

@export()
var originEndpointPath = '/'

@export()
var originProbePath = '/index.html'

@export()
var routingSuffix = [
  '/<placeholder-workspace-name>'
]

@export()
var ruleSets = [
  {
    name: 'JSFilesPath'
    rules: [
      {
        name: 'AppendJSFilesFolder'
        config: {
          order: 0
          conditions: []
          actions: [
            {
              name: 'UrlRewrite'
              parameters: {
                typeName: 'DeliveryRuleUrlRewriteActionParameters'
                sourcePattern: '/'
                destination: '/JSFiles/'
                preserveUnmatchedPath: true
              }
            }
          ]
          matchProcessingBehavior: 'Continue'
        }
      }
    ]
  }
]
