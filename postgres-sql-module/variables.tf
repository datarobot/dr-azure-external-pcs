variable "project_name" {
  description = "Project / Company Name for the deployment"
  type        = string
}

variable "resource_group" {
  description = "Azure Resource Group"
  type        = any
}

variable "tags" {
  description = "Tags to Apply"
  type        = map(string)
}

variable "disk_size" {
  type        = number
  description = "disk size in Mbs"
  default     = 32768
}

variable "db_instance_sku" {
  type        = string
  description = "DB instance type"
  default     = "GP_Standard_D2ds_v4"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for postgres db"
}

variable "key_vault_id" {
  description = "Key Vault Id for db secrets"
  type        = string
}

variable "network_id" {
  description = "Network id for private dns access"
  type        = string
}
