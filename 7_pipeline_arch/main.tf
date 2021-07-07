terraform {
  required_providers {
    azurerm = {
      source =  "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "juanc"
    container_name       = "blobcontainer"
    access_key           = "<access_key>"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "azdevopsRG"
  location = "eastus"
}
