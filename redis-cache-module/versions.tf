terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.72"
    }
  }

  required_version = ">= 1.2.5"
}
