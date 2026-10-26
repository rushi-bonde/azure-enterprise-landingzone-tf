variable "location" { type = string; default = "eastus" }
variable "tenant_id" { type = string }
variable "ssh_public_key" { type = string }
variable "vnet_address_space" { type = list(string) }
variable "subnets" { type = any }
variable "nsg_rules" { type = any }
variable "custom_routes" { type = any; default = {} }
variable "allowed_office_ips" { type = list(string); default = [] }
variable "kv_access_policies" { type = any; default = {} }
variable "scale_sets" { type = any }