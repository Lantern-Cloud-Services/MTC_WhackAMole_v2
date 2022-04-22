

// resource "azurerm_kubernetes_cluster" "default" {
  //   name                = "${var.name}-aks"
  //   location            = "${azurerm_resource_group.default.location}"
  //   resource_group_name = "${azurerm_resource_group.default.name}"
  //   dns_prefix          = "${var.name}-aks-${var.environment}"
//   depends_on          = ["azurerm_role_assignment.default"]

  //   agent_pool_profile {
  //     name            = "default"
  //     count           = "${var.node_count}"
  //     vm_size         = "${var.node_type}"
  //     os_type         = "${var.node_os}"
  //     os_disk_size_gb = 30
  //     vnet_subnet_id  = "${azurerm_subnet.aks.id}"
  //   }

  //   service_principal {
  //     client_id     = "${azuread_application.default.application_id}"
  //     client_secret = "${azuread_service_principal_password.default.value}"
  //   }

  //   role_based_access_control {
  //     enabled = true
  //   }

  //   network_profile {
  //     network_plugin = "azure"
  //   }

//   addon_profile {
  //     oms_agent {
  //       enabled                    = true
  //       log_analytics_workspace_id = "${azurerm_log_analytics_workspace.default.id}"
  //     }

//     http_application_routing {
//       enabled = true
//     }
//   }

  //   tags = "${var.tags}"
// }


param location string
param defaultTags object
param baseName string
param environment string
param aksAzureMonitorModuleId string
param aksSubnetId string
@secure()
param servicePClientId string
@secure()
param servicePSecret string


param aksSettings object = {
  kubernetesVersion: null
  networkPlugin: 'azure'
  skuTier: 'Paid'
  aksName: '${baseName}-vnet'
  dnsPrefix: '${baseName}-aks-${environment}'
  enableRBAC: true 
  loadBalancerSku: 'basic'
  identity: 'SystemAssigned'
  aadProfileManaged: true
  // networkPolicy: 'calico'
  // serviceCidr: '172.16.0.0/22' // Must be cidr not in use any where else across the Network (Azure or Peered/On-Prem).  Can safely be used in multiple clusters - presuming this range is not broadcast/advertised in route tables.
  // dnsServiceIP: '172.16.0.10' // Ip Address for K8s DNS
  // dockerBridgeCidr: '172.16.4.1/22' // Used for the default docker0 bridge network that is required when using Docker as the Container Runtime.  Not used by AKS or Docker and is only cluster-routable.  Cluster IP based addresses are allocated from this range.  Can be safely reused in multiple clusters.
  // outboundType: 'loadBalancer'
  // adminGroupObjectIDs: [] 
}

param defaultNodePool object = {
  name: 'default'
  count: 3
  vmSize: 'Standard_D2s_v3'
  osType: 'Linux'
  osDiskSizeGB: 50
  vnetSubnetID: aksSubnetId
  mode: 'System'
  // osDiskType: 'Ephemeral'
  // maxCount: 6
  // minCount: 2
  // enableAutoScaling: true
  // type: 'VirtualMachineScaleSets'
  // orchestratorVersion: null
}


resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: '${baseName}-vnet'
  location: location
  tags: defaultTags

  sku: {
    name: 'Basic'
    tier: aksSettings.skuTier
  }

  properties: {
    kubernetesVersion: aksSettings.kubernetesVersion
    dnsPrefix: aksSettings.dnsPrefix
    // linuxProfile: {
    //   adminUsername: adminUsername
    //   ssh: {
    //     publicKeys: [
    //       {
    //         keyData: adminPublicKey
    //       }
    //     ]
    //   }
    enableRBAC: aksSettings.enableRBAC

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {          
          logAnalyticsWorkspaceResourceID: aksAzureMonitorModuleId          
        }
      }
      httpApplicationRouting: {
        enabled: true
      }      
    }

    networkProfile: {
      networkPlugin: aksSettings.networkPlugin 
    }

    agentPoolProfiles: [
      defaultNodePool
    ]

    servicePrincipalProfile: {
      clientId: servicePClientId
      secret: servicePSecret
    }
  }
}
