output "databricks_service_url" {
  value = "https://${azurerm_databricks_workspace.databricks.workspace_url}"
}

output "databricks_cluster_url" {
  value = "https://${databricks_cluster.cluster.url}"
}

output "databricks_job_url" {
  value = "https://${databricks_job.job.url}"
}

output "databricks_account_id" {
  value = azurerm_databricks_workspace.databricks.workspace_id
}
