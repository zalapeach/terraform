resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup014"
  location = "westus2"
}

resource "azurerm_user_assigned_identity" "user_mi" {
  name                = "aks-user-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "aks_az_014"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  dns_prefix                = "jcar-example014"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name       = "nodepool"
    node_count = 3
    vm_size    = "Standard_B2s"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.user_mi.id]
  }
}

resource "azurerm_user_assigned_identity" "example_mi" {
  name                = "example-user-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
