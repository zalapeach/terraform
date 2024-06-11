output "client_secret" {
  value     = azuread_service_principal_password.pwd.value
  sensitive = true
}

output "client_id" {
  value = azuread_application.app.client_id
}

output "azure_key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "database_password" {
  value     = random_password.password.0.result
  sensitive = true
}

output "wordpress_password" {
  value     = random_password.password.1.result
  sensitive = true
}
