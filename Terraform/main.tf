terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" {
  name     = "django-helpdesk"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.k8s_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.k8s_cluster_name}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.vm_size
    enable_auto_scaling = false 
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "testing"
  }
}