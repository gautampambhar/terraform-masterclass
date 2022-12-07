# WHAT 
This project is created to deploy and manage Azure Infrastructure using terraform as IaC and Azure DevOps YAML pipelines. This project is a complete solution of Azure resource deployment with terraform and Azure YAML pipelines with many environments (dev, stage, prod).

This project requires the initial manual resource creation to store your terraform remote tfstate file as well as service principal and service connection to connect Azure services to Azure DevOps.

# Deploy 
To keep it simple, the project deploys blob storage with static files in it. but you could add as many azure resources as you like.

# Goal
The goal of the project is to write Azure resources in terraform and deploy them automatically via the Azure YAML pipeline with multiple environments.

# Prerequisite 
- On your Azure DevOps project, navigate to marketplace store and install Azure Pipelines Terraform Tasks

# Resource creation manually before pipeline execution 
1. run terraform/backends/setup.azcli. This will create below resources
    1. Resource group
        - Terraform backend file gets stored
        - Use this resource group if you want to store variables in an Azure key vault against Variable Groups in ADO.
    2. Storage account
        -  terraform backend file gets stored
    3. Storage container
2. Create Azure service principal manually(portal --> Azure AD --> App registrations) - manually preferred
    - create certificates & secrets, if an app is manually created
3. Navigate to Azure subscription to give access to the service principal on the azure resource
    - Azure subscription --> IAM --> Role assignement --> add --> role assignement --> select service principal
4. Create service connection manually 
    - give details including app secret 
    - Service Principal Id: Enter SP's Application Client ID
    - Service principal key: enter SP (config & secret) --> Value(no secret ID)
    - Tenant ID: enter SP Value
5. Create a key vault(optional) only if you want to store the below values in the Azure variable group and not in YAML variable templates (This project stored variables in the pipelines/vars/{env}-vars.yml)
    - add 6 varibale and it's value - environment, backendServiceArm, backendAzureRmSubscriptionId, backendAzureRmResourceGroupName, backendAzureRmStorageAccountName
    - navigate to keyvault --> access policy --> create --> add service principal Get & List secret permission
6. Create a variable group in ADO and link key vault (optional) only if you want to store the below values in the pipeline variable template
    - link it against the service principal 

# Local Deployment  
When deploying locally, use terraform partial configuration. Don't use the default configuration, i.e. never use your remote backend having your resource group, container name, and key values inside. Instead use partial configuration(mentioned in the backend.tf) and create backend config files such as sample.backend.hcl or azure.conf to store your config in this file.

**NOTE:**  PLEASE DO NOT CHECK IN sample.backend.hcl or azure.conf files in your repository. These files are just for your local deployment and consist of credentials. Always use the .gitignore file to exclude these files. 

1. init 
terraform init -backend-config=sample.backend.hcl
2. plan 
terraform plan -var-file=environments/dev/dev.tfvars -out deployment.tfplan   |   terraform plan -var-file=environments/prod/prod.tfvars -out deployment.tfplan
3. apply 
terraform apply deployment.tfplan
4. destroy 
terraform destroy -var-file=environments/dev/dev.tfvars

# YAML Pipeline Files
Find the Azure YAML pipeline file in the pipelines/ directory

## How?
- Azure YAML pipeline consists of a minimum of 2 stages, one stage for building terraform files and one for deployment to one environment(ex: dev). You can have multiple stages based on how many environments you want.
- Each environment stores its terraform state file in separate blob storage.
- Deployment used terraform CLI tasks rather than a script or terraform tasks. This saves a lot of time as Terraform CLI task gives you option directly where you want to store your tf state files. This however becomes PITA with Script and Terraform task deployment especially when you want to store terraform tfstate file in separate blob storage.

1. cd.yml file is the old way of doing YAML deployment
2. cd2.yml file is the new way of YAML deployment where you can utilize approvals on stage(add approval before the production stage execution)

