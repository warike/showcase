locals {
  aws_private_cidr_block = module.vpc.private_subnets_cidr_blocks[0]
  mongodb_ip_list = {
    "AWS"  = local.aws_private_cidr_block,
    "MyIP" = var.my_ip
  }
}

data "aws_caller_identity" "current" {}

## MongoDB Atlas Network Container
resource "mongodbatlas_network_container" "warike_development_mongodb_atlas_network_container" {
  project_id       = mongodbatlas_project.warike_development_mongodb_atlas_project.id
  atlas_cidr_block = local.atlas_cidr_block
  provider_name    = local.mongodb_provider_name
  region_name      = local.mongodb_region_name
}

## MongoDB Atlas Project IP Access List from local mongodb_ip_list
resource "mongodbatlas_project_ip_access_list" "warike_development_mongodb_atlas_ip_access" {
  for_each = local.mongodb_ip_list

  project_id = mongodbatlas_project.warike_development_mongodb_atlas_project.id
  cidr_block = each.value
  comment    = each.key
}

## MongoDB Atlas Network Peering
resource "mongodbatlas_network_peering" "warike_development_mongodb_atlas_network_peering" {
  container_id  = mongodbatlas_network_container.warike_development_mongodb_atlas_network_container.id
  project_id    = mongodbatlas_project.warike_development_mongodb_atlas_project.id
  provider_name = local.mongodb_provider_name

  accepter_region_name   = local.aws_region
  vpc_id                 = module.vpc.vpc_id
  aws_account_id         = data.aws_caller_identity.current.account_id
  route_table_cidr_block = local.aws_private_cidr_block
}

## AWS VPC Peering Connection Accepter
## Accept the peering connection request
resource "aws_vpc_peering_connection_accepter" "warike_development_mongodb_atlas_vpc_peering_connection_accepter" {
  vpc_peering_connection_id = mongodbatlas_network_peering.warike_development_mongodb_atlas_network_peering.connection_id
  auto_accept               = true

  tags = {
    Side = "Accepter"
    Name = local.project_name
  }
}

## AWS Route for MongoDB Atlas Network Peering
resource "aws_route" "warike_development_mongodb_atlas_vpc_peering_route" {
  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block    = local.atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.warike_development_mongodb_atlas_network_peering.connection_id
  depends_on = [
    aws_vpc_peering_connection_accepter.warike_development_mongodb_atlas_vpc_peering_connection_accepter
  ]
}