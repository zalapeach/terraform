variable "env_arm_tenant_id" {
  description = "Azure Tenant Id"
  type        = string
  sensitive   = true
}

variable "env_arm_subscription_id" {
  description = "Azure Client Id"
  type        = string
  sensitive   = true
}

variable "env_azdo_github_pat" {
  description = "Azure DevOps GitHub PAT"
  type        = string
  sensitive   = true
}

variable "env_azdo_pat" {
  description = "Azure DevOps PAT"
  type        = string
  sensitive   = true
}

variable "env_azdo_url" {
  description = "Azure DevOps Service URL"
  type        = string
}

variable "env_tfe_token" {
  description = "Terraform Cloud Token"
  type        = string
  sensitive   = true
}

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
