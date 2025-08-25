variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my_project"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS profile name"
  type        = string
  default     = "default"
}

variable "gh_owner" {
  description = "GitHub owner (user or organization)"
  type        = string
  default     = "warike"
}

variable "gh_token" {
  description = "GitHub token"
  type        = string
  sensitive   = true
}

variable "sandbox_email" {
  description = "Sandbox email"
  type        = string
}

variable "domain" {
  description = "Domain for SES"
  type        = string
}