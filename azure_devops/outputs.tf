output "env" {
  value     = data.external.env.result
  sensitive = true
}

output "azure_key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
