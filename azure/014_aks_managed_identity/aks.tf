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

  network_profile {
    network_plugin = "kubenet"
  }
}

resource "azurerm_user_assigned_identity" "example_mi" {
  name                = "example-user-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "vms" {
  scope                = azurerm_kubernetes_cluster.aks.node_resource_group_id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.example_mi.principal_id
}

resource "azurerm_federated_identity_credential" "federation" {
  name                = "aks-workload-identity"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureAdTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.example_mi.id
  subject             = format("system:serviceaccount:%s:workload-identity", kubernetes_namespace.apps.metadata[0].name)
}
