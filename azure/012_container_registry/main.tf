resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup012"
  location = "westus2"
}

resource "azurerm_container_registry" "acr" {
  name                = "zalapeach"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}
