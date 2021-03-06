terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
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
  name     = "vaultRG"
  location = "eastus"
}

resource "azurerm_key_vault" "keyvault" {
  name                = "zalaVault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg
  sku_name            = "standard"
}
