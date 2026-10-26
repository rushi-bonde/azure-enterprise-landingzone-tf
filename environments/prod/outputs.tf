output "vnet_id" { value = module.networking.vnet_id }
output "key_vault_uri" { value = module.key_vault.key_vault_uri }
output "scale_set_ids" { value = module.compute_cluster.scale_set_ids }