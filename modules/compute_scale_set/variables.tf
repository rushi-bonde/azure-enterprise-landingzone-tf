variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_username" { type = string; default = "azureadmin" }
variable "ssh_public_key" { type = string }
variable "subnet_id" { type = string }
variable "scale_sets" {
  description = "Complex map of VM Scale Sets with dynamic data disks and extensions."
  type = map(object({
    sku                 = string
    instances           = number
    zones               = optional(list(string), ["1", "2", "3"])
    upgrade_mode        = optional(string, "Automatic")
    data_disks = optional(list(object({
      caching              = string
      disk_size_gb         = number
      lun                  = number
      storage_account_type = string
    })), [])
    extensions = optional(map(object({
      publisher            = string
      type                 = string
      type_handler_version = string
      settings             = optional(string)
    })), {})
  }))
}
variable "tags" { type = map(string); default = {} }