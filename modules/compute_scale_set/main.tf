resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  for_each = var.scale_sets

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = each.value.sku
  instances           = each.value.instances
  admin_username      = var.admin_username
  zones               = each.value.zones
  upgrade_mode        = each.value.upgrade_mode
  tags                = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "primary-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  dynamic "data_disk" {
    for_each = each.value.data_disks
    content {
      caching              = data_disk.value.caching
      create_option        = "Empty"
      disk_size_gb         = data_disk.value.disk_size_gb
      lun                  = data_disk.value.lun
      storage_account_type = data_disk.value.storage_account_type
    }
  }

  dynamic "extension" {
    for_each = each.value.extensions
    content {
      name                 = extension.key
      publisher            = extension.value.publisher
      type                 = extension.value.type
      type_handler_version = extension.value.type_handler_version
      settings             = extension.value.settings
    }
  }
}