# resource "azurerm_cosmosdb_account" "msp_security" {
#   count               = 2
#   name                = "${module.msp_security.cosmosdb_account.name}-${count.index}"
#   location            = azurerm_resource_group.msp_security.location
#   resource_group_name = azurerm_resource_group.msp_security.name
#   offer_type          = "Standard"
#   kind                = "GlobalDocumentDB"

#   consistency_policy {
#     consistency_level       = "Session"
#     max_interval_in_seconds = 5
#     max_staleness_prefix    = 100
#   }

#   geo_location {
#     location          = azurerm_resource_group.msp_security.location
#     failover_priority = 0
#   }
# }