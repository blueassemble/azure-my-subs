module "audit_ahub_definition" {
  source              = "gettek/policy-as-code/azurerm//modules/definition"
  file_path           = "../policy_template/audit_AHUB_for_eligible_vms.json"
}