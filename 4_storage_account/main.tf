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
  name     = "Practice07d"
  location = "eastus"
}

resource "random_id" "id" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "storage_${random_id.id.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "storage_container"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name = "storage_blob"
  storage_account_name = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type = "Block"
}
