terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1.21.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "011"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup011"
  location = "westus2"
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.databricks.workspace_url}"
}

data "databricks_current_user" "user" {
  depends_on = [azurerm_databricks_workspace.databricks]
}
