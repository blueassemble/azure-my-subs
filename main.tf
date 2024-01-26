# resource "azurerm_resource_group" "avd" {
#   name = var.avd_resource_group_name
#   location = "korea central"
# }

data azurerm_client_config "current" {
}


resource "azurerm_resource_group" "policy" {
    name = module.naming_policy.resource_group.name
    location = var.location
}

resource "azurerm_user_assigned_identity" "policy" {
  location            = azurerm_resource_group.policy.location
  name                = "identity-policy"
  resource_group_name = azurerm_resource_group.policy.name
}
resource "azurerm_role_assignment" "policy" {
  scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id = azurerm_user_assigned_identity.policy.principal_id
}