terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
#  backend "azurerm" {
#    resource_group_name  = "<storage_account_resource_group>"
#    storage_account_name = "<storage_account_name>"
#    container_name       = "tfstate"
#    key                  = "codelab.microsoft.tfstate"
#  }
}

provider "azurerm" {
  features {}

 # subscription_id   = "<azure_subscription_id>"
 # tenant_id         = "<azure_subscription_tenant_id>"
 # client_id         = "<service_principal_appid>"
 # client_secret     = "<service_principal_password>"
}