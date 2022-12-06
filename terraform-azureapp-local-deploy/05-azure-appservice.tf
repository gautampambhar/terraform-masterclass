# APP service plan
resource "azurerm_app_service_plan" "svcplan" {
  name                = "tfazapp-appserviceplan"
  location            = var.location
  resource_group_name = var.rg-name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# service plan
resource "azurerm_app_service" "appsvc" {
  name                = "tfazapp-webapp-dev"
  location            = var.location
  resource_group_name = var.rg-name
  app_service_plan_id = azurerm_app_service_plan.svcplan.id


  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}