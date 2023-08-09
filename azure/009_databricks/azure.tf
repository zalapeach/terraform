resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup009"
  location = "westus2"
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
}
