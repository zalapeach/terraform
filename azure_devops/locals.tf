locals {
  workspaces = ["azdo", "001", "002", "003", "004", "005", "006", "007", "008", "009", "010",
  "011"]
  variables = {
    ARM_CLIENT_ID = {
      value       = azuread_application.app.application_id
      description = "Azure - Client Id"
    },
    ARM_CLIENT_SECRET = {
      value       = azuread_service_principal_password.pwd.value
      description = "Azure - Client Secret"
    },
    ARM_TENANT_ID = {
      value       = var.env_arm_tenant_id
      description = "Azure - Tenant Id"
    },
    ARM_SUBSCRIPTION_ID = {
      value       = var.env_arm_subscription_id
      description = "Azure - Subscription Id"
    },
    AZDO_GITHUB_SERVICE_CONNECTION_PAT = {
      value       = var.env_azdo_github_pat
      description = "Azure DevOps - GitHub Service Connection Personal Access Token (PAT)"
    },
    AZDO_PERSONAL_ACCESS_TOKEN = {
      value       = var.env_azdo_pat
      description = "Azure DevOps - Personal Access Token (PAT)"
    },
    AZDO_ORG_SERVICE_URL = {
      value       = var.env_azdo_url
      description = "Azure DevOps - Service URL"
    },
    TFE_TOKEN = {
      value       = var.env_tfe_token
      description = "Terraform Cloud Token"
    },
    TF_VAR_org_email = {
      value       = var.org_email
      description = "personal email 1"
    },
    TF_VAR_org_email1 = {
      value       = var.org_email1
      description = "personal email 2"
    }
  }
  pipelines = [
    { name = "Terraform create - update infra",
    path = "pipelines/azure-tf-create.yml" },
    { name = "Terraform destroy infra",
    path = "pipelines/azure-tf-destroy.yml" },
    { name = "Ansible configure - example 006"
    path = "pipelines/ansible-configure.yml" }
  ]
  users = [
    data.azuread_client_config.current.object_id,
    azuread_service_principal.sp.object_id
  ]
}
