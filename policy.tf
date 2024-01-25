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

resource "azurerm_resource_policy_assignment" "deploy_vm_auto_shutdown" {
  name                 = "deploy-vm-autoshutdown-assignment"
  resource_id          = data.azurerm_client_config.current.subscription_id
  policy_definition_id = azurerm_policy_definition.deploy_vm_auto_shutdown.id
}