output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

ouput "tls_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}
