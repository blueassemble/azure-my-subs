# resource "azurerm_resource_group" "avd" {
#   name = var.avd_resource_group_name
#   location = "korea central"
# }

resource "azurerm_resource_group" "sentinel" {
    name = module.naming.resource_group.name
    location = var.location
}