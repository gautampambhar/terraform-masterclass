terraform {
  backend "azurerm" {
    resource_group_name  = "rg"
    storage_account_name = ""
    container_name       = ""
    key                  = ""
  }
}