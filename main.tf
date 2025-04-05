provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rgd" {
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
  location           = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind               = "Windows"
  reserved           = false
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "UserInputCalApp"
  location           = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
}
