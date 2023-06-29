resource "azuredevops_project" "project" {
  name        = "Terraform"
  description = "Azure DevOps project managed & created with Terraform"
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.project.id
  description           = "GitHub Service Endpoint using PAT"
  service_endpoint_name = "GitHub PAT"

  auth_personal {}
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
