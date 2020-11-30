
# ==========
# Python Function App: Post Messages to Unlettered Discord Server #testing Channel
# ==========

# References
# ----------
# AzureRM Function App Exmaple: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app

resource "azurerm_resource_group" "unlettered-py-fa-rg" {
  name     = "rg-unlettered-py-fa"
  location = var.resource_groups_location
}

resource "azurerm_app_service_plan" "unlettered-py-fa-asp" {
  name                = "asp-unlettered-py-fa"
  location            = azurerm_resource_group.unlettered-py-fa-rg.location
  resource_group_name = azurerm_resource_group.unlettered-py-fa-rg.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "unlettered-py-fa-sa" {
  name                     = "saunletteredpyfx"
  location                 = azurerm_resource_group.unlettered-py-fa-rg.location
  resource_group_name      = azurerm_resource_group.unlettered-py-fa-rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "unlettered-py-fa" {
  name                       = "fa-unlettered-py"
  location                   = azurerm_resource_group.unlettered-py-fa-rg.location
  resource_group_name        = azurerm_resource_group.unlettered-py-fa-rg.name
  app_service_plan_id        = azurerm_app_service_plan.unlettered-py-fa-asp.id
  storage_account_name       = azurerm_storage_account.unlettered-py-fa-sa.name
  storage_account_access_key = azurerm_storage_account.unlettered-py-fa-sa.primary_access_key
  version                    = "~3"
  os_type                    = "linux" # We'll use Linux for now. Maybe the future won't care?

  site_config {
    linux_fx_version          = "PYTHON|3.8"
    use_32_bit_worker_process = false
  }
}
