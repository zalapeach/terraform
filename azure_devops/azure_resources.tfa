resource "azurerm_resource_group" "rg" {
  name     = "azure_devops_rg"
  location = "eastus2"
}

resource "azurerm_key_vault" "kv" {
  name                        = "AzDevOpsKeyVault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true

  sku_name                    = "standard"

  access_policy {
    tenant_id =
    object_id =
  }
}
