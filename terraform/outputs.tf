output "web_app_url" {
  description = "The URL of the deployed Azure Web App"
  value       = "https://${azurerm_linux_web_app.web.default_hostname}"
}

output "web_app_name" {
  description = "The name of the Azure Web App"
  value       = azurerm_linux_web_app.web.name
}

output "resource_group_name" {
  description = "The name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.appserviceplan.id
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "postgresql_fully_qualified_domain_name" {
  description = "PostgreSQL server FQDN"
  value       = azurerm_postgresql_flexible_server.db_flex.fqdn
}

output "postgresql_connection_string" {
  description = "PostgreSQL connection string without password"
  value       = "host=${azurerm_postgresql_flexible_server.db_flex.fqdn} port=5432 dbname=${azurerm_postgresql_flexible_server_database.db.name} user=${var.db_admin_username}@${azurerm_postgresql_flexible_server.db_flex.name}"
}
