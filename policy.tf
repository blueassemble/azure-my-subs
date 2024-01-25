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