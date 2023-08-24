terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "netWatch"
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
  to       = azurerm_resource_group.rg
  id       = "/subscriptions/$(subscriptionId)/resourceGroups/NetworkWatcherRG"
}

resource "azurerm_resource_group" "rg" {
  name     = "NetworkWatcherRG"
  location = "eastus2"
}
