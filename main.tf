# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "location" {
  type = string
  default = "West Europe"
}

variable "prefix" {
  type = string
  default = "weu"
}

# Define Resource Group
resource "azurerm_resource_group" "webtest" {
  name     = "${var.prefix}-webtest-rg"
  location = var.location
}

# Define App Service Plan
resource "azurerm_app_service_plan" "webtest" {
  name                = "${var.prefix}-webtest-appserviceplan"
  location            = azurerm_resource_group.webtest.location
  resource_group_name = azurerm_resource_group.webtest.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Define App Service
resource "azurerm_app_service" "webtest" {
  name                = "cpt-${var.prefix}-webtest"
  location            = azurerm_resource_group.webtest.location
  resource_group_name = azurerm_resource_group.webtest.name
  app_service_plan_id = azurerm_app_service_plan.webtest.id

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.webtest.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = "instrumnetationkey=${azurerm_application_insights.webtest.connection_string}"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  site_config {
    linux_fx_version = "DOCKER|cpinotossi/webtest:v1.3"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}

# App Insight
resource "azurerm_application_insights" "webtest" {
  name                = "${var.prefix}-webtest-appinsight"
  location            = azurerm_resource_group.webtest.location
  resource_group_name = azurerm_resource_group.webtest.name
  application_type    = "web"
}

output "webapp_key" {
value = "${azurerm_application_insights.webtest.instrumentation_key}"
}

output "webapp_id" {
value = "${azurerm_application_insights.webtest.app_id}"
}

output "default_site_hostname" {
  value = azurerm_app_service.webtest.default_site_hostname
}
