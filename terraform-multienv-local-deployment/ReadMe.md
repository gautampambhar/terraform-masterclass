Intent of this project is to get started with terraform local deployment with muti-environment. 

# What: 
This project will dpeloy a static website on Azure with 2 envrionments - dev and prod using terraform 

# How:
I have used terraform workspace to diffrenciate the muti-envrironment deployment. 

# Catch:
This project uses a single backend location(blob storage) to store  tfstate file for both the environment. Meaning both env's tfstate file will be store in the same blob storage/container. Earlier tfstate file will we overwritten by the environment deployment, so in the container only one file will be there. 

# Terraform Workspace 
- by default you'll work in th default terraform workspace
- for multi-stage deployment create workspace for specific envrironment and do the dpeloyment in that workspace

# Manual azure resources 
1. resource group 
2. storage account 
3. container // to store tfstate files

1. Commands 
- terraform workspace new development // to create workspace
- terraform workspace list // list of workspace
- terraform workspace select <workspace name> // checkout to desired workspace and do the deployment

# Deployment Flow 
1. perform below command in the terraform folder 
- terraform init
2. create terraform workspace (dev,prod)
3. switch ro the terraform workspace(dev, prod) and plan the deployment
- terraform plan --var-file=environments/dev/dev.tfvars
4. apply changes
- terraform apply --var-file=environments/dev/dev.tfvars
5. destroy changes
- terraform destory --var-file=environments/dev/dev.tfvars

# Deploy
This solution will deploy Azure resources such as, resource group, 


