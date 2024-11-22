resource "azurerm_resource_group" "rm" {
  name     = "rm-sample"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "sample-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rm.location
  resource_group_name = azurerm_resource_group.rm.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "sample-subnet"
  resource_group_name  = azurerm_resource_group.rm.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "sample-nsg"
  location            = azurerm_resource_group.rm.location
  resource_group_name = azurerm_resource_group.rm.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rm.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.rm.location
  resource_group_name = azurerm_resource_group.rm.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "sample-nic"
  location            = azurerm_resource_group.rm.location
  resource_group_name = azurerm_resource_group.rm.name

  ip_configuration {
    name                          = "sample-internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "sample-vm"
  resource_group_name = azurerm_resource_group.rm.name
  location            = azurerm_resource_group.rm.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  computer_name = "samplevm"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pem.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}