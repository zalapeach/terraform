output "tenant_id" {
  value = azuread_service_principal.sp.application_tenant_id
}

output "client_secret" {
  value     = azuread_service_principal_password.pwd.value
  sensitive = true
}

output "client_id" {
  value = azuread_application.app.application_id
}
