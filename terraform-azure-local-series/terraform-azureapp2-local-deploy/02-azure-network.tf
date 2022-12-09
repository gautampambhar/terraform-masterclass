# Create virtual network
resource "azurerm_virtual_network" "tfazapp2_vnet" {
  name                = "TfAz2Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg-name

  tags = var.tags
}

# Create subnet
resource "azurerm_subnet" "tfazapp2_vsubnet1" {
  name                 = "TfAz2Subnet1"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.tfazapp2_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Deploy Public IP
# Take inbound traffic and dispach to each machine to balance the traffic load
resource "azurerm_public_ip" "tfazapp2_pip" {
  name                = "tfazapp2pubip"
  location            = var.location
  resource_group_name = var.rg-name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# create network security group and rules
# NSG rules that will allow and deny inbound network traffic to outbound traffic from several azure resources
resource "azurerm_network_security_group" "tfazapp2_nsg1" {
  name                = "tfazapp2SecurityGroup1"
  location            = var.location
  resource_group_name = var.rg-name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Create LB
resource "azurerm_lb" "tfazapp2_lb" {
  name                = "tfazapp2lb"
  location            = var.location
  resource_group_name = var.rg-name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.tfazapp2_pip.id
  }

  tags = var.tags

}

# LB backend address pool
# The backend pool defines the group of resources that will serve traffic for a given load-balancing rule.
# so this is IP pool for your VM to use
resource "azurerm_lb_backend_address_pool" "tfazapp2_bap" {
  loadbalancer_id = azurerm_lb.tfazapp2_lb.id
  name            = "BackEndAddressPool"
  #resource_group_name = var.rg-name
}

# # LB NAT Pool
# # Allows you to connect VMs in a VNet by using LB IP address and port number
# # so you can connect to specific VM from the public IP
# resource "azurerm_lb_nat_pool" "tfazapp2_lbnatpool" {
#   resource_group_name            = var.rg-name
#   loadbalancer_id                = azurerm_lb.tfazapp2_lb.id
#   name                           = "SampleApplicationPool"
#   protocol                       = "Tcp"
#   frontend_port_start            = 80
#   frontend_port_end              = 81
#   backend_port                   = 8080
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# LB Probe
# require health probe to detect the endpoint status
# This determines which backend pool instance will recieve new connection. also detects failure of application
resource "azurerm_lb_probe" "tfazapp2_lbprobe" {
  loadbalancer_id     = azurerm_lb.tfazapp2_lb.id
  #resource_group_name = var.rg-name
  name                = "ssh-running-probe"
  port                = 80
  # protocol              = "Http"
  # request_path          = "/" 
}

# LB Rule 
# Manages a Load Balancer Rule. It defines how incoming traffic distributed to all instances within backend pool
resource "azurerm_lb_rule" "tfazapp2_lbrule" {
  loadbalancer_id                = azurerm_lb.tfazapp2_lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  backend_address_pool_ids       =[azurerm_lb_backend_address_pool.tfazapp2_bap.id]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.tfazapp2_lbprobe.id
}

# # LB Outbound rule
# # configures outbound network address translation (NAT) for all VM identified by the backend pool 
# # This enables instances in backend to communicate to internet or other endpoints 
# resource "azurerm_lb_outbound_rule" "tfazapp2_lboutrule" {
#   name                    = "OutboundRule"
#   loadbalancer_id         = azurerm_lb.tfazapp2_lb.id
#   protocol                = "Tcp"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.tfazapp_bap.id

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#   }
# }

# # LB NAT rules
# # Inbound NAT rules forwards incoming traffic set to frontend IP address and port combination. The traffic is sent to specific VM in the backend pool


# resource "azurerm_lb_nat_rule" "tfazapp2_lbnatrule" {
#   resource_group_name            = var.rg-name
#   loadbalancer_id                = azurerm_lb.tfazapp2_lb.id
#   name                           = "RDPAccess"
#   protocol                       = "Tcp"
#   frontend_port                  = 3389
#   backend_port                   = 3389
#   frontend_ip_configuration_name = "PublicIPAddress"
# }
