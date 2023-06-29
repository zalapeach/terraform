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
