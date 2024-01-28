module "audit_ahub_definition" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_AHUB_for_eligible_vms.json"
  
  policy_name         = "Custom Name"
  display_name        = "Custom Display Name"
  policy_description  = "Custom Description"
  policy_category     = "Custom Category"
  policy_version      = "Custom Version"

  policy_rule       = (local.policy_file).properties.policyRule
  policy_parameters = (local.policy_file).properties.parameters
  policy_metadata   = (local.policy_file).properties.metadata
}

locals {
  policy_file = jsondecode(file("policy_template/audit_AHUB_for_eligible_vms.json"))
}