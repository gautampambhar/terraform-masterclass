# CIDR List for VNET
variable "cidr_range" {
    type = list
}

#Subnet Map
variable "subnet_map" {
    type = map
}

#NIC IP list
variable "nic_list" {
    type = list (map(string))
}

#Storage check
variable "strage_check" {
    type = string
}