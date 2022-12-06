# Create storage account
resource "azurerm_storage_account" "storage_account1" {
  name                     = var.storage-account-name
  resource_group_name      = var.rg-name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Create storage container
resource "azurerm_storage_container" "storage_container1" {
  name                  = "blobcontainer"
  storage_account_name  = azurerm_storage_account.storage_account1.name
  container_access_type = "private"
}

# Create storage blob
resource "azurerm_storage_blob" "storage_blob1" {
  name                   = "TerraformBlob"
  storage_account_name   = azurerm_storage_account.storage_account1.name
  storage_container_name = azurerm_storage_container.storage_container1.name
  type                   = "Block"
}

# Create storage file share
resource "azurerm_storage_share" "storage_share1" {
  name                 = "terraformshare"  
  storage_account_name = azurerm_storage_account.storage_account1.name
  quota                = 50
}