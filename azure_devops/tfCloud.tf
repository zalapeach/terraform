resource "tfe_organization" "org" {
  name  = "zalapeach"
  email = var.org_email
}

resource "tfe_workspace" "workspace" {
  name         = "azdo"
  organization = tfe_organization.org.name
}
