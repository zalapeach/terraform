resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "exercise013"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = azurerm_user_assigned_identity.identity.principal_id
  }

  computer_name                   = "exercise013"
  admin_username                  = "zala"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "zala"
    public_key = tls_private_key.sshkey.public_key_openssh
  }
}

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

data "azurerm_key_vault" "kv" {
  name                = data.terraform_remote_state.azdo.outputs.azure_key_vault_name
  resource_group_name = data.terraform_remote_state.azdo.outputs.resource_group_name
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "vms-certificate-exercise-013"
  key_vault_id = data.azurerm_key_vault.kv.id
  value        = tls_private_key.sshkey.private_key_pem
}
