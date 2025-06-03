provider "azurerm" {
  features {}
}

module "vnet" {
  source                 = "./../"
  name                   = "app"
  environment            = "dev"
  resource_group_name    = ""
  location               = ""
  address_space          = "10.0.0.0/16"
  enable_ddos_pp         = false
  enable_network_watcher = false
}
