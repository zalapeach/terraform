variable "org_email" {
  description = "Terraform Cloud organization email"
  type        = string
  sensitive   = true
}

variable "org_email1" {
  description = "another email"
  type        = string
  sensitive   = true
}

variable "sp_client_id" {
  description = "Terraform service principal client ID"
  type        = string
  sensitive   = true
}
