module "naming_policy" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["policy"]
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

resource "azurerm_subscription_policy_assignment" "deploy_vm_auto_shutdown" {
  name                 = "deploy-vm-autoshutdown-assignment"
  subscription_id          = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  policy_definition_id = azurerm_policy_definition.deploy_vm_auto_shutdown.id
  location = azurerm_user_assigned_identity.policy.location
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy.id]
  }
}