module "postgresql_database" {
  source = "./postgres-sql-module/"
  project_name   = var.project_name
  resource_group = azurerm_resource_group.main
  disk_size = var.postgres_disk_size
  key_vault_id = var.key_vault_id
  subnet_id = module.vpc.postgresql_subnet_id
  network_id          = module.vpc.network_id
  tags = local.default_tags
}

module "redis" {
  source = "./redis-cache-module/"
  project_name   = var.project_name
  resource_group = azurerm_resource_group.main
  key_vault_id = var.key_vault_id
  subnet_id = module.vpc.redis_subnet_id
  network_id = module.vpc.network_id
  tags = local.default_tags
}

module "mongo_atlas" {
  source                    = "./mongo-atlas-database/"
  resource_group            = azurerm_resource_group.main
  key_vault_id              = var.key_vault_id
  project_id                = var.project_name
  subnet_id                 = module.vpc.mongo_atlas_subnet_id
  atlas_org_id              = var.atlas_org_id
  atlas_project_name        = var.project_name
  mongodb_version           = var.mongodb_version
  vpc_id                    = module.vpc.network_id
  cidr_block                = var.vpc_cidr
  pl_sg_cidr_range          = var.vpc_cidr
  azure_region              = var.region
  atlas_azure_region        = local.azure_to_atlas_region[var.region]
  atlas_disk_size           = var.atlas_disk_size
  atlas_instance_type       = var.atlas_instance_type
  atlas_db_user             = var.atlas_db_user
  db_audit_enable           = local.is_production
  chosen_copy_region        = local.chosen_copy_region
  tags                      = local.default_tags
}
