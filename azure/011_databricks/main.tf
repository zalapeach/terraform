data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup011"
  location = "westus2"
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
}
