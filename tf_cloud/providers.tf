terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.24.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.64.0"
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
