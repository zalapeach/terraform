terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.61.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "azdo"
    }
  }
}

provider "azuredevops" {}

provider "azurerm" {
  features {}
}
