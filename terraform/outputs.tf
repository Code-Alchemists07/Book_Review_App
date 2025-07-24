output "web_app_url" {
  description = "The URL of the deployed Web App"
  value       = "https://${azurerm_linux_web_app.web.default_hostname}"
}

output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_app_service_plan.plan.id
}

output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_primary_web_endpoint" {
  description = "Web endpoint of the Storage Account (can be used for static content or testing)"
  value       = azurerm_storage_account.storage.primary_web_endpoint
}

output "application_insights_connection_string" {
  description = "App Insights Connection String (for monitoring agent integration)"
  value       = azurerm_application_insights.appinsights.connection_string
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.appinsights.instrumentation_key
}

output "web_app_name" {
  description = "Name of the Azure Web App"
  value       = azurerm_linux_web_app.web.name
}
