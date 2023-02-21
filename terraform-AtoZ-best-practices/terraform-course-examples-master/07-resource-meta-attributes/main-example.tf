# Create a virtual network within the resource group

################# Count #################
# Basic Looping
# Todo: Want to create 2 vnet with count and 2 subnets with for_each

CIDR_RANGE = ["10.0.0.0/24","20.0.0.0/24"] 

resource "azurerm_virtual_network" "vnet" {
	count = length(var.CIDR_RANGE) # Number of vnet to be created
	name  = format ("%s%s", "vnet-", (count.index+1)) # Name should be unique
	resource_group_name = azurerm_resource_group.rg.name
	location = azurerm_resource_group.rg.location
	address_space = [var.CIDR_RANGE[ count.index]]
}

################# For Each #################
## Looping thorugh MAP type variable
SUBNET_MAP = {
    web_sub  = "10.0.0.0/28"
    app_sub  = "10.0.0.16/28"
    data_sub = "10.0.0.32/28"
}

resource "azurerm_subnet" "subnet" {
	for_each 				= var.SUBNET_MAP
	name 	 				= each.key
	resource_group_name 	= azurerm_resource_group.rg.name
	virtual_network_name	= azurerm_virtual_network.vnet[0].name
	address_prefixes 		= [each.value]	
}

################# For Each - For Loop #################
NIC_LIST = [
    { # This is one map
        nic_name = "web-srv1"
        nic_ip   = "10.0.0.21"
    },
    { # This is second map
        nic_name = "web-srv2"
        nic_ip   = "10.0.0.22"
    }
]

resource "azurerm network_ interface" "nics" {
	# take every/single(one map) item in the list and create a map with the key as the nic_name and the value as the entire map/object
	for_each = {for nic in var.NIC_LIST: nic.nic_name => nic} 
	name	 = each.value.nic_name # access nic_name from the nic map(value)
	location = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	
	ip_configuration {
		name 							= "internal"
		subnet_id						= azurerm_subnet.subnet["app_sub"].id # store subnet id in the "app_sub" key
		private_ip_address_allocation	= "Static"
		private_ip_address				= each.value.private_ip
	}
}


################# If else condition #################

resource "azurerm _storage_account" "stg_acc" {
	count 	= var.strage_check == "create" ? 1 : 0
	name	=	"mylearning"
	resource_group_name = azurerm_resource_group.rg.name
	location 	= lookup(var.location,"amer")
	account_tier = "Standard"
	account_replication_type = "LRS"
}