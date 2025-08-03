variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my_project"
}

variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}
