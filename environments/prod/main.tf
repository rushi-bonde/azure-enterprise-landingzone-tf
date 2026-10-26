locals {
  environment = "prod"
  workload    = "enterprise-platform"
  common_tags = {
    Environment = local.environment
    Workload    = local.workload
    ManagedBy   = "Terraform"
    Compliance  = "CIS-Azure-Level-2"
    CostCenter  = "FinOps-Platform-901"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.workload}-${local.environment}"
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "vnet-${local.workload}-${local.environment}"
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  nsg_rules           = var.nsg_rules
  custom_routes       = var.custom_routes
  tags                = local.common_tags
}

module "key_vault" {
  source = "../../modules/key_vault"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_name      = "kv-${local.workload}-${local.environment}"
  tenant_id           = var.tenant_id
  access_policies     = var.kv_access_policies
  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = var.allowed_office_ips
    virtual_network_subnet_ids = [module.networking.subnet_ids["app-tier"]]
  }
  tags = local.common_tags
}

module "compute_cluster" {
  source = "../../modules/compute_scale_set"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.networking.subnet_ids["app-tier"]
  ssh_public_key      = var.ssh_public_key
  scale_sets          = var.scale_sets
  tags                = local.common_tags
}