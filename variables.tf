

variable "location" {
  description = "Azure region to deploy resources in"
  default     = "eastus"
}

variable "project" {
  description = "Short project name"
  default     = "bookreview"
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  default     = "dev"
}

variable "app_service_plan_sku" {
  description = "App Service pricing tier"
  default     = "S1"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}
