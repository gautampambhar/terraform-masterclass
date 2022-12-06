# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = "=3.0.0"
    features {} 
    skip_provider_registration = true
}