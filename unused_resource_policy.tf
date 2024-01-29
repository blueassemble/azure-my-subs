module "audit_ahub_definition" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_cost_optimization/audit_AHUB_for_eligible_vms.json"
  
  policy_name         = (local.audit_ahub).properties.displayName
  display_name        = (local.audit_ahub).properties.displayName
  policy_description  = (local.audit_ahub).properties.description
  policy_category     = (local.audit_ahub).properties.metadata.category
  policy_version      = (local.audit_ahub).properties.metadata.version

  policy_rule       = (local.audit_ahub).properties.policyRule
  policy_parameters = (local.audit_ahub).properties.parameters
  policy_metadata   = (local.audit_ahub).properties.metadata
}

locals {
  audit_ahub = jsondecode(file("policy_template/audit_AHUB_for_eligible_vms.json"))
}

module "audit_unused_serverfarms" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_cost_optimization/audit_AHUB_for_eligible_vms.json"
  
  policy_name         = (local.audit_unused_serverfarms).properties.displayName
  display_name        = (local.audit_unused_serverfarms).properties.displayName
  policy_description  = (local.audit_unused_serverfarms).properties.description
  policy_category     = (local.audit_unused_serverfarms).properties.metadata.category
  policy_version      = (local.audit_unused_serverfarms).properties.metadata.version

  policy_rule       = (local.audit_unused_serverfarms).properties.policyRule
  policy_parameters = (local.audit_unused_serverfarms).properties.parameters
  policy_metadata   = (local.audit_unused_serverfarms).properties.metadata
}

locals {
  audit_unused_serverfarms = jsondecode(file("policy_template/audit_unused_serverfarms.json"))
}

module "audit_unused_disks" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_cost_optimization/audit_unused_disks.json"
  
  policy_name         = (local.audit_unused_disks).properties.displayName
  display_name        = (local.audit_unused_disks).properties.displayName
  policy_description  = (local.audit_unused_disks).properties.description
  policy_category     = (local.audit_unused_disks).properties.metadata.category
  policy_version      = (local.audit_unused_disks).properties.metadata.version

  policy_rule       = (local.audit_unused_disks).properties.policyRule
  policy_parameters = (local.audit_unused_disks).properties.parameters
  policy_metadata   = (local.audit_unused_disks).properties.metadata
}

locals {
  audit_unused_disks = jsondecode(file("policy_template/audit_unused_disks.json"))
}

module "audit_unused_publicips" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_cost_optimization/audit_unused_publicips.json"
  
  policy_name         = (local.audit_unused_publicips).properties.displayName
  display_name        = (local.audit_unused_publicips).properties.displayName
  policy_description  = (local.audit_unused_publicips).properties.description
  policy_category     = (local.audit_unused_publicips).properties.metadata.category
  policy_version      = (local.audit_unused_publicips).properties.metadata.version

  policy_rule       = (local.audit_unused_publicips).properties.policyRule
  policy_parameters = (local.audit_unused_publicips).properties.parameters
  policy_metadata   = (local.audit_unused_publicips).properties.metadata
}

locals {
  audit_unused_publicips = jsondecode(file("policy_template/audit_unused_publicips.json"))
}