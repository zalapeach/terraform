output "rg_id" {
  value     = azurerm_resource_group.rg.id
  sensitive = true
}

output "vnet_id" {
  value     = azurerm_virtual_network.vnet.id
  sensitive = true
}

output "subnet_ids" {
  value     = values(azurerm_subnet.map)[*].id
  sensitive = true
}

output "ip_ids" {
  value     = values(azurerm_public_ip.map)[*].id
  sensitive = true
}

output "appGtw_id" {
  value     = azurerm_application_gateway.appGateway.id
  sensitive = true
}

output "nic_ids" {
  value     = values(azurerm_network_interface.map)[*].id
  sensitive = true
}

output "nicAppGtwBackpool_ids" {
  value     = values(azurerm_network_interface_application_gateway_backend_address_pool_association.map)[*].id
  sensitive = true
}

output "nsg_id" {
  value     = azurerm_network_security_group.nsg.id
  sensitive = true
}

output "secRule_ids" {
  value     = values(azurerm_network_security_rule.map)[*].id
  sensitive = true
}

output "as_id" {
  value     = azurerm_availability_set.as.id
  sensitive = true
}

output "nsga_ids" {
  value     = values(azurerm_network_interface_security_group_association.map)[*].id
  sensitive = true
}

output "vm_ids" {
  value     = values(azurerm_linux_virtual_machine.map)[*].id
  sensitive = true
}

output "bastion_id" {
  value     = azurerm_bastion_host.bastion.id
  sensitive = true
}

output "agent_id" {
  value     = azurerm_virtual_machine_extension.agent.id
  sensitive = true
}
