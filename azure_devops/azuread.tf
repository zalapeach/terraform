resource "azuread_application" "terraform" {
  display_name = "Terraform"
  owners       = [var.personal_azuread_object_id]
}

resource "azuread_service_principal" "terraform" {
  application_id               = azuread_application.terraform.application_id
  app_role_assignment_required = false
  owners                       = [var.personal_azuread_object_id]
}
