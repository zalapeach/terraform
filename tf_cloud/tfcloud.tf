resource "tfe_organization" "org" {
  name                          = "zalapeach"
  email                         = var.org_email
  allow_force_delete_workspaces = true
}

resource "tfe_workspace" "workspaces" {
  count        = length(local.workspaces)
  name         = local.workspaces[count.index]
  organization = tfe_organization.org.name
  force_delete = true
}

resource "tfe_variable_set" "varset" {
  name         = "Terraform credentials"
  description  = "Terraform environment credentials used to build infrastructure"
  organization = tfe_organization.org.name
}

resource "tfe_workspace_variable_set" "wsvarset" {
  count           = length(local.workspaces)
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.workspaces[count.index].id
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
