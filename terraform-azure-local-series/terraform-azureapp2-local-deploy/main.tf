terraform {
  # 1. Required Version Terraform
  required_version = ">= 1.2"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.27"
    }
  }
}


resource "azurerm_resource_group" "resource_group" {
  name     = "tf-azapp2-rg"
  location = "eastus"
}