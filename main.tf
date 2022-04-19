## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : labels
#Description : Terraform module to create consistent naming for multiple names.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-azure-labels.git?ref=tags/0.12.0"

  name        = var.name
  application = var.application
  environment = var.environment
  tags        = var.tags
  managedby   = var.managedby
  label_order = var.label_order
}

#Module      : NETWORK INTERFACE
#Description : Terraform resource to create a network interface for virtual machine.
resource "azurerm_network_interface" "default" {
  count                         = var.enabled ? var.machine_count : 0
  name                          = format("%s-network-interface-%s", module.labels.id, count.index + 1)
  resource_group_name           = var.resource_group_name
  location                      = var.location
  dns_servers                   = var.dns_servers
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking
  internal_dns_name_label       = var.internal_dns_name_label
  tags                          = module.labels.tags

  ip_configuration {
    name                          = format("%s-ip-configuration-%s", module.labels.id, count.index + 1)
    subnet_id                     = var.private_ip_address_version == "IPv4" ? element(var.subnet_id, count.index) : ""
    private_ip_address_version    = var.private_ip_address_version
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = var.public_ip_enabled ? element(azurerm_public_ip.default.*.id, count.index) : ""
    primary                       = var.primary
    private_ip_address            = var.private_ip_address_allocation == "Static" ? element(var.private_ip_addresses, count.index) : ""
  }

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : AVAILABILITY SET
#Description : Terraform resource to create a availability set for virtual machine.
resource "azurerm_availability_set" "default" {
  count                        = var.enabled && var.availability_set_enabled ? 1 : 0
  name                         = format("%s-availability-set", module.labels.id)
  resource_group_name          = var.resource_group_name
  location                     = var.location
  platform_update_domain_count = var.platform_update_domain_count
  platform_fault_domain_count  = var.platform_fault_domain_count
  proximity_placement_group_id = var.proximity_placement_group_id
  managed                      = var.managed
  tags                         = module.labels.tags

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : PUBLIC IP
#Description : Terraform resource to create a public IP for network interface.
resource "azurerm_public_ip" "default" {
  count                   = var.enabled && var.public_ip_enabled ? var.machine_count : 0
  name                    = format("%s-public-ip-%s", module.labels.id, count.index + 1)
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku                     = var.sku
  allocation_method       = var.sku == "Standard" ? "Static" : var.allocation_method
  ip_version              = var.ip_version
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  domain_name_label       = var.domain_name_label
  reverse_fqdn            = var.reverse_fqdn
  public_ip_prefix_id     = var.public_ip_prefix_id
  zones                   = var.zones
  tags                    = module.labels.tags

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : STORAGE ACCOUNT
#Description : Terraform resource to create a storage account for virtual machine.
resource "azurerm_storage_account" "default" {
  count                     = var.enabled && var.boot_diagnostics_enabled ? 1 : 0
  name                      = "teststorageaccount"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.account_kind == "BlobStorage" || var.account_kind == "FileStorage" || var.account_kind == "StorageV2" ? var.access_tier : ""
  enable_https_traffic_only = var.enable_https_traffic_only
  is_hns_enabled            = var.is_hns_enabled
  tags                      = module.labels.tags

  dynamic "blob_properties" {
    for_each = var.blob_properties_enabled ? [1] : []

    content {
      cors_rule {
        allowed_headers    = var.allowed_headers
        allowed_methods    = var.allowed_methods
        allowed_origins    = var.allowed_origins
        exposed_headers    = var.exposed_headers
        max_age_in_seconds = var.max_age_in_seconds
      }

      delete_retention_policy {
        days = var.days
      }
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain_enabled ? [1] : []

    content {
      name          = format("%s-custom-domain", module.labels.id)
      use_subdomain = var.use_subdomain
    }
  }

  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []

    content {
      type = var.sa_type
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties_enabled ? [1] : []

    content {
      cors_rule {
        allowed_headers    = var.allowed_headers
        allowed_methods    = var.allowed_methods
        allowed_origins    = var.allowed_origins
        exposed_headers    = var.exposed_headers
        max_age_in_seconds = var.max_age_in_seconds
      }

      logging {
        delete                = var.log_delete
        read                  = var.log_read
        version               = var.log_version
        write                 = var.log_write
        retention_policy_days = var.retention_policy_days
      }

      minute_metrics {
        enabled               = var.minute_metrics_enabled
        version               = var.version
        include_apis          = var.include_apis
        retention_policy_days = var.retention_policy_days
      }

      hour_metrics {
        enabled               = var.hour_metrics_enabled
        version               = var.version
        include_apis          = var.include_apis
        retention_policy_days = var.retention_policy_days
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules_enabled ? [1] : []

    content {
      default_action             = var.default_action
      bypass                     = [var.bypass]
      ip_rules                   = azurerm_public_ip.default.*.ip_address
      virtual_network_subnet_ids = var.subnet_id
    }
  }

  dynamic "static_website" {
    for_each = var.static_website_enabled ? [1] : []

    content {
      index_document     = var.index_document
      error_404_document = var.error_404_document
    }
  }

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : LINUX VIRTUAL MACHINE
#Description : Terraform resource to create a linux virtual machine.
resource "azurerm_virtual_machine" "default" {
  count                            = var.enabled ? var.machine_count : 0
  name                             = format("%s-virtual-machine-%s", module.labels.id, count.index + 1)
  resource_group_name              = var.resource_group_name
  location                         = var.location
  network_interface_ids            = [element(azurerm_network_interface.default.*.id, count.index)]
  vm_size                          = var.vm_size
  availability_set_id              = join("", azurerm_availability_set.default.*.id)
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  primary_network_interface_id     = element(azurerm_network_interface.default.*.id, count.index)
  proximity_placement_group_id     = var.proximity_placement_group_id
  zones                            = var.zones
  tags                             = module.labels.tags

  dynamic "os_profile_linux_config" {
    for_each = var.linux_enabled && var.disable_password_authentication ? [1] : []

    content {
      disable_password_authentication = var.disable_password_authentication

      ssh_keys {
        key_data = file(var.file_path)
        path     = "/home/${var.username}/.ssh/authorized_keys"
      }
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {
      enabled     = var.boot_diagnostics_enabled
      storage_uri = join("", azurerm_storage_account.default.*.primary_blob_endpoint)
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.addtional_capabilities_enabled ? [1] : []

    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }

  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []

    content {
      type         = var.vm_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "os_profile" {
    for_each = var.os_profile_enabled && var.create_option == "FromImage" ? [1] : []

    content {
      computer_name  = format("%s-virtual-machine-%s", module.labels.id, count.index + 1)
      admin_username = var.admin_username
      admin_password = var.windows_enabled && var.disable_password_authentication == false ? var.admin_password : ""
      custom_data    = file("${path.module}/user-data.tpl")
    }
  }

  dynamic "os_profile_secrets" {
    for_each = var.vault_enabled ? [1] : []

    content {
      source_vault_id = var.source_vault_id

      vault_certificates {
        certificate_url   = var.certificate_url
        certificate_store = var.certificate_store
      }
    }
  }

  dynamic "plan" {
    for_each = var.plan_enabled ? [1] : []

    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }

  storage_os_disk {
    name                      = format("%s-storage-os-disk", module.labels.id)
    create_option             = var.create_option
    caching                   = var.caching
    disk_size_gb              = var.disk_size_gb
    image_uri                 = var.image_uri
    os_type                   = var.os_type
    write_accelerator_enabled = var.write_accelerator_enabled
    managed_disk_id           = var.create_option == "Attach" ? var.managed_disk_id : null
    managed_disk_type         = var.managed_disk_type
    vhd_uri                   = var.vhd_uri
  }

  dynamic "storage_data_disk" {
    for_each = var.storage_data_disk_enabled ? [1] : []

    content {
      name                      = format("%s-storage-data-disk", module.labels.id)
      create_option             = var.create_option
      caching                   = var.caching
      disk_size_gb              = var.disk_size_gb
      lun                       = var.lun
      write_accelerator_enabled = var.write_accelerator_enabled
      managed_disk_id           = var.create_option == "Attach" ? var.managed_disk_id : ""
      managed_disk_type         = var.ultra_ssd_enabled ? "UltraSSD_LRS" : var.managed_disk_type
      #vhd_uri                   = var.vhd_uri
    }
  }

  dynamic "storage_image_reference" {
    for_each = var.storage_image_reference_enabled ? [1] : []

    content {
      publisher = var.custom_image_id == "" ? var.image_publisher : ""
      offer     = var.custom_image_id == "" ? var.image_offer : ""
      sku       = var.custom_image_id == "" ? var.image_sku : ""
      version   = var.custom_image_id == "" ? var.image_version : ""
      id        = var.custom_image_id
    }
  }

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : VIRTUAL MACHINE
#Description : Terraform resource to create a virtual machine.
resource "azurerm_virtual_machine" "default" {
  count                            = var.enabled ? var.machine_count : 0
  name                             = format("%s-virtual-machine-%s", module.labels.id, count.index + 1)
  resource_group_name              = var.resource_group_name
  location                         = var.location
  network_interface_ids            = [element(azurerm_network_interface.default.*.id, count.index)]
  vm_size                          = var.vm_size
  availability_set_id              = join("", azurerm_availability_set.default.*.id)
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  license_type                     = var.license_type
  primary_network_interface_id     = element(azurerm_network_interface.default.*.id, count.index)
  proximity_placement_group_id     = var.proximity_placement_group_id
  zones                            = var.zones
  tags                             = module.labels.tags

  dynamic "os_profile_linux_config" {
    for_each = var.linux_enabled && var.disable_password_authentication ? [1] : []

    content {
      disable_password_authentication = var.disable_password_authentication

      ssh_keys {
        key_data = file(var.file_path)
        path     = "/home/${var.username}/.ssh/authorized_keys"
      }
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = var.windows_enabled ? [1] : []

    content {
      provision_vm_agent        = var.provision_vm_agent
      enable_automatic_upgrades = var.enable_automatic_upgrades
      timezone                  = var.timezone
      
      winrm {
        protocol        = var.protocol
        certificate_url = var.certificate_url
      }

      additional_unattend_config {
        pass         = var.pass
        component    = var.component
        setting_name = var.setting_name
        content      = var.content
      }
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_enabled ? [1] : []

    content {
      enabled     = var.boot_diagnostics_enabled
      storage_uri = join("", azurerm_storage_account.default.*.primary_blob_endpoint)
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.addtional_capabilities_enabled ? [1] : []

    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }

  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []

    content {
      type         = var.vm_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "os_profile" {
    for_each = var.os_profile_enabled && var.create_option == "FromImage" ? [1] : []

    content {
      computer_name  = format("%s-virtual-machine-%s", module.labels.id, count.index + 1)
      admin_username = var.admin_username
      admin_password = var.windows_enabled && var.disable_password_authentication == false ? var.admin_password : ""
      custom_data    = file("${path.module}/user-data.tpl")
    }
  }

  dynamic "os_profile_secrets" {
    for_each = var.vault_enabled ? [1] : []

    content {
      source_vault_id = var.source_vault_id

      vault_certificates {
        certificate_url   = var.certificate_url
        certificate_store = var.certificate_store
      }
    }
  }

  dynamic "plan" {
    for_each = var.plan_enabled ? [1] : []

    content {
      name      = var.plan_name
      publisher = var.plan_publisher
      product   = var.plan_product
    }
  }

  storage_os_disk {
    name                      = format("%s-storage-os-disk", module.labels.id)
    create_option             = var.create_option
    caching                   = var.caching
    disk_size_gb              = var.disk_size_gb
    image_uri                 = var.image_uri
    os_type                   = var.os_type
    write_accelerator_enabled = var.write_accelerator_enabled
    managed_disk_id           = var.create_option == "Attach" ? var.managed_disk_id : null
    managed_disk_type         = var.managed_disk_type
    #vhd_uri                   = var.vhd_uri
  }

  dynamic "storage_data_disk" {
    for_each = var.storage_data_disk_enabled ? [1] : []

    content {
      name                      = format("%s-storage-data-disk", module.labels.id)
      create_option             = var.create_option
      caching                   = var.caching
      disk_size_gb              = var.disk_size_gb
      lun                       = var.lun
      write_accelerator_enabled = var.write_accelerator_enabled
      managed_disk_id           = var.create_option == "Attach" ? var.managed_disk_id : ""
      managed_disk_type         = var.ultra_ssd_enabled ? "UltraSSD_LRS" : var.managed_disk_type
      #vhd_uri                   = var.vhd_uri
    }
  }

  dynamic "storage_image_reference" {
    for_each = var.storage_image_reference_enabled ? [1] : []

    content {
      publisher = var.custom_image_id == "" ? var.image_publisher : ""
      offer     = var.custom_image_id == "" ? var.image_offer : ""
      sku       = var.custom_image_id == "" ? var.image_sku : ""
      version   = var.custom_image_id == "" ? var.image_version : ""
      id        = var.custom_image_id
    }
  }

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : VIRTUAL MACHINE NETWORK SECURITY GROUP ASSOCIATION
#Description : Terraform resource to create a virtual machine.
resource "azurerm_network_interface_security_group_association" "default" {
  count                     = var.enabled && var.network_interface_sg_enabled ? var.machine_count : 0
  network_interface_id      = azurerm_network_interface.default[count.index].id
  network_security_group_id = var.network_security_group_id
}