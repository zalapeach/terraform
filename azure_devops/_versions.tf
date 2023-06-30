terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.62.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.45.0"
    }
  }
}

provider "azuread" {}

provider "azuredevops" {}

provider "azurerm" {
  features {}

#  client_id       = var.arm_client_id
#  client_secret   = var.arm_client_secret
#  tenant_id       = var.env_arm_tenant_id
#  subscription_id = var.env_arm_subscription_id
}

provider "tfe" {}
