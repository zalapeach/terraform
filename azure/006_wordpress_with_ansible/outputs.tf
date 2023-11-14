output "env" {
  value     = data.external.env.result
  sensitive = true
}

output "tls_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}

output "appgtw_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "private_ips" {
  value = {
    "${azurerm_linux_virtual_machine.vms[0].name}": azurerm_linux_virtual_machine.vms[0].private_ips_address,
    "${azurerm_linux_virtual_machine.vms[1].name}": azurerm_linux_virtual_machine.vms[1].private_ips_address,
    "${azurerm_linux_virtual_machine.vms[2].name}": azurerm_linux_virtual_machine.vms[2].private_ips_address,
    "${azurerm_linux_virtual_machine.vms[3].name}": azurerm_linux_virtual_machine.vms[3].private_ips_address
  }
}
