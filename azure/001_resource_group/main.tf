terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.107.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az001"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup001"
  location = "eastus2"
}
