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
  value           = var.env_tfe_token
  category        = "env"
  description     = "Terraform Cloud Token"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}

resource "tfe_variable" "azdopat" {
  key             = "AZDO_PERSONAL_ACCESS_TOKEN"
  value           = var.env_azdo_personal_access_token
  category        = "env"
  description     = "Azure DevOps Personal Access token (PAT)"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}

resource "tfe_variable" "armtenant" {
  key             = "ARM_TENANT_ID"
  value           = var.env_arm_tenant_id
  category        = "env"
  description     = "Azure Tenant Id"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}

resource "tfe_variable" "armsubscription" {
  key             = "ARM_SUBSCRIPTION_ID"
  value           = var.env_arm_subscription_id
  category        = "env"
  description     = "Azure Subscription Id"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}

resource "tfe_variable" "armclient" {
  key             = "ARM_CLIENT_ID"
  value           = azuread_application.app.application_id
  category        = "env"
  description     = "Azure Subscription Id"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}

resource "tfe_variable" "armclientsecret" {
  key             = "ARM_CLIENT_SECRET"
  value           = azuread_service_principal_password.pwd.value
  category        = "env"
  description     = "Azure Subscription Id"
  variable_set_id = tfe_variable_set.varset.id
  sensitive       = true
}
