// references:
// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment

locals {
  models = {
    "o4-mini" = {
      model_format  = "OpenAI"
      model_name    = "o4-mini"
      sku_name      = "GlobalStandard"
      sku_capacity  = 250
      model_version = "2025-04-16"
    }
  }
  rai_filters = [
    {
      name               = "Violence"
      filter_enabled     = true
      block_enabled      = true
      severity_threshold = "Medium"
      source             = "Completion"
    },
    {
      name               = "Hate"
      filter_enabled     = true
      block_enabled      = true
      severity_threshold = "Medium"
      source             = "Completion"
    },
    {
      name               = "Sexual"
      filter_enabled     = true
      block_enabled      = true
      severity_threshold = "Medium"
      source             = "Completion"
    },
    {
      name               = "SelfHarm"
      filter_enabled     = true
      block_enabled      = true
      severity_threshold = "Medium"
      source             = "Completion"
    }
  ]
}

## Resource Group to Host all resources
resource "azurerm_resource_group" "development_mastra_resource_group" {
  name     = "development-resource-group-${local.project_name}"
  location = local.azure_location

  tags = merge(local.tags, {
    Name = "${local.project_name}-rg"
  })
}

## Cognitive Account to Host OpenAI models
resource "azurerm_cognitive_account" "development_mastra_cognitive_account" {
  name                  = "${local.project_name}-ca"
  custom_subdomain_name = "${local.project_name}-ca"
  location              = azurerm_resource_group.development_mastra_resource_group.location
  resource_group_name   = azurerm_resource_group.development_mastra_resource_group.name
  kind                  = "OpenAI"
  sku_name              = "S0"
}


## Models deployments
resource "azurerm_cognitive_deployment" "development_mastra_model_deployments" {
  for_each = local.models

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.development_mastra_cognitive_account.id
  rai_policy_name      = azurerm_cognitive_account_rai_policy.development_mastra_rai_policy.name

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.sku_capacity
  }

}

## Guards and Control
resource "azurerm_cognitive_account_rai_policy" "development_mastra_rai_policy" {
  name                 = "${local.project_name}-rai-policy"
  cognitive_account_id = azurerm_cognitive_account.development_mastra_cognitive_account.id
  base_policy_name     = "Microsoft.Default"

  dynamic "content_filter" {
    for_each = local.rai_filters
    content {
      name               = content_filter.value.name
      filter_enabled     = content_filter.value.filter_enabled
      block_enabled      = content_filter.value.block_enabled
      severity_threshold = content_filter.value.severity_threshold
      source             = content_filter.value.source
    }
  }
}
