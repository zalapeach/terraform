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
