resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup013"
  location = "westus2"
}

resource "azurerm_user_assigned_identity" "identity" {
  location            = azurerm_resource_group.rg.location
  name                = "exercise-013-identity"
  resource_group_name = azurerm_resource_group.rg.name
}

data "azuredevops_project" "terraform" {
  name = "Terraform"
}

resource "azuredevops_service_principal_entitlement" "identity" {
  origin_id = azurerm_user_assigned_identity.identity.principal_id
}

resource "azuredevops_group" "automation" {
  scope        = data.azuredevops_project.terraform.id
  display_name = "Terraform Automation"
  description  = "Terraform Automation group to access repos and pipelines"
  members = [
    azuredevops_service_principal_entitlement.identity.descriptor
  ]
}

resource "azuredevops_git_permissions" "access" {
  project_id = data.azuredevops_project.terraform.id
  principal  = azuredevops_group.automation.id
  permissions = {
    CreateRepository      = "Deny"
    DeleteRepository      = "Deny"
    RenameRepository      = "Deny"
    GenericRead           = "Allow"
    GenericContribute     = "Allow"
    PullRequestContribute = "Allow"
  }
}

resource "azuredevops_build_folder_permissions" "access" {
  project_id = data.azuredevops_project.terraform.id
  path       = "\\"
  principal  = azuredevops_group.automation.id
  permissions = {
    "ViewBuilds" : "Allow",
    "QueueBuilds" : "Allow",
    "ViewBuildDefinition" : "Allow",
    "QueueBuilds" : "Allow"
  }
}
