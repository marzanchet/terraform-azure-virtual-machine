output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "The name of the resource group in which the subnet is created in."
}

output "virtual_network_name" {
  value       = module.virtual_network.virtual_network_name
  description = "The name of the virtual network in which the subnet is created in."
}

output "subnet_id" {
  value       = module.subnet.subnet_id
  description = "The subnet ID."
}

output "subnet_name" {
  value       = module.subnet.subnet_name
  description = "The name of the subnet."
}

output "address_prefix" {
  value       = module.subnet.address_prefix
  description = "The address prefixes for the subnet."
}

output "network_interface_id" {
  value       = module.virtual_machine.network_interface_id
  description = "The ID of the Network Interface."
}

output "network_interface_private_ip_addresses" {
  value       = module.virtual_machine.network_interface_private_ip_addresses
  description = "The private IP addresses of the network interface."
}

output "availability_set_id" {
  value       = module.virtual_machine.availability_set_id
  description = "The ID of the Availability Set."
}

output "public_ip_id" {
  value       = module.virtual_machine.public_ip_id
  description = "The Public IP ID."
}

output "public_ip_address" {
  value       = module.virtual_machine.public_ip_address
  description = "The IP address value that was allocated."
}

output "storage_account_id" {
  value       = module.virtual_machine.storage_account_id
  description = "The storage account Resource ID."
}

output "storage_account_primary_location" {
  value       = module.virtual_machine.storage_account_primary_location
  description = "The endpoint URL for blob storage in the primary location."
}

output "storage_account_primary_blob_endpoint" {
  value       = module.virtual_machine.storage_account_primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}

output "virtual_machine_id" {
  value       = module.virtual_machine.virtual_machine_id
  description = "The ID of the Virtual Machine."
}

output "tags" {
  value       = module.subnet.tags
  description = "The tags associated to resources."
}