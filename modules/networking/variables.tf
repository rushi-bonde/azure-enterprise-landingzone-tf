variable "resource_group_name" {
  description = "Name of the target resource group."
  type        = string
}

variable "location" {
  description = "Azure region for deployment."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network in CIDR notation."
  type        = list(string)
}

variable "dns_servers" {
  description = "Optional custom DNS server IPs."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Complex map of subnets with delegations and service endpoints."
  type = map(object({
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string), [])
    private_endpoint_network_policies_enabled     = optional(bool, false)
    private_link_service_network_policies_enabled = optional(bool, true)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    }))
  }))
}

variable "nsg_rules" {
  description = "Map of dynamic security rules with port ranges, directions, and priorities."
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string)
    source_port_ranges         = optional(list(string))
    destination_port_range     = optional(string)
    destination_port_ranges    = optional(list(string))
    source_address_prefix      = optional(string)
    source_address_prefixes   = optional(list(string))
    destination_address_prefix = optional(string)
    destination_address_prefixes = optional(list(string))
    description                = optional(string)
  }))
  default = {}
}

variable "custom_routes" {
  description = "Map of routes for dynamic injection into Route Tables."
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}