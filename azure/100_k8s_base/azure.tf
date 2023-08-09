resource "azurerm_resource_group" "rg" {
  name     = "aksTestCluster"
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "tamarindo"

  default_node_pool {
    name       = "nodepool"
    node_count = 3
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}
