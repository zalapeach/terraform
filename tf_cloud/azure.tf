resource "azurerm_role_assignment" "sp" {
  scope                = "/subscriptions/${var.env_arm_subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}
