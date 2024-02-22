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
  address_prefixes     = ["10.0.0.0/24"]

  depends_on = [
    azurerm_virtual_network.msp_security
  ]
}