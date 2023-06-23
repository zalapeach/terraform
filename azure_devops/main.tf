terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.5.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "azdo"
    }
  }
}

provider "azuredevops" {
}

resource "azuredevops_project" "project" {
  name        = "Terraform Examples"
  description = "Project related with Terraform examples, fully managed by Terraform"
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "Github PAT"

  auth_personal {
  }
}

resource "azuredevops_build_definition" "pipeline" {
  project_id = azuredevops_project.project.id
  name       = "Terraform Pipeline"
  path       = "\\"

  ci_trigger {
    use_yaml = true
  }

  repository {
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    repo_type             = "GitHub"
    repo_id               = "zalapeach/terraform"
    yml_path              = "pipelines/azure-tf-create.yml"
  }
}
