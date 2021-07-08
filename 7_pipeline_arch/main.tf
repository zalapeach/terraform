terraform {
  required_providers {
    azurerm = {
      source =  "hashicorp/azurerm"
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
  name = "azdevopsRG"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "ip" {
  name                = "myDinamicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "myNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ssh"
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

resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "confNIC"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id

  }
}

resource "azurerm_network_interface_security_group_association" "nsga" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "mysql01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name    = "osDisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04_LTS"
    version   = "latest"
  }

  computer_name                   = "mysql01"
  admin_username                  = "zala"
  disable_password_authentication = true

  admin_ssh_key {
    username = "zala"
    public_key = file("./id_rsa.pub")
  }
}
