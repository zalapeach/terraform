terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.45.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "azdo"
    }
  }
}

provider "tfe" {}
