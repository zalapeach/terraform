terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az014"
    }
  }
}
