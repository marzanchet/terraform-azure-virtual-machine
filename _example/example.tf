provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "git::https://github.com/clouddrove/terraform-azure-resource-group.git?ref=tags/0.12.0"

  name        = "resource-group"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  enabled  = true
  location = "North Europe"
}

module "virtual_network" {
  source = "git::https://github.com/clouddrove/terraform-azure-virtual-network.git?ref=slave"

  ## Tags
  name        = "virtual-network"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]
  enabled     = true

  ## Virtual Network
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.0", "10.0.0.1"]
}

module "subnet" {
  source = "../../terraform-azure-subnet"

  ## Tags
  name        = "subnet"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]
  enabled     = true

  ## Subnet
  endpoint_enabled                               = true
  address_prefixes                               = ["10.0.0.0/24", "10.0.1.0/24"]
  resource_group_name                            = module.resource_group.resource_group_name
  virtual_network_name                           = module.virtual_network.virtual_network_name
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.AzureActiveDirectory", "Microsoft.Storage", "Microsoft.Sql"]

  delegations = [
    {
      name                       = "Test-1"
      service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
      service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  ]

  ## Network Security Group Association
  network_security_group_id = module.security_group.security_group_id
}

module "security_group" {
  source = "../../terraform-azure-security-group"

  ## Tags
  name        = "security-group"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]
  enabled     = true

  ## Security Group
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  ## Security Group Rule
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["22", "80"]
  source_address_prefixes      = ["49.36.131.84/32"]
  destination_address_prefixes = module.subnet.address_prefix
  access                       = "Allow"
  priority                     = 105
}

module "virtual_machine" {
  source = "../"

  ## Tags
  name        = "virtual-machine"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]
  
  ## Common 
  enabled             = true
  machine_count       = 2
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  ## Network Interface
  subnet_id                     = module.subnet.subnet_id
  private_ip_address_version    = "IPv4"
  private_ip_address_allocation = "Static"
  primary                       = true
  private_ip_addresses          = ["10.0.0.3", "10.0.1.5"]

  ## Availability Set
  availability_set_enabled     = true
  platform_update_domain_count = 7
  platform_fault_domain_count  = 3

  ## Public IP
  public_ip_enabled = true
  sku               = "Basic"
  allocation_method = "Static"
  ip_version        = "IPv4"
  domain_name_label = "clouddrove"

  ## Storage Account
  boot_diagnostics_enabled = true
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules_enabled    = true
  default_action           = "Deny"
  bypass                   = "Logging"

  ## Virtual Machine
  vm_size                         = "Standard_D2s_v3"
  linux_enabled                   = true
  file_path                       = "~/.ssh/id_rsa.pub"
  username                        = "aashish"
  os_profile_enabled              = true
  admin_username                  = "aashish"
  create_option                   = "FromImage"
  caching                         = "ReadWrite"
  disk_size_gb                    = 10
  os_type                         = "Linux"
  managed_disk_type               = "Standard_LRS"
  storage_image_reference_enabled = true
  image_publisher                 = "Canonical"
  image_offer                     = "UbuntuServer"
  image_sku                       = "16.04-LTS"
  image_version                   = "latest"
}