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
  count     = 4
  value     = element(azurerm_network_interface.nic.*.id, count.index)
  sensitive = true
}

output "nicAppGtwBackpool_ids" {
  count     = 2
  value     = element(azurerm_network_interface_application_gateway_backend_address_pool_association.nic-gw.*.id, count.index)
  sensitive = true
}

output "nsg_id" {
  value     = azurerm_network_security_group.nsg.id
  sensitive = true
}

output "httpSecRule_id" {
  value     = azurerm_network_security_rule.httpSecRule.id
  sensitive = true
}

output "openDBSecRule_id" {
  value     = element(azurerm_network_security_rule.openDBSecRule.id, count.index)
  sensitive = true
}

output "dbSecRule_id" {
  value     = element(azurerm_network_security_rule.dbSecRule.id, count.index)
  sensitive = true
}

output "sshSecRule_id" {
  value     = element(azurerm_network_security_rule.sshSecRule.id, count.index)
  sensitive = true
}

output "dbSecRule_id" {
  value     = element(azurerm_network_security_rule.dbSecRule.id, count.index)
  sensitive = true
}

output "as_id" {
  value     = azurerm_availability_set.as.id
  sensitive = true
}

output "nsga_ids" {
  count     = 4
  value     = element(azurerm_network_interface_security_group_association.nsga.*.id, count.index)
  sensitive = true
}

output "vm_ids" {
  count     = 4
  value     = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
  sensitive = true
}

output "bastionSubnet_id" {
  value     = azurerm_subnet.subnetBastion.id
  sensitive = true
}

output "bastionIp_id" {
  value     = azurerm_public_ip.bastionIP.id
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
