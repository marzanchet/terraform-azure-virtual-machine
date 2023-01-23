output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "The name of the resource group in which the subnet is created in."
}

output "virtual_network_name" {
  value       = module.vnet.vnet_name
  description = "The name of the virtual network in which the subnet is created in."
}

output "subnet_id" {
  value       = module.subnet.default_subnet_id
  description = "The subnet ID."
}

output "network_interface_private_ip_addresses" {
  value       = module.virtual-machine.network_interface_private_ip_addresses
  description = "The private IP addresses of the network interface."
}

output "availability_set_id" {
  value       = module.virtual-machine.availability_set_id
  description = "The ID of the Availability Set."
}

output "public_ip_id" {
  value       = module.virtual-machine.public_ip_id
  description = "The Public IP ID."
}

output "public_ip_address" {
  value       = module.virtual-machine.public_ip_address
  description = "The IP address value that was allocated."
}

output "virtual_machine_id" {
  value       = join("", module.virtual-machine.*.virtual_machine_id)
  description = "The ID of the Virtual Machine."
}

output "tags" {
  value       = module.virtual-machine.tags
  description = "The tags associated to resources."
}
