@description('The name of the Azure Front Door. This value is stored in the common-imports.bicep parameter imports file.')
param frontDoorName string
param workspaceName string

@description('The rulesets to be applied to the Azure Front Door. This value is stored in the workspace-specific bicep parameter imports file.')
param ruleSets object

resource frontDoor 'Microsoft.Cdn/profiles@2024-02-01' existing = {
  name: frontDoorName
}

resource ruleSet 'Microsoft.Cdn/profiles/ruleSets@2024-09-01' = if (!empty(ruleSets)) {
  name: format('{0}{1}',workspaceName,ruleSets.name)
  parent: frontDoor
}

resource ruleResource 'Microsoft.Cdn/profiles/ruleSets/rules@2024-09-01' = [
  for (rule, i) in ruleSets.rules: if (!empty(rule)) {
    name: rule.name
    parent: ruleSet
    properties: rule.config
  }
]

output ruleSetId string = ruleSet.id
