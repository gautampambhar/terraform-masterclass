# META Arguments 

1. depends_on
2. count: Create nultiple identical resources by specifiying count
3. for_each: same as count. create multiple resources based on key value pair: The for_each meta argument accepts a map or set of strings. Terraform will create one instance of that resource for each member of that map or set
4. provider: create resources in multiple region. create another provider section for that region and use that region against the resource you want to create 
5. lifecycle:
    - create_before_destroy = true
	- prevent_destroy       = true
	- ignore_changes        = [tags] # When you manually modify resource and don;t want to track and instead you want to ignore it. ex: manually modified some of the tags. 