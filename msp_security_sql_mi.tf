# resource "random_string" "sql_mi" {
#     length  = 4
#     special = false
# }

# resource "azurerm_network_security_group" "sql_mi" {
#   name                = "mi-security-group"
#   location            = azurerm_resource_group.msp_security.location
#   resource_group_name = azurerm_resource_group.msp_security.name
# }


# resource "azurerm_network_security_rule" "allow_management_inbound" {
#   name                        = "allow_management_inbound"
#   priority                    = 106
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
#   name                        = "allow_misubnet_inbound"
#   priority                    = 200
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "10.0.0.0/24"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
#   name                        = "allow_health_probe_inbound"
#   priority                    = 300
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "AzureLoadBalancer"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "allow_tds_inbound" {
#   name                        = "allow_tds_inbound"
#   priority                    = 1000
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "1433"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "deny_all_inbound" {
#   name                        = "deny_all_inbound"
#   priority                    = 4096
#   direction                   = "Inbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "allow_management_outbound" {
#   name                        = "allow_management_outbound"
#   priority                    = 106
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_ranges     = ["80", "443", "12000"]
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
#   name                        = "allow_misubnet_outbound"
#   priority                    = 200
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "10.0.0.0/24"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_network_security_rule" "deny_all_outbound" {
#   name                        = "deny_all_outbound"
#   priority                    = 4096
#   direction                   = "Outbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.msp_security.name
#   network_security_group_name = azurerm_network_security_group.sql_mi.name
# }

# resource "azurerm_subnet" "sql_mi" {
#   name                 = "subnet-mi"
#   resource_group_name  = azurerm_resource_group.msp_security.name
#   virtual_network_name = azurerm_virtual_network.msp_security.name
#   address_prefixes     = ["10.0.3.0/24"]

#   delegation {
#     name = "managedinstancedelegation"

#     service_delegation {
#       name    = "Microsoft.Sql/managedInstances"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
#     }
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "sql_mi" {
#   subnet_id                 = azurerm_subnet.sql_mi.id
#   network_security_group_id = azurerm_network_security_group.sql_mi.id
# }

# resource "azurerm_route_table" "sql_mi" {
#   name                          = "routetable-mi"
#   location                      = azurerm_resource_group.msp_security.location
#   resource_group_name           = azurerm_resource_group.msp_security.name
#   disable_bgp_route_propagation = false
#   depends_on = [
#     azurerm_subnet.sql_mi,
#   ]
# }

# resource "azurerm_subnet_route_table_association" "sql_mi" {
#   subnet_id      = azurerm_subnet.sql_mi.id
#   route_table_id = azurerm_route_table.sql_mi.id
# }

# resource "azurerm_mssql_managed_instance" "sql_mi" {
#   name                = "${module.msp_security.mssql_managed_instance.name}-${random_string.sql_mi.result}"
#   resource_group_name = azurerm_resource_group.msp_security.name
#   location            = azurerm_resource_group.msp_security.location

#   license_type       = "BasePrice"
#   sku_name           = "GP_Gen5"
#   storage_size_in_gb = 32
#   subnet_id          = azurerm_subnet.sql_mi.id
#   vcores             = 4

#   administrator_login          = var.admin_username
#   administrator_login_password = var.admin_password

#   depends_on = [
#     azurerm_subnet_network_security_group_association.sql_mi,
#     azurerm_subnet_route_table_association.sql_mi,
#   ]
# }