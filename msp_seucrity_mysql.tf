resource "azurerm_mysql_server" "msp_security" {
  name                = "cyanmysql01"
  location            = azurerm_resource_group.msp_security.location
  resource_group_name = azurerm_resource_group.msp_security.name
  sku_name            = "B_Gen5_2"

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  version = "8.0"

  ssl_enforcement_enabled = true
}

resource "azurerm_mysql_database" "example" {
  name                = "cyanmysql01"
  resource_group_name = azurerm_resource_group.msp_security.name
  server_name         = azurerm_mysql_server.msp_security.name
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  charset             = "utf8"
}