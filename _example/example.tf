provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  name        = "app-vm"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

#Vnet
module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "clouddrove/virtual-network/azure"
  version    = "1.0.4"

  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
  enable_ddos_pp      = false

  #subnet
  default_name_subnet           = true
  subnet_names                  = ["subnet1"]
  subnet_prefixes               = ["10.0.1.0/24"]
  disable_bgp_route_propagation = false

  # routes
  enabled_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}


module "security_group" {
  source = "./../_module/terraform-azure-network-security-group"

  ## Tags
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]

  ## Security Group
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  ##Security Group rule for Custom port.
  custom_port = [{
    name                         = "ssh"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["22"]
    source_address_prefixes      = ["0.0.0.0/0"]
    destination_address_prefixes = ["0.0.0.0/0"]
    access                       = "Allow"
    priority                     = 1002
    },
    {
      name                         = "http-https"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = ["80", "443"]
      source_address_prefixes      = ["0.0.0.0/0"]
      destination_address_prefixes = ["0.0.0.0/0"]
      access                       = "Allow"
      priority                     = 1003
    }
  ]
}


module "virtual-machine" {
  source = "../"

  ## Tags
  name        = "virtual-machine"
  environment = "test"
  label_order = ["environment", "name"]

  ## Common
  enabled             = true
  machine_count       = 1
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  ## Network Interface
  subnet_id                     = module.virtual_network.vnet_subnets
  private_ip_address_version    = "IPv4"
  private_ip_address_allocation = "Static"
  primary                       = true
  private_ip_addresses          = ["10.0.1.4"]
  #nsg
  network_interface_sg_enabled = true
  network_security_group_id    = module.security_group.security_group_id

  ## Availability Set
  availability_set_enabled     = true
  platform_update_domain_count = 7
  platform_fault_domain_count  = 3

  ## Public IP
  public_ip_enabled = true
  sku               = "Basic"
  allocation_method = "Static"
  ip_version        = "IPv4"


  ## Virtual Machine
  linux_enabled                   = true
  vm_size                         = "Standard_B1s"
  file_path                       = "~/.ssh/id_rsa.pub"
  username                        = "ubuntu"
  os_profile_enabled              = true
  admin_username                  = "ubuntu"
  create_option                   = "FromImage"
  caching                         = "ReadWrite"
  disk_size_gb                    = 30
  os_type                         = "Linux"
  managed_disk_type               = "Standard_LRS"
  storage_image_reference_enabled = true
  image_publisher                 = "Canonical"
  image_offer                     = "UbuntuServer"
  image_sku                       = "16.04-LTS"
  image_version                   = "latest"
}
