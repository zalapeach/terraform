resource "random_password" "password" {
  count            = 2
  length           = 16
  special          = true
  override_special = "¡!¿?@$%&=-+()[]{}:"
}
