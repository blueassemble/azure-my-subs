module "naming_policy" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["policy"]
}

resource "azurerm_subscription_policy_assignment" "deploy_vm_auto_shutdown" {
  name                 = "Deploy Virtual Machine Autoshutdown Schedule"
  subscription_id          = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  policy_definition_id = azurerm_policy_definition.deploy_vm_auto_shutdown.id
  location = azurerm_user_assigned_identity.policy.location
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy.id]
  }
}

resource "azurerm_policy_set_definition" "my_initiative" {
  name         = "myInitiativeDefinition"
  policy_type  = "Custom"
  display_name = "My Initiative Definition"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deploy_vm_auto_shutdown.id
  }
}