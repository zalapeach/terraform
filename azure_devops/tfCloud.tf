resource "tfe_organization" "org" {
  name  = "zalapeach"
  email = var.org_email
}

resource "tfe_workspace" "workspace" {
  name         = "azdo"
  organization = tfe_organization.org.name
}

resource "tfe_variable_set" "varset" {
  name         = "Terraform credentials"
  description  = "Terraform credentials used for build infrastructure"
  organization = tfe_organization.org.name
}

resource "tfe_workspace_variable_set" "workvarset" {
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.workspace.id
}

resource "tfe_variable" "tfetoken" {
  key             = "TFE_TOKEN"
  value           = var.tfe_token
  category        = "env"
  description     = "Terraform Cloud Token"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}
