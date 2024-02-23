resource "azurerm_mssql_server" "msp_security" {
  count                         = 2
  name                          = "${module.msp_security.mssql_server.name}-${count.index}"
  resource_group_name           = azurerm_resource_group.msp_security.name
  location                      = azurerm_resource_group.msp_security.location
  version                       = "12.0"
  administrator_login           = var.admin_username
  administrator_login_password  = var.admin_password
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "msp_security" {
  count        = 2
  name         = "${module.msp_security.mssql_database.name}-${count.index}"
  server_id    = azurerm_mssql_server.msp_security[count.index].id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = "Basic"
  enclave_type = "VBS"
}

resource "azurerm_subnet" "private_endpoint" {
  name                 = "${module.msp_security.subnet.name}-private-endpoint"
  resource_group_name  = azurerm_resource_group.msp_security.name
  virtual_network_name = azurerm_virtual_network.msp_security.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_endpoint" "msp_security" {
  count               = 2
  name                = "${module.msp_security.private_endpoint.name}-${count.index}"
  location            = azurerm_resource_group.msp_security.location
  resource_group_name = azurerm_resource_group.msp_security.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "mssql-private-endpoint-connection-${count.index}"
    private_connection_resource_id = azurerm_mssql_server.msp_security[count.index].id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = count.index == 0 ? true : false
    request_message = count.index == 0 ? jsonencode({
      "properties" = {
        "privateLinkServiceConnectionState" = {
          "status" = "Approved",
          "description" = "Auto-Approved"
        }
      }
    }) : null
  }

  private_dns_zone_group {
    name                 = "mssql-private-endpoint-dns-group-${count.index}"
    private_dns_zone_ids = [azurerm_private_dns_zone.msp_security.id]
  }
}


resource "azurerm_private_dns_zone" "msp_security" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.msp_security.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "msp_security" {
  name                  = "privatelink-dns-link"
  resource_group_name   = azurerm_resource_group.msp_security.name
  private_dns_zone_name = azurerm_private_dns_zone.msp_security.name
  virtual_network_id    = azurerm_virtual_network.msp_security.id
}