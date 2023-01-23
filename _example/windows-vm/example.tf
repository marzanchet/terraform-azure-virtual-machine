provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  name        = "app-win-vm"
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
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  subnet_ids              = module.subnet.default_subnet_id
  ##Security Group rule for Custom port.
  inbound_rules = [
    {
      name                       = "rdp"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "3389"
      description                = "allow rdp port"
    },
    {
      name                       = "http"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "443"
      description                = "allow https port"
    }
  ]

}


module "virtual-machine" {
  source = "../../"


  # Resource Group, location, VNet and Subnet details
  ## Tags
  name        = "app"
  environment = "test"
  label_order = ["environment", "name"]

  ## Common
  is_vm_windows                   = true
  enabled                         = true
  machine_count                   = 1
  resource_group_name             = module.resource_group.resource_group_name
  location                        = module.resource_group.resource_group_location
  disable_password_authentication = false
  create_option                   = "FromImage"
  disk_size_gb                    = 128


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


  # This module support multiple Pre-Defined Linux and Windows Distributions.
  # Check the README.md file for more pre-defined images for WindowsServer, MSSQLServer.
  # Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
  # This module creates a random admin password if `admin_password` is not specified
  # Specify a valid password with `admin_password` argument to use your own password 
  os_type       = "windows"
  computer_name = "app-win-comp"

  # windows_distribution_name = "windows2019dc"
  vm_size         = "Standard_B1s"
  admin_username  = "azureadmin"
  admin_password  = "Password@123"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2019-Datacenter"
  image_version   = "latest"


  # Boot diagnostics to troubleshoot virtual machines, by default uses managed 
  # To use custom storage account, specify `storage_account_name` with a valid name
  # Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics
  enable_boot_diagnostics = false #Default is false 

  # Attach a managed data disk to a Windows/Linux VM's. Possible Storage account type are: 
  # `Standard_LRS`, `StandardSSD_ZRS`, `Premium_LRS`, `Premium_ZRS`, `StandardSSD_LRS`
  # or `UltraSSD_LRS` (UltraSSD_LRS only available in a region that support availability zones)
  # Initialize a new data disk - you need to connect to the VM and run diskmanagemnet or fdisk
  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 128
      storage_account_type = "StandardSSD_LRS"
    }
    # ,{
    #   name                 = "disk2"
    #   disk_size_gb         = 200
    #   storage_account_type = "Standard_LRS"
    # }
  ]

  # Deploy log analytics agents to virtual machine. 
  # Log analytics workspace customer id and primary shared key required.
  # deploy_log_analytics_agent                 = true
  # log_analytics_customer_id                  = data.azurerm_log_analytics_workspace.example.workspace_id
  # log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.example.primary_shared_key
}