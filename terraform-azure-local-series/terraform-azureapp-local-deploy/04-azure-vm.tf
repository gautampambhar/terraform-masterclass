#Create NIC
resource "azurerm_network_interface" "tfazapp_nic" {
  name                = "tfazapppip-nic"
  location            = var.location
  resource_group_name = var.rg-name

    ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.virtual_subnet_tf.id
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfazapp_pip.id
  }
}

#Create Boot Diagnostic Account
resource "azurerm_storage_account" "boot_diagnostic_sa" {
  name                     = "tfazappbootdiagnosticsa"
  resource_group_name      = var.rg-name
  location                 = var.location
   account_tier            = "Standard"
   account_replication_type = "LRS"

   tags = var.tags
  }

#Create Virtual Machine
resource "azurerm_virtual_machine" "tfazapp_vm" {
  name                  = "robot"
  location              = var.location
  resource_group_name   = var.rg-name
  network_interface_ids = [azurerm_network_interface.tfazapp_nic.id]
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "robot"
    admin_username = "vmadmin"
    admin_password = "Password12345!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.boot_diagnostic_sa.primary_blob_endpoint
    }
}