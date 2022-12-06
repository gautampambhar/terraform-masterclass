# SQL Server
resource "azurerm_mysql_server" "tfazapp_mysql_server" {
  name                = "tfazapp-mysql-server-dev-1221"
  location            = var.location
  resource_group_name = var.rg-name

  sku_name = "B_Gen5_2"
  # capacity = "2"
  # tier = "Basic"
  # family = "Gen4"
        
  storage_mb = "5120"
  version = "8.0"
  backup_retention_days = "7"
  ssl_enforcement_enabled = true
  infrastructure_encryption_enabled = false
  auto_grow_enabled = true
  public_network_access_enabled = true 

  administrator_login          = "mysqladminun"
  administrator_login_password = "easytologin4once!"
}

resource "azurerm_mysql_database" "tfazapp_mysql_db" {
  name                = "tfazapp-mysql-db-dev"
  resource_group_name = var.rg-name
  server_name         = azurerm_mysql_server.tfazapp_mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}