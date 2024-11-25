provider "azurerm" {
  features {}
}

provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}

locals {
  # Postgres Variables
  environment        = "prod"
  project_name       = "my-test-external"
  postgres_disk_size = 32768
  key_vault_id       = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/sts-staging-azure-resources/providers/Microsoft.KeyVault/vaults/drsts-sts-staging-azure"
  db_instance_sku    = "GP_Standard_D2ds_v4"
  postgres_subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/sts-staging-azure-resources/providers/Microsoft.Network/virtualNetworks/sts-staging-azure-network/subnets/postgresql"
  postgresql_version = "13"
  network_id         = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue"

  # Redis Variables
  redis_subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/sts-staging-azure-resources/providers/Microsoft.Network/virtualNetworks/sts-staging-azure-network/subnets/redis"

  # Mongo Atlas Variables
  mongo_atlas_subnet_id          = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/sts-staging-azure-resources/providers/Microsoft.Network/virtualNetworks/sts-staging-azure-network/subnets/mongo-atlas"
  resource_group_name            = "sts-staging-azure-resources"
  resource_group_location        = "eastus"
  atlas_org_id                   = "6247263f0abc00000000000"
  atlas_project_name             = "my-test-external"
  atlas_mongodb_version          = "6.0"
  cidr_block                     = "10.0.0.0/16"
  pl_sg_cidr_range               = ["10.0.0.0/16"]
  azure_region                   = "eastus2"
  atlas_azure_region             = "eastus"
  atlas_disk_size                = 100
  atlas_instance_type            = "M30"
  atlas_cluster_type             = "REPLICASET"
  atlas_db_user                  = "pcs-mongodb"
  atlas_num_shards               = 1
  termination_protection_enabled = true
  is_production                  = local.environment != "dev"
  pit_enabled                    = true
  current_region_type            = local.azure_to_atlas_region[var.region]
  is_us_region                   = length([for region in var.us_copy_region : region if region == local.current_region_type]) > 0
  is_eu_region                   = length([for region in var.eu_copy_region : region if region == local.current_region_type]) > 0
  is_apac_region                 = length([for region in var.apac_copy_region : region if region == local.current_region_type]) > 0
  is_me_region                   = length([for region in var.me_copy_region : region if region == local.current_region_type]) > 0

  chosen_copy_region = coalesce(local.is_us_region ? element([for region in var.us_copy_region : region if region != local.current_region_type], 0) : local.is_eu_region ? element([for region in var.eu_copy_region : region if region != local.current_region_type], 0) : local.is_apac_region ? element([for region in var.apac_copy_region : region if region != local.current_region_type], 0) : local.is_me_region ? element([for region in var.me_copy_region : region if region != local.current_region_type], 0) : null)

  azure_to_atlas_region = {
    # US regions
    "centralus"       = "US_CENTRAL"
    "eastus"          = "US_EAST"
    "eastus2"         = "US_EAST_2"
    "westcentralus"   = "US_WEST_CENTRAL"
    "southcentralus"  = "US_SOUTH_CENTRAL"
    "brazilsouth"     = "BRAZIL_SOUTH"
    "brazilsoutheast" = "BRAZIL_SOUTHEAST" # this region is recommended only for disaster recovery
    "canadaeast"      = "CANADA_EAST"
    "canadacentral"   = "CANADA_CENTRAL"
    # APAC regions
    "australiaeast"      = "AUSTRALIA_EAST"
    "centralindia"       = "INDIA_CENTRAL"
    "westindia"          = "INDIA_WEST"
    "japaneast"          = "JAPAN_EAST"
    "japanwest"          = "JAPAN_WEST"
    "koreacentral"       = "KOREA_CENTRAL"
    "koreasouth"         = "KOREA_SOUTH"
    "eastasia"           = "ASIA_EAST"
    "southeastasia"      = "ASIA_SOUTH_EAST"
    "australiacentral"   = "AUSTRALIA_CENTRAL"
    "australiaeast"      = "AUSTRALIA_EAST"
    "australiasoutheast" = "AUSTRALIA_SOUTH_EAST"
    "australiacentral2"  = "AUSTRALIA_CENTRAL_2" # this region is recommended only for disaster recovery
    # EU regions
    "northeurope"        = "EUROPE_NORTH"
    "westeurope"         = "EUROPE_WEST"
    "uksouth"            = "UK_SOUTH"
    "ukwest"             = "UK_WEST"
    "francecentral"      = "FRANCE_CENTRAL"
    "italynorth"         = "ITALY_NORTH"
    "germanywestcentral" = "GERMANY_WEST_CENTRAL"
    "polandcentral"      = "POLAND_CENTRAL"
    "switzerlandnorth"   = "SWITZERLAND_NORTH"
    "norwayeast"         = "NORWAY_EAST"
    "francesouth"        = "FRANCE_SOUTH"     # this region is recommended only for disaster recovery
    "germanynorth"       = "GERMANY_NORTH"    # this region is recommended only for disaster recovery
    "switzerlandwest"    = "SWITZERLAND_WEST" # this region is recommended only for disaster recovery
    "norwaywest"         = "NORWAY_WEST"      # this region is recommended only for disaster recovery
    # Middle East regions
    "uaenorth"      = "UAE_NORTH"
    "qatarcentral"  = "QATAR_CENTRAL"
    "israelcentral" = "ISRAEL_CENTRAL"
    "uaecentral"    = "UAE_CENTRAL" # this region is recommended only for disaster recovery
  }
  # Tags for resource and cost tracking
  default_tags = {
    customer    = "datarobot"
    user        = "datarobot"
    cost-center = "org-cost-center"
    cluster_id  = "datarobot-k8s-cluster-association"
    environment = "development"
    expiration  = "never"
  }
}
