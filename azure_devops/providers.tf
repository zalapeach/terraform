terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.8.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.24.0"
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
