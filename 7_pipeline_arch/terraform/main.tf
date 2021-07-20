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

locals {
  names = [
    { name = "vm" },
    { name = "vm" },
    { name = "db" },
    { name = "ag" }
  ]
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

resource "azurerm_subnet" "subnetFront" {
  name                 = "frontend"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Creates all stuff for Application gateway

resource "azurerm_public_ip" "ip" {
  name                = "wordpressIP"
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
    name            = "vnet-backpool"
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

# start prerequisites for frontend VMs

resource "azurerm_subnet" "subnetBack" {
  name                 = "backend"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic" {
  count               = 4
  name                = "nic0${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nicIPConf"
    subnet_id                     = azurerm_subnet.subnetBack.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.${count.index + 4}"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-gw" {
  count                   = 2
  network_interface_id    = element(azurerm_network_interface.nic.*.id, count.index)
  ip_configuration_name   = "nicIPConf"
  backend_address_pool_id = azurerm_application_gateway.appGateway.backend_address_pool[0].id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "netSecGrp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "httpSecRule" {
  name                         = "httpSecRule"
  priority                     = 1001
  direction                    = "inbound"
  access                       = "allow"
  protocol                     = "TCP"
  source_port_range            = "*"
  destination_port_range       = "80"
  source_address_prefix        = "*"
  destination_address_prefixes = [azurerm_network_interface.nic[0].private_ip_address,
                                  azurerm_network_interface.nic[1].private_ip_address]
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "openDBSecRule" {
  name                        = "openDBSecRule"
  priority                    = 1002
  direction                   = "outbound"
  access                      = "allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefixes     = [azurerm_network_interface.nic[0].private_ip_address,
                                 azurerm_network_interface.nic[1].private_ip_address]
  destination_address_prefix  = azurerm_network_interface.nic[2].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "dbSecRule" {
  name                        = "dbSecRule"
  priority                    = 1003
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefixes     = [azurerm_network_interface.nic[0].private_ip_address,
                                 azurerm_network_interface.nic[1].private_ip_address]
  destination_address_prefix  = azurerm_network_interface.nic[2].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "sshSecRule" {
  name                         = "sshSecRule"
  priority                     = 1004
  direction                    = "inbound"
  access                       = "allow"
  protocol                     = "TCP"
  source_port_range            = "*"
  destination_port_range       = "22"
  source_address_prefix        = "*"
  destination_address_prefix   = "*"
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = azurerm_network_security_group.nsg.name
}

resource "azurerm_availability_set" "as" {
  name                         = "availabilitySet"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 4
  managed                      = true
}

resource "azurerm_network_interface_security_group_association" "nsga" {
  count                     = 4
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                 = 4
  name                  = "${local.names[count.index].name}0${count.index}"
  location              = azurerm_resource_group.rg.location
  availability_set_id   = azurerm_availability_set.as.id
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "osDisk0${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-LTS"
    version   = "latest"
  }

  computer_name   = "${local.names[count.index].name}0${count.index}"
  admin_username  = "zala"

  admin_ssh_key {
    username   = "zala"
    public_key = file("./id_rsa.pub")
  }

  admin_ssh_key {
    username   = "zala"
    public_key = file("./agent.pub")
  }

  tags = {
    env = "${local.names[count.index].name}"
  }
}

# Creating Bastion

resource "azurerm_subnet" "subnetBastion" {
  name                 = "AzureBastionSubnet"
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "bastionIP" {
  name                = "bastionIP"
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_bastion_host" "bastion" {
  name                = "myBastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "IPConf"
    subnet_id            = azurerm_subnet.subnetBastion.id
    public_ip_address_id = azurerm_public_ip.bastionIP.id
  }
}

# Create dynamic agent

resource "azurerm_virtual_machine_extension" "agent" {
  name                 = "azureDevOpsAgent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm[3].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/zalapeach/terraform/master/7_pipeline_arch/agent.sh",
        "https://juanc.blob.core.windows.net/blobcontainer/agent?sp=r&st=2021-07-16T20:50:56Z&se=2025-07-17T04:50:56Z&spr=https&sv=2020-08-04&sr=b&sig=i%2FvmAxghyk50NpcMYGj8o7gGeFjLRYXEXGsuMl6MrTQ%3D",
        "https://juanc.blob.core.windows.net/blobcontainer/agent.pub?sp=r&st=2021-07-16T20:52:09Z&se=2025-07-17T04:52:09Z&spr=https&sv=2020-08-04&sr=b&sig=RTGjiUIUGvVhnK7MKI3VbCvSSVvmr%2BrVKeulgtSq%2FHM%3D"
        ],
      "commandToExecute": "sh agent.sh ${var.azure_devops_pat} ${var.azure_devops_org} ${var.azure_client_id} ${var.azure_client_secret} ${var.azure_tenant_id}"
    }
SETTINGS

  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}
