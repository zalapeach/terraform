output "tls_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}

output "appgtw_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "secrets" {
  value = {
    dbPass = data.azurerm_key_vault_secret.passwords["dbPass"].value
    wpPass = data.azurerm_key_vault_secret.passwords["wpPass"].value
  }
  sensitive = true
}

output "private_ips" {
  value = {
    node1 = azurerm_network_interface.nic[0].private_ip_address
    node2 = azurerm_network_interface.nic[1].private_ip_address
    db    = azurerm_network_interface.nic[2].private_ip_address
  }
}
