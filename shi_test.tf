module "naming_shi" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["shi"]
}

resource "azurerm_resource_group" "shi" {
  name     = module.naming_shi.resource_group.name
  location = var.location
}

resource "azurerm_data_factory" "shi" {
  name                = module.naming_shi.data_factory.name
  location            = azurerm_resource_group.shi.location
  resource_group_name = azurerm_resource_group.shi.name
}

resource "azurerm_virtual_network" "shi" {
  name                = module.naming_shi.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.shi.location
  resource_group_name = azurerm_resource_group.shi.name
}

resource "azurerm_subnet" "shi" {
  name                 = module.naming_shi.subnet.name
  resource_group_name  = azurerm_resource_group.shi.name
  virtual_network_name = azurerm_resource_group.shi.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [
    azurerm_virtual_network.shi
  ]
}

resource "azurerm_public_ip" "shi" {
  name                = module.naming_shi.public_ip.name
  resource_group_name = azurerm_resource_group.shi.name
  location            = azurerm_resource_group.shi.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "shi" {
  name                = module.naming_shi.network_interface.name
  location            = azurerm_resource_group.shi.location
  resource_group_name = azurerm_resource_group.shi.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.shi.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "shi" {
  name                = module.naming_shi.virtual_machine.name
  resource_group_name = azurerm_resource_group.shi.name
  location            = azurerm_resource_group.shi.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.shi.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_mssql_virtual_machine" "shi" {
  virtual_machine_id               = azurerm_windows_virtual_machine.shi.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = true
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PUBLIC"
  sql_connectivity_update_password = var.admin_password
  sql_connectivity_update_username = var.admin_username

  auto_patching {
    day_of_week                            = "Sunday"
    maintenance_window_duration_in_minutes = 60
    maintenance_window_starting_hour       = 2
  }
}
