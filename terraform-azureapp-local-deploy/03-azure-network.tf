# Create virtual network
resource "azurerm_virtual_network" "virtual_net_tf" {
    name                = "TfAzVnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = var.rg-name

    tags = var.tags
}

# Create subnet
resource "azurerm_subnet" "virtual_subnet_tf" {
    name                 = "TfAzSubnet"
    resource_group_name = var.rg-name
    virtual_network_name = azurerm_virtual_network.virtual_net_tf.name
    address_prefixes       = ["10.0.1.0/24"]
}

#Deploy Public IP
resource "azurerm_public_ip" "tfazapp_pip" {
  name                = "tfazapppubip"
  location            = var.location
  resource_group_name = var.rg-name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}