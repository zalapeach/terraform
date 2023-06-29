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
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.45.0"
    }
  }
}

provider "azuread" {}

provider "azuredevops" {}

provider "tfe" {}
