resource "random_string" "synapse_workspace" {
  length  = 4
  special = false
  upper = false
}

resource "azurerm_virtual_network" "synapse_workspace" {
  name                = "vnet-${random_string.synapse_workspace.result}"
  resource_group_name = azurerm_resource_group.msp_security.name
  location            = azurerm_resource_group.msp_security.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_storage_account" "msp_security" {
  name                     = "strg${random_string.synapse_workspace.result}"
  resource_group_name      = azurerm_resource_group.msp_security.name
  location                 = azurerm_resource_group.msp_security.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "msp_security" {
  name               = "${module.msp_security.storage_data_lake_gen2_filesystem.name}${random_string.synapse_workspace.result}"
  storage_account_id = azurerm_storage_account.msp_security.id
}

resource "azurerm_synapse_workspace" "msp_security" {
  count                                = 2
  name                                 = "synapse-${random_string.synapse_workspace.result}-${count.index}"
  resource_group_name                  = azurerm_resource_group.msp_security.name
  location                             = azurerm_resource_group.msp_security.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.msp_security.id
  sql_administrator_login              = var.admin_username
  sql_administrator_login_password     = var.admin_password
  public_network_access_enabled = count.index==0 ? true : false
  managed_virtual_network_enabled = true
}
