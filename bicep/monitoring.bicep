  // resource "azurerm_application_insights" "default" {
  //   name                = "${var.name}-${var.environment}-ai"
  //   location            = "${azurerm_resource_group.default.location}"
  //   resource_group_name = "${azurerm_resource_group.default.name}"
  //   application_type    = "Web"

  //   tags = "${var.tags}"
  // }

  // resource "azurerm_log_analytics_workspace" "default" {
  //   name                = "${var.name}-${var.environment}-law"
  //   location            = "${azurerm_resource_group.default.location}"
  //   resource_group_name = "${azurerm_resource_group.default.name}"
  //   sku                 = "PerGB2018"
  //   retention_in_days   = 30

  //   tags = "${var.tags}"
  // }

// resource "azurerm_log_analytics_solution" "test" {
//   solution_name         = "ContainerInsights"
//   location              = "${azurerm_log_analytics_workspace.default.location}"
//   resource_group_name   = "${azurerm_resource_group.default.name}"
//   workspace_resource_id = "${azurerm_log_analytics_workspace.default.id}"
//   workspace_name        = "${azurerm_log_analytics_workspace.default.name}"

//   plan {
//     publisher = "Microsoft"
//     product   = "OMSGallery/ContainerInsights"
//   }
// }

param location string
param defaultTags object
param baseName string
param environment string

resource aksAzureMonitor 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${baseName}-${environment}-law'
  tags: defaultTags
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource aksAppInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${baseName}-${environment}-ai'
  tags: defaultTags
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: aksAzureMonitor.id
  }
}

output aksAZMonId string = aksAzureMonitor.id
