output "rg_id" {
  value     = azurerm_resource_group.rg.id
  sensitive = true
}

output "vnet_id" {
  value     = azurerm_virtual_network.vnet.id
  sensitive = true
}

output "frontSubnet_id" {
  value     = azurerm_subnet.subnetFront.id
  sensitive = true
}

output "appGtwIp_id" {
  value     = azurerm_public_ip.ip.id
  sensitive = true
}

output "appGtw_id" {
  value     = azurerm_application_gateway.appGateway.id
  sensitive = true
}

output "backSubnet_id" {
  value     = azurerm_subnet.subnetBack.id
  sensitive = true
}

output "nic_ids" {
  value     = azurerm_network_interface.nic.*.id
  sensitive = true
}
