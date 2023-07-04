locals {
  workspaces = ["azdo", "001", "002", "003"]
  variables = {
    ARM_CLIENT_ID = {
      value       = azuread_application.app.application_id
      description = "Azure - Client Id"
    }
    ARM_CLIENT_SECRET = {
      value       = azuread_service_principal_password.pwd.value
      description = "Azure - Client Secret"
    }
    ARM_TENANT_ID = {
      value       = var.env_arm_tenant_id
      description = "Azure - Tenant Id"
    }
    ARM_SUBSCRIPTION_ID = {
      value       = var.env_arm_subscription_id
      description = "Azure - Subscription Id"
    }
    AZDO_GITHUB_SERVICE_CONNECTION_PAT = {
      value       = var.env_azdo_github_pat
      description = "Azure DevOps - GitHub Service Connection Personal Access Token (PAT)"
    }
    AZDO_PERSONAL_ACCESS_TOKEN = {
      value       = var.env_azdo_pat
      description = "Azure DevOps - Personal Access Token (PAT)"
    }
    AZDO_ORG_SERVICE_URL = {
      value       = var.env_azdo_url
      description = "Azure DevOps - Service URL"
    }
    TFE_TOKEN = {
      value       = var.env_tfe_token
      description = "Terraform Cloud Token"
    }
  }
}
