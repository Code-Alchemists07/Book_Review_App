variable "db_admin_username" {
  default = "dbadminuser"
}

variable "db_admin_password" {
  description = "Database admin password"
  sensitive   = true
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "azurerm_resource_group" "main" {
  name     = "bookreview-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = "bookreview${random_id.rand.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Wait 60s after storage account creation
resource "time_sleep" "wait_for_storage" {
  depends_on      = [azurerm_storage_account.storage]
  create_duration = "60s"
}

resource "azurerm_storage_container" "bookcovers" {
  name                  = "bookcovers"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "blob"

  depends_on = [
    time_sleep.wait_for_storage
  ]
}

resource "azurerm_postgresql_flexible_server" "db_flex" {
  name                   = "bookreview-db-${random_id.rand.hex}"
  location               = azurerm_resource_group.main.location
  resource_group_name    = azurerm_resource_group.main.name
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  version                = "13"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"
  public_network_access_enabled = true
  tags                   = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "bookreviews"
  server_id = azurerm_postgresql_flexible_server.db_flex.id
  charset   = "UTF8"
  collation = "en_US.utf8"

  depends_on = [
    azurerm_postgresql_flexible_server.db_flex
  ]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.db_flex.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"

  depends_on = [
    azurerm_postgresql_flexible_server.db_flex
  ]
}

locals {
  postgres_connection_string = "host=${azurerm_postgresql_flexible_server.db_flex.fqdn} port=5432 dbname=${azurerm_postgresql_flexible_server_database.db.name} user=${var.db_admin_username}@${azurerm_postgresql_flexible_server.db_flex.name} password=${var.db_admin_password} sslmode=require"
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "bookreview-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "web" {
  name                = "bookreview-web-${random_id.rand.hex}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }

  app_settings = {
    DB_CONNECTION   = local.postgres_connection_string
    STORAGE_ACCOUNT = azurerm_storage_account.storage.name
    STORAGE_KEY     = azurerm_storage_account.storage.primary_access_key
    PYTHON_VERSION  = "3.9"
  }

  tags = var.tags

  depends_on = [
    azurerm_postgresql_flexible_server_database.db,
    azurerm_postgresql_flexible_server_firewall_rule.allow_all,
    azurerm_storage_container.bookcovers
  ]
}

resource "azurerm_app_service_source_control" "github" {
  app_id   = azurerm_linux_web_app.web.id
  repo_url = "https://github.com/Code-Alchemists07/Book_Review_App"
  branch   = "main"
}
