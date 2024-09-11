terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.107.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name "databricksRAg"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/$(subscriptionId)/resourceGroups/zalabricks-rg"
}

resource "azurerm_resource_group" "rg" {
  name     = "zalabricks-rg"
  location = "eastus2"
}
