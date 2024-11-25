variable "region" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "eastus"
}

variable "us_copy_region" {
  type        = list(string)
  default     = ["US_EAST", "US_EAST_2", "US_CENTRAL", "US_WEST_CENTRAL", "US_SOUTH_CENTRAL", "BRAZIL_SOUTH", "CANADA_EAST", "CANADA_CENTRAL"]
  description = "Region for cross region snapshot store to support major region going down"
}

variable "eu_copy_region" {
  type        = list(string)
  default     = ["EUROPE_NORTH", "EUROPE_WEST", "UK_SOUTH", "UK_WEST", "FRANCE_CENTRAL", "ITALY_NORTH", "GERMANY_WEST_CENTRAL", "POLAND_CENTRAL", "SWITZERLAND_NORTH", "NORWAY_EAST"]
  description = "Region for cross region snapshot store to support major region going down"
}

variable "apac_copy_region" {
  type        = list(string)
  default     = ["AUSTRALIA_EAST", "INDIA_CENTRAL", "INDIA_WEST", "JAPAN_EAST", "JAPAN_WEST", "KOREA_CENTRAL", "KOREA_SOUTH", "ASIA_EAST", "ASIA_SOUTH_EAST", "AUSTRALIA_CENTRAL", "AUSTRALIA_EAST", "AUSTRALIA_SOUTH_EAST"]
  description = "Region for cross region snapshot store to support major region going down"
}

variable "me_copy_region" {
  type        = list(string)
  default     = ["UAE_NORTH", "QATAR_CENTRAL", "ISRAEL_CENTRAL"]
  description = "Region for cross region snapshot store to support major region going down"
}

variable "atlas_public_key" {}
variable "atlas_private_key" {}
