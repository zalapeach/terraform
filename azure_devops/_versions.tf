terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.45.0"
    }
  }
}

provider "tfe" {}

provider "azuread" {}
