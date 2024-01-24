resource "azurerm_resource_group" "avd" {
  name = var.avd_resource_group_name
  location = "korea central"
}