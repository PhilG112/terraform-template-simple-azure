# Configure the Azure Provider
provider "azurerm" { }

# Create a resource group
resource "azurerm_resource_group" "azure-resource-group" {
  name = "${var.resource-group-name}"
  location = "${var.resource-group-location}"
}

# Create Azure App Service Plan
resource "azurerm_app_service_plan" "app-service-plan" {
  name = "${var.app-service-plan-name}"
  resource_group_name = "${azurerm_resource_group.azure-resource-group.name}"
  location  = "${azurerm_resource_group.azure-resource-group.location}"
  kind = "Windows"
  sku = {
      tier = "Free"
      size = "F1"
  }
}

# Create Azure CosmosDB account
resource "azurerm_cosmosdb_account" "cosmosdb-account" {
    name = "${var.cosmosdb-account-name}"
    resource_group_name = "${azurerm_resource_group.azure-resource-group.name}"
    location = "${azurerm_resource_group.azure-resource-group.location}"
    offer_type = "Standard"
    kind = "GlobalDocumentDB"
    consistency_policy {
        consistency_level = "BoundedStaleness"
        max_interval_in_seconds = 10
        max_staleness_prefix = 200
    }
    geo_location {
        location = "${azurerm_resource_group.azure-resource-group.location}"
        failover_priority = 0
    }
}

# Create Azure App Service
resource "azurerm_app_service" "app-service" {
    name = "${var.app-service-name}"
    resource_group_name = "${azurerm_resource_group.azure-resource-group.name}"
    location = "${azurerm_resource_group.azure-resource-group.location}"
    app_service_plan_id = "${azurerm_app_service_plan.app-service-plan.id}"
    connection_string {
        name = "CosmosDBPrimaryKey"
        type = "Custom"
        value = "${azurerm_cosmosdb_account.cosmosdb-account.primary_master_key}"
    }
    connection_string {
        name = "CosmosDBEndpointUrl"
        type = "Custom"
        value = "${azurerm_cosmosdb_account.cosmosdb-account.endpoint}"
    }
}