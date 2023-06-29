resource "tfe_organization" "org" {
  name                          = "zalapeach"
  email                         = var.org_email
  allow_force_delete_workspaces = true
}

resource "tfe_workspace" "workspace" {
  name         = "azdo"
  organization = tfe_organization.org.name
  force_delete = true
}

resource "tfe_variable_set" "varset" {
  name         = "Terraform credentials"
  description  = "Terraform environment credentials used to build infrastructure"
  organization = tfe_organization.org.name
}

resource "tfe_workspace_variable_set" "workspacevarset" {
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.workspace.id
}

resource "tfe_variable" "tfetoken" {
  key             = "TFE_TOKEN"
  value           = var.tfe_token
  category        = "env"
  description     = "Terraform Cloud Token"
  variable_set_id = tfe_variable_set.varset.id
}
