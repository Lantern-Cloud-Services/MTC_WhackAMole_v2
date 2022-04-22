param location string
param defaultTags object
param baseName string
param environment string


resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: replace('${baseName}-${environment}acr', '-', '')
  tags: defaultTags
  location: location
  sku: {
    #disable-next-line BCP036 //Disabling validation of this parameter to cope with empty string to indicate no ACR required.
    name: 'Basic'
  }
  properties: {
    // TOD create a repo - whack-a-mole/mole-cloud
    
    // policies: {
    //   trustPolicy: enableACRTrustPolicy ? {
    //     status: acrContentTrustEnabled
    //     type: 'Notary'
    //   } : {}
    //   retentionPolicy: acrUntaggedRetentionPolicyEnabled ? {
    //     status: 'enabled'
    //     days: acrUntaggedRetentionPolicy
    //   } : json('null')
    // }
    // publicNetworkAccess: privateLinks /* && empty(acrIPWhitelist)*/ ? 'Disabled' : 'Enabled'
    // zoneRedundancy: acrZoneRedundancyEnabled
  }
}
