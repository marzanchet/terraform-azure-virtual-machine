output "network_interface_id" {
  value       = join("", azurerm_network_interface.default.*.id)
  description = "The ID of the Network Interface."
}

output "network_interface_private_ip_addresses" {
  value       = join("", azurerm_network_interface.default.0.private_ip_addresses)
  description = "The private IP addresses of the network interface."
}

output "availability_set_id" {
  value       = join("", azurerm_availability_set.default.*.id)
  description = "The ID of the Availability Set."
}

output "public_ip_id" {
  value       = join("", azurerm_public_ip.default.*.id)
  description = "The Public IP ID."
}

output "public_ip_address" {
  value       = join("", azurerm_public_ip.default.*.ip_address)
  description = "The IP address value that was allocated."
}

output "storage_account_id" {
  value       = join("", azurerm_storage_account.default.*.id)
  description = "The storage account Resource ID."
}

output "storage_account_primary_location" {
  value       = join("", azurerm_storage_account.default.*.primary_location)
  description = "The endpoint URL for blob storage in the primary location."
}

output "storage_account_primary_blob_endpoint" {
  value       = join("", azurerm_storage_account.default.*.primary_blob_endpoint)
  description = "The endpoint URL for blob storage in the primary location."
}

output "virtual_machine_id" {
  value       = join("", azurerm_virtual_machine.default.*.id)
  description = "The ID of the Virtual Machine."
}

# output "virtual_machine_identity" {
#   value       = join("", azurerm_virtual_machine.default.identity.*.principal_id)
#   description = "The Principal ID for the Service Principal associated with the Managed Service Identity of this Virtual Machine."
# }

output "network_interface_sg_association_id" {
  value       = join("", azurerm_network_interface_security_group_association.default.*.id)
  description = "The (Terraform specific) ID of the Association between the Network Interface and the Network Interface."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags associated to resources."
}