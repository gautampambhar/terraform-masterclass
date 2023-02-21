CIDR_RANGE = ["10.0.0.0/24","20.0.0.0/24"] 

### Map of locations 
LOCATION = {
    apac = "eastasia"
    emea = "northeurope"
    amer = "eastus"
}

### Subnet Map 
SUBNET_MAP = {
    web_sub  = "10.0.0.0/28"
    app_sub  = "10.0.0.16/28"
    data_sub = "10.0.0.32/28"
}

### NIC List
NIC_LIST = [
    {
        nic_name = "web-srv1"
        nic_ip   = "10.0.0.21"
    },
    {
        nic_name = "web-srv2"
        nic_ip   = "10.0.0.22"
    }
]