locals {
  mongodb_org_id                 = data.mongodbatlas_roles_org_id.warike_development_mongodb_atlas_org_id
  mongodb_project_name           = var.mongodbatlas_project_name
  mongodb_cluster_name           = "cluster-${local.project_name}"
  mongodb_provider_name          = "AWS"
  mongodb_region_name            = "US_EAST_1"
  mongodb_main_database_name     = "database-${random_pet.warike_development_atlas_database.id}"
  mongodb_administrator_username = "administrator-${random_string.warike_development_atlas_username.id}"
  mongodb_administrator_password = random_password.warike_development_atlas_password.result

  atlas_cidr_block = "10.8.0.0/21"

}

## Random name
resource "random_pet" "warike_development_atlas_database" {
  length    = 6
  separator = "-"
}

## Random String
resource "random_string" "warike_development_atlas_username" {
  length = 4
  lower  = true
}

## MongoDB Atlas password
resource "random_password" "warike_development_atlas_password" {
  length           = 20
  special          = false
  override_special = "_%@"
}

## MongoDB Atlas organization ID
data "mongodbatlas_roles_org_id" "warike_development_mongodb_atlas_org_id" {
}

## MongoDB Atlas Project
resource "mongodbatlas_project" "warike_development_mongodb_atlas_project" {
  name   = local.mongodb_project_name
  org_id = data.mongodbatlas_roles_org_id.warike_development_mongodb_atlas_org_id.org_id

  limits {
    name  = "atlas.project.deployment.clusters"
    value = 1
  }

  is_collect_database_specifics_statistics_enabled = true
  is_data_explorer_enabled                         = true
  is_extended_storage_sizes_enabled                = false
  is_performance_advisor_enabled                   = true
  is_realtime_performance_panel_enabled            = true
  is_schema_advisor_enabled                        = true

  tags = local.tags
}

## MongoDB Atlas Database User
resource "mongodbatlas_database_user" "warike_development_mongodb_atlas_db_user" {
  username   = local.mongodb_administrator_username
  password   = local.mongodb_administrator_password
  project_id = mongodbatlas_project.warike_development_mongodb_atlas_project.id

  auth_database_name = "admin"

  roles {
    role_name     = "dbAdmin"
    database_name = local.mongodb_main_database_name
  }

  depends_on = [
    random_password.warike_development_atlas_password,
    random_string.warike_development_atlas_username,
    random_pet.warike_development_atlas_database
  ]
}

## MongoDB Atlas Advanced Cluster 
resource "mongodbatlas_advanced_cluster" "warike_development_mongodb_atlas_cluster" {
  project_id     = mongodbatlas_project.warike_development_mongodb_atlas_project.id
  name           = local.mongodb_cluster_name
  cluster_type   = "REPLICASET"
  backup_enabled = false


  replication_specs = [
    {
      region_configs = [
        {
          electable_specs = {
            instance_size = "M10"
            node_count    = 3
          }

          provider_name = local.mongodb_provider_name
          region_name   = local.mongodb_region_name
          priority      = 7
          tags          = local.tags
        }
      ]
    }
  ]

}

## MongoDB Atlas standard connection string
output "atlas_connection_string" {
  value = mongodbatlas_advanced_cluster.warike_development_mongodb_atlas_cluster.connection_strings.standard
}

## MongoDB Atlas container CIDR block
output "atlas_cidr_block" {
  value = mongodbatlas_network_container.warike_development_mongodb_atlas_network_container.atlas_cidr_block
}

## MongoDB Atlas username
output "atlas_username" {
  value = mongodbatlas_database_user.warike_development_mongodb_atlas_db_user.username
}

## Export credentials
resource "local_file" "warike_development_debug_password" {
  content         = <<EOF
MONGODB_ATLAS_ADMINISTRATOR_USERNAME=${local.mongodb_administrator_username}
MONGODB_ATLAS_PASSWORD=${local.mongodb_administrator_password}
EOF
  filename        = "${local.project_name}-atlas-credentials.env"
  file_permission = "0644"
}