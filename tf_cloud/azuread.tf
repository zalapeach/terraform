data "azuread_client_config" "current" {}

resource "azuread_application" "app" {
  display_name = "Terraform"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "pwd" {
  display_name         = "password or secret_id"
  service_principal_id = azuread_service_principal.sp.object_id
}
