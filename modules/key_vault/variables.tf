variable "resource_group_name" {
  type        = string
  description = "Target Resource Group name."
}

variable "location" {
  type        = string
  description = "Target region."
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault."
}

variable "sku_name" {
  type        = string
  default     = "premium"
  description = "SKU for Key Vault (standard or premium for HSM backed keys)."
}

variable "tenant_id" {
  type        = string
  description = "Microsoft Entra Tenant ID."
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Enforce purge protection to prevent catastrophic secret loss."
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 90
  description = "Retention days for soft-deleted secrets."
}

variable "access_policies" {
  description = "Map of dynamic access policies for applications, managed identities, and admins."
  type = map(object({
    object_id               = string
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}

variable "network_acls" {
  description = "Dynamic network ACL rules for Zero Trust Key Vault access."
  type = object({
    default_action             = string
    bypass                     = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}