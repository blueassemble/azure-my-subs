resource "azurerm_postgresql_server" "msp_security" {
    name                = module.msp_security.postgresql_server_name
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    sku_name = "B_Gen5_2"

    storage_mb = 5120
    backup_retention_days = 7

    administrator_login          = var.admin_username
    administrator_login_password = var.admin_password

    version = "9.5"

    ssl_enforcement_enabled = true
}