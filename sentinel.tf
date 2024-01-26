module "naming_sentinel" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["sentinel"]
}

resource "azurerm_resource_group" "sentinel" {
  name     = module.naming_sentinel.resource_group.name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = module.naming_sentinel.log_analytics_workspace.name
  location            = azurerm_resource_group.sentinel.location
  resource_group_name = azurerm_resource_group.sentinel.name
  sku                 = "PerGB2018"
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  # resource_group_name          = azurerm_resource_group.sentinel.name
  # workspace_name               = azurerm_log_analytics_workspace.sentinel.name
  workspace_id = azurerm_log_analytics_workspace.sentinel.id
  customer_managed_key_enabled = false
}

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  name                       = "activity-log-sentinel"
  target_resource_id         = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id

  enabled_log {
    category = "Administrative"
  }
  enabled_log {
    category = "Security"
  }
  enabled_log {
    category = "ServiceHealth"
  }
  enabled_log {
    category = "Alert"
  }
  enabled_log {
    category = "Recommendation"
  }
  enabled_log {
    category = "Policy"
  }
  enabled_log {
    category = "Autoscale"
  }
  enabled_log {
    category = "ResourceHealth"
  }
}
