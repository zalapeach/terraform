variable "org_email" {
  description = "Terraform Cloud organization email"
  type        = string
  sensitive   = true
}

variable "env_tfe_token" {
  description = "Terraform Cloud Token"
  type        = string
  sensitive   = true
}

variable "env_azdo_personal_access_token" {
  description = "Azure DevOps PAT"
  type        = string
  sensitive   = true
}

variable "env_arm_tenant_id" {
  description = "Azure Tenant Id"
  type        = string
  sensitive   = true
}

variable "env_arm_subscription_id" {
  description = "Azure Client id"
  type        = string
  sensitive   = true
}

# variable "arm_client_id" {
#   description = "Azure Client id"
#   type        = string
#   default     = "${ azuread_application.app.application_id }"
# }

# variable "arm_client_secret" {
#   description = "Azure Client id"
#   type        = string
#   sensitive   = true
#   default     = "${ azuread_service_principal_password.pwd.value }"
# }
