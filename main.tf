module "postgresql_database" {
  source                  = "./postgres-sql-module/"
  project_name            = local.project_name
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  disk_size               = local.postgres_disk_size
  key_vault_id            = local.key_vault_id
  subnet_id               = local.postgres_subnet_id
  network_id              = local.network_id
  postgresql_version      = local.postgresql_version
  tags                    = local.default_tags
}

module "redis" {
  source                  = "./redis-cache-module/"
  project_name            = local.project_name
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  key_vault_id            = local.key_vault_id
  subnet_id               = local.redis_subnet_id
  network_id              = local.network_id
  tags                    = local.default_tags
}

module "mongo_atlas" {
  source                         = "./mongo-atlas-database/"
  environment                    = local.environment
  resource_group_name            = local.resource_group_name
  resource_group_location        = local.resource_group_location
  key_vault_id                   = local.key_vault_id
  network_id                     = local.network_id
  project_id                     = local.project_name
  subnet_id                      = local.mongo_atlas_subnet_id
  atlas_org_id                   = local.atlas_org_id
  atlas_project_name             = local.project_name
  atlas_mongodb_version          = local.atlas_mongodb_version
  vpc_id                         = local.network_id
  cidr_block                     = local.cidr_block
  pl_sg_cidr_range               = local.cidr_block
  azure_region                   = var.region
  atlas_azure_region             = local.azure_to_atlas_region[var.region]
  atlas_disk_size                = local.atlas_disk_size
  atlas_instance_type            = local.atlas_instance_type
  atlas_cluster_type             = local.atlas_cluster_type
  atlas_db_user                  = local.atlas_db_user
  chosen_copy_region             = local.chosen_copy_region
  termination_protection_enabled = local.termination_protection_enabled
  atlas_num_shards               = local.atlas_num_shards
  pit_enabled                    = local.pit_enabled
  tags                           = local.default_tags
}
