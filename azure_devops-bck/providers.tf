terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.51.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=1.1.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.107.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.55.0"
    }
  }
}

provider "azuread" {}

provider "azuredevops" {}

provider "azurerm" {
  features {}

  tenant_id       = var.env_arm_tenant_id
  subscription_id = var.env_arm_subscription_id
}

provider "tfe" {}
