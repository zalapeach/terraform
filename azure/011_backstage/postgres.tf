resource "random_password" "pass" {
  length = 20
}

resource "azurerm_postgresql_flexible_server" "server" {
  name                   = "backstage-server-demo"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = 16
  administrator_login    = "zala"
  administrator_password = random_password.pass.result
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
}
