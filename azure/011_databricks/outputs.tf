output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.databricks.workspace_url}"
}

output "databricks_account_id" {
  value = azurerm_databricks_workspace.databricks.workspace_id
}
