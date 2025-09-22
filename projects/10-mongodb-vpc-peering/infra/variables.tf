variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my_project"
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

variable "mongodbatlas_public_key" {
  description = "MongoDB public key"
  type        = string
  sensitive   = true
}

variable "mongodbatlas_private_key" {
  description = "MongoDB private key"
  type        = string
  sensitive   = true
}

variable "mongodbatlas_org_id" {
  description = "MongoDB organization ID"
  type        = string
}

variable "mongodbatlas_project_name" {
  description = "MongoDB project name"
  type        = string
}

variable "key_pair" {
  description = "Key pair"
  type        = string
}

variable "my_ip" {
  description = "My IP"
  type        = string
  default     = "1.2.3.4/32"
}