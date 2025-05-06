terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az003"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup003"
  location = "eastus2"
}

resource "random_id" "id" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "storage${random_id.id.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "container"
  storage_account_id    = azurerm_storage_account.storageaccount.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "example"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.storagecontainer.name
  type                   = "Block"
  source                 = var.blob_path
}

resource "azurerm_role_assignment" "test" {
  scope                = azurerm_storage_account.storageaccount.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = "860b52d9-325e-481e-b5d6-aaab2699da15"
}
