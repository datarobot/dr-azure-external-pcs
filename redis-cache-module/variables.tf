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

variable "subnet_id" {
  type        = string
  description = "Subnet id for redis"
}

variable "network_id" {
  description = "Network id for private dns access"
  type        = string
}


variable "key_vault_id" {
  description = "Key Vault Id for db secrets"
  type        = string
}
