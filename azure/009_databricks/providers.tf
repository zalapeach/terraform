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
      name = "009"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = azurerm_databricks_workspace.databricks.workspace_url
}
