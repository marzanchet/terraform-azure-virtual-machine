#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "label_order" {
  type        = list
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

## Common Variables

variable "enabled" {
  type        = bool
  default     = false
  description = "Flag to control the module creation."
}

variable "machine_count" {
  type        = number
  default     = 0
  description = "Number of Virtual Machines to create."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  default     = ""
  description = "Location where resource should be created."
}

variable "create" {
  type        = string
  default     = "60m"
  description = "Used when creating the Resource Group."
}

variable "update" {
  type        = string
  default     = "60m"
  description = "Used when updating the Resource Group."
}

variable "read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Resource Group."
}

variable "delete" {
  type        = string
  default     = "60m"
  description = "Used when deleting the Resource Group."
}

## Network Interface

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "List of IP addresses of DNS servers."
}

variable "enable_ip_forwarding" {
  type        = bool
  default     = false
  description = "Should IP Forwarding be enabled? Defaults to false."
}

variable "enable_accelerated_networking" {
  type        = bool
  default     = false
  description = "Should Accelerated Networking be enabled? Defaults to false."
}

variable "internal_dns_name_label" {
  type        = string
  default     = null
  description = "The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network."
}

variable "subnet_id" {
  type        = list
  default     = []
  description = "The ID of the Subnet where this Network Interface should be located in."
}

variable "private_ip_address_version" {
  type        = string
  default     = "IPv4"
  description = "The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4."
}

variable "private_ip_address_allocation" {
  type        = string
  default     = "Static"
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
}

variable "primary" {
  type        = bool
  default     = false
  description = "Is this the Primary IP Configuration? Must be true for the first ip_configuration when multiple are specified. Defaults to false."
}

variable "private_ip_addresses" {
  type        = list
  default     = []
  description = "The Static IP Address which should be used."
}

## Availability Set

variable "availability_set_enabled" {
  type        = bool
  default     = false
  description = "Whether availability set is enabled."
}

variable "platform_update_domain_count" {
  type        = number
  default     = 5
  description = "Specifies the number of update domains that are used. Defaults to 5."
}

variable "platform_fault_domain_count" {
  type        = number
  default     = 3
  description = "Specifies the number of fault domains that are used. Defaults to 3."
}

variable "proximity_placement_group_id" {
  type        = string
  default     = ""
  description = "The ID of the Proximity Placement Group to which this Virtual Machine should be assigned."
}

variable "managed" {
  type        = bool
  default     = true
  description = "Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true."
}

## Public IP

variable "public_ip_enabled" {
  type        = bool
  default     = false
  description = "Whether public IP is enabled."
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
}

variable "allocation_method" {
  type        = string
  default     = ""
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
}

variable "ip_version" {
  type        = string
  default     = ""
  description = "The IP Version to use, IPv6 or IPv4."
}

variable "idle_timeout_in_minutes" {
  type        = number
  default     = 10
  description = "Specifies the timeout for the TCP idle connection. The value can be set between 4 and 60 minutes."
}

