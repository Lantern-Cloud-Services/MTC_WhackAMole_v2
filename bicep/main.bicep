// az account list --output table
// az account set --subscription "My Demos"


// az group create --name demo-mtc-appdev-whackamolev2-rg1 --location westus
// az deployment group create --resource-group demo-mtc-appdev-whackamolev2-rg1 --template-file bicep/main.bicep --parameters @bicep/main.parameters.json           


// az deployment sub create --location WestUs --template-file bicep/main.bicep --parameters @bicep/main.parameters.json

param baseName string
param environment string

param resourceGroupName     string = '${baseName}-rg2'
param resourceGroupLocation string = 'WestUs'

// Default tags 
param deploymentDateTag string = utcNow('MM/dd/yy')
param mtcArchitectTag   string = 'Jason Cook'
param deployedWithTag   string = 'Bicep'
param defaultTagsObject object = {
  'mtc-architect': mtcArchitectTag
  'deployed-with': deployedWithTag
  'created-date': deploymentDateTag
}

// TODO need to externalize or dynamically create
@secure()
param aksServicePClientId string = ''
@secure()
param aksServicePSecret string = ''

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {  
  name: resourceGroupName
  location: resourceGroupLocation
  tags: defaultTagsObject
}


module networkModule './networking.bicep' = {
  name: 'networkInfraDeployment'
  scope: rg
  params: {
    location: resourceGroupLocation
    defaultTags: defaultTagsObject
    baseName: baseName
  }
}

module aksAzureMonitorModule './monitoring.bicep' = {
  name: 'aksAzureMonitorDeployment'
  scope: rg
  params: {
    location: resourceGroupLocation
    defaultTags: defaultTagsObject
    baseName: baseName
    environment: environment
  }
}

module aksACR './acr.bicep' = {
  name: 'aksACRDeployment'
  scope: rg
  params: {
    location: resourceGroupLocation
    defaultTags: defaultTagsObject
    baseName: baseName
    environment: environment
  }
}

module aksModule './aks.bicep' = {
  name: 'aksDeployment'
  scope: rg
  params: {
    location: resourceGroupLocation
    defaultTags: defaultTagsObject
    baseName: baseName
    environment: environment
    aksAzureMonitorModuleId: aksAzureMonitorModule.outputs.aksAZMonId
    aksSubnetId: networkModule.outputs.aksSubnetId
    servicePClientId: aksServicePClientId
    servicePSecret: aksServicePSecret
  }
}

// module k8sModule './kubernetes.bicep' = {
//   name: 'kubernetesInfraDeployment'
//   scope: rg
//   params: {
//     defaultTags: defaultTagsObject
//     baseName: baseName
//     environment: environment
//   }
// }
