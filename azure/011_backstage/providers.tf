terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az011"
    }
  }
}

provider "azurerm" {
  features {}
}
