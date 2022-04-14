// az account list --output table
// az account set --subscription "My Demos"


// az group create --name demo-mtc-appdev-whackamolev2-rg1 --location westus
// az deployment group create --resource-group demo-mtc-appdev-whackamolev2-rg1 --template-file bicep/main.bicep --parameters @bicep/main.parameters.json           



//targetScope = 'subscription'

// Default tags 
param deploymentDateTag string = utcNow('MM/dd/yy')
param mtcArchitectTag   string = 'Jason Cook'
param deployedWithTag   string = 'Bicep'
param defaultTagsObject object = {
  'mtc-architect': mtcArchitectTag
  'deployed-with': deployedWithTag
  'created-date': deploymentDateTag
}

@minLength(3)
@maxLength(24)
param storageName string


param baseName string
//param vnetName string = '${baseName}-vnet'








module networkModule './networking.bicep' = {
  name: 'networkInfraDeployment'
  params: {
    defaultTags: defaultTagsObject
    baseName: baseName
  }
}

