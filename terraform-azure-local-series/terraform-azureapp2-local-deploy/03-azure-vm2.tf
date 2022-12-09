# Network Interface
# use to connect to VNet
resource "azurerm_network_interface" "tfazapp2_nic" {
  count               = 2
  name                = "tfazapp2-vm1-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "tfazapp2NicConfig"
    subnet_id                     = azurerm_subnet.tfazapp2_vsubnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfazapp2_pip.id
  }
}

# Azure disk
resource "azurerm_managed_disk" "tfazapp2_disk" {
  count                = 2
  name                 = "tfazapp2_disk_${count.index}"
  location             = var.location
  resource_group_name  = var.rg-name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = var.tags
}

# Azure Avilability Set
resource "azurerm_availability_set" "tfazapp2_aset" {
  name                         = "tfazapp2-aset"
  location                     = var.location
  resource_group_name          = var.rg-name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true # azure manage Avilability group
  tags                         = var.tags
}

# Azure VM

resource "azurerm_virtual_machine" "tfazapp2_vm" {
  name                             = "tfazapp2-vm-${count.index}"
  count                            = 2
  location                         = var.location
  resource_group_name              = var.rg-name
  availability_set_id              = azurerm_availability_set.tfazapp2_aset.id
  network_interface_ids            = [element(azurerm_network_interface.tfazapp2_nic.*.id, count.index)]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_data_disk {
    name            = element(azurerm_managed_disk.tfazapp2_disk.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.tfazapp2_disk.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.tfazapp2_disk.*.disk_size_gb, count.index)
    caching         = "ReadWrite"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.tags
}

# # network interface security group association
# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.tfazapp2_nic.id
#   network_security_group_id = azurerm_network_security_group.tfazapp2_nsg1.id
# }


# # Create Boot Diagnostic Account
# resource "azurerm_storage_account" "boot_diagnostic_sa" {
#   name                     = "tfazappbootdiagnosticsa"
#   resource_group_name      = var.rg-name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = var.tags
# }

# # Create SSH key
# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# #Create Virtual Machine
# resource "azurerm_linux_virtual_machine" "tfazapp2_vm" {
#   name                  = "tfazapp2vm"
#   location              = var.location
#   resource_group_name   = var.rg-name
#   network_interface_ids = [azurerm_network_interface.tfazapp2_nic.id]
#   size                  = "Standard_DS1_v2"

#   os_disk {
#     name                 = "OsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   computer_name                   = "myvm"
#   admin_username                  = "azureuser"
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.ssh.public_key_openssh
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.boot_diagnostic_sa.primary_blob_endpoint
#   }
# }
