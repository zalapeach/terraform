resource "random_password" "pass" {
  length = 20
}

resource "random_string" "ext" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_postgresql_flexible_server" "server" {
  name                   = "backstage-server-${random_string.ext.result}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = 16
  administrator_login    = "zala"
  administrator_password = random_password.pass.result
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
}

# not needed - created by backstage
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "backstage_plugin_catalog"
  server_id = azurerm_postgresql_flexible_server.server.id
  collation = "es_MX.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_configuration" "example" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.server.id
  value     = "off"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "rule" {
  name             = "open-connections"
  server_id        = azurerm_postgresql_flexible_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
