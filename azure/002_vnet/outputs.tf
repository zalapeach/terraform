output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subscription_id" {
  value     = data.external.env.result["subscription_id"]
  sensitive = true
}
