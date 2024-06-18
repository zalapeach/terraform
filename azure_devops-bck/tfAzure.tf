resource "azurerm_role_assignment" "sp" {
  scope                = "/subscriptions/${var.env_arm_subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}

resource "azurerm_resource_group" "rg" {
  name     = "azdo"
  location = "eastus2"
}

resource "azurerm_key_vault" "kv" {
  name                        = "azdokv-${random_string.kvname.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = var.env_arm_tenant_id
  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "access" {
  count        = length(local.users)
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.env_arm_tenant_id
  object_id    = local.users[count.index]

  secret_permissions = [
    "Delete", "Get", "List", "Purge", "Set"
  ]

  certificate_permissions = [
    "Create", "Delete", "Get", "Import", "List", "Update"
  ]
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = local.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_access_policy.access
  ]
}
