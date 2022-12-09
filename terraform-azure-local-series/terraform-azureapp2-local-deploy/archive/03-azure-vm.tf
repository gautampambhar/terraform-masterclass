# Network Interface
# use to connect to VNet
resource "azurerm_network_interface" "tfazapp2_nic" {
  name                = "tfazapp2-vm1-nic"
  location            = var.location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "tfazapp2NicConfig"
    subnet_id                     = azurerm_subnet.tfazapp2_vsubnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfazapp2_pip.id
  }
}

# network interface security group association
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.tfazapp2_nic.id
  network_security_group_id = azurerm_network_security_group.tfazapp2_nsg1.id
}


# Create Boot Diagnostic Account
resource "azurerm_storage_account" "boot_diagnostic_sa" {
  name                     = "tfazappbootdiagnosticsa"
  resource_group_name      = var.rg-name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Create SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Create Virtual Machine
resource "azurerm_linux_virtual_machine" "tfazapp2_vm" {
  name                  = "tfazapp2vm"
  location              = var.location
  resource_group_name   = var.rg-name
  network_interface_ids = [azurerm_network_interface.tfazapp2_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.boot_diagnostic_sa.primary_blob_endpoint
  }
}
