**What**: Provisioners are Terraform resources used to execute scripts as a part of the resource creation or destruction

**When**: provisioner will only run on every first creation or on the destroy 

1. File: allows us to create file and execute script on a remote server. copy file from local machine and paste it on local machine 

## Types
**local-exec**: Invokes a script on the machine running Terraform.

**remote- exec**: Invokes a script on a remote resource after it is created.

2. external data block

**What**: Just like the local-exec provisioner, external data bock can be used to run scripts on machines running Terraform. 

**Difference**: The difference between a provisioner and the external data block is that the scripts in the external data block **can return data in JSON format**, whereas provisioners cannot return any outputs. 

**Catch**: It is important to note that external data blocks are also meant to be a last resort and should not be used if there is a better alternative.