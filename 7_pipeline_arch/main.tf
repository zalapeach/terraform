terraform {
  required_providers {
    azurerm = {
      source =  "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "<check backend.conf file>"
    container_name       = "<check backend.conf file>"
    access_key           = "<check backend.conf file>"
    key                  = "<check backend.conf file>"
  }
}

provider "azurerm" {
  features {}

  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "rg" {
  name = "azdevopsRG"
  location = "eastus"
}
