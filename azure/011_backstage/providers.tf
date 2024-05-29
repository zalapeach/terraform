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
  host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  client_key             = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  cluster_ca_certificate = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}
