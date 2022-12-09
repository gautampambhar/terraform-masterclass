# Resource Group
# --------------
# Create a dedicated resource group
# Configurable: name, location
AZ_RG_NAME=tfstate-dev-acgazapp2-rg
AZ_STORAGEACCT_NAME=tfstatedevacgazapp2sa  # must be globally unique
AZ_LOCATION=eastus

az group create \
	--name $AZ_RG_NAME \
	--location $AZ_LOCATION


# Storage Account
# ---------------
# This holds your actual Terraform state file
# Note: we explicitly disable public access.

az storage account create \
	--name $AZ_STORAGEACCT_NAME \
	--resource-group $AZ_RG_NAME \
	--kind StorageV2 \
	--sku Standard_LRS \
	--https-only true \
	--allow-blob-public-access false \
	--tags "demo=tf"

# Blobs always need a parent container, so we'll create one
az storage container create \
	--name terraform \
	--account-name $AZ_STORAGEACCT_NAME \
	--public-acces off \
	--auth-mode login
