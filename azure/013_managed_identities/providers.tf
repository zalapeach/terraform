terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.105.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.9.0"
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

provider "azuredevops" {}
