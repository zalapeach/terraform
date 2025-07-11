terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
  }
  cloud {
    organization = "zalapeach"
    workspaces {
      name = "Az006"
    }
  }
}

provider "azurerm" {
  features {}
}

data "external" "env" {
  program = ["${path.module}/scripts/env.sh"]
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup006"
  location = "westus2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  address_prefixes     = ["10.0.0.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "pip" {
  name                = "WordPressIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gw" {
  name                = "AppGW"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "GWIpConf"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendIp"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = "backendPool"
  }

  backend_http_settings {
    name                  = "httpSettings"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    cookie_based_affinity = "Disabled"
  }

  http_listener {
    name                           = "listener"
    protocol                       = "Http"
    frontend_port_name             = "frontendPort"
    frontend_ip_configuration_name = "frontendIp"
  }

  request_routing_rule {
    name                       = "routingRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
    priority                   = 100
  }

  depends_on = [
    azurerm_linux_virtual_machine.vms
  ]
}

# frontend VMs

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic" {
  count               = 4
  name                = "nic0${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nicIpConf"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.${count.index + 4}"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nicGw" {
  count                   = 2
  network_interface_id    = element(azurerm_network_interface.nic.*.id, count.index)
  ip_configuration_name   = "nicIpConf"
  backend_address_pool_id = tolist(azurerm_application_gateway.gw.backend_address_pool).0.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "netSecGrp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allowHttp" {
  name                   = "allowHttp"
  priority               = 1001
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "80"
  source_address_prefix  = "*"
  destination_address_prefixes = [
    azurerm_network_interface.nic[0].private_ip_address,
    azurerm_network_interface.nic[1].private_ip_address
  ]
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allowOutboundToDb" {
  name                   = "allowOutboundToDb"
  priority               = 1002
  direction              = "Outbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "3306"
  source_address_prefixes = [
    azurerm_network_interface.nic[0].private_ip_address,
    azurerm_network_interface.nic[1].private_ip_address
  ]
  destination_address_prefix  = azurerm_network_interface.nic[2].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allowInboundToDb" {
  name                   = "allowInboundToDb"
  priority               = 1003
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "3306"
  source_address_prefixes = [
    azurerm_network_interface.nic[0].private_ip_address,
    azurerm_network_interface.nic[1].private_ip_address
  ]
  destination_address_prefix  = azurerm_network_interface.nic[2].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allowSsh" {
  name                        = "allowSsh"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_interface_security_group_association" "nicNsg" {
  count                     = 4
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vms" {
  count                 = 4
  name                  = "${local.names[count.index].name}-0${count.index}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "osDisk-${local.names[count.index].name}-0${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "${local.names[count.index].name}-0${count.index}"
  admin_username                  = "zala"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "zala"
    public_key = tls_private_key.sshkey.public_key_openssh
  }

  tags = {
    env = "${local.names[count.index].name}"
  }
}

# Creating bastion

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "bastionIp" {
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
    name                 = "ipConf"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastionIp.id
  }
}

# Create dynamic agent

resource "azurerm_virtual_machine_extension" "agent" {
  name                 = "azureDevOpsAgent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vms[3].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/zalapeach/terraform/master/azure/006_wordpress_with_ansible/scripts/agent.sh"
        ],
      "commandToExecute": "sh agent.sh ${data.external.env.result["azure_devops_pat"]} ${data.external.env.result["azure_devops_org"]} ${data.external.env.result["azure_app_id"]} ${data.external.env.result["azure_app_secret"]} ${data.external.env.result["azure_app_tenant"]}"
    }
SETTINGS

  depends_on = [
    azurerm_linux_virtual_machine.vms
  ]
}

# Keep private certs on keyvault

data "azurerm_key_vault" "kv" {
  name                = data.terraform_remote_state.azdo.outputs.azure_key_vault_name
  resource_group_name = data.terraform_remote_state.azdo.outputs.resource_group_name
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "vms-certificate-exercise-006"
  key_vault_id = data.azurerm_key_vault.kv.id
  value        = tls_private_key.sshkey.private_key_pem
}
