resource "azurerm_resource_group" "rg" {
  name     = "backstageCluster"
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "backstage"

  default_node_pool {
    name       = "nodepool2"
    node_count = 3
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}
