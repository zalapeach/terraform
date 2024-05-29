terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az011"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.host
  client_certificate     = azurerm_kubernetes_cluster.aks.kube_config.client_certificate
  client_key             = azurerm_kubernetes_cluster.aks.kube_config.client_key
  cluster_ca_certificate = azurerm_kubernetes_cluster.aks.kube_config.cluster_ca_certificate
}
