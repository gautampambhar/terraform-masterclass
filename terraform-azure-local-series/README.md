# What
This projects are intended to create Azure resources with terraform. Resources such as, Compute, storage, database and container resources will be created here to understand the best terraform practices on how and whys. 

# Azure authentication 

Auth to Azure can possible only via Azure CLI
    - install Azure CLI

2 ways of authenticating Terraform with Azure via Azure CLI

1. login to Azure via `az login`
2. Auth via service principal 
    `az ad sp create-for-rbac --name tfauthtoazure --role Contributor`
    - add the service principal to terraform provider 
    ```
    terraform {
        required_providers {
            azurerm = {
            source  = "hashicorp/azurerm"
            version = "=3.0.0"
            }
        }
        }

        # Configure the Microsoft Azure Provider
        provider "azurerm" {
        features {}

        subscription_id = "00000000-0000-0000-0000-000000000000"
        client_id       = "00000000-0000-0000-0000-000000000000"
        client_secret   = var.client_secret
        tenant_id       = "00000000-0000-0000-0000-000000000000"
        }

    ```


# Deploy Best practices
1. Create Network infra before creating VMs
    - Vnet and subnet 
    - NIC (network interface card) --> associate with Network infra --> assign it to VM
2. Create VM
    - assign NIC to VM
    - Create azure storage for boot diagnostic