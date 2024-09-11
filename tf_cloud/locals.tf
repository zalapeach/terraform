locals {
  workspaces = {
    netWatch = {},
    Az001    = {},
    Az002    = {},
    Az003    = {},
    Az004    = {},
    Az005    = {},
    Az006    = {},
    Az007    = {},
    Az008    = {},
    Az009    = {},
    Az010    = {}
  }
  variables = {
    ARM_CLIENT_ID = {
      value       = azuread_application.app.client_id,
      description = "Azure - Client Id"
    },
    ARM_CLIENT_SECRET = {
      value       = azuread_service_principal_password.pwd.value
      description = "Azure - Client Secret"
    },
    ARM_CLIENT_OBJECT_ID = {
      value       = azuread_service_principal.sp.object_id
      description = "Azure - Object Id"
    },
    ARM_TENANT_ID = {
      value       = var.env_arm_tenant_id
      description = "Azure - Tenant Id"
    },
    ARM_SUBSCRIPTION_ID = {
      value       = var.env_arm_subscription_id,
      description = "Azure - Subscription Id"
    },
    AAD_PERSONAL_OBJECT_ID = {
      value       = var.env_aad_personal_object_id,
      description = "Azure Active Directory - Personal Object ID (mine)"
    },
    AZDO_GITHUB_SERVICE_CONNECTION_PAT = {
      value       = var.env_azdo_github_pat,
      description = "Azure DevOps - GitHub Service Connection Personal Access Token (PAT)"
    },
    AZDO_PERSONAL_ACCESS_TOKEN = {
      value       = var.env_azdo_pat,
      description = "Azure DevOps - Personal Access Token (PAT)"
    },
    AZDO_ORG_SERVICE_URL = {
      value       = var.env_azdo_url,
      description = "Azure DevOps - Service URL"
    },
    TFE_TOKEN = {
      value       = var.env_tfe_token,
      description = "Terraform Cloud Token"
    },
    TF_VAR_org_email = {
      value       = var.org_email,
      description = "Personal email 1"
    },
    TF_VAR_org_email1 = {
      value       = var.org_email1
      description = "Personal email 2"
    },
    TF_VAR_sp_client_id = {
      value       = azuread_service_principal.sp.client_id
      description = "Terraform Service Principal client ID"
    }
  }
}
