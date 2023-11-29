resource "random_string" "kvname" {
  length  = 5
  special = false
}

resource "random_password" "password" {
  count            = 2
  length           = 16
  special          = false
}
