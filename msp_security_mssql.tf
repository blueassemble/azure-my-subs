# resource "azurerm_mssql_server" "msp_security" {
#   count                        = 2
#   name                         = "${module.msp_security.mssql_server.name}-${count.index}"
#   resource_group_name          = azurerm_resource_group.msp_security.name
#   location                     = azurerm_resource_group.msp_security.location
#   version                      = "12.0"
#   administrator_login          = var.admin_username
#   administrator_login_password = var.admin_password
# }

# resource "azurerm_mssql_database" "msp_security" {
#   count          = 2
#   name           = "${module.msp_security.mssql_database.name}-${count.index}"
#   server_id      = azurerm_mssql_server.msp_security[count.index].id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   sku_name       = "Basic"
#   enclave_type   = "VBS"
# }

