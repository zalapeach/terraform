locals {
  pipelines = [
    {
      name = "Terraform create - update infra",
      path = "pipelines/tf-azure-create.yml"
    },
    {
      name = "Terraform destroy infra",
      path = "pipelines/tf-azure-destroy.yml"
    },
    {
      name = "Terraform destroy - Network Watchers",
      path = "pipelines/tf-azure-drop-net-watchers.yml"
    },
    {
      name = "Drop offline agents",
      path = "pipelines/azdo-drop-agents.yml"
      variables = [
        {
          name  = "azdoUrl",
          value = data.external.env.result.azure_devops_org
        },
        {
          name  = "projectName",
          value = azuredevops_project.project.name
        },
        {
          name  = "poolName",
          value = azuredevops_agent_pool.agentPool.name
        }
      ]
    },
    {
      name = "Ansible configure - example 006",
      path = "pipelines/ansible-configure.yml",
      variables = [
        {
          name     = "dbName",
          value    = "wordpress",
          override = true
        },
        {
          name     = "dbUser",
          value    = "root",
          override = true
        },
        {
          name     = "wpUser",
          value    = "admin",
          override = true
        },
        {
          name     = "wpEmail",
          value    = data.external.env.result.email
          override = true
        }
      ]
    }
  ]
  users = [
    data.external.env.result.azure_ad_personal_object_id,
    data.external.env.result.azure_app_object_id
  ]
  secrets = {
    tfToken        = data.external.env.result.terraform_cloud_token,
    subscriptionId = data.external.env.result.azure_subscription_id,
    azdoPat        = data.external.env.result.azure_devops_pat,
    appId          = data.external.env.result.azure_app_id,
    appSecret      = data.external.env.result.azure_app_secret,
    appTenant      = data.external.env.result.azure_tenant_id,
    dbPass         = random_password.password.0.result,
    wpPass         = random_password.password.1.result
  }
}
