resource "mongodbatlas_project" "azure_atlas_project" {
  name   = "${var.atlas_project_name}-datarobot"
  org_id = var.atlas_org_id

  is_collect_database_specifics_statistics_enabled = true
  is_data_explorer_enabled                         = true
  is_performance_advisor_enabled                   = true
  is_realtime_performance_panel_enabled            = true
  is_schema_advisor_enabled                        = true
}

# Mongo atlas cluster to be created
resource "mongodbatlas_advanced_cluster" "azure_mongo_atlas_cluster" {
  project_id                     = mongodbatlas_project.azure_atlas_project.id
  name                           = "${var.atlas_project_name}-${var.environment}"
  cluster_type                   = var.atlas_cluster_type
  pit_enabled                    = var.pit_enabled
  termination_protection_enabled = var.termination_protection_enabled
  version_release_system         = "LTS"
  backup_enabled                 = true
  replication_specs {
    num_shards = var.atlas_num_shards
    region_configs {
      provider_name = "AZURE"
      region_name   = var.atlas_azure_region
      priority      = 7
      electable_specs {
        instance_size = var.atlas_instance_type
        node_count    = 3
      }
      auto_scaling {
        disk_gb_enabled = true
      }
    }
  }
  advanced_configuration {
    javascript_enabled           = false
    minimum_enabled_tls_protocol = "TLS1_2"
  }
  mongo_db_major_version = var.atlas_mongodb_version
  disk_size_gb           = var.atlas_disk_size
  lifecycle {
    ignore_changes = [disk_size_gb]
  }
}

# Backup schedule for mongo atlas cluster
resource "mongodbatlas_cloud_backup_schedule" "azure_mongo_atlas_automated_cloud_backup" {
  project_id   = mongodbatlas_project.azure_atlas_project.id
  cluster_name = mongodbatlas_advanced_cluster.azure_mongo_atlas_cluster.name

  policy_item_hourly {
    frequency_interval = 6 #accepted values = 1, 2, 4, 6, 8, 12 -> every n hours
    retention_unit     = "days"
    retention_value    = 7
  }
  policy_item_daily {
    frequency_interval = 1 #accepted values = 1 -> every 1 day
    retention_unit     = "days"
    retention_value    = 30
  }
  policy_item_weekly {
    frequency_interval = 6 # accepted values = 1 to 7 -> every 1=Monday,2=Tuesday,3=Wednesday,4=Thursday,5=Friday,6=Saturday,7=Sunday day of the week
    retention_unit     = "days"
    retention_value    = 30
  }
  policy_item_monthly {
    frequency_interval = 1 # accepted values = 1 to 28 -> 1 to 28 every nth day of the month  
    # accepted values = 40 -> every last day of the month
    retention_unit  = "months"
    retention_value = 1
  }
  copy_settings {
    cloud_provider = "AZURE"
    frequencies = [
      "HOURLY",
      "DAILY",
      "WEEKLY",
      "MONTHLY",
      "ON_DEMAND"
    ]
    region_name         = var.chosen_copy_region
    replication_spec_id = mongodbatlas_advanced_cluster.azure_mongo_atlas_cluster.replication_specs.*.id[0]
    should_copy_oplogs  = true
  }
}


resource "mongodbatlas_database_user" "azure_mongo_atlas_db_user" {
  username           = var.atlas_db_user
  password           = random_password.azure_atlas_mongo_password_generator.result
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.azure_atlas_project.id
  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }
  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

resource "mongodbatlas_privatelink_endpoint" "atlaspl" {
  project_id    = mongodbatlas_project.azure_atlas_project.id
  provider_name = "AZURE"
  region        = var.azure_region
}

resource "azurerm_private_endpoint" "ptfe_service" {
  name                = "${var.atlas_project_name}-dratlas"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags
  private_service_connection {
    name                           = mongodbatlas_privatelink_endpoint.atlaspl.private_link_service_name
    private_connection_resource_id = mongodbatlas_privatelink_endpoint.atlaspl.private_link_service_resource_id
    is_manual_connection           = true
    request_message                = "Azure Private Link Mongo Atlas Setup"
  }

}

resource "mongodbatlas_privatelink_endpoint_service" "atlaseplink" {
  project_id                  = mongodbatlas_privatelink_endpoint.atlaspl.project_id
  private_link_id             = mongodbatlas_privatelink_endpoint.atlaspl.private_link_id
  endpoint_service_id         = azurerm_private_endpoint.ptfe_service.id
  private_endpoint_ip_address = azurerm_private_endpoint.ptfe_service.private_service_connection[0].private_ip_address
  provider_name               = "AZURE"
}

resource "mongodbatlas_project_ip_access_list" "cidr_whitelist" {
  project_id = mongodbatlas_project.azure_atlas_project.id
  cidr_block = var.cidr_block
  comment    = "cidr block for AZURE VPC"
}

resource "azurerm_network_security_group" "mongo_atlas_pl" {
  name                = "${var.atlas_project_name}-dratlas"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "mongo-atlas-pl-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "1000"
    destination_port_range     = "1800"
    source_address_prefix      = var.pl_sg_cidr_range
    destination_address_prefix = "*"
  }
  tags = var.tags
}

resource "random_password" "azure_atlas_mongo_password_generator" {
  length           = 20
  special          = false
  override_special = "_"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "atlas_dbpass" {
  name         = "${var.atlas_project_name}-mongo-password"
  value        = random_password.azure_atlas_mongo_password_generator.result
  key_vault_id = var.key_vault_id
  tags         = var.tags
}
