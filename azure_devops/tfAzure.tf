resource "azurerm_role_assignment" "sp" {
  scope                = "/subscriptions/${var.env_arm_subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}

resource "azurerm_resource_group" "rg" {
  name     = "azdo"
  location = "eastus2"
}

resource "random_string" "kvname" {
  length  = 5
  special = false
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
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.env_arm_tenant_id
  object_id    = data.azuread_client_config.current.object_id

  secret_permissions = [
    "Delete", "Get", "List", "Purge", "Set"
  ]

  depends_on = [
    azurerm_key_vault.kv
  ]
}

resource "azurerm_key_vault_access_policy" "spaccess" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.env_arm_tenant_id
  object_id    = azuread_service_principal.sp.object_id

  secret_permissions = [
    "Delete", "Get", "List", "Purge", "Set"
  ]

  depends_on = [
    azurerm_key_vault.kv
  ]
}

resource "azurerm_key_vault_secret" "secrettftoken" {
  name         = "tf-token"
  value        = var.env_tfe_token
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_access_policy.spaccess
  ]
}
