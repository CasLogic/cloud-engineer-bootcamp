output "resource_group_name" {
  description = "Name of the deployed resource group"
  value       = azurerm_resource_group.lab.name
}

output "vm_name" {
  description = "Name of the deployed Linux VM"
  value       = azurerm_linux_virtual_machine.web_vm.name
}

output "public_ip_address" {
  description = "Public IP address of the Linux VM"
  value       = azurerm_public_ip.web_public_ip.ip_address
}
output "vm_details" {
  description = "Connection details for the deployed VM"

  value = {
    name       = azurerm_linux_virtual_machine.web_vm.name
    public_ip  = azurerm_public_ip.web_public_ip.ip_address
    private_ip = azurerm_network_interface.web_nic.private_ip_address
    username   = azurerm_linux_virtual_machine.web_vm.admin_username
  }
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