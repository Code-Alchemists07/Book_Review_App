variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
  default     = "canadacentral"
}

variable "project" {
  description = "Short project name"
  type        = string
  default     = "bookreview"
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "app_service_plan_sku" {
  description = "App Service pricing tier"
  type        = string
  default     = "S1"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "db_admin_username" {
  default = "dbadminuser"
}

variable "db_admin_password" {
  description = "Database admin password"
  sensitive   = true
}


variable "github_repo_url" {
  description = "URL of the GitHub repository for deployment"
  type        = string
}

variable "github_branch" {
  description = "Branch to deploy from"
  type        = string
  default     = "main"
}

# variable "github_token" {
#   description = "GitHub Personal Access Token for source control"
#   sensitive   = true
# }


variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    project     = "BookReviewPlatform"
    team        = "CodeAlchemists07"
    environment = "dev"
  }
}
