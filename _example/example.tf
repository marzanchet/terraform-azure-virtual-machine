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

module "vnet" {
  source  = "clouddrove/vnet/azure"
  version = "1.0.0"

  name                = "app"
  environment         = "test"
  label_order         = ["name", "environment"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
  enable_ddos_pp      = false
}

module "subnet" {
  source  = "clouddrove/subnet/azure"
  version = "1.0.1"

  name                 = "app"
  environment          = "test"
  label_order          = ["name", "environment"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet.vnet_name)

  #subnet
  default_name_subnet = true
  subnet_names        = ["subnet1", "subnet2"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]

  # route_table
  enable_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

module "security_group" {
source  = "clouddrove/network-security-group/azure"
  version = "1.0.0"
  ## Tags
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]

  ## Security Group
  resource_group_name      = module.resource_group.resource_group_name
  resource_group_location  = module.resource_group.resource_group_location
  subnet_ids               = module.subnet.default_subnet_id
  ##Security Group rule for Custom port.
  inbound_rules = [
    {
     name = "ssh" 
     priority = 101
     access = "Allow"
     protocol = "Tcp"
     source_address_prefix = "10.10.0.0/16"
     source_port_range = "*"
     destination_address_prefix = "0.0.0.0/0"
     destination_port_range = "22"
     description = "ssh allowed port"
}]
  
}


module "virtual-machine" {
  source = "../"

  ## Tags
  name        = "app"
  environment = "test"
  label_order = ["environment", "name"]

  ## Common
  enabled             = true
  machine_count       = 1
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  ## Network Interface
  subnet_id                     = module.subnet.default_subnet_id
  private_ip_address_version    = "IPv4"
  private_ip_address_allocation = "Static"
  primary                       = true
  private_ip_addresses          = ["10.0.1.4"]
  #nsg
  network_interface_sg_enabled = true
  network_security_group_id    = module.security_group.id

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
  image_offer                     = "0001-com-ubuntu-server-focal"
  image_sku                       = "20_04-lts"
  image_version                   = "latest"
}
