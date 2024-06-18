resource "azuredevops_project" "project" {
  name        = "Terraform"
  description = "Azure DevOps project managed & created with Terraform"
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.project.id
  description           = "GitHub Service Endpoint using PAT"
  service_endpoint_name = "GitHub PAT"

  auth_personal {}
}

resource "azuredevops_serviceendpoint_azurerm" "azure" {
  project_id            = azuredevops_project.project.id
  description           = "Azure Endpoint using Service Principal"
  service_endpoint_name = "Azure"

  credentials {
    serviceprincipalid  = azuread_application.app.client_id
    serviceprincipalkey = azuread_service_principal_password.pwd.value
  }

  azurerm_spn_tenantid      = var.env_arm_tenant_id
  azurerm_subscription_id   = var.env_arm_subscription_id
  azurerm_subscription_name = "Personal VS subscription"
}

resource "azuredevops_build_definition" "pipelines" {
  count      = length(local.pipelines)
  project_id = azuredevops_project.project.id
  name       = local.pipelines[count.index].name
  path       = "\\"

  ci_trigger {
    use_yaml = true
  }

  repository {
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    repo_type             = "GitHub"
    repo_id               = "zalapeach/terraform"
    yml_path              = local.pipelines[count.index].path
    branch_name           = "refs/heads/master"
  }

  variable {
    name           = "keyVaultName"
    value          = azurerm_key_vault.kv.name
    allow_override = false
  }

  dynamic "variable" {
    for_each = try(local.pipelines[count.index].variables, [])
    content {
      name           = variable.value["name"]
      value          = variable.value["value"]
      is_secret      = try(variable.value["secret"], false)
      allow_override = try(variable.value["override"], false)
    }
  }
}

resource "azuredevops_agent_pool" "agentPool" {
  name = "SelfHosted"
}

resource "azuredevops_agent_queue" "queue" {
  project_id    = azuredevops_project.project.id
  agent_pool_id = azuredevops_agent_pool.agentPool.id
}

resource "azuredevops_pipeline_authorization" "authQueue" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_agent_queue.queue.id
  type        = "queue"
}

resource "azuredevops_pipeline_authorization" "authAzure" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.azure.id
  type        = "endpoint"
}

resource "azuredevops_pipeline_authorization" "authGitHub" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.github.id
  type        = "endpoint"
}
