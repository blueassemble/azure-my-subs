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
  file_path           = each.value
  policy_name = trimsuffix(split("/",each.value)[2],".json")
}