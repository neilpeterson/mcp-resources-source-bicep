@description('The location of all resources')
param location string

@description('Name of the storage account')
param storageAccountName string

@description('SKU name for the storage account')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageAccountSku string

@description('Kind of storage account')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param storageAccountKind string

@description('Enable/disable blob encryption at rest')
param enableBlobEncryption bool

@description('Enable/disable https traffic only')
param supportsHttpsTrafficOnly bool

@description('Virtual network resource ID')
param vnetResourceId string

@description('Subnet name within the virtual network for private endpoint')
param privateEndpointSubnetName string

@description('Private endpoint name')
param privateEndpointName string

// Create the storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: storageAccountKind
  properties: {
    accessTier: (storageAccountKind == 'BlobStorage') ? 'Hot' : null
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    encryption: {
      services: {
        blob: {
          enabled: enableBlobEncryption
        }
        file: {
          enabled: enableBlobEncryption
        }
      }
      keySource: 'Microsoft.Storage'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
}

// Get the subnet resource ID by combining the VNET resource ID and subnet name
var privateEndpointSubnetId = '${vnetResourceId}/subnets/${privateEndpointSubnetName}'

// Create private endpoint for the storage account
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

// Outputs
output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output privateEndpointId string = privateEndpoint.id
