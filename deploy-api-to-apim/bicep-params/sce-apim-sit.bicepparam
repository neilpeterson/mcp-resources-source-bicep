using '../main.bicep'

// API Management instance name - select from allowed values
param apimInstanceName = 'apim-api-gateway-msft-lab'

// API properties
param apiBackendUrl = 'https://api-backend.example.com'
param apiName = 'example-api'
param apiDisplayName = 'Example API'
param apiDescription = 'This is an example API for demonstration purposes'
param apiPath = 'example'

// API revision defaults to '1' in the template if not specified

// API operation sample details
param apiOperationSampleName = 'get-hello'
param apiOperationSampleDisplayName = 'Get Hello'

// Operation method and path
// Default values in the template: GET and /hello
// Uncomment to override defaults
// param apiOperstionOperationMethod = 'GET'
// param apiOperationsMethodPath = '/hello'
