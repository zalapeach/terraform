terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.10.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
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
