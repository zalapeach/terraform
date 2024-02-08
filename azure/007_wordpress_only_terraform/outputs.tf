output "tls_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}

output "appgtw_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
