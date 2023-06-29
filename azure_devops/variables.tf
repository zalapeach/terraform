variable "org_email" {
  description = "Terraform Cloud organization email"
  type        = string
  sensitive   = true
}

variable "tfe_token" {
  description = "Terraform Cloud Token"
  type        = string
  sensitive   = true
}
