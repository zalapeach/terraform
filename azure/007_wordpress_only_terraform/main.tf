terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az007"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup007"
  location = "westus2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "front" {
  name                 = "front"
  address_prefixes     = ["10.1.0.0/24"]
  resource_group_name  = azure_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "pip" {
  name                = "wpIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gw" {
  name                = "WordPressGW"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
