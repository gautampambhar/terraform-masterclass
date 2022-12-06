terraform {
  backend "azurerm" {
    resource_group_name   = "tfcicd-prod-rg"
    storage_account_name  = "tfcicdprodtfbackendsa"
    container_name        = "terraform-backend-files"
    key                   = "terraform.tfstate"
  }
}