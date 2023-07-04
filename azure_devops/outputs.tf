output "client_secret" {
  value     = azuread_service_principal_password.pwd.value
  sensitive = true
}

output "client_id" {
  value = azuread_application.app.application_id
}

output "azure_key_vault_name" {
  value = azurerm_key_vault.kv.name
}
