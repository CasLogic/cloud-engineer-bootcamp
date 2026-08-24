terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}
locals {
  project_name = "terraform-lab"
  name_suffix  = var.environment

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}
resource "azurerm_resource_group" "lab" {
  name = "rg-${local.project_name}-${local.name_suffix}"
  location = var.location
  tags = local.tags
}
resource "azurerm_virtual_network" "vnet" {
  name = "vnet-${local.project_name}-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  address_space = var.vnet_address_space
  tags = local.tags
}
resource "azurerm_subnet" "subnet" {
  name = "subnet-web-${local.name_suffix}"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = var.subnet_address_prefixes
  
}
resource "azurerm_network_security_group" "web_nsg" {
  name = "nsg-web-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
security_rule {
  name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.tags
}
resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
resource "azurerm_public_ip" "web_public_ip" {
  name = "pip-web-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = local.tags
}
resource "azurerm_network_interface" "web_nic" {
  name = "nic-web-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_public_ip.id
  }  
  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "web_vm" {
  name = "vm-web01-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = var.vm_size
  admin_username      = "azureadmin"

  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  admin_ssh_key {
    username   = "azureadmin"
    public_key = file("~/.ssh/id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))
  tags = local.tags
}
resource "azurerm_managed_disk" "web_data_disk" {
  name                 = "disk-web-data-${local.name_suffix}"
  location             = azurerm_resource_group.lab.location
  resource_group_name  = azurerm_resource_group.lab.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4

  tags = local.tags
}
resource "azurerm_virtual_machine_data_disk_attachment" "web_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.web_data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.web_vm.id

  lun     = "0"
  caching = "ReadWrite"
}