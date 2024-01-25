terraform {

  cloud {
    organization = "blueassemble"

    workspaces {
      name = "azure-my-subs"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.88.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }
}
