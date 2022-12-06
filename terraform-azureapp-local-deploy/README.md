# Goals
This project is created to create Azure resources listed below via Terraform locally. 
- Azure blob storage account with container, file share and blob
- Azure VNet with Subnet
- Azure VM with Boot Diagnostic Account and  NIC 
- Azure App Service
- Azure MySql Server with Database

## Create Manual Resources to store terarform state file
1. execute `script/setup.sh` to create manual resources

## Terraform config
1. Set tarraform backend in the `backend.tf`
2. Execute below commands in root directory
    - terraform init
    - terraform validate
    - terraform plan --var-file=environments/dev/dev.tfvars
    - terraform apply --var-file=environments/dev/dev.tfvars
    - terraform destroy --var-file=environments/dev/dev.tfvars