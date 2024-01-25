module "sentinel" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["sentinel"]
}

resource "azurerm_resource_group" "sentinel" {
  name     = module.sentinel.resource_group.name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = module.sentinel.log_analytics_workspace.name
  location            = azurerm_resource_group.sentinel.location
  resource_group_name = azurerm_resource_group.sentinel.name
  sku                 = "PerGB2018"
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  resource_group_name          = azurerm_resource_group.sentinel.name
  workspace_name               = azurerm_log_analytics_workspace.sentinel.name
  customer_managed_key_enabled = false
}

resource "azurerm_sentinel_data_connector_azure_active_directory" "sentinel" {
  name                       = "sentinel-entra-connect"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel.workspace_id
}