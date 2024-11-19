terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.72"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.11"
    }
  }
  required_version = ">= 1.2.5"
}
