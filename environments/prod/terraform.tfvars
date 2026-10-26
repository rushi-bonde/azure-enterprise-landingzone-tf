location           = "eastus"
tenant_id          = "00000000-0000-0000-0000-000000000000"
ssh_public_key     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExampleKeyForEnterpriseLandingZone admin@bonde"
vnet_address_space = ["10.100.0.0/16"]

subnets = {
  "app-tier" = {
    address_prefixes                          = ["10.100.1.0/24"]
    service_endpoints                         = ["Microsoft.KeyVault", "Microsoft.Storage"]
    private_endpoint_network_policies_enabled = false
  }
  "db-tier" = {
    address_prefixes                          = ["10.100.2.0/24"]
    service_endpoints                         = ["Microsoft.Sql"]
    private_endpoint_network_policies_enabled = true
    delegation = {
      name = "delegation-sql"
      service_delegation = {
        name    = "Microsoft.Sql/managedInstances"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
  "private-endpoints" = {
    address_prefixes                          = ["10.100.3.0/24"]
    private_endpoint_network_policies_enabled = true
  }
}

nsg_rules = {
  "Allow_HTTPS_Inbound" = {
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "10.100.1.0/24"
    description                = "Allow TLS ingress to application layer."
  }
  "Deny_All_Direct_SSH_Inbound" = {
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    description                = "Strict Zero Trust perimeter: block all public SSH access."
  }
}

custom_routes = {
  "Default_Via_Firewall" = {
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.100.0.4"
  }
}

scale_sets = {
  "vmss-api-prod" = {
    sku          = "Standard_D4s_v5"
    instances    = 3
    zones        = ["1", "2", "3"]
    upgrade_mode = "Automatic"
    data_disks = [
      {
        caching              = "ReadOnly"
        disk_size_gb         = 128
        lun                  = 0
        storage_account_type = "Premium_LRS"
      }
    ]
  }
}