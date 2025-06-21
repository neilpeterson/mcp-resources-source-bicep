using '../main.bicep'

param location = 'centralus'
param storageAccountName = 'tststorageacct'
param storageAccountSku = 'Standard_LRS'
param storageAccountKind = 'StorageV2'
param enableBlobEncryption = true
param supportsHttpsTrafficOnly = true
param vnetResourceId = '<placeholder-vnet-resource-id>'
param privateEndpointSubnetName = '<placeholder-private-endpoint-subnet-name>'
param privateEndpointName = 'tstprivateendpoint'


