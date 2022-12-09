output "public_ip" {
  value = azurerm_public_ip.tfazapp2_pip.ip_address
}

# output "tls_private_key" {
#   value     = tls_private_key.ssh.private_key_pem
#   sensitive = true
# }

output "vm0_private_ip" {
  value = azurerm_network_interface.tfazapp2_nic.0.private_ip_address
}

output "vm1_private_ip" {
  value = azurerm_network_interface.tfazapp2_nic.1.private_ip_address
}
