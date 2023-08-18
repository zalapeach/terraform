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
      name = "002"
    }
  }
}

provider "azurerm" {
  features {}
}

data "external" "env" {
  program = ["${path.module}/scripts/env.sh"]
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup002"
  location = "eastus2"

  tags = {
    Environment = "Terraform"
    Team        = "DevOps"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myTfVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.rg.name
}
