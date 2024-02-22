module "msp_security" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["msp-security"]
}

resource "azurerm_resource_group" "msp_security" {
  name     = module.msp_security.resource_group.name
  location = var.location
}

resource "azurerm_virtual_network" "msp_security" {
  name                = module.msp_security.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.msp_security.location
  resource_group_name = azurerm_resource_group.msp_security.name
}

resource "azurerm_subnet" "msp_security" {
  name                 = module.msp_security.subnet.name
  resource_group_name  = azurerm_resource_group.msp_security.name
  virtual_network_name = azurerm_virtual_network.msp_security.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [
    azurerm_virtual_network.msp_security
  ]
}

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

