locals {
  workspaces = ["azdo", "netWatch", "Az001", "Az002", "Az003", "Az004", "Az005", "Az006", "Az007",
  "Az008", "Az009", "Az010", "Az011", "Az100", "Az101", "Az102", "Az103"]
  variables = {
    ARM_CLIENT_ID = {
      value       = azuread_application.app.application_id,
      description = "Azure - Client Id"
    },
    ARM_CLIENT_SECRET = {
      value       = azuread_service_principal_password.pwd.value,
      description = "Azure - Client Secret"
    },
    ARM_TENANT_ID = {
      value       = var.env_arm_tenant_id,
      description = "Azure - Tenant Id"
    },
    ARM_SUBSCRIPTION_ID = {
      value       = var.env_arm_subscription_id,
      description = "Azure - Subscription Id"
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
      description = "personal email 1"
    },
    TF_VAR_org_email1 = {
      value       = var.org_email1,
      description = "personal email 2"
    }
  }
  pipelines = [
    {
      name = "Terraform create - update infra",
      path = "pipelines/tf-azure-create.yml",
    },
    { name = "Terraform destroy infra",
      path = "pipelines/tf-azure-destroy.yml",
    },
    {
      name = "Terraform destroy - Network watchers",
      path = "pipelines/tf-azure-drop-net-watchers.yml",
    },
    {
      name = "Drop offline agents",
      path = "pipelines/azdo-drop-agents.yml",
      variables = [
        {
          name  = "azdoUrl",
          value = var.env_azdo_url,
        },
        {
          name  = "projectName",
          value = azuredevops_project.project.name,
        },
        {
          name  = "poolName",
          value = azuredevops_agent_pool.agentPool.name,
        }
      ]
    },
    { name = "Ansible configure - example 006",
      path = "pipelines/ansible-configure.yml"
    }
  ]
  users = [
    data.azuread_client_config.current.object_id,
    azuread_service_principal.sp.object_id
  ]
  secrets = {
    tfToken        = var.env_tfe_token,
    subscriptionId = var.env_arm_subscription_id,
    azdoPat        = var.env_azdo_pat,
    appId          = azuread_application.app.application_id,
    appSecret      = azuread_service_principal_password.pwd.value,
    appTenant      = var.env_arm_subscription_id
  }
}
