locals {
  tags = {
    project     = var.project
    environment = var.environment
  }

  rg_name              = "${var.project}-rg-${var.environment}"
  app_service_plan     = "${var.project}-plan-${var.environment}"
  web_app_name         = "${var.project}-web-${var.environment}"
  storage_account_name = lower(replace("${var.project}${var.environment}", "-", ""))
  app_insights_name    = "${var.project}-ai-${var.environment}"
}
