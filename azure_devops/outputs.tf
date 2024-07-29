output "env" {
  value     = data.external.env.result
  sensitive = true
}
