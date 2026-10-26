output "assignment_ids" {
  value = { for k, v in azurerm_subscription_policy_assignment.policy : k => v.id }
}