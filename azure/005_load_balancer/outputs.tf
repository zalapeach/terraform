output "tls_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "private_ip_linux_01" {
  value = azurerm_linux_virtual_machine.vm[0].private_ip_address
}

output "private_ip_linux_02" {
  value = azurerm_linux_virtual_machine.vm[1].private_ip_address
}
