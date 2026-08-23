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