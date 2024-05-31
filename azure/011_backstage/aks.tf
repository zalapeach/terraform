resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup011"
  location = "westus"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "backstage"

  default_node_pool {
    name                        = "nodepool2"
    node_count                  = 2
    vm_size                     = "Standard_D8s_v3"
    temporary_name_for_rotation = "temporal"
  }

  identity {
    type = "SystemAssigned"
  }
}