variable "domain_name_label" {
  type        = string
  default     = ""
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "reverse_fqdn" {
  type        = string
  default     = ""
  description = "A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
}

variable "public_ip_prefix_id" {
  type        = string
  default     = null
  description = "If specified then public IP address allocated will be provided from the public IP prefix resource."
}

variable "zones" {
  type        = list
  default     = []
  description = "A collection containing the availability zone to allocate the Public IP in."
}

## Storage Account

variable "boot_diagnostics_enabled" {
  type        = bool
  default     = false
  description = "Whether boot diagnostics block is enabled."
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
}

variable "account_tier" {
  type        = string
  default     = ""
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
}

variable "account_replication_type" {
  type        = string
  default     = ""
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "enable_https_traffic_only" {
  type        = bool
  default     = true
  description = "Boolean flag which forces HTTPS if enabled. Defaults to true."
}

variable "is_hns_enabled" {
  type        = bool
  default     = false
  description = "Is Hierarchical Namespace enabled?."
}

variable "blob_properties_enabled" {
  type        = bool
  default     = false
  description = "Is blob properties is enabled."
}

variable "allowed_headers" {
  type        = list
  default     = []
  description = "A list of headers that are allowed to be a part of the cross-origin request."
}

variable "allowed_methods" {
  type        = list
  default     = []
  description = "A list of http headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH."
}

variable "allowed_origins" {
  type        = list
  default     = []
  description = "A list of origin domains that will be allowed by CORS."
}

variable "exposed_headers" {
  type        = list
  default     = []
  description = "A list of response headers that are exposed to CORS clients."
}

variable "max_age_in_seconds" {
  type        = number
  default     = 60
  description = "The number of seconds the client should cache a preflight response."
}

variable "days" {
  type        = number
  default     = 7
  description = "Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7."
}

variable "custom_domain_enabled" {
  type        = bool
  default     = false
  description = "Whether custom domain is enabled."
}

variable "use_subdomain" {
  type        = bool
  default     = false
  description = "Should the Custom Domain Name be validated by using indirect CNAME validation?."
}

variable "identity_enabled" {
  type        = bool
  default     = false
  description = "Whether identity block is enabled."
}

variable "sa_type" {
  type        = string
  default     = "SystemAssigned"
  description = "Specifies the identity type of the Storage Account. At this time the only allowed value is SystemAssigned."
}

variable "queue_properties_enabled" {
  type        = bool
  default     = false
  description = "Whether queue properties is enabled."
}

variable "log_delete" {
  type        = bool
  default     = false
  description = "Indicates whether all delete requests should be logged."
}

variable "log_read" {
  type        = bool
  default     = false
  description = "Indicates whether all read requests should be logged."
}

variable "log_version" {
  type        = string
  default     = ""
  description = "The version of storage analytics to configure."
}

variable "log_write" {
  type        = bool 
  default     = false
  description = "Indicates whether all write requests should be logged."
}

variable "retention_policy_days" {
  type        = number
  default     = 7
  description = "Specifies the number of days that logs will be retained."
}

variable "minute_metrics_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether minute metrics are enabled for the Queue service."
}

variable "include_apis" {
  type        = bool
  default     = false
  description = "Indicates whether metrics should generate summary statistics for called API operations."
}

variable "hour_metrics_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether hour metrics are enabled for the Queue service."
}

variable "network_rules_enabled" {
  type        = bool
  default     = false
  description = "Whether network rules block is enabled."
}

variable "default_action" {
  type        = string
  default     = ""
  description = "Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
}

variable "bypass" {
  type        = string
  default     = ""
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
}

variable "static_website_enabled" {
  type        = bool
  default     = false
  description = "Whether static website block is enabled."
}

variable "index_document" {
  type        = string
  default     = ""
  description = "The webpage that Azure Storage serves for requests to the root of a website or any subfolder. For example, index.html. The value is case-sensitive."
}

variable "error_404_document" {
  type        = string
  default     = ""
  description = "The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file."
}

## Virtual Machine

variable "vm_size" {
  type        = string
  default     = ""
  description = "Specifies the size of the Virtual Machine."
}

variable "delete_os_disk_on_termination" {
  type        = bool
  default     = true
  description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? Defaults to false."
}

variable "delete_data_disks_on_termination" {
  type        = bool
  default     = true
  description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? Defaults to false."
}

variable "license_type" {
  type        = string
  default     = "Windows_Client"
  description = "Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows_Client and Windows_Server."
}

variable "linux_enabled" {
  type        = bool
  default     = false
  description = "Whether linux block is enabled."
}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "Specifies whether password authentication should be disabled."
}

variable "file_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "The Public SSH Key which should be written to the path defined above."
}

variable "username" {
  type        = string
  default     = ""
  description = "The linux user name."
}

variable "windows_enabled" {
  type        = bool
  default     = false
  description = "Whether windows block is enabled."
}

variable "provision_vm_agent" {
  type        = bool
  default     = false
  description = "Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to false."
}

variable "enable_automatic_upgrades" {
  type        = bool
  default     = false
  description = "Are automatic updates enabled on this Virtual Machine? Defaults to false."
}

variable "timezone" {
  type        = string
  default     = ""
  description = "Specifies the time zone of the virtual machine."
}

variable "protocol" {
  type        = string
  default     = ""
  description = "Specifies the protocol of listener. Possible values are HTTP or HTTPS."
}

variable "certificate_url" {
  type        = string
  default     = ""
  description = "The ID of the Key Vault Secret which contains the encrypted Certificate which should be installed on the Virtual Machine. This certificate must also be specified in the vault_certificates block within the os_profile_secrets block."
}

variable "pass" {
  type        = string
  default     = "oobeSystem"
  description = "Specifies the name of the pass that the content applies to. The only allowable value is oobeSystem."
}

variable "component" {
  type        = string
  default     = "Microsoft-Windows-Shell-Setup"
  description = "Specifies the name of the component to configure with the added content. The only allowable value is Microsoft-Windows-Shell-Setup."
}

variable "setting_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the setting to which the content applies. Possible values are: FirstLogonCommands and AutoLogon."
}

variable "content" {
  type        = string
  default     = ""
  description = "Specifies the base-64 encoded XML formatted content that is added to the unattend.xml file for the specified path and component."
}

