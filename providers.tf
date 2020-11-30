terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.38.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
