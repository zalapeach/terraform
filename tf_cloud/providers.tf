terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.56.0"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}

  tenant_id       = var.env_arm_tenant_id
  subscription_id = var.env_arm_subscription_id
}

provider "tfe" {}
