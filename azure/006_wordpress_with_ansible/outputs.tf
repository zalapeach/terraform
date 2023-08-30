output "env" {
  value = data.external.env.result
}

output "tls_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}
