provider "azurerm" {
  features {}
  subscription_id = "2f1ef4d2-8798-474f-81d1-d2fc16c553b6"
  tenant_id       = "f8cf3d71-5b5b-441f-adb3-416c06e43d1d"
}

resource "azurerm_resource_group" "rg" {
  name     = "UserInputCalRG"
  location = "East US"
}


resource "azurerm_storage_account" "storage" {
  name                     = "userinputcalstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "UserInputCalPlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Windows"
  reserved            = false
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "UserInputCalApp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
}
