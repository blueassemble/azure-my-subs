resource "azurerm_mariadb_server" "msp_security" {
    name                = "cyanmaria01"
    location            = azurerm_resource_group.msp_security.location
    resource_group_name = azurerm_resource_group.msp_security.name

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  sku_name   = "GP_Gen5_4"
  storage_mb = 51200
  version    = "10.2"

  auto_grow_enabled                = true
  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_mariadb_database" "msp_security" {
  name                = "cyanmaria01"
  resource_group_name = azurerm_resource_group.msp_security.name
  server_name         = azurerm_mariadb_server.msp_security.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}