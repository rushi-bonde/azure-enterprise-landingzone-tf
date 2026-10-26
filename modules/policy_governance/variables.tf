variable "scope" { type = string }
variable "policy_assignments" {
  description = "Map of policy assignments with dynamic non-compliance messages."
  type = map(object({
    policy_definition_id = string
    display_name         = string
    description          = string
    enforce              = optional(bool, true)
    non_compliance_messages = optional(list(object({
      content                        = string
      policy_definition_reference_id = optional(string)
    })), [])
  }))
}