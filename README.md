# dr-azure-external-pcs
Terraform modules for external PCS provisioning

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mongo_atlas"></a> [mongo\_atlas](#module\_mongo\_atlas) | ./mongo-atlas-database/ | n/a |
| <a name="module_postgresql_database"></a> [postgresql\_database](#module\_postgresql\_database) | ./postgres-sql-module/ | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | ./redis-cache-module/ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apac_copy_region"></a> [apac\_copy\_region](#input\_apac\_copy\_region) | Region for cross region snapshot store to support major region going down | `list(string)` | <pre>[<br>  "AUSTRALIA_EAST",<br>  "INDIA_CENTRAL",<br>  "INDIA_WEST",<br>  "JAPAN_EAST",<br>  "JAPAN_WEST",<br>  "KOREA_CENTRAL",<br>  "KOREA_SOUTH",<br>  "ASIA_EAST",<br>  "ASIA_SOUTH_EAST",<br>  "AUSTRALIA_CENTRAL",<br>  "AUSTRALIA_EAST",<br>  "AUSTRALIA_SOUTH_EAST"<br>]</pre> | no |
| <a name="input_atlas_private_key"></a> [atlas\_private\_key](#input\_atlas\_private\_key) | n/a | `any` | n/a | yes |
| <a name="input_atlas_public_key"></a> [atlas\_public\_key](#input\_atlas\_public\_key) | n/a | `any` | n/a | yes |
| <a name="input_eu_copy_region"></a> [eu\_copy\_region](#input\_eu\_copy\_region) | Region for cross region snapshot store to support major region going down | `list(string)` | <pre>[<br>  "EUROPE_NORTH",<br>  "EUROPE_WEST",<br>  "UK_SOUTH",<br>  "UK_WEST",<br>  "FRANCE_CENTRAL",<br>  "ITALY_NORTH",<br>  "GERMANY_WEST_CENTRAL",<br>  "POLAND_CENTRAL",<br>  "SWITZERLAND_NORTH",<br>  "NORWAY_EAST"<br>]</pre> | no |
| <a name="input_me_copy_region"></a> [me\_copy\_region](#input\_me\_copy\_region) | Region for cross region snapshot store to support major region going down | `list(string)` | <pre>[<br>  "UAE_NORTH",<br>  "QATAR_CENTRAL",<br>  "ISRAEL_CENTRAL"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure Region in which all resources in this example should be created. | `string` | `"eastus"` | no |
| <a name="input_us_copy_region"></a> [us\_copy\_region](#input\_us\_copy\_region) | Region for cross region snapshot store to support major region going down | `list(string)` | <pre>[<br>  "US_EAST",<br>  "US_EAST_2",<br>  "US_CENTRAL",<br>  "US_WEST_CENTRAL",<br>  "US_SOUTH_CENTRAL",<br>  "BRAZIL_SOUTH",<br>  "CANADA_EAST",<br>  "CANADA_CENTRAL"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
