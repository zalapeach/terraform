terraform {
  required_providers {
    azurerm = {
      source =  "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "<change this>"
    container_name       = "<change this>"
    access_key           = "<change this>"
    key                  = "<change this>"
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
