// main.tf

// AZ Availables
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  vpc_name = "vpc-${var.project_name}"
  ## Use 3 AZs form data.aws_availability_zones.available.names
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr_block = "10.0.0.0/16"

  # Generate 3 private subnets (/24 each)
  private_subnets = [
    for i in range(3) : cidrsubnet(local.vpc_cidr_block, 8, i)
  ]

  # Generate 3 public subnets (/24 each), offset to avoid overlap
  public_subnets = [
    for i in range(3) : cidrsubnet(local.vpc_cidr_block, 8, i + 100)
  ]

  intra_subnets = [
    for i in range(3) : cidrsubnet(local.vpc_cidr_block, 8, i + 200)
  ]
  additional_public_subnet_tags = {
    "public" = "true"
  }
  additional_private_subnet_tags = {
    "private" = "true"
  }

  additional_intra_subnet_tags = {
    "intra" = "true"
  }

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = local.vpc_name
  cidr = local.vpc_cidr_block

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  map_public_ip_on_launch = true


  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = merge(
    local.additional_public_subnet_tags,
    {}
  )
  private_subnet_tags = merge(
    local.additional_private_subnet_tags,
    {}
  )

  intra_subnet_tags = merge(
    local.additional_intra_subnet_tags,
    {}
  )

  tags = local.tags
}