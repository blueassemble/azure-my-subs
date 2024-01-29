module "naming_shi" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["shi"]
}

resource "azurerm_resource_group" "shi" {
  name     = module.naming_shi.resource_group
  location = var.location
}

resource "azurerm_data_factory" "shi" {
  name                = module.naming_shi.azure_data_factory
  location            = azurerm_resource_group.shi.location
  resource_group_name = azurerm_resource_group.shi.name
}