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
      name = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup001"
  location = "eastus"
}
