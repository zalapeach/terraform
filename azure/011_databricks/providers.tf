terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.39.0"
    }
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

provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.id
  host                        = "https://${azurerm_databricks_workspace.databricks.workspace_url}"
}
