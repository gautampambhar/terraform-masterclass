# META Arguments 

1. depends_on
2. count: Create multiple identical resources by specifiying count
	- Usage example: work with simple list
3. for_each: same as count. create multiple resources based on key value pair: The for_each meta argument accepts a map or set of strings. Terraform will create one instance of that resource for each member of that map or set
	- Usage example: work with map(key-value pair) and list of map(use for_each with for loop)
4. provider: create resources in multiple region. create another provider section for that region and use that region against the resource you want to create 
5. lifecycle:
    - create_before_destroy = true
	- prevent_destroy       = true
	- ignore_changes        = [tags] # When you manually modify resource and don't want to track and instead you want to ignore it. ex: manually modified some of the tags. 


# Variable Type and its Usage
1. List
	- use count
2. Maps: key value pair
	- use for_each
3. List of Map: multiple element in the list where element itself a map
	- use for_each with for loop (you can't directly use for_each)

# Example
1. **List**: 
CIDR_RANGE = ["10.0.0.0/24","20.0.0.0/24"] 

2. **Map**: (key-value pair)
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

3. List of Map
### NIC List
NIC_LIST = [
    {
        nic_name = "web-srv1"
        nic_ip   = "10.0.0.21"
    }
    {
        nic_name = "web-srv2"
        nic_ip   = "10.0.0.22"
    }