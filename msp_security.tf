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

# resource "azurerm_public_ip" "msp_security" {
#   count               = 2
#   name                = "${module.msp_security.public_ip.name}-${count.index}"
#   resource_group_name = azurerm_resource_group.msp_security.name
#   location            = azurerm_resource_group.msp_security.location
#   allocation_method   = "Static"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "azurerm_network_interface" "msp_security" {
#   count               = 2
#   name                = "${module.msp_security.network_interface.name}-${count.index}"
#   location            = azurerm_resource_group.msp_security.location
#   resource_group_name = azurerm_resource_group.msp_security.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.msp_security.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.msp_security[count.index].id
#   }
# }

# resource "azurerm_network_security_group" "subnet" {
#   name                = "subnet-${module.msp_security.network_security_group.name}"
#   location            = azurerm_resource_group.msp_security.location
#   resource_group_name = azurerm_resource_group.msp_security.name

#   security_rule {
#     name                       = "AllowInbound"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "subnet" {
#   subnet_id                 = azurerm_subnet.msp_security.id
#   network_security_group_id = azurerm_network_security_group.subnet.id
# }

# resource "azurerm_network_security_group" "nic" {
#   count               = 2
#   name                = "nic-${module.msp_security.network_security_group.name}-${count.index}"
#   location            = azurerm_resource_group.msp_security.location
#   resource_group_name = azurerm_resource_group.msp_security.name

#   security_rule {
#     name                       = "AllowOutbound-${count.index}"
#     priority                   = 110
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

# }

# resource "azurerm_network_interface_security_group_association" "nic" {
#   count                     = 2
#   network_interface_id      = azurerm_network_interface.msp_security[count.index].id
#   network_security_group_id = azurerm_network_security_group.nic[count.index].id
# }

# resource "azurerm_windows_virtual_machine" "msp_security" {
#   count               = 2
#   name                = "${module.msp_security.virtual_machine.name}-${count.index}"
#   computer_name       = substr("${module.msp_security.virtual_machine.name}-${count.index}", 0, 15)
#   resource_group_name = azurerm_resource_group.msp_security.name
#   location            = azurerm_resource_group.msp_security.location
#   size                = "Standard_F2"
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   network_interface_ids = [
#     azurerm_network_interface.msp_security[count.index].id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftSQLServer"
#     offer     = "sql2019-ws2022"
#     sku       = "sqldev"
#     version   = "latest"
#   }
# }

# resource "azurerm_mssql_virtual_machine" "msp_security" {
#   count                            = 2
#   virtual_machine_id               = azurerm_windows_virtual_machine.msp_security[count.index].id
#   sql_license_type                 = "PAYG"
#   r_services_enabled               = true
#   sql_connectivity_port            = 1433
#   sql_connectivity_type            = "PUBLIC"
#   sql_connectivity_update_password = var.admin_password
#   sql_connectivity_update_username = var.admin_username

#   auto_patching {
#     day_of_week                            = "Sunday"
#     maintenance_window_duration_in_minutes = 60
#     maintenance_window_starting_hour       = 2
#   }

#   depends_on = [
#     azurerm_windows_virtual_machine.msp_security
#   ]
# }

resource "azurerm_mssql_server" "msp_security" {
  count                        = 2
  name                         = "${module.msp_security.mssql_server.name}-${count.index}"
  resource_group_name          = azurerm_resource_group.msp_security.name
  location                     = azurerm_resource_group.msp_security.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "msp_security" {
  count          = 2
  name           = "${module.msp_security.mssql_database.name}-${count.index}"
  server_id      = azurerm_mssql_server.msp_security[count.index].id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  enclave_type   = "VBS"
}