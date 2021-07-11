terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "<check backend.conf file>"
    container_name       = "<check backend.conf file>"
    access_key           = "<check backend.conf file>"
    key                  = "<check backend.conf file>"
  }
}

provider "azurerm" {
  features {}

  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "azdevopsRG"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet01"
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "SubnetFront" {
  name                 = "frontend"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "SubnetBack" {
  name                 = "frontend"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "ip" {
  name                = "myDinamicIP"
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_application_gateway" "appGateway" {
  name                = "myAppGateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "myGatewayIPConf"
    subnet_id = azurerm_subnet.subnetFront.id
  }

  frontend_port {
    name = "vnet-frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "vnet-frontendIP"
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  backend_address_pool {
    name = "vnet-backpool"
  }

  backend_http_settings {
    name                  = "vnet-httpSet"
    path                  = "/"
    port                  = 80
    protocol              = "http"
    request_timeout       = 60
    cookie_based_affinity = "disabled"
  }

  http_listener {
    name                           = "vnet-listener"
    protocol                       = "http"
    frontend_port_name             = "vnet-frontendPort"
    frontend_ip_configuration_name = "vnet-frontendIP"
  }

  request_routing_rule {
    name                       = "vnet-routingRule"
    rule_type                  = "Basic"
    http_listener_name         = "vnet-listener"
    backend_address_pool_name  = "vnet-backpool"
    backend_http_settings_name = "vnet-httpSet"
  }
}
