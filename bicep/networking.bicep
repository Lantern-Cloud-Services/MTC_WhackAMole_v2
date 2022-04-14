param defaultTags object
param baseName string

param vnetAddressSpace          string = '10.0.0.0/8'
param aksSubNetAddressSpace     string = '10.1.0.0/16'
param ingressSubNetAddressSpace string = '10.2.0.0/24'
param gatewaySubNetAddressSpace string = '10.2.1.0/24'

// VNT to deploy resources into
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: '${baseName}-vnet'
  location: resourceGroup().location
  tags: defaultTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: '${baseName}-aks-subnet'
        properties: {
          addressPrefix: aksSubNetAddressSpace
          networkSecurityGroup: {
            id: nsgAKS.id
          }
        }
      }
      {
        name: '${baseName}-ingress-subnet'
        properties: {
          addressPrefix: ingressSubNetAddressSpace
          networkSecurityGroup: {
            id:  nsgIngress.id            
          }
        }
      }
      {
        name: '${baseName}-gateway-subnet'
        properties: {
          addressPrefix: gatewaySubNetAddressSpace
          networkSecurityGroup: {
            id: nsgGateway.id
          }
        }
      }
    ]
  }
}

// Network Security Groups
resource nsgAKS  'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${baseName}-aks-nsg'
  location: resourceGroup().location
  tags: defaultTags
}
resource nsgIngress  'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${baseName}-ingress-nsg'
  location: resourceGroup().location
  tags: defaultTags
}
resource nsgGateway  'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${baseName}-gateway-nsg'
  location: resourceGroup().location
  tags: defaultTags
}

