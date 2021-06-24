terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
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
  name     = "Practice07c"
  location = "eastus"

  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet01"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "ip" {
  name                = "myDinamicIP"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_network_security_group" "mynsg" {
  name                = "myNSG"
  location            = "eastus"
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

  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_network_interface" "mynic" {
  name                = "myNIC"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNICconfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgAssociation" {
  network_interface_id      = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}

resource "random_id" "id" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.id.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform"
  }
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
  name                  = "ubuntu07c"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.mynic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "osDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "tamarindo"
  admin_username                  = "zala"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "zala"
    public_key = file("/root/projects/terraform/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform"
  }
}
