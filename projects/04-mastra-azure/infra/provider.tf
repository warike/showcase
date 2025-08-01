terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}
## Azure provider
provider "azurerm" {
  subscription_id = local.azure_subscription_id
  features {}
}

locals {
  project_name          = var.project_name
  azure_location        = var.azure_location
  azure_subscription_id = var.azure_subscription_id

  tags = {
    project     = local.project_name
    environment = "dev"
    owner       = "warike"
    cost-center = "development"
    terraform   = "true"
  }
}
