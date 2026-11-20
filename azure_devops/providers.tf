terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.16.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.2.0"
    }
  }
  cloud {
    organization = "zalapeach1"
    workspaces {
      name = "azdo"
    }
  }
}

provider "azuredevops" {}

provider "azurerm" {
  features {}
}
