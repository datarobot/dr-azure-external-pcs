locals {
  is_production = var.environment != "dev"

  current_region_type = local.azure_to_atlas_region[var.region]
  is_us_region        = length([for region in var.us_copy_region : region if region == local.current_region_type]) > 0
  is_eu_region        = length([for region in var.eu_copy_region : region if region == local.current_region_type]) > 0
  is_apac_region      = length([for region in var.apac_copy_region : region if region == local.current_region_type]) > 0
  is_me_region        = length([for region in var.me_copy_region : region if region == local.current_region_type]) > 0

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
}
