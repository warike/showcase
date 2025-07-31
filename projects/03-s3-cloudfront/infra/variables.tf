variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "s3-cloudfront"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile name"
  type        = string
  default     = "default"
}

variable "gh_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "gh_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "warike"
}