variable "addtional_capabilities_enabled" {
  type        = bool
  default     = false
  description = "Whether additional capabilities block is enabled."
}

variable "ultra_ssd_enabled" {
  type        = bool
  default     = false
  description = "Should Ultra SSD disk be enabled for this Virtual Machine?."
}

variable "vm_type" {
  type        = string
  default     = ""
  description = "The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned and UserAssigned."
}

variable "identity_ids" {
  type        = list
  default     = []
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
}

variable "os_profile_enabled" {
  type        = bool
  default     = false
  description = "Whether os profile block is enabled."
}

variable "admin_username" {
  type        = string
  default     = ""
  description = "Specifies the name of the local administrator account."
}

variable "admin_password" {
  type        = string
  default     = ""
  description = "The password associated with the local administrator account."
}

variable "vault_enabled" {
  type        = bool
  default     = false
  description = "Whether key vault is enabled."
}

variable "source_vault_id" {
  type        = string
  default     = ""
  description = "Specifies the ID of the Key Vault to use."
}

variable "certificate_store" {
  type        = string
  default     = ""
  description = "Specifies the certificate store on the Virtual Machine where the certificate should be added to, such as My."
}

variable "plan_enabled" {
  type        = bool
  default     = false
  description = "Whether plan block is enabled."
}

variable "plan_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the image from the marketplace."
}

variable "plan_publisher" {
  type        = string
  default     = ""
  description = "Specifies the publisher of the image."
}

variable "plan_product" {
  type        = string
  default     = ""
  description = "Specifies the product of the image from the marketplace."
}

variable "create_option" {
  type        = string
  default     = ""
  description = "Specifies how the OS Disk should be created. Possible values are Attach (managed disks only) and FromImage."
}

variable "caching" {
  type        = string
  default     = ""
  description = "Specifies the caching requirements for the OS Disk. Possible values include None, ReadOnly and ReadWrite."
}

variable "disk_size_gb" {
  type        = number
  default     = 8
  description = "Specifies the size of the OS Disk in gigabytes."
}

variable "image_uri" {
  type        = string
  default     = ""
  description = "Specifies the Image URI in the format publisherName:offer:skus:version. This field can also specify the VHD uri of a custom VM image to clone. When cloning a Custom (Unmanaged) Disk Image the os_type field must be set."
}

variable "os_type" {
  type        = string
  default     = ""
  description = "Specifies the Operating System on the OS Disk. Possible values are Linux and Windows."
}

variable "write_accelerator_enabled" {
  type        = bool
  default     = false
  description = "Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS managed disks with no caching and M-Series VMs. Defaults to false."
}

variable "managed_disk_id" {
  type        = string
  default     = ""
  description = "Specifies the ID of an existing Managed Disk which should be attached as the OS Disk of this Virtual Machine. If this is set then the create_option must be set to Attach."
}

variable "managed_disk_type" {
  type        = string
  default     = ""
  description = "Specifies the type of Managed Disk which should be created. Possible values are Standard_LRS, StandardSSD_LRS or Premium_LRS."
}

variable "vhd_uri" {
  type        = string
  default     = null
  description = "Specifies the URI of the VHD file backing this Unmanaged OS Disk. Changing this forces a new resource to be created."
}

variable "storage_data_disk_enabled" {
  type        = bool
  default     = false
  description = "Whether storage data disk is enabled."
}

variable "lun" {
  type        = number
  default     = 0
  description = "Specifies the logical unit number of the data disk. This needs to be unique within all the Data Disks on the Virtual Machine."
}

variable "storage_image_reference_enabled" {
  type        = bool
  default     = false
  description = "Whether storage image reference is enabled."
}

variable "custom_image_id" {
  type        = string
  default     = ""
  description = "Specifies the ID of the Custom Image which the Virtual Machine should be created from."
}

variable "image_publisher" {
  type        = string
  default     = ""
  description = "Specifies the publisher of the image used to create the virtual machine."
}

variable "image_offer" {
  type        = string
  default     = ""
  description = "Specifies the offer of the image used to create the virtual machine."
}

variable "image_sku" {
  type        = string
  default     = ""
  description = "Specifies the SKU of the image used to create the virtual machine."
}

variable "image_version" {
  type        = string
  default     = ""
  description = "Specifies the version of the image used to create the virtual machine."
}

variable "network_interface_sg_enabled" {
  type        = bool
  default     = false
  description = "Whether network interface security group is enabled."
}

variable "network_security_group_id" {
  type        = string
  default     = ""
  description = "The ID of the Network Security Group which should be attached to the Network Interface."
}