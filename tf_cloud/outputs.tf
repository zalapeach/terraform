output "arm_client_secret" {
  value     = azuread_service_principal_password.pwd.value
  sensitive = true
}

output "arm_client_id" {
  value = azuread_application.app.client_id
}
