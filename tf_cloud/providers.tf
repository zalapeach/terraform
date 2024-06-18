terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.56.0"
    }
  }
}

provider "azuread" {}

provider "tfe" {}
