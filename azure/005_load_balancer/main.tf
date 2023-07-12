terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "005"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup005"
  location = "eastus2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet0"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "lb_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "sshSecRule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_lb" "lb" {
  name                = "lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "frontend_ip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_bp" {
  name            = "backendAddressPool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb_hp" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "sshHealthProbe"
  port            = 22
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "sshRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend_ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_bp.id]
  probe_id                       = azurerm_lb_probe.lb_hp.id
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic0${ count.index }"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_ip_conf"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_bp" {
  count                   = 2
  network_interface_id    = element(azurerm_network_interface.nic.*.id, count.index)
  ip_configuration_name   = "nic_ip_conf"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_bp.id
}

resource "azurerm_availability_set" "as" {
  name                         = "availabilitySet"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_interface_security_group_association" "nsga" {
  count                     = 2
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg.id
}
