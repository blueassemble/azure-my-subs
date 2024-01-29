module "audit_ahub_definition" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_AHUB_for_eligible_vms.json"
  
  policy_name         = (local.policy_file).properties.displayName
  display_name        = (local.policy_file).properties.displayName
  policy_description  = (local.policy_file).properties.description
  policy_category     = (local.policy_file).properties.metadata.category
  policy_version      = (local.policy_file).properties.metadata.version

  policy_rule       = (local.policy_file).properties.policyRule
  policy_parameters = (local.policy_file).properties.parameters
  policy_metadata   = (local.policy_file).properties.metadata
}

locals {
  policy_file = jsondecode(file("policy_template/audit_AHUB_for_eligible_vms.json"))
}