locals {
  ddos_pp_id = var.enable_ddos_pp == false && var.existing_ddos_pp != null ? var.existing_ddos_pp : var.enable_ddos_pp && var.existing_ddos_pp == null ? azurerm_network_ddos_protection_plan.example[0].id : null
}

resource "azurerm_virtual_network" "vnet" {
  count                   = var.enable == true ? 1 : 0
  name                    = format("%s-vnet", var.name)
  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = length(var.address_spaces) == 0 ? [var.address_space] : var.address_spaces
  dns_servers             = var.dns_servers
  bgp_community           = var.bgp_community
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  dynamic "ddos_protection_plan" {
    for_each = local.ddos_pp_id != null ? ["ddos_protection_plan"] : []
    content {
      id     = local.ddos_pp_id
      enable = true
    }
  }
  dynamic "encryption" {
    for_each = var.enforcement != null ? ["encryption"] : []
    content {
      enforcement = var.enforcement
    }
  }
  tags = var.tags
}

resource "azurerm_network_ddos_protection_plan" "example" {
  count               = var.enable_ddos_pp && var.enable == true ? 1 : 0
  name                = format("%s-ddospp", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_watcher" "flow_log_nw" {
  count               = var.enable && var.enable_network_watcher ? 1 : 0
  name                = format("%s-network_watcher", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
}