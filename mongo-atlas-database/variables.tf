variable "environment" {
  description = "Environment to deploy can be (dev,prod)"
  type        = string
}

variable "project_id" {
  description = "Azure project ID"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Resource Group"
  type        = any
}

variable "resource_group_location" {
  description = "Azure Resource Group"
  type        = any
}

variable "tags" {
  description = "Tags to Apply"
  type        = map(string)
}

variable "key_vault_id" {
  description = "Secret Vault ID"
  type        = string
}

variable "atlas_org_id" {
  description = "atlas datarobot organization id"
  type        = string
}

variable "atlas_project_name" {
  description = "atlas project name"
  type        = string
}

variable "azure_region" {
  description = "azure region"
  type        = string
}

variable "atlas_azure_region" {
  description = "atlas region"
  type        = string
}

variable "atlas_disk_size" {
  description = "atlas disk size"
  type        = string
}

variable "atlas_instance_type" {
  description = "atlas instance type"
  type        = string
}

variable "atlas_db_user" {
  description = "atlas datarobot user"
  type        = string
}

variable "pl_sg_cidr_range" {
  description = "VPC CIDR block for private link sg"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for atlas"
}

variable "atlas_mongodb_version" {
  description = "mongodb cluster version"
  type        = string
}

variable "cidr_block" {
  description = "vpc cidr block to whitelist"
  type        = string
}

variable "chosen_copy_region" {
  type        = string
  description = "get current region cluster is provisioned"

  validation {
    condition     = var.chosen_copy_region != null
    error_message = "Chosen_copy_region must be set to a valid region, add a region if it does not exist."
  }
}

variable "termination_protection_enabled" {
  type        = bool
  description = "Enable termination for atlas cluster instances."
}

variable "atlas_num_shards" {
  type        = number
  description = "Number of shards if sharded cluster else default is 1"
}

variable "network_id" {
  type        = string
  description = "Network id in azure where resources need to be provisioned"
}

variable "pit_enabled" {
  type        = bool
  description = "Point in time restore for mongodb"
}

variable "atlas_cluster_type" {
  type        = string
  description = "Atlas cluster type either REPLICASET or SHARDED"
}
