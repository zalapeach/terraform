terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.105.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az012"
    }
  }
}

provider "azurerm" {
  features {}
}
