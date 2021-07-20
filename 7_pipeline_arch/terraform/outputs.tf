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

output "nicAppGtwBackpool_ids" {
  value     = azurerm_network_interface_application_gateway_backend_address_pool_association.nic-gw.*.id
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
  value     = azurerm_network_security_rule.openDBSecRule.id
  sensitive = true
}

output "dbSecRule_ids" {
  value     = azurerm_network_security_rule.dbSecRule.id
  sensitive = true
}

output "sshSecRule_ids" {
  value     = azurerm_network_security_rule.sshSecRule.id
  sensitive = true
}

output "as_id" {
  value     = azurerm_availability_set.as.id
  sensitive = true
}

output "nsga_ids" {
  value     = azurerm_network_interface_security_group_association.nsga.*.id
  sensitive = true
}

output "vm_ids" {
  value     = azurerm_linux_virtual_machine.vm.*.id
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
