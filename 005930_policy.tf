# resource "azurerm_policy_set_definition" "wjswk" {
#   name         = "005930"
#   policy_type  = "Custom"
#   display_name = "005930"

#   policy_definition_reference {
#     policy_definition_id = azurerm_policy_definition.deploy_vm_auto_shutdown.id
#   }
# }

# resource "azurerm_subscription_policy_assignment" "wjswk" {
#   name                 = "005930"
#   subscription_id      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
#   policy_definition_id = azurerm_policy_set_definition.wjswk.id
#   location             = azurerm_user_assigned_identity.policy.location
#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.policy.id]
#   }
# }

module "wjswk" {
  source = "gettek/policy-as-code/azurerm//modules/definition"
  for_each = {
    for p in fileset(path.module, "./policy_template/005930/*.json") :
    trimsuffix(basename(p), ".json") => pathexpand(p)
  }
  file_path   = each.value
  policy_name = trimsuffix(split("/", each.value)[2], ".json")
}

module "wjswk_initiative" {
  source                  = "gettek/policy-as-code/azurerm//modules/initiative"
  initiative_name         = "005930 Initiative"
  initiative_display_name = "005930 Initiative"
  initiative_description  = "005930 Initiative"
  initiative_category     = "General"

  member_definitions = [for p in module.wjswk : p.definition]
}

module "wjswk_assignment" {
  source           = "gettek/policy-as-code/azurerm//modules/set_assignment"
  initiative       = module.wjswk_initiative.initiative
  assignment_scope = azurerm_resource_group.msp_security.id

}

output "policy_names" {
  value = [for p in module.wjswk : p.definition.name]
}
