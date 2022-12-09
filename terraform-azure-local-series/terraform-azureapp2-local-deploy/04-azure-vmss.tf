resource "azurerm_virtual_machine_scale_set" "tfazapp2_vmss" {
  name                = "mytestscaleset-1"
  location            = var.location
  resource_group_name = var.rg-name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Manual" # Rolling

  #   rolling_upgrade_policy {
  #     max_batch_instance_percent              = 20
  #     max_unhealthy_instance_percent          = 20
  #     max_unhealthy_upgraded_instance_percent = 5
  #     pause_time_between_batches              = "PT0S"
  #   }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.tfazapp2_lbprobe.id

  sku {
    name     = "Standard_DS1_V2"
    tier     = "Standard"
    capacity = 2 # start with 2 vm
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username       = "myadmin"
    admin_password       = "Empty1234"
    custom_data          = file("web.conf")
  }

  os_profile_linux_config {
    disable_password_authentication = false

    # ssh_keys {
    #   disable_password_authentication = false
    #   #   path     = "/home/myadmin/.ssh/authorized_keys"
    #   #   key_data = file("~/.ssh/demo_key.pub")
    # }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.tfazapp2_vsubnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.tfazapp2_bap.id]
      #load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]

    }
  }

  tags = var.tags
}

# SETUP AUTOSCALE RULES
resource "azurerm_monitor_autoscale_setting" "tfazapp2_autoscale" {
  name                = "myAutoscaleSetting"
  resource_group_name = var.rg-name
  location            = var.location
  target_resource_id  = azurerm_virtual_machine_scale_set.tfazapp2_vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.tfazapp2_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.tfazapp2_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  #   notification {
  #     email {
  #       send_to_subscription_administrator    = true
  #       send_to_subscription_co_administrator = true
  #       custom_emails                         = ["admin@contoso.com"]
  #     }
  #   }
}