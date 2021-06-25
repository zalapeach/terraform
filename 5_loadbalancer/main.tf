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
  name     = "Practice07e"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet02"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ip" {
  name                = "loadbalancer_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "netsecgrp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "sshSecurityRule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_lb" "lb" {
  name                = "loadbalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "frontend_ip"
    public_ip_address_id = azurerm_public_ip.ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_bp" {
  name            = "BackendAddressPool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb_hp" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "sshHealthProbe"
  port                = 22
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "sshRule"
  protocol                       = "tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_bp.id
  probe_id                       = azurerm_lb_probe.lb_hp.id
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic0${count.index}"
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
  managed                      = true
}

resource "random_id" "id" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

resource "azurerm_network_interface_security_group_association" "nsga" {
  count                     = 2
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                 = 2
  name                  = "ubuntu07e-0${count.index}"
  location              = azurerm_resource_group.rg.location
  availability_set_id   = azurerm_availability_set.as.id
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "osDisk0${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "linux-0${count.index}"
  admin_username                  = "zala"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "zala"
    public_key = file("/root/projects/terraform/id_rsa.pub")
  }
}
