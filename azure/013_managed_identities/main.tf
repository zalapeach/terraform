resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup013"
  location = "westus2"
}

resource "azurerm_user_assigned_identity" "identity" {
  location            = azurerm_resource_group.rg.location
  name                = "exercise-013-identity"
  resource_group_name = azurerm_resource_group.rg.name
}

data "azuredevops_project" "terraform" {
  name = "Terraform"
}

resource "azuredevops_user_entitlement" "identity" {
  origin_id = azurerm_user_assigned_identity.identity.client
  origin    = "aad"
}
