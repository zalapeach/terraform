output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
