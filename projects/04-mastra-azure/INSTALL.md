
#### Configuring Auth Azure

Using CLI as authentication method for azure provider
`az login --tenant $AZURE_TENANT_ID`

#### Creating resources

```hcl
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
  ...
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
```

#### Creating deployment considerations
 - model deployment name should be the same as the name of the model `o4-mini`


#### Testing the deployment
```bash
curl -s http://localhost:4111/api/agents/weatherAgent/generate \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      { "role": "user", "content": "whats the weather in Arica, Chile?" }
    ]
  }' | jq -r '.text'
Current weather for Arica:

• Temperature: 17°C (Feels like 16.3°C)  
• Conditions: Overcast  
• Humidity: 86%  
• Wind: 16.2 km/h, gusts up to 24.5 km/h  

Let me know if you need a forecast or activity suggestions!
```