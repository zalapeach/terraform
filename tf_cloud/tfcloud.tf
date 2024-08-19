resource "tfe_organization" "org" {
  name                          = "zalapeach"
  email                         = var.org_email
  allow_force_delete_workspaces = true
}

resource "tfe_workspace" "azdo" {
  name         = "azdo"
  organization = tfe_organization.org.name
  force_delete = true
}

resource "tfe_workspace" "workspaces" {
  for_each                  = local.workspaces
  name                      = each.key
  organization              = tfe_organization.org.name
  force_delete              = true
  remote_state_consumer_ids = try(each.value.workspace_ids, [])
}

resource "tfe_variable_set" "varset" {
  name         = "Terraform credentials"
  description  = "Terraform environment credentials used to build infrastructure"
  organization = tfe_organization.org.name
}

resource "tfe_workspace_variable_set" "azdo" {
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.azdo.id
}

resource "tfe_workspace_variable_set" "wsvarset" {
  for_each        = local.workspaces
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.workspaces[each.key].id
}

resource "tfe_variable" "vars" {
  for_each        = local.variables
  key             = each.key
  value           = each.value.value
  category        = "env"
  description     = each.value.description
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}